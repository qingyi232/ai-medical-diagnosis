import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录' },
  },
  {
    path: '/',
    component: () => import('@/layouts/MainLayout.vue'),
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Dashboard.vue'),
        meta: { title: '工作台', icon: 'DataBoard' },
      },
      {
        path: 'users',
        name: 'Users',
        component: () => import('@/views/system/UserList.vue'),
        meta: { title: '用户管理', icon: 'UserFilled', roles: ['admin'] },
      },
      {
        path: 'patients',
        name: 'Patients',
        component: () => import('@/views/patients/PatientList.vue'),
        meta: { title: '患者管理', icon: 'User', roles: ['doctor'] },
      },
      {
        path: 'patients/:id',
        name: 'PatientDetail',
        component: () => import('@/views/patients/PatientDetail.vue'),
        meta: { title: '患者详情', hidden: true, roles: ['doctor'] },
      },
      {
        path: 'records',
        name: 'Records',
        component: () => import('@/views/records/RecordList.vue'),
        meta: { title: '病历管理', icon: 'Document', roles: ['doctor'] },
      },
      {
        path: 'records/:id',
        name: 'RecordDetail',
        component: () => import('@/views/records/RecordDetail.vue'),
        meta: { title: '病历详情', hidden: true, roles: ['doctor'] },
      },
      {
        path: 'knowledge',
        name: 'Knowledge',
        component: () => import('@/views/knowledge/KnowledgeList.vue'),
        meta: { title: '知识库', icon: 'Collection' },
      },
      {
        path: 'plan-generate',
        name: 'PlanGenerate',
        component: () => import('@/views/plan/PlanGenerate.vue'),
        meta: { title: '方案生成', icon: 'MagicStick', roles: ['doctor'] },
      },
      {
        path: 'plans',
        name: 'Plans',
        component: () => import('@/views/plan/PlanList.vue'),
        meta: { title: '方案管理', icon: 'Files' },
      },
      {
        path: 'plans/:id',
        name: 'PlanDetail',
        component: () => import('@/views/plan/PlanDetail.vue'),
        meta: { title: '方案详情', hidden: true },
      },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  document.title = `${to.meta.title || ''} - 智慧医疗方案生成系统`
  const token = localStorage.getItem('token')
  if (to.path !== '/login' && !token) {
    next('/login')
    return
  }
  if (to.meta.roles && token) {
    const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
    if (!to.meta.roles.includes(userInfo.role)) {
      next('/dashboard')
      return
    }
  }
  next()
})

export default router
