import os
import json
import numpy as np
from flask import current_app
import dashscope
from dashscope import TextEmbedding

VECTOR_DIM = 1024
_faiss_index = None
_chunk_metadata = []


def get_embedding(text):
    """使用通义千问Embedding API获取文本向量"""
    dashscope.api_key = current_app.config.get('DASHSCOPE_API_KEY')
    try:
        response = TextEmbedding.call(
            model=TextEmbedding.Models.text_embedding_v3,
            input=text,
            dimension=VECTOR_DIM,
        )
        if response.status_code == 200:
            return response.output['embeddings'][0]['embedding']
        else:
            print(f"Embedding API错误: {response.code} - {response.message}")
            return None
    except Exception as e:
        print(f"获取embedding异常: {str(e)}")
        return None


def get_batch_embeddings(texts):
    """批量获取文本向量"""
    dashscope.api_key = current_app.config.get('DASHSCOPE_API_KEY')
    embeddings = []
    batch_size = 25
    for i in range(0, len(texts), batch_size):
        batch = texts[i:i + batch_size]
        try:
            response = TextEmbedding.call(
                model=TextEmbedding.Models.text_embedding_v3,
                input=batch,
                dimension=VECTOR_DIM,
            )
            if response.status_code == 200:
                for item in response.output['embeddings']:
                    embeddings.append(item['embedding'])
            else:
                print(f"批量Embedding错误: {response.code}")
                embeddings.extend([None] * len(batch))
        except Exception as e:
            print(f"批量获取embedding异常: {str(e)}")
            embeddings.extend([None] * len(batch))
    return embeddings


def split_text(text, chunk_size=500, overlap=100):
    """将文本切分为多个片段"""
    if not text:
        return []
    chunks = []
    start = 0
    while start < len(text):
        end = start + chunk_size
        if end < len(text):
            split_points = [
                text.rfind('。', start, end),
                text.rfind('\n', start, end),
                text.rfind('；', start, end),
                text.rfind('.', start, end),
            ]
            best_split = max(p for p in split_points if p > start)
            if best_split > start:
                end = best_split + 1
        chunk = text[start:end].strip()
        if chunk:
            chunks.append(chunk)
        start = end - overlap if end < len(text) else end
    return chunks


def init_vector_store(app=None):
    """初始化向量存储"""
    global _faiss_index, _chunk_metadata
    try:
        import faiss
        _faiss_index = faiss.IndexFlatIP(VECTOR_DIM)

        store_path = current_app.config.get('VECTOR_STORE_PATH', './vector_store') if not app else app.config.get(
            'VECTOR_STORE_PATH', './vector_store')
        os.makedirs(store_path, exist_ok=True)

        index_file = os.path.join(store_path, 'faiss.index')
        meta_file = os.path.join(store_path, 'metadata.json')

        if os.path.exists(index_file) and os.path.exists(meta_file):
            _faiss_index = faiss.read_index(index_file)
            with open(meta_file, 'r', encoding='utf-8') as f:
                _chunk_metadata = json.load(f)
            print(f"已加载向量索引，共 {_faiss_index.ntotal} 条向量")
        else:
            print("创建新的向量索引")
    except ImportError:
        print("FAISS未安装，使用简易向量检索")
        _faiss_index = None
        _chunk_metadata = []


def save_vector_store():
    """保存向量存储到磁盘"""
    global _faiss_index, _chunk_metadata
    try:
        import faiss
        store_path = current_app.config.get('VECTOR_STORE_PATH', './vector_store')
        os.makedirs(store_path, exist_ok=True)
        if _faiss_index is not None:
            faiss.write_index(_faiss_index, os.path.join(store_path, 'faiss.index'))
        with open(os.path.join(store_path, 'metadata.json'), 'w', encoding='utf-8') as f:
            json.dump(_chunk_metadata, f, ensure_ascii=False, indent=2)
    except Exception as e:
        print(f"保存向量存储失败: {str(e)}")


