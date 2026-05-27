<template>
  <el-container class="layout-container">
    <!-- 侧边栏 -->
    <el-aside :width="isCollapse ? '64px' : '240px'" class="layout-aside">
      <div class="logo-area">
        <div class="logo-icon">
          <el-icon :size="24"><FirstAidKit /></el-icon>
        </div>
        <span v-show="!isCollapse" class="logo-text">智慧医疗</span>
      </div>

      <el-menu
        :default-active="currentRoute"
        :collapse="isCollapse"
        :collapse-transition="false"
        @select="handleMenuSelect"
        class="side-menu"
      >
        <el-menu-item index="/dashboard">
          <el-icon><DataBoard /></el-icon>
          <template #title>工作台</template>
        </el-menu-item>

        <!-- 管理员：用户管理 -->
        <el-menu-item v-if="isAdmin" index="/users">
          <el-icon><UserFilled /></el-icon>
          <template #title>用户管理</template>
        </el-menu-item>

        <!-- 医生：患者管理、病历管理 -->
        <el-menu-item v-if="isDoctor" index="/patients">
          <el-icon><User /></el-icon>
          <template #title>患者管理</template>
        </el-menu-item>
        <el-menu-item v-if="isDoctor" index="/records">
          <el-icon><Document /></el-icon>
          <template #title>病历管理</template>
        </el-menu-item>

        <el-menu-item index="/knowledge">
          <el-icon><Collection /></el-icon>
          <template #title>知识库{{ isAdmin ? '管理' : '' }}</template>
        </el-menu-item>

        <div class="menu-divider" v-show="!isCollapse">
          <span>{{ isAdmin ? '系统管理' : '智能分析' }}</span>
        </div>

        <!-- 医生：方案生成 -->
        <el-menu-item v-if="isDoctor" index="/plan-generate">
          <el-icon><MagicStick /></el-icon>
          <template #title>方案生成</template>
        </el-menu-item>
        <el-menu-item index="/plans">
          <el-icon><Files /></el-icon>
          <template #title>方案管理</template>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <el-container class="main-container">
      <!-- 顶部栏 -->
      <el-header class="layout-header">
        <div class="header-left">
          <el-icon
            class="collapse-btn"
            @click="isCollapse = !isCollapse"
            :size="20"
          >
            <Fold v-if="!isCollapse" />
            <Expand v-else />
          </el-icon>
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/dashboard' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item v-if="$route.meta.title">
              {{ $route.meta.title }}
            </el-breadcrumb-item>
          </el-breadcrumb>
        </div>

        <div class="header-right">
          <el-dropdown trigger="click" @command="handleCommand">
            <div class="user-info">
              <el-tag :type="isAdmin ? 'danger' : 'success'" size="small" class="role-tag" effect="dark">
                {{ isAdmin ? '管理员' : '医生' }}
              </el-tag>
              <el-avatar :size="32" class="user-avatar">
                {{ userStore.userInfo.real_name?.[0] || 'U' }}
              </el-avatar>
              <span class="user-name">{{ userStore.userInfo.real_name || userStore.userInfo.username }}</span>
              <el-icon><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人信息</el-dropdown-item>
                <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <!-- 内容区域 -->
      <el-main class="layout-main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const isCollapse = ref(false)

const isAdmin = computed(() => userStore.userInfo.role === 'admin')
const isDoctor = computed(() => userStore.userInfo.role !== 'admin')

const currentRoute = computed(() => {
  const first = '/' + route.path.split('/')[1]
  return first
})

function handleMenuSelect(index) {
  if (route.path !== index) {
    router.push(index)
  }
}

function handleCommand(command) {
  if (command === 'logout') {
    userStore.logout()
  } else if (command === 'profile') {
    ElMessage.info('个人信息功能开发中')
  }
}
</script>

<style lang="scss" scoped>
.layout-container {
  height: 100vh;
  overflow: hidden;
}

.layout-aside {
  background: linear-gradient(180deg, #1A3C32 0%, #1B5E4B 40%, #1A3C32 100%);
  transition: width 0.3s ease;
  overflow: hidden;
  display: flex;
  flex-direction: column;

  .logo-area {
    height: 64px;
    display: flex;
    align-items: center;
    padding: 0 16px;
    gap: 12px;

    .logo-icon {
      min-width: 36px;
      height: 36px;
      background: rgba(255, 255, 255, 0.15);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--accent-color);
    }

    .logo-text {
      font-size: 18px;
      font-weight: 700;
      color: #fff;
      letter-spacing: 2px;
      white-space: nowrap;
    }
  }

  .side-menu {
    border: none;
    background: transparent;
    flex: 1;
    overflow-y: auto;
    padding: 8px;

    :deep(.el-menu-item) {
      color: rgba(255, 255, 255, 0.7);
      border-radius: 8px;
      margin-bottom: 2px;
      height: 44px;
      line-height: 44px;

      &:hover {
        background: rgba(255, 255, 255, 0.1);
        color: #fff;
      }

      &.is-active {
        background: rgba(201, 149, 107, 0.25);
        color: var(--accent-color);
        font-weight: 600;
      }

      .el-icon {
        color: inherit;
      }
    }
  }

  .menu-divider {
    padding: 16px 20px 8px;
    font-size: 11px;
    color: rgba(255, 255, 255, 0.35);
    text-transform: uppercase;
    letter-spacing: 2px;
    white-space: nowrap;
  }
}

.main-container {
  background: var(--bg-color);
}

.layout-header {
  height: 64px;
  background: var(--bg-white);
  border-bottom: 1px solid var(--border-light);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  box-shadow: var(--shadow-sm);

  .header-left {
    display: flex;
    align-items: center;
    gap: 16px;

    .collapse-btn {
      cursor: pointer;
      color: var(--text-secondary);
      transition: color 0.3s;

      &:hover {
        color: var(--primary-color);
      }
    }
  }

  .header-right {
    .user-info {
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      padding: 6px 12px;
      border-radius: 8px;
      transition: background 0.3s;

      &:hover {
        background: var(--primary-lighter);
      }

      .user-avatar {
        background: var(--primary-color);
        color: #fff;
        font-size: 14px;
      }

      .user-name {
        font-size: 14px;
        color: var(--text-primary);
        font-weight: 500;
      }
    }
  }
}

.layout-main {
  padding: 20px;
  overflow-y: auto;
}
</style>
