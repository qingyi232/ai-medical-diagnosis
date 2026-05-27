<template>
  <div class="login-page">
    <div class="login-bg"></div>

    <div class="login-container">
      <div class="login-left">
        <div class="brand-info">
          <div class="brand-icon">
            <el-icon :size="40"><FirstAidKit /></el-icon>
          </div>
          <h1>智慧医疗方案生成系统</h1>
          <p class="brand-desc">
            基于大模型与RAG技术，为医疗机构提供精准、可解释的智慧医疗方案
          </p>
          <div class="feature-list">
            <div class="feature-item">
              <el-icon><Search /></el-icon>
              <span>病例语义检索</span>
            </div>
            <div class="feature-item">
              <el-icon><DataAnalysis /></el-icon>
              <span>智能方案生成</span>
            </div>
            <div class="feature-item">
              <el-icon><Collection /></el-icon>
              <span>医疗知识库</span>
            </div>
          </div>
        </div>
      </div>

      <div class="login-right">
        <div class="login-form-wrapper">
          <h2>欢迎登录</h2>
          <p class="login-subtitle">请输入您的账号信息</p>

          <el-form ref="formRef" :model="form" :rules="rules" size="large" @keyup.enter="handleLogin">
            <el-form-item prop="username">
              <el-input
                v-model="form.username"
                placeholder="请输入用户名"
                :prefix-icon="User"
              />
            </el-form-item>
            <el-form-item prop="password">
              <el-input
                v-model="form.password"
                type="password"
                placeholder="请输入密码"
                :prefix-icon="Lock"
                show-password
              />
            </el-form-item>
            <el-form-item>
              <el-button
                type="primary"
                :loading="loading"
                class="login-btn"
                @click="handleLogin"
              >
                {{ loading ? '登录中...' : '登 录' }}
              </el-button>
            </el-form-item>
          </el-form>

        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { User, Lock } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref(null)
const loading = ref(false)

const form = reactive({
  username: '',
  password: '',
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

async function handleLogin() {
  await formRef.value?.validate()
  loading.value = true
  try {
    const res = await userStore.login(form)
    if (res.code === 200) {
      ElMessage.success('登录成功')
      router.push('/dashboard')
    } else {
      ElMessage.error(res.message || '登录失败')
    }
  } catch (e) {
    // handled by interceptor
  } finally {
    loading.value = false
  }
}
</script>

<style lang="scss" scoped>
.login-page {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: url('https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1920&q=80') center/cover no-repeat fixed;
  position: relative;
  overflow: hidden;
}

.login-bg {
  position: absolute;
  inset: 0;
  background: rgba(27, 60, 50, 0.45);
  backdrop-filter: blur(2px);
}

.login-container {
  position: relative;
  display: flex;
  width: 900px;
  min-height: 520px;
  background: #fff;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(27, 94, 75, 0.1);
  overflow: hidden;
}

.login-left {
  width: 420px;
  background: linear-gradient(135deg, rgba(26, 60, 50, 0.92) 0%, rgba(27, 94, 75, 0.88) 50%, rgba(45, 138, 110, 0.85) 100%),
    url('https://images.unsplash.com/photo-1631549916768-4119b2e5f926?w=800&q=80') center/cover no-repeat;
  padding: 48px 40px;
  display: flex;
  align-items: center;
  position: relative;

  &::before {
    content: '';
    position: absolute;
    inset: 0;
    background: url('https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=800&q=80') center/cover no-repeat;
    opacity: 0.12;
    z-index: 0;
  }

  .brand-info {
    position: relative;
    z-index: 1;
    color: #fff;

    .brand-icon {
      width: 64px;
      height: 64px;
      background: rgba(201, 149, 107, 0.2);
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--accent-color);
      margin-bottom: 24px;
    }

    h1 {
      font-size: 26px;
      font-weight: 700;
      margin-bottom: 12px;
      letter-spacing: 1px;
    }

    .brand-desc {
      font-size: 14px;
      color: rgba(255, 255, 255, 0.7);
      line-height: 1.6;
      margin-bottom: 36px;
    }

    .feature-list {
      display: flex;
      flex-direction: column;
      gap: 16px;

      .feature-item {
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 14px;
        color: rgba(255, 255, 255, 0.85);

        .el-icon {
          width: 32px;
          height: 32px;
          background: rgba(255, 255, 255, 0.1);
          border-radius: 8px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 16px;
          color: var(--accent-color);
        }
      }
    }
  }
}

.login-right {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 48px;

  .login-form-wrapper {
    width: 100%;
    max-width: 340px;

    h2 {
      font-size: 24px;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 8px;
    }

    .login-subtitle {
      font-size: 14px;
      color: var(--text-secondary);
      margin-bottom: 32px;
    }

    .login-btn {
      width: 100%;
      height: 44px;
      border-radius: 10px;
      font-size: 16px;
      font-weight: 600;
      letter-spacing: 4px;
    }

    .login-footer {
      text-align: center;
      margin-top: 20px;
      font-size: 12px;
      color: var(--text-light);
    }
  }
}
</style>
