<template>
  <div class="record-list">
    <div class="page-card">
      <div class="page-header">
        <span class="page-title">病历管理</span>
        <div class="header-actions">
          <el-input
            v-model="keyword"
            placeholder="搜索诊断/主诉/编号"
            :prefix-icon="Search"
            clearable
            style="width: 260px"
            @clear="fetchData"
            @keyup.enter="fetchData"
          />
        </div>
      </div>

      <el-table :data="tableData" stripe v-loading="loading" style="width: 100%">
        <el-table-column prop="record_no" label="病历编号" width="170" />
        <el-table-column prop="patient_name" label="患者" width="100" />
        <el-table-column prop="visit_date" label="就诊日期" width="120" />
        <el-table-column prop="department" label="科室" width="100" />
        <el-table-column prop="chief_complaint" label="主诉" min-width="180" show-overflow-tooltip />
        <el-table-column prop="diagnosis" label="诊断" min-width="200" show-overflow-tooltip />
        <el-table-column prop="diagnosis_type" label="类型" width="80">
          <template #default="{ row }">
            <el-tag size="small" :type="row.diagnosis_type === '确诊' ? 'success' : 'info'" class="status-tag">
              {{ row.diagnosis_type }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="创建时间" width="170" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" size="small" @click="$router.push(`/records/${row.id}`)">详情</el-button>
            <el-button text type="primary" size="small" @click="goGenerate(row)">生成方案</el-button>
            <el-popconfirm title="确定删除该病历？" @confirm="handleDelete(row.id)">
              <template #reference>
                <el-button text type="danger" size="small">删除</el-button>
              </template>
            </el-popconfirm>
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
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Search } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { getAllRecordsApi, deleteRecordApi } from '@/api/patient'

const router = useRouter()
const keyword = ref('')
const loading = ref(false)
const tableData = ref([])
const page = ref(1)
const perPage = ref(10)
const total = ref(0)

async function fetchData() {
  loading.value = true
  try {
    const res = await getAllRecordsApi({ page: page.value, per_page: perPage.value, keyword: keyword.value })
    if (res.code === 200) {
      tableData.value = res.data.items
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

function goGenerate(row) {
  router.push({ path: '/plan-generate', query: { record_id: row.id, patient_id: row.patient_id } })
}

async function handleDelete(id) {
  const res = await deleteRecordApi(id)
  if (res.code === 200) {
    ElMessage.success('删除成功')
    fetchData()
  }
}

onMounted(fetchData)
</script>

<style lang="scss" scoped>
.header-actions { display: flex; gap: 12px; }
.pagination-wrap { display: flex; justify-content: flex-end; margin-top: 16px; }
</style>
