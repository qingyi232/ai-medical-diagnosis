<template>
  <div class="patient-detail" v-loading="loading">
    <div class="page-card" v-if="patient">
      <div class="page-header">
        <span class="page-title">患者详情 - {{ patient.name }}</span>
        <el-button @click="$router.back()">返回</el-button>
      </div>

      <el-descriptions :column="3" border>
        <el-descriptions-item label="患者编号">{{ patient.patient_no }}</el-descriptions-item>
        <el-descriptions-item label="姓名">{{ patient.name }}</el-descriptions-item>
        <el-descriptions-item label="性别">{{ patient.gender }}</el-descriptions-item>
        <el-descriptions-item label="年龄">{{ patient.age }} 岁</el-descriptions-item>
        <el-descriptions-item label="血型">{{ patient.blood_type }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ patient.phone }}</el-descriptions-item>
        <el-descriptions-item label="过敏史" :span="3">{{ patient.allergy_history || '无' }}</el-descriptions-item>
        <el-descriptions-item label="既往病史" :span="3">{{ patient.medical_history || '无' }}</el-descriptions-item>
        <el-descriptions-item label="家族病史" :span="3">{{ patient.family_history || '无' }}</el-descriptions-item>
      </el-descriptions>
    </div>

    <!-- 病历记录 -->
    <div class="page-card" style="margin-top: 20px">
      <div class="page-header">
        <span class="page-title">病历记录</span>
        <el-button type="primary" :icon="Plus" @click="showRecordDialog()">新增病历</el-button>
      </div>

      <el-table :data="records" stripe>
        <el-table-column prop="record_no" label="病历编号" width="160" />
        <el-table-column prop="visit_date" label="就诊日期" width="120" />
        <el-table-column prop="department" label="科室" width="100" />
        <el-table-column prop="diagnosis" label="诊断" min-width="200" show-overflow-tooltip />
        <el-table-column prop="diagnosis_type" label="类型" width="80" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button text type="primary" size="small" @click="$router.push(`/records/${row.id}`)">详情</el-button>
            <el-button text type="primary" size="small" @click="goGenerate(row)">生成方案</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 新增病历弹窗 -->
    <el-dialog v-model="recordDialogVisible" title="新增病历" width="800px" destroy-on-close>
      <el-form ref="recordFormRef" :model="recordForm" :rules="recordRules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="就诊日期" prop="visit_date">
              <el-date-picker v-model="recordForm.visit_date" type="date" value-format="YYYY-MM-DD" style="width:100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="就诊科室">
              <el-input v-model="recordForm.department" placeholder="如：内科" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="主诉" prop="chief_complaint">
          <el-input v-model="recordForm.chief_complaint" type="textarea" :rows="2" placeholder="患者主要症状" />
        </el-form-item>
        <el-form-item label="现病史">
          <el-input v-model="recordForm.present_illness" type="textarea" :rows="3" placeholder="详细描述" />
        </el-form-item>
        <el-form-item label="体格检查">
          <el-input v-model="recordForm.physical_exam" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="实验室检查">
          <el-input v-model="recordForm.lab_results" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="影像学检查">
          <el-input v-model="recordForm.imaging_results" type="textarea" :rows="2" />
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="16">
            <el-form-item label="诊断">
              <el-input v-model="recordForm.diagnosis" type="textarea" :rows="2" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="诊断类型">
              <el-select v-model="recordForm.diagnosis_type" style="width:100%">
                <el-option label="初诊" value="初诊" />
                <el-option label="复诊" value="复诊" />
                <el-option label="确诊" value="确诊" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="治疗方案">
          <el-input v-model="recordForm.treatment" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="处方用药">
          <el-input v-model="recordForm.prescription" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="recordDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleCreateRecord">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Plus } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { getPatientApi, getPatientRecordsApi } from '@/api/patient'
import { createRecordApi } from '@/api/patient'

const route = useRoute()
const router = useRouter()
const loading = ref(false)
const patient = ref(null)
const records = ref([])
const recordDialogVisible = ref(false)
const submitting = ref(false)
const recordFormRef = ref(null)

const recordForm = reactive({
  visit_date: '', department: '', chief_complaint: '', present_illness: '',
  physical_exam: '', lab_results: '', imaging_results: '', diagnosis: '',
  diagnosis_type: '初诊', treatment: '', prescription: '',
})

const recordRules = {
  chief_complaint: [{ required: true, message: '请输入主诉', trigger: 'blur' }],
}

function showRecordDialog() {
  Object.keys(recordForm).forEach(k => { recordForm[k] = k === 'diagnosis_type' ? '初诊' : '' })
  recordDialogVisible.value = true
}

function goGenerate(record) {
  router.push({ path: '/plan-generate', query: { record_id: record.id, patient_id: patient.value?.id } })
}

async function handleCreateRecord() {
  await recordFormRef.value?.validate()
  submitting.value = true
  try {
    const res = await createRecordApi(route.params.id, recordForm)
    if (res.code === 200) {
      ElMessage.success('病历创建成功')
      recordDialogVisible.value = false
      fetchRecords()
    }
  } finally {
    submitting.value = false
  }
}

async function fetchRecords() {
  const res = await getPatientRecordsApi(route.params.id, { page: 1, per_page: 100 })
  if (res.code === 200) records.value = res.data.items
}

onMounted(async () => {
  loading.value = true
  try {
    const res = await getPatientApi(route.params.id)
    if (res.code === 200) patient.value = res.data
    await fetchRecords()
  } finally {
    loading.value = false
  }
})
</script>
