from datetime import datetime
from app import db


class KnowledgeDocument(db.Model):
    __tablename__ = 'knowledge_documents'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String(256), nullable=False, comment='文档标题')
    doc_type = db.Column(db.String(50), nullable=False, comment='文档类型: guideline/case/textbook/paper')
    category = db.Column(db.String(100), nullable=True, comment='疾病分类')
    file_path = db.Column(db.String(512), nullable=True, comment='原始文件路径')
    file_size = db.Column(db.Integer, nullable=True, comment='文件大小(字节)')
    content = db.Column(db.Text, nullable=True, comment='文档全文内容')
    description = db.Column(db.Text, nullable=True, comment='文档描述')
    is_vectorized = db.Column(db.Boolean, default=False, comment='是否已向量化')
    chunk_count = db.Column(db.Integer, default=0, comment='切片数量')
    uploaded_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True, comment='上传人')
    status = db.Column(db.Integer, default=1, comment='状态: 0禁用 1启用')
    created_at = db.Column(db.DateTime, default=datetime.now, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')

    chunks = db.relationship('KnowledgeChunk', backref='document', lazy='dynamic',
                             cascade='all, delete-orphan')

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'doc_type': self.doc_type,
            'category': self.category,
            'file_path': self.file_path,
            'file_size': self.file_size,
            'description': self.description,
            'is_vectorized': self.is_vectorized,
            'chunk_count': self.chunk_count,
            'status': self.status,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S') if self.created_at else None,
        }


class KnowledgeChunk(db.Model):
    __tablename__ = 'knowledge_chunks'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    document_id = db.Column(db.Integer, db.ForeignKey('knowledge_documents.id'), nullable=False, comment='文档ID')
    chunk_index = db.Column(db.Integer, nullable=False, comment='切片序号')
    content = db.Column(db.Text, nullable=False, comment='切片内容')
    token_count = db.Column(db.Integer, nullable=True, comment='token数量')
    embedding_id = db.Column(db.String(100), nullable=True, comment='向量ID')
    created_at = db.Column(db.DateTime, default=datetime.now, comment='创建时间')

    def to_dict(self):
        return {
            'id': self.id,
            'document_id': self.document_id,
            'chunk_index': self.chunk_index,
            'content': self.content,
            'token_count': self.token_count,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S') if self.created_at else None,
        }
