<template>
  <div class="plan-generate">
    <el-row :gutter="20">
      <!-- 左侧：输入区域 -->
      <el-col :span="10">
        <div class="page-card input-panel">
          <div class="page-header">
            <span class="page-title">病例信息输入</span>
          </div>

          <!-- 如果有关联病历则显示 -->
          <el-alert
            v-if="linkedRecord"
            type="success"
            :closable="false"
            style="margin-bottom: 16px"
          >
            <template #title>
              已关联病历：{{ linkedRecord.record_no }}（{{ linkedRecord.patient_name }}）
            </template>
          </el-alert>

          <el-form label-position="top">
            <el-form-item label="方案标题">
              <el-input v-model="planTitle" placeholder="如：XXX患者心衰治疗方案" />
            </el-form-item>

            <el-form-item label="病例信息">
              <el-input
                v-model="inputText"
                type="textarea"
                :rows="16"
                placeholder="请输入患者病例信息，包括：&#10;• 主诉：主要症状及持续时间&#10;• 现病史：详细病情描述&#10;• 既往史：过往疾病、手术史&#10;• 体格检查：生命体征及体查结果&#10;• 实验室检查：血常规、生化等&#10;• 影像学检查：CT、超声等&#10;• 当前诊断（如有）&#10;&#10;信息越详细，生成方案越精准。"
              />
            </el-form-item>

            <div class="action-buttons">
              <el-button
                type="primary"
                size="large"
                :loading="generating"
                :icon="MagicStick"
                class="generate-btn"
                @click="handleGenerate"
              >
                {{ generating ? '方案生成中...' : '生成智慧医疗方案' }}
              </el-button>
              <el-button
                size="large"
                :icon="Search"
                @click="handleSearch"
                :loading="searching"
              >
                知识库检索
              </el-button>
            </div>
          </el-form>

          <!-- 检索结果 -->
          <div v-if="searchResults.length" class="search-results" style="margin-top: 20px">
            <h4 class="section-title">
              <el-icon><Search /></el-icon>
              知识库检索结果（{{ searchResults.length }} 条）
            </h4>
            <div
              v-for="(item, idx) in searchResults"
              :key="idx"
              class="search-item"
            >
              <div class="search-item-header">
                <span class="source-title">{{ item.doc_title }}</span>
                <el-tag size="small" type="success" class="status-tag">
                  相关度 {{ (item.score * 100).toFixed(0) }}%
                </el-tag>
              </div>
              <p class="search-item-content">{{ item.content }}</p>
            </div>
          </div>
        </div>
      </el-col>

      <!-- 右侧：结果展示 -->
      <el-col :span="14">
        <div class="page-card result-panel">
          <div class="page-header">
            <span class="page-title">生成结果</span>
            <div v-if="generatedPlan" class="result-actions">
              <el-button size="small" :icon="Download" @click="handleExport">
                导出Word
              </el-button>
              <el-button size="small" :icon="View" @click="$router.push(`/plans/${generatedPlan.id}`)">
                查看详情
              </el-button>
            </div>
          </div>

          <!-- 未生成状态 -->
          <div v-if="!generatedPlan && !generating" class="empty-state">
            <div class="empty-icon">
              <el-icon :size="64"><Document /></el-icon>
            </div>
            <h3>输入病例信息，生成智慧医疗方案</h3>
            <p>系统将基于RAG技术检索医疗知识库，结合通义千问大模型生成专业医疗方案</p>
            <div class="process-steps">
              <div class="step">
                <div class="step-num">1</div>
                <span>输入病例</span>
              </div>
              <div class="step-arrow">→</div>
              <div class="step">
                <div class="step-num">2</div>
                <span>语义检索</span>
              </div>
              <div class="step-arrow">→</div>
              <div class="step">
                <div class="step-num">3</div>
                <span>大模型推理</span>
              </div>
              <div class="step-arrow">→</div>
              <div class="step">
                <div class="step-num">4</div>
                <span>方案输出</span>
              </div>
            </div>
          </div>

          <!-- 生成中 -->
          <div v-if="generating" class="generating-state">
            <div class="generating-animation">
              <div class="pulse-ring"></div>
              <el-icon :size="40" class="generating-icon"><Loading /></el-icon>
            </div>
            <h3>正在生成医疗方案...</h3>
            <p>系统正在检索知识库并调用大模型生成方案，请稍候</p>
            <div class="generating-steps">
              <div class="g-step done">
                <el-icon><Check /></el-icon>
                <span>病例信息解析</span>
              </div>
              <div class="g-step" :class="{ done: generatingStep >= 2 }">
                <el-icon v-if="generatingStep >= 2"><Check /></el-icon>
                <el-icon v-else><Loading /></el-icon>
                <span>知识库语义检索</span>
              </div>
              <div class="g-step" :class="{ done: generatingStep >= 3 }">
                <el-icon v-if="generatingStep >= 3"><Check /></el-icon>
                <el-icon v-else><Loading /></el-icon>
                <span>大模型方案推理</span>
              </div>
            </div>
          </div>

          <!-- 生成完成 -->
          <div v-if="generatedPlan && !generating" class="result-content">
            <div class="result-meta">
              <el-tag type="success" size="small" class="status-tag">方案已生成</el-tag>
              <span class="meta-text" v-if="generatedPlan.confidence_score">
                知识库匹配度：{{ (generatedPlan.confidence_score * 100).toFixed(0) }}%
              </span>
              <span class="meta-text">{{ generatedPlan.created_at }}</span>
            </div>

            <div class="plan-text markdown-body" v-html="renderedPlan"></div>

            <!-- 参考来源 -->
            <div v-if="generatedPlan.reference_sources" class="reference-section">
              <h4 class="section-title">
                <el-icon><Collection /></el-icon>
                参考来源
              </h4>
              <div class="reference-list">
                <div
                  v-for="(src, idx) in generatedPlan.reference_sources.split('\n')"
                  :key="idx"
                  class="reference-item"
                >
                  {{ idx + 1 }}. {{ src }}
                </div>
              </div>
            </div>

            <el-divider />
            <div class="disclaimer">
              <el-icon><Warning /></el-icon>
              <span>免责声明：本系统生成的方案仅供医生参考，最终诊疗决策须由执业医师做出。</span>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { MagicStick, Search, View, Loading, Check, Warning, Download } from '@element-plus/icons-vue'
