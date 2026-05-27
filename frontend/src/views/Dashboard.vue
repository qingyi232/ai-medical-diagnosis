<template>
  <div class="dashboard">
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stat-row">
      <el-col :span="6">
        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-icon" style="background: linear-gradient(135deg, #1B5E4B, #2D8A6E)">
              <el-icon><User /></el-icon>
            </div>
          </div>
          <div class="stat-value">{{ isAdmin ? (stats.user_count || 0) : (stats.patient_count || 0) }}</div>
          <div class="stat-label">{{ isAdmin ? '系统用户' : '患者总数' }}</div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-icon" style="background: linear-gradient(135deg, #C9956B, #DEB98A)">
              <el-icon><Document /></el-icon>
            </div>
          </div>
          <div class="stat-value">{{ isAdmin ? (stats.patient_count || 0) : (stats.record_count || 0) }}</div>
          <div class="stat-label">{{ isAdmin ? '患者总数' : '病历记录' }}</div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-icon" style="background: linear-gradient(135deg, #5B8FA8, #7BB3C8)">
              <el-icon><Collection /></el-icon>
            </div>
          </div>
          <div class="stat-value">{{ stats.knowledge_count || 0 }}</div>
          <div class="stat-label">知识库文档</div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-icon" style="background: linear-gradient(135deg, #4CAF50, #66BB6A)">
              <el-icon><MagicStick /></el-icon>
            </div>
          </div>
          <div class="stat-value">{{ stats.plan_count || 0 }}</div>
          <div class="stat-label">生成方案</div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <!-- 快捷操作 -->
      <el-col :span="8">
        <div class="page-card quick-actions">
          <div class="page-header">
            <span class="page-title">快捷操作</span>
          </div>
          <div class="action-grid">
            <!-- 医生快捷操作 -->
            <template v-if="isDoctor">
              <div class="action-item" @click="$router.push('/plan-generate')">
                <div class="action-icon" style="background: var(--primary-lighter); color: var(--primary-color)">
                  <el-icon :size="24"><MagicStick /></el-icon>
                </div>
                <span>生成方案</span>
              </div>
              <div class="action-item" @click="$router.push('/patients')">
                <div class="action-icon" style="background: var(--accent-lighter); color: var(--accent-color)">
                  <el-icon :size="24"><UserFilled /></el-icon>
                </div>
                <span>新增患者</span>
              </div>
              <div class="action-item" @click="$router.push('/records')">
                <div class="action-icon" style="background: #EBF5FB; color: var(--info-color)">
                  <el-icon :size="24"><EditPen /></el-icon>
                </div>
                <span>录入病历</span>
              </div>
              <div class="action-item" @click="$router.push('/knowledge')">
                <div class="action-icon" style="background: #E8F5E9; color: var(--success-color)">
                  <el-icon :size="24"><Search /></el-icon>
                </div>
                <span>查看知识库</span>
              </div>
            </template>
            <!-- 管理员快捷操作 -->
            <template v-else>
              <div class="action-item" @click="$router.push('/users')">
                <div class="action-icon" style="background: var(--primary-lighter); color: var(--primary-color)">
                  <el-icon :size="24"><UserFilled /></el-icon>
                </div>
                <span>用户管理</span>
              </div>
              <div class="action-item" @click="$router.push('/knowledge')">
                <div class="action-icon" style="background: var(--accent-lighter); color: var(--accent-color)">
                  <el-icon :size="24"><Collection /></el-icon>
                </div>
                <span>知识库管理</span>
              </div>
              <div class="action-item" @click="$router.push('/plans')">
                <div class="action-icon" style="background: #EBF5FB; color: var(--info-color)">
                  <el-icon :size="24"><Files /></el-icon>
                </div>
                <span>方案审核</span>
              </div>
              <div class="action-item" @click="$router.push('/knowledge')">
                <div class="action-icon" style="background: #E8F5E9; color: var(--success-color)">
                  <el-icon :size="24"><Upload /></el-icon>
                </div>
                <span>上传文档</span>
              </div>
            </template>
          </div>
        </div>

        <!-- 系统信息 -->
        <div class="page-card system-info" style="margin-top: 20px">
          <div class="page-header">
            <span class="page-title">系统信息</span>
          </div>
          <div class="info-list">
            <div class="info-item">
              <span class="info-label">向量化文档</span>
              <span class="info-value">{{ stats.vectorized_count || 0 }} 篇</span>
            </div>
            <div class="info-item">
              <span class="info-label">已审核方案</span>
              <span class="info-value">{{ stats.approved_plan_count || 0 }} 份</span>
            </div>
            <div class="info-item">
              <span class="info-label">大模型</span>
              <span class="info-value">通义千问 Qwen-Plus</span>
            </div>
            <div class="info-item">
              <span class="info-label">RAG引擎</span>
              <span class="info-value">FAISS + Embedding V3</span>
            </div>
          </div>
        </div>
      </el-col>

      <!-- 最近方案 -->
      <el-col :span="16">
        <div class="page-card">
          <div class="page-header">
            <span class="page-title">最近生成的方案</span>
            <el-button text type="primary" @click="$router.push('/plans')">查看全部</el-button>
          </div>
          <el-table :data="stats.recent_plans || []" stripe style="width: 100%">
            <el-table-column prop="title" label="方案标题" min-width="180" show-overflow-tooltip />
            <el-table-column prop="patient_name" label="患者" width="100" />
            <el-table-column prop="status" label="状态" width="100">
              <template #default="{ row }">
                <el-tag
                  :type="statusType(row.status)"
                  class="status-tag"
                  size="small"
                >
                  {{ statusText(row.status) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="created_at" label="生成时间" width="170" />
            <el-table-column label="操作" width="80">
              <template #default="{ row }">
                <el-button text type="primary" size="small" @click="$router.push(`/plans/${row.id}`)">
                  查看
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 最近病历 -->
        <div class="page-card" style="margin-top: 20px">
          <div class="page-header">
            <span class="page-title">最近病历记录</span>
            <el-button text type="primary" @click="$router.push('/records')">查看全部</el-button>
          </div>
          <el-table :data="stats.recent_records || []" stripe style="width: 100%">
            <el-table-column prop="record_no" label="病历编号" width="160" />
            <el-table-column prop="patient_name" label="患者" width="100" />
            <el-table-column prop="diagnosis" label="诊断" min-width="200" show-overflow-tooltip />
            <el-table-column prop="department" label="科室" width="100" />
            <el-table-column prop="created_at" label="创建时间" width="170" />
          </el-table>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { getStatsApi } from '@/api/dashboard'

const userStore = useUserStore()
const isAdmin = computed(() => userStore.userInfo.role === 'admin')
const isDoctor = computed(() => userStore.userInfo.role !== 'admin')

const stats = ref({})

function statusType(status) {
  const map = { generated: 'info', reviewed: 'warning', approved: 'success', rejected: 'danger' }
  return map[status] || 'info'
}

function statusText(status) {
  const map = { generated: '已生成', reviewed: '已审阅', approved: '已采纳', rejected: '已驳回' }
  return map[status] || status
}

onMounted(async () => {
  try {
    const res = await getStatsApi()
    if (res.code === 200) {
      stats.value = res.data
    }
  } catch (e) {
    // handled by interceptor
  }
})
</script>

<style lang="scss" scoped>
.stat-row {
  margin-bottom: 20px;
}

.stat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.quick-actions {
  .action-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;

    .action-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      padding: 16px;
      border-radius: 10px;
      cursor: pointer;
      transition: all 0.3s;
      border: 1px solid var(--border-light);

      &:hover {
        background: var(--primary-lighter);
        border-color: var(--primary-light);
        transform: translateY(-2px);
      }

      .action-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      span {
        font-size: 13px;
        color: var(--text-secondary);
        font-weight: 500;
      }
    }
  }
}

.system-info {
  .info-list {
    display: flex;
    flex-direction: column;
    gap: 12px;

    .info-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 8px 0;
      border-bottom: 1px solid var(--border-light);

      &:last-child {
        border-bottom: none;
      }

      .info-label {
        font-size: 13px;
        color: var(--text-secondary);
      }

      .info-value {
        font-size: 13px;
        font-weight: 600;
        color: var(--text-primary);
      }
    }
  }
}
</style>
