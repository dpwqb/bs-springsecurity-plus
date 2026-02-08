import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue'),
    meta: { title: '首页' }
  },
  {
    path: '/resources',
    name: 'Resources',
    component: () => import('@/views/ResourceList.vue'),
    meta: { title: '资源列表' }
  },
  {
    path: '/resource/:id',
    name: 'ResourceDetail',
    component: () => import('@/views/ResourceDetail.vue'),
    meta: { title: '资源详情' }
  },
  {
    path: '/articles',
    name: 'Articles',
    component: () => import('@/views/ArticleList.vue'),
    meta: { title: '文章列表' }
  },
  {
    path: '/article/:id',
    name: 'ArticleDetail',
    component: () => import('@/views/ArticleDetail.vue'),
    meta: { title: '文章详情' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  document.title = to.meta.title ? `${to.meta.title} - 学享汇` : '学享汇'
  next()
})

export default router
