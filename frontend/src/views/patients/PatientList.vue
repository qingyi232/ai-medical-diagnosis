<template>
  <div class="patient-list">
    <div class="page-card">
      <div class="page-header">
        <span class="page-title">患者管理</span>
        <div class="header-actions">
          <el-input
            v-model="keyword"
            placeholder="搜索患者姓名/编号"
            :prefix-icon="Search"
            clearable
            style="width: 240px"
            @clear="fetchData"
            @keyup.enter="fetchData"
          />
          <el-button type="primary" :icon="Plus" @click="showDialog()">新增患者</el-button>
        </div>
      </div>

      <el-table :data="tableData" stripe v-loading="loading" style="width: 100%">
        <el-table-column prop="patient_no" label="患者编号" width="150" />
        <el-table-column prop="name" label="姓名" width="100" />
        <el-table-column prop="gender" label="性别" width="70" />
        <el-table-column prop="age" label="年龄" width="70" />
        <el-table-column prop="phone" label="联系电话" width="130" />
        <el-table-column prop="blood_type" label="血型" width="80" />
        <el-table-column prop="medical_history" label="既往病史" min-width="200" show-overflow-tooltip />
        <el-table-column prop="created_at" label="创建时间" width="170" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button text type="primary" size="small" @click="$router.push(`/patients/${row.id}`)">详情</el-button>
            <el-button text type="primary" size="small" @click="showDialog(row)">编辑</el-button>
            <el-popconfirm title="确定删除该患者？" @confirm="handleDelete(row.id)">
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

    <!-- 新增/编辑弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑患者' : '新增患者'"
      width="640px"
      destroy-on-close
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="姓名" prop="name">
              <el-input v-model="form.name" placeholder="请输入患者姓名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="性别" prop="gender">
              <el-select v-model="form.gender" placeholder="请选择" style="width: 100%">
                <el-option label="男" value="男" />
                <el-option label="女" value="女" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="年龄" prop="age">
              <el-input-number v-model="form.age" :min="0" :max="150" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="血型">
              <el-select v-model="form.blood_type" placeholder="请选择" style="width: 100%" clearable>
                <el-option label="A型" value="A型" />
                <el-option label="B型" value="B型" />
                <el-option label="AB型" value="AB型" />
                <el-option label="O型" value="O型" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="联系电话">
              <el-input v-model="form.phone" placeholder="请输入联系电话" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="身份证号">
              <el-input v-model="form.id_card" placeholder="请输入(脱敏)" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="过敏史">
          <el-input v-model="form.allergy_history" type="textarea" :rows="2" placeholder="请输入过敏史" />
        </el-form-item>
        <el-form-item label="既往病史">
          <el-input v-model="form.medical_history" type="textarea" :rows="2" placeholder="请输入既往病史" />
        </el-form-item>
        <el-form-item label="家族病史">
          <el-input v-model="form.family_history" type="textarea" :rows="2" placeholder="请输入家族病史" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { Search, Plus } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { getPatientsApi, createPatientApi, updatePatientApi, deletePatientApi } from '@/api/patient'

const keyword = ref('')
const loading = ref(false)
const tableData = ref([])
const page = ref(1)
const perPage = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitting = ref(false)
const formRef = ref(null)
const editId = ref(null)

const form = reactive({
  name: '', gender: '', age: null, phone: '', id_card: '',
  blood_type: '', allergy_history: '', medical_history: '', family_history: '',
})

const rules = {
  name: [{ required: true, message: '请输入患者姓名', trigger: 'blur' }],
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getPatientsApi({ page: page.value, per_page: perPage.value, keyword: keyword.value })
    if (res.code === 200) {
      tableData.value = res.data.items
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

function showDialog(row) {
  isEdit.value = !!row
  editId.value = row?.id || null
  Object.keys(form).forEach(k => { form[k] = row?.[k] ?? (k === 'age' ? null : '') })
  dialogVisible.value = true
}

async function handleSubmit() {
  await formRef.value?.validate()
  submitting.value = true
  try {
    const res = isEdit.value
      ? await updatePatientApi(editId.value, form)
      : await createPatientApi(form)
    if (res.code === 200) {
      ElMessage.success(res.message)
      dialogVisible.value = false
      fetchData()
    }
  } finally {
    submitting.value = false
  }
}

async function handleDelete(id) {
  const res = await deletePatientApi(id)
  if (res.code === 200) {
    ElMessage.success('删除成功')
    fetchData()
  }
}

onMounted(fetchData)
</script>

<style lang="scss" scoped>
.header-actions {
  display: flex;
  gap: 12px;
}
.pagination-wrap {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}
</style>
