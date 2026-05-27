<template>
  <div class="record-detail" v-loading="loading">
    <div class="page-card" v-if="record">
      <div class="page-header">
        <span class="page-title">病历详情 - {{ record.record_no }}</span>
        <div>
          <el-button type="primary" @click="goGenerate">基于此病历生成方案</el-button>
          <el-button @click="$router.back()">返回</el-button>
        </div>
      </div>

      <el-descriptions :column="3" border class="record-desc">
        <el-descriptions-item label="病历编号">{{ record.record_no }}</el-descriptions-item>
        <el-descriptions-item label="患者姓名">{{ record.patient_name }}</el-descriptions-item>
        <el-descriptions-item label="就诊日期">{{ record.visit_date }}</el-descriptions-item>
        <el-descriptions-item label="就诊科室">{{ record.department }}</el-descriptions-item>
        <el-descriptions-item label="诊断类型">
          <el-tag size="small" :type="record.diagnosis_type === '确诊' ? 'success' : 'info'">
            {{ record.diagnosis_type }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">{{ record.status === 'active' ? '活跃' : '已归档' }}</el-descriptions-item>
      </el-descriptions>

      <div class="section-grid">
        <div class="section-block" v-if="record.chief_complaint">
          <h4>主诉</h4>
          <p>{{ record.chief_complaint }}</p>
        </div>
        <div class="section-block" v-if="record.present_illness">
          <h4>现病史</h4>
          <p>{{ record.present_illness }}</p>
        </div>
        <div class="section-block" v-if="record.past_history">
          <h4>既往史</h4>
          <p>{{ record.past_history }}</p>
        </div>
        <div class="section-block" v-if="record.physical_exam">
          <h4>体格检查</h4>
          <p>{{ record.physical_exam }}</p>
        </div>
        <div class="section-block" v-if="record.lab_results">
          <h4>实验室检查</h4>
          <p>{{ record.lab_results }}</p>
        </div>
        <div class="section-block" v-if="record.imaging_results">
          <h4>影像学检查</h4>
          <p>{{ record.imaging_results }}</p>
        </div>
        <div class="section-block" v-if="record.diagnosis">
          <h4>诊断</h4>
          <p style="white-space: pre-line">{{ record.diagnosis }}</p>
        </div>
        <div class="section-block" v-if="record.treatment">
          <h4>治疗方案</h4>
          <p style="white-space: pre-line">{{ record.treatment }}</p>
        </div>
        <div class="section-block" v-if="record.prescription">
          <h4>处方用药</h4>
          <p style="white-space: pre-line">{{ record.prescription }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getRecordApi } from '@/api/patient'

const route = useRoute()
const router = useRouter()
const loading = ref(false)
const record = ref(null)

function goGenerate() {
  router.push({ path: '/plan-generate', query: { record_id: record.value.id, patient_id: record.value.patient_id } })
}

onMounted(async () => {
  loading.value = true
  try {
    const res = await getRecordApi(route.params.id)
    if (res.code === 200) record.value = res.data
  } finally {
    loading.value = false
  }
})
</script>

<style lang="scss" scoped>
.record-desc {
  margin-bottom: 24px;
}

.section-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;

  .section-block {
    background: var(--bg-color);
    border-radius: 10px;
    padding: 16px 20px;
    border: 1px solid var(--border-light);

    h4 {
      font-size: 14px;
      font-weight: 600;
      color: var(--primary-color);
      margin-bottom: 8px;
      padding-bottom: 6px;
      border-bottom: 1px solid var(--border-light);
    }

    p {
      font-size: 13px;
      line-height: 1.8;
      color: var(--text-primary);
    }
  }
}
</style>
