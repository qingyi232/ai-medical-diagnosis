<template>
  <div class="knowledge-list">
    <div class="page-card">
      <div class="page-header">
        <span class="page-title">医疗知识库</span>
        <div class="header-actions">
          <el-input
            v-model="keyword"
            placeholder="搜索文档标题"
            :prefix-icon="Search"
            clearable
            style="width: 220px"
            @clear="fetchData"
            @keyup.enter="fetchData"
          />
          <el-select v-model="filterType" placeholder="文档类型" clearable style="width: 140px" @change="fetchData">
            <el-option label="临床指南" value="guideline" />
            <el-option label="病例文档" value="case" />
            <el-option label="教材" value="textbook" />
            <el-option label="论文" value="paper" />
          </el-select>
          <el-button v-if="isAdmin" type="primary" :icon="Plus" @click="showAddDialog">新增文档</el-button>
          <el-button v-if="isAdmin" :icon="Upload" @click="showUploadDialog">上传文件</el-button>
        </div>
      </div>

      <el-table :data="tableData" stripe v-loading="loading" style="width: 100%">
        <el-table-column prop="title" label="文档标题" min-width="220" show-overflow-tooltip />
        <el-table-column prop="doc_type" label="类型" width="100">
          <template #default="{ row }">
            <el-tag size="small" :type="typeTag(row.doc_type)" class="status-tag">{{ typeText(row.doc_type) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="category" label="疾病分类" width="120" show-overflow-tooltip />
        <el-table-column prop="chunk_count" label="切片数" width="80" />
        <el-table-column prop="is_vectorized" label="向量化" width="90" align="center">
          <template #default="{ row }">
            <el-tag :type="row.is_vectorized ? 'success' : 'info'" size="small" class="status-tag">
              {{ row.is_vectorized ? '已完成' : '未处理' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="创建时间" width="170" />
        <el-table-column label="操作" :width="isAdmin ? 260 : 80" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" size="small" @click="showDetailDialog(row)">查看</el-button>
            <template v-if="isAdmin">
              <el-button
                text type="success" size="small"
                :loading="vectorizingId === row.id"
                @click="handleVectorize(row)"
                :disabled="row.is_vectorized"
              >
                {{ row.is_vectorized ? '已向量化' : '向量化' }}
              </el-button>
              <el-button text type="primary" size="small" @click="showEditDialog(row)">编辑</el-button>
              <el-popconfirm title="确定删除该文档？" @confirm="handleDelete(row.id)">
                <template #reference>
                  <el-button text type="danger" size="small">删除</el-button>
                </template>
              </el-popconfirm>
            </template>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrap">
        <el-pagination
          v-model:current-page="page"
          v-model:page-size="perPage"
          :total="total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next"
          @change="fetchData"
        />
      </div>
    </div>

    <!-- 新增/编辑文档弹窗 -->
    <el-dialog v-model="addDialogVisible" :title="isEdit ? '编辑文档' : '新增知识文档'" width="720px" destroy-on-close>
      <el-form ref="addFormRef" :model="addForm" :rules="addRules" label-width="90px">
        <el-row :gutter="20">
          <el-col :span="16">
            <el-form-item label="文档标题" prop="title">
              <el-input v-model="addForm.title" placeholder="请输入文档标题" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="文档类型" prop="doc_type">
              <el-select v-model="addForm.doc_type" style="width:100%">
                <el-option label="临床指南" value="guideline" />
                <el-option label="病例文档" value="case" />
                <el-option label="教材" value="textbook" />
                <el-option label="论文" value="paper" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="疾病分类">
              <el-input v-model="addForm.category" placeholder="如：心血管疾病" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="描述">
              <el-input v-model="addForm.description" placeholder="简要描述" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="文档内容" prop="content">
          <el-input
            v-model="addForm.content"
            type="textarea"
            :rows="14"
            placeholder="请输入或粘贴医疗知识文档内容（临床指南、病例、教材等）"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="addDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleAddSubmit">保存</el-button>
      </template>
    </el-dialog>

    <!-- 上传文件弹窗 -->
    <el-dialog v-model="uploadDialogVisible" title="上传知识文档" width="520px" destroy-on-close>
      <el-form label-width="90px">
        <el-form-item label="文档标题">
          <el-input v-model="uploadTitle" placeholder="留空则使用文件名" />
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="文档类型">
              <el-select v-model="uploadType" style="width:100%">
                <el-option label="临床指南" value="guideline" />
                <el-option label="病例文档" value="case" />
                <el-option label="教材" value="textbook" />
                <el-option label="论文" value="paper" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="疾病分类">
              <el-input v-model="uploadCategory" placeholder="如：内分泌疾病" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="选择文件">
          <el-upload
            ref="uploadRef"
            :auto-upload="false"
            :limit="1"
            accept=".txt,.pdf,.docx,.doc,.md"
            :on-change="handleFileChange"
          >
            <el-button :icon="Upload">选择文件</el-button>
            <template #tip>
              <div class="el-upload__tip">支持 txt、pdf、docx、md 格式，最大 50MB</div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="uploadDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="uploading" @click="handleUpload">上传</el-button>
      </template>
    </el-dialog>

    <!-- 文档详情弹窗 -->
    <el-dialog v-model="detailDialogVisible" title="文档详情" width="760px" destroy-on-close>
      <div v-if="detailDoc" class="detail-content">
        <el-descriptions :column="2" border size="small" style="margin-bottom:16px">
          <el-descriptions-item label="标题">{{ detailDoc.title }}</el-descriptions-item>
          <el-descriptions-item label="类型">{{ typeText(detailDoc.doc_type) }}</el-descriptions-item>
          <el-descriptions-item label="分类">{{ detailDoc.category || '-' }}</el-descriptions-item>
          <el-descriptions-item label="切片数">{{ detailDoc.chunk_count }}</el-descriptions-item>
        </el-descriptions>
        <div class="content-preview">
          <h4>文档内容</h4>
          <div class="content-text" style="white-space:pre-line">{{ detailContent }}</div>
        </div>
        <div v-if="detailChunks.length" class="chunks-section" style="margin-top:16px">
          <h4>文档切片（{{ detailChunks.length }} 个）</h4>
          <el-collapse>
            <el-collapse-item
              v-for="chunk in detailChunks"
              :key="chunk.id"
              :title="`切片 #${chunk.chunk_index + 1}（${chunk.token_count} 字符）`"
            >
              <p style="white-space:pre-line;font-size:13px;line-height:1.7">{{ chunk.content }}</p>
            </el-collapse-item>
          </el-collapse>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { Search, Plus, Upload } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import {
  getDocumentsApi, getDocumentApi, createDocumentApi, updateDocumentApi,
  deleteDocumentApi, uploadDocumentApi, vectorizeDocumentApi
} from '@/api/knowledge'

const userStore = useUserStore()
const isAdmin = computed(() => userStore.userInfo.role === 'admin')

const keyword = ref('')
const filterType = ref('')
const loading = ref(false)
const tableData = ref([])
const page = ref(1)
const perPage = ref(10)
const total = ref(0)

const addDialogVisible = ref(false)
const isEdit = ref(false)
const editId = ref(null)
const submitting = ref(false)
const addFormRef = ref(null)
const addForm = reactive({ title: '', doc_type: 'guideline', category: '', description: '', content: '' })
const addRules = {
  title: [{ required: true, message: '请输入文档标题', trigger: 'blur' }],
  content: [{ required: true, message: '请输入文档内容', trigger: 'blur' }],
}

const uploadDialogVisible = ref(false)
const uploading = ref(false)
const uploadTitle = ref('')
const uploadType = ref('guideline')
const uploadCategory = ref('')
const uploadFile = ref(null)
const uploadRef = ref(null)

const detailDialogVisible = ref(false)
const detailDoc = ref(null)
const detailContent = ref('')
const detailChunks = ref([])

const vectorizingId = ref(null)

function typeText(t) {
  return { guideline: '临床指南', case: '病例文档', textbook: '教材', paper: '论文' }[t] || t
}
function typeTag(t) {
  return { guideline: 'success', case: 'warning', textbook: '', paper: 'info' }[t] || ''
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getDocumentsApi({
      page: page.value, per_page: perPage.value, keyword: keyword.value, doc_type: filterType.value,
    })
    if (res.code === 200) {
      tableData.value = res.data.items
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

function showAddDialog() {
  isEdit.value = false
  editId.value = null
  Object.assign(addForm, { title: '', doc_type: 'guideline', category: '', description: '', content: '' })
  addDialogVisible.value = true
}

function showEditDialog(row) {
  isEdit.value = true
  editId.value = row.id
  Object.assign(addForm, { title: row.title, doc_type: row.doc_type, category: row.category || '', description: row.description || '', content: '' })
  addDialogVisible.value = true
  getDocumentApi(row.id).then(res => {
    if (res.code === 200) {
      addForm.content = res.data.content || res.data.chunks?.map(c => c.content).join('\n') || ''
    }
  })
}

async function handleAddSubmit() {
  await addFormRef.value?.validate()
  submitting.value = true
  try {
    const res = isEdit.value
      ? await updateDocumentApi(editId.value, addForm)
      : await createDocumentApi(addForm)
    if (res.code === 200) {
      ElMessage.success(res.message)
      addDialogVisible.value = false
      fetchData()
    }
  } finally {
    submitting.value = false
  }
}

function showUploadDialog() {
  uploadTitle.value = ''
  uploadType.value = 'guideline'
  uploadCategory.value = ''
  uploadFile.value = null
  uploadDialogVisible.value = true
}

function handleFileChange(file) {
  uploadFile.value = file.raw
}

async function handleUpload() {
  if (!uploadFile.value) return ElMessage.warning('请选择文件')
  uploading.value = true
  try {
    const formData = new FormData()
    formData.append('file', uploadFile.value)
    if (uploadTitle.value) formData.append('title', uploadTitle.value)
    formData.append('doc_type', uploadType.value)
    if (uploadCategory.value) formData.append('category', uploadCategory.value)
    const res = await uploadDocumentApi(formData)
    if (res.code === 200) {
      ElMessage.success('上传成功')
      uploadDialogVisible.value = false
      fetchData()
    }
  } finally {
    uploading.value = false
  }
}

async function handleVectorize(row) {
  vectorizingId.value = row.id
  try {
    const res = await vectorizeDocumentApi(row.id)
    if (res.code === 200) {
      ElMessage.success(res.message)
      fetchData()
    } else {
      ElMessage.error(res.message)
    }
  } finally {
    vectorizingId.value = null
  }
}

async function showDetailDialog(row) {
  detailDoc.value = row
  detailContent.value = ''
  detailChunks.value = []
  detailDialogVisible.value = true
  const res = await getDocumentApi(row.id)
  if (res.code === 200) {
    detailContent.value = res.data.content || res.data.chunks?.map(c => c.content).join('\n\n') || '暂无内容'
    detailChunks.value = res.data.chunks || []
  }
}

async function handleDelete(id) {
  const res = await deleteDocumentApi(id)
  if (res.code === 200) {
    ElMessage.success('删除成功')
    fetchData()
  }
}

onMounted(fetchData)
</script>

<style lang="scss" scoped>
.header-actions { display: flex; gap: 10px; }
.pagination-wrap { display: flex; justify-content: flex-end; margin-top: 16px; }
.detail-content {
  h4 {
    font-size: 15px;
    font-weight: 600;
    color: var(--primary-color);
    margin-bottom: 10px;
  }
  .content-text {
    max-height: 300px;
    overflow-y: auto;
    background: var(--bg-color);
    border-radius: 8px;
    padding: 16px;
    font-size: 13px;
    line-height: 1.8;
    border: 1px solid var(--border-light);
  }
}
</style>