import { generatePlanApi, searchKnowledgeApi, exportPlanApi } from '@/api/plan'
import { getRecordApi } from '@/api/patient'
import { marked } from 'marked'

const route = useRoute()

const planTitle = ref('智慧医疗方案')
const inputText = ref('')
const generating = ref(false)
const generatingStep = ref(1)
const searching = ref(false)
const searchResults = ref([])
const generatedPlan = ref(null)
const linkedRecord = ref(null)

const renderedPlan = computed(() => {
  if (!generatedPlan.value?.generated_plan) return ''
  return marked(generatedPlan.value.generated_plan)
})

async function handleGenerate() {
  if (!inputText.value.trim()) return ElMessage.warning('请输入病例信息')

  generating.value = true
  generatingStep.value = 1
  generatedPlan.value = null

  const stepTimer = setInterval(() => {
    if (generatingStep.value < 3) generatingStep.value++
  }, 3000)

  try {
    const params = {
      input_text: inputText.value,
      title: planTitle.value || '智慧医疗方案',
    }
    if (route.query.record_id) params.record_id = parseInt(route.query.record_id)
    if (route.query.patient_id) params.patient_id = parseInt(route.query.patient_id)

    const res = await generatePlanApi(params)
    if (res.code === 200) {
      generatedPlan.value = res.data
      ElMessage.success('医疗方案生成成功')
    } else {
      ElMessage.error(res.message || '方案生成失败')
    }
  } catch (e) {
    ElMessage.error('方案生成出错，请重试')
  } finally {
    clearInterval(stepTimer)
    generating.value = false
  }
}

async function handleExport() {
  if (!generatedPlan.value?.id) return
  try {
    const res = await exportPlanApi(generatedPlan.value.id)
    const blob = new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `${generatedPlan.value.title || '医疗方案'}.docx`
    a.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('方案导出成功')
  } catch (e) {
    ElMessage.error('导出失败，请重试')
  }
}

async function handleSearch() {
  if (!inputText.value.trim()) return ElMessage.warning('请输入病例信息')
  searching.value = true
  try {
    const res = await searchKnowledgeApi({ query: inputText.value, top_k: 5 })
    if (res.code === 200) {
      searchResults.value = res.data || []
      if (!searchResults.value.length) ElMessage.info('未检索到相关知识库内容')
      else ElMessage.success(`检索到 ${searchResults.value.length} 条相关结果`)
    } else {
      ElMessage.error(res.message || '检索失败')
    }
  } catch (e) {
    console.error('知识库检索失败:', e)
    ElMessage.error(e?.response?.data?.message || '知识库检索请求失败，请重试')
  } finally {
    searching.value = false
  }
}

