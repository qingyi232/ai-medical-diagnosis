<template>
  <div class="plan-detail" v-loading="loading">
    <template v-if="plan">
      <!-- 顶部概要 -->
      <div class="page-card">
        <div class="page-header">
          <span class="page-title">{{ plan.title }}</span>
          <div class="header-actions">
            <el-tag :type="statusType(plan.status)" class="status-tag">{{ statusText(plan.status) }}</el-tag>
            <el-button type="primary" @click="handleExport">导出Word</el-button>
            <el-button @click="$router.back()">返回</el-button>
          </div>
        </div>

        <el-descriptions :column="4" border size="small">
          <el-descriptions-item label="患者">{{ plan.patient_name || '-' }}</el-descriptions-item>
          <el-descriptions-item label="生成时间">{{ plan.created_at }}</el-descriptions-item>
          <el-descriptions-item label="知识库匹配度">
            <span v-if="plan.confidence_score" style="font-weight:600;color:var(--primary-color)">
              {{ (plan.confidence_score * 100).toFixed(0) }}%
            </span>
            <span v-else>-</span>
          </el-descriptions-item>
          <el-descriptions-item label="评分">
            <el-rate v-if="plan.rating" v-model="plan.rating" disabled />
            <span v-else style="color:var(--text-light)">未评分</span>
          </el-descriptions-item>
        </el-descriptions>
      </div>

      <el-row :gutter="20" style="margin-top: 20px">
        <!-- 左侧：输入信息 -->
        <el-col :span="8">
          <div class="page-card side-panel">
            <h4 class="section-title">
              <el-icon><Document /></el-icon>
              输入病例信息
            </h4>
            <div class="text-block">{{ plan.input_text }}</div>
          </div>

          <!-- 参考来源 -->
          <div class="page-card side-panel" style="margin-top: 16px" v-if="plan.reference_sources">
            <h4 class="section-title">
              <el-icon><Collection /></el-icon>
              参考来源
            </h4>
            <div class="reference-list">
              <div
                v-for="(src, idx) in plan.reference_sources.split('\n').filter(Boolean)"
                :key="idx"
                class="reference-item"
              >
                <el-icon><Document /></el-icon>
                {{ src }}
              </div>
            </div>
          </div>

          <!-- 医生反馈 -->
          <div class="page-card side-panel" style="margin-top: 16px">
            <h4 class="section-title">
              <el-icon><ChatDotRound /></el-icon>
              医生反馈
            </h4>
            <el-form label-position="top">
              <el-form-item label="评分">
                <el-rate v-model="feedbackRating" :colors="['#C9956B', '#C9956B', '#1B5E4B']" />
              </el-form-item>
              <el-form-item label="反馈意见">
                <el-input
                  v-model="feedbackText"
                  type="textarea"
                  :rows="3"
                  placeholder="请输入您对该方案的评价和修改建议"
                />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" size="small" @click="submitFeedback('approved')">采纳方案</el-button>
                <el-button type="warning" size="small" @click="submitFeedback('reviewed')">标记已阅</el-button>
                <el-button type="danger" size="small" @click="submitFeedback('rejected')">驳回方案</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-col>

        <!-- 右侧：生成方案 -->
        <el-col :span="16">
          <div class="page-card main-plan">
            <h4 class="section-title">
              <el-icon><MagicStick /></el-icon>
              智慧医疗方案
            </h4>
            <div class="markdown-body plan-content" v-html="renderedPlan"></div>

            <el-divider />
            <div class="disclaimer">
              <el-icon><Warning /></el-icon>
              <span>免责声明：本系统生成的方案仅供医生参考，最终诊疗决策须由执业医师做出。</span>
            </div>
          </div>
        </el-col>
      </el-row>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getPlanApi, submitFeedbackApi, exportPlanApi } from '@/api/plan'
import { marked } from 'marked'

const route = useRoute()
const loading = ref(false)
const plan = ref(null)
const feedbackRating = ref(0)
const feedbackText = ref('')

function statusType(s) {
  return { generated: 'info', reviewed: 'warning', approved: 'success', rejected: 'danger' }[s] || 'info'
}
function statusText(s) {
  return { generated: '已生成', reviewed: '已审阅', approved: '已采纳', rejected: '已驳回' }[s] || s
}

const renderedPlan = computed(() => {
  if (!plan.value?.generated_plan) return ''
  return marked(plan.value.generated_plan)
})

async function handleExport() {
  try {
    const res = await exportPlanApi(route.params.id)
    const blob = new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `${plan.value.title || '医疗方案'}.docx`
    a.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('方案导出成功')
  } catch (e) {
    ElMessage.error('导出失败，请重试')
  }
}

async function submitFeedback(status) {
  const data = { status }
  if (feedbackRating.value) data.rating = feedbackRating.value
  if (feedbackText.value) data.doctor_feedback = feedbackText.value
  const res = await submitFeedbackApi(route.params.id, data)
  if (res.code === 200) {
    ElMessage.success('反馈提交成功')
    plan.value = res.data
  }
}

onMounted(async () => {
  loading.value = true
  try {
    const res = await getPlanApi(route.params.id)
    if (res.code === 200) {
      plan.value = res.data
      feedbackRating.value = res.data.rating || 0
      feedbackText.value = res.data.doctor_feedback || ''
    }
  } finally {
    loading.value = false
  }
})
</script>

<style lang="scss" scoped>
.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 15px;
  font-weight: 600;
  color: var(--primary-color);
  margin-bottom: 16px;
  padding-bottom: 10px;
  border-bottom: 1px solid var(--border-light);
}

.side-panel {
  .text-block {
    background: var(--bg-color);
    border: 1px solid var(--border-light);
    border-radius: 8px;
    padding: 14px 16px;
    font-size: 13px;
    line-height: 1.8;
    color: var(--text-primary);
    white-space: pre-line;
    max-height: 300px;
    overflow-y: auto;
  }

  .reference-list {
    .reference-item {
      display: flex;
      align-items: flex-start;
      gap: 6px;
      font-size: 13px;
      color: var(--text-secondary);
      padding: 6px 0;
      border-bottom: 1px solid var(--border-light);

      &:last-child { border-bottom: none; }

      .el-icon {
        color: var(--accent-color);
        margin-top: 3px;
        flex-shrink: 0;
      }
    }
  }
}

.main-plan {
  .plan-content {
    max-height: calc(100vh - 360px);
    overflow-y: auto;
    padding-right: 8px;
  }
}

.disclaimer {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: var(--warning-color);
  padding: 10px;
  background: #FFF8E1;
  border-radius: 6px;
}
</style>
