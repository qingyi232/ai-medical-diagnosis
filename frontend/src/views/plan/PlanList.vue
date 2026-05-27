<template>
  <div class="plan-list">
    <div class="page-card">
      <div class="page-header">
        <span class="page-title">方案管理</span>
        <div class="header-actions">
          <el-input
            v-model="keyword"
            placeholder="搜索方案标题"
            :prefix-icon="Search"
            clearable
            style="width: 240px"
            @clear="fetchData"
            @keyup.enter="fetchData"
          />
          <el-select v-model="filterStatus" placeholder="状态筛选" clearable style="width: 130px" @change="fetchData">
            <el-option label="已生成" value="generated" />
            <el-option label="已审阅" value="reviewed" />
            <el-option label="已采纳" value="approved" />
            <el-option label="已驳回" value="rejected" />
          </el-select>
          <el-button type="primary" :icon="MagicStick" @click="$router.push('/plan-generate')">
            生成新方案
          </el-button>
        </div>
      </div>

      <el-table :data="tableData" stripe v-loading="loading" style="width: 100%">
        <el-table-column prop="title" label="方案标题" min-width="200" show-overflow-tooltip />
        <el-table-column prop="patient_name" label="患者" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="statusType(row.status)" size="small" class="status-tag">
              {{ statusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="confidence_score" label="匹配度" width="90">
          <template #default="{ row }">
            <span v-if="row.confidence_score">{{ (row.confidence_score * 100).toFixed(0) }}%</span>
            <span v-else class="text-light">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="rating" label="评分" width="80">
          <template #default="{ row }">
            <span v-if="row.rating" style="color: var(--accent-color); font-weight: 600">{{ row.rating }}分</span>
            <span v-else class="text-light">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="生成时间" width="170" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" size="small" @click="$router.push(`/plans/${row.id}`)">查看</el-button>
            <el-button text type="success" size="small" @click="handleApprove(row)" v-if="row.status === 'generated'">
              采纳
            </el-button>
            <el-popconfirm title="确定删除该方案？" @confirm="handleDelete(row.id)">
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
import { Search, MagicStick } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { getPlansApi, deletePlanApi, submitFeedbackApi } from '@/api/plan'

const keyword = ref('')
const filterStatus = ref('')
const loading = ref(false)
const tableData = ref([])
const page = ref(1)
const perPage = ref(10)
const total = ref(0)

function statusType(s) {
  return { generated: 'info', reviewed: 'warning', approved: 'success', rejected: 'danger' }[s] || 'info'
}
function statusText(s) {
  return { generated: '已生成', reviewed: '已审阅', approved: '已采纳', rejected: '已驳回' }[s] || s
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getPlansApi({
      page: page.value, per_page: perPage.value,
      keyword: keyword.value, status: filterStatus.value,
    })
    if (res.code === 200) {
      tableData.value = res.data.items
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

async function handleApprove(row) {
  const res = await submitFeedbackApi(row.id, { status: 'approved' })
  if (res.code === 200) {
    ElMessage.success('方案已采纳')
    fetchData()
  }
}

async function handleDelete(id) {
  const res = await deletePlanApi(id)
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
.text-light { color: var(--text-light); font-size: 12px; }
</style>