onMounted(async () => {
  if (route.query.record_id) {
    try {
      const res = await getRecordApi(route.query.record_id)
      if (res.code === 200) {
        linkedRecord.value = res.data
        const r = res.data
        const parts = []
        if (r.chief_complaint) parts.push(`主诉：${r.chief_complaint}`)
        if (r.present_illness) parts.push(`现病史：${r.present_illness}`)
        if (r.past_history) parts.push(`既往史：${r.past_history}`)
        if (r.physical_exam) parts.push(`体格检查：${r.physical_exam}`)
        if (r.lab_results) parts.push(`实验室检查：${r.lab_results}`)
        if (r.imaging_results) parts.push(`影像学检查：${r.imaging_results}`)
        if (r.diagnosis) parts.push(`诊断：${r.diagnosis}`)
        inputText.value = parts.join('\n')
        planTitle.value = `${r.patient_name || ''}医疗方案`
      }
    } catch (e) {
      // ignore
    }
  }
})
</script>

<style lang="scss" scoped>
.input-panel {
  min-height: calc(100vh - 130px);
}

.result-panel {
  min-height: calc(100vh - 130px);
}

.generate-btn {
  flex: 1;
  height: 46px;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 1px;
  border-radius: 10px;
}

.action-buttons {
  display: flex;
  gap: 12px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  font-weight: 600;
  color: var(--primary-color);
  margin-bottom: 12px;
}

.search-results {
  .search-item {
    background: var(--bg-color);
    border: 1px solid var(--border-light);
    border-radius: 8px;
    padding: 12px 16px;
    margin-bottom: 8px;

    .search-item-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 6px;

      .source-title {
        font-size: 13px;
        font-weight: 600;
        color: var(--primary-color);
      }
    }

    .search-item-content {
      font-size: 12px;
      line-height: 1.6;
      color: var(--text-secondary);
      display: -webkit-box;
      -webkit-line-clamp: 3;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
  }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 400px;
  text-align: center;

  .empty-icon {
    color: var(--border-color);
    margin-bottom: 20px;
  }

  h3 {
    font-size: 18px;
    color: var(--text-primary);
    margin-bottom: 8px;
  }

  p {
    font-size: 14px;
    color: var(--text-secondary);
    margin-bottom: 32px;
    max-width: 400px;
  }

  .process-steps {
    display: flex;
    align-items: center;
    gap: 12px;

    .step {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;

      .step-num {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: var(--primary-lighter);
        color: var(--primary-color);
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      span {
        font-size: 12px;
        color: var(--text-secondary);
      }
    }

    .step-arrow {
      color: var(--text-light);
      font-size: 18px;
      margin-bottom: 20px;
    }
  }
}

.generating-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 400px;

  .generating-animation {
    position: relative;
    margin-bottom: 24px;

    .pulse-ring {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 80px;
      height: 80px;
      border-radius: 50%;
      border: 2px solid var(--primary-light);
      animation: pulse 1.5s infinite;
    }

    .generating-icon {
      color: var(--primary-color);
      animation: spin 1.5s linear infinite;
    }
  }

  h3 {
    color: var(--text-primary);
    margin-bottom: 8px;
  }

  p {
    color: var(--text-secondary);
    font-size: 14px;
    margin-bottom: 24px;
  }

  .generating-steps {
    display: flex;
    flex-direction: column;
    gap: 10px;

    .g-step {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 14px;
      color: var(--text-light);
      transition: all 0.3s;

      .el-icon {
        animation: spin 1s linear infinite;
      }

      &.done {
        color: var(--success-color);

        .el-icon {
          animation: none;
        }
      }
    }
  }
}

.result-content {
  .result-meta {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
    padding-bottom: 12px;
    border-bottom: 1px solid var(--border-light);

    .meta-text {
      font-size: 12px;
      color: var(--text-light);
    }
  }

  .plan-text {
    max-height: calc(100vh - 380px);
    overflow-y: auto;
    padding-right: 8px;
  }

  .reference-section {
    margin-top: 20px;
    padding: 16px;
    background: var(--accent-lighter);
    border-radius: 8px;

    .reference-item {
      font-size: 13px;
      color: var(--text-secondary);
      margin-bottom: 4px;
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
}

@keyframes pulse {
  0% { transform: translate(-50%, -50%) scale(1); opacity: 0.5; }
  100% { transform: translate(-50%, -50%) scale(1.5); opacity: 0; }
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
</style>