def add_to_vector_store(chunks, doc_id, doc_title):
    """将文本切片添加到向量存储"""
    global _faiss_index, _chunk_metadata

    if _faiss_index is None:
        init_vector_store()

    texts = [c['content'] if isinstance(c, dict) else c for c in chunks]
    embeddings = get_batch_embeddings(texts)

    valid_vectors = []
    valid_meta = []
    for i, emb in enumerate(embeddings):
        if emb is not None:
            valid_vectors.append(emb)
            valid_meta.append({
                'doc_id': doc_id,
                'doc_title': doc_title,
                'chunk_index': i,
                'content': texts[i],
            })

    if valid_vectors:
        try:
            import faiss
            vectors = np.array(valid_vectors, dtype=np.float32)
            faiss.normalize_L2(vectors)
            _faiss_index.add(vectors)
            _chunk_metadata.extend(valid_meta)
            save_vector_store()
            return len(valid_vectors)
        except ImportError:
            _chunk_metadata.extend([{**m, 'vector': v} for m, v in zip(valid_meta, valid_vectors)])
            return len(valid_vectors)
    return 0


def search_similar(query, top_k=5):
    """语义检索相似文档，返回 (results, error_msg)"""
    global _faiss_index, _chunk_metadata

    if _faiss_index is None or (hasattr(_faiss_index, 'ntotal') and _faiss_index.ntotal == 0):
        init_vector_store()
        if _faiss_index is None or (hasattr(_faiss_index, 'ntotal') and _faiss_index.ntotal == 0):
            return [], '向量索引为空，请先对知识库文档进行向量化'

    truncated_query = query[:2000] if len(query) > 2000 else query

    query_embedding = get_embedding(truncated_query)
    if query_embedding is None:
        return [], 'Embedding API调用失败，请检查API Key配置或网络连接'

    try:
        import faiss
        query_vector = np.array([query_embedding], dtype=np.float32)
        faiss.normalize_L2(query_vector)
        scores, indices = _faiss_index.search(query_vector, min(top_k, _faiss_index.ntotal))

        results = []
        for score, idx in zip(scores[0], indices[0]):
            if idx < len(_chunk_metadata) and idx >= 0:
                results.append({
                    'score': float(score),
                    'content': _chunk_metadata[idx]['content'],
                    'doc_id': _chunk_metadata[idx]['doc_id'],
                    'doc_title': _chunk_metadata[idx]['doc_title'],
                    'chunk_index': _chunk_metadata[idx]['chunk_index'],
                })
        print(f"[RAG] 检索完成，找到 {len(results)} 条结果")
        return results, None
    except ImportError:
        return _simple_search(query_embedding, top_k), None


def _simple_search(query_embedding, top_k=5):
    """简易向量检索(无FAISS时使用)"""
    global _chunk_metadata
    if not _chunk_metadata:
        return []

    query_vec = np.array(query_embedding)
    scored = []
    for meta in _chunk_metadata:
        if 'vector' in meta:
            doc_vec = np.array(meta['vector'])
            score = np.dot(query_vec, doc_vec) / (np.linalg.norm(query_vec) * np.linalg.norm(doc_vec) + 1e-8)
            scored.append((float(score), meta))
    scored.sort(key=lambda x: x[0], reverse=True)

    return [{
        'score': s,
        'content': m['content'],
        'doc_id': m['doc_id'],
        'doc_title': m['doc_title'],
        'chunk_index': m['chunk_index'],
    } for s, m in scored[:top_k]]


def remove_doc_from_store(doc_id):
    """从向量存储中移除文档（重建索引）"""
    global _faiss_index, _chunk_metadata
    _chunk_metadata = [m for m in _chunk_metadata if m.get('doc_id') != doc_id]
    try:
        import faiss
        _faiss_index = faiss.IndexFlatIP(VECTOR_DIM)
        if _chunk_metadata:
            texts = [m['content'] for m in _chunk_metadata]
            embeddings = get_batch_embeddings(texts)
            valid = [(e, m) for e, m in zip(embeddings, _chunk_metadata) if e is not None]
            if valid:
                vectors = np.array([v[0] for v in valid], dtype=np.float32)
                faiss.normalize_L2(vectors)
                _faiss_index.add(vectors)
                _chunk_metadata = [v[1] for v in valid]
        save_vector_store()
    except ImportError:
        pass
