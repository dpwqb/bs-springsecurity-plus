<template>
  <div class="home-page">
    <!-- 导航栏 -->
    <AppHeader />

    <!-- Hero Banner区域 -->
    <section class="hero-section">
      <div class="hero-bg">
        <div class="hero-content">
          <h1 class="hero-title">
            <span class="gradient-text">学享汇</span>
          </h1>
          <p class="hero-slogan">免费文档资源共享平台，让学习更简单</p>
          <div class="hero-stats">
            <div class="stat-item">
              <div class="stat-number">{{ formatNumber(stats.totalResources) }}</div>
              <div class="stat-label">优质资源</div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <div class="stat-number">{{ formatNumber(stats.totalUsers) }}</div>
              <div class="stat-label">注册用户</div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <div class="stat-number">{{ formatNumber(stats.todayDownloads) }}</div>
              <div class="stat-label">今日下载</div>
            </div>
          </div>
          <div class="hero-actions">
            <el-button type="primary" size="large" @click="handleUpload">
              <el-icon><Upload /></el-icon>
              上传资源
            </el-button>
            <el-button size="large" @click="router.push('/resources')">
              <el-icon><Search /></el-icon>
              浏览资源
            </el-button>
            <el-button size="large" @click="router.push('/articles')">
              <el-icon><Memo /></el-icon>
              阅读文章
            </el-button>
          </div>
        </div>
      </div>
    </section>

    <!-- 主内容区 -->
    <div class="main-container">
      <!-- 热门分类 -->
      <section class="categories-section">
        <div class="section-header">
          <h3 class="section-title">
            <el-icon><Grid /></el-icon>
            热门分类
          </h3>
        </div>
        <div class="category-list">
          <div
            v-for="category in categories"
            :key="category.categoryId"
            class="category-card"
            @click="handleCategoryClick(category)"
          >
            <div class="category-icon">
              <el-icon :size="32" :color="getCategoryColor(category.categoryId)">
                <Folder />
              </el-icon>
            </div>
            <div class="category-info">
              <div class="category-name">{{ category.categoryName }}</div>
              <div class="category-count">{{ category.resourceCount || 0 }} 个资源</div>
            </div>
          </div>
        </div>
      </section>

      <!-- 双栏布局 -->
      <el-row :gutter="20">
        <!-- 左侧：最新资源 -->
        <el-col :xs="24" :sm="24" :md="16" :lg="16">
          <section class="resources-section">
            <div class="section-header">
              <h3 class="section-title">
                <el-icon><Document /></el-icon>
                最新资源
              </h3>
              <el-link type="primary" @click="router.push('/resources')">
                查看更多 <el-icon><ArrowRight /></el-icon>
              </el-link>
            </div>

            <!-- 加载中 -->
            <LoadingSkeleton v-if="loading" type="grid" :rows="4" />

            <!-- 资源列表 -->
            <el-row v-else :gutter="20">
              <el-col
                v-for="resource in resources.slice(0, 8)"
                :key="resource.resourceId"
                :xs="24"
                :sm="12"
                :md="12"
                :lg="12"
              >
                <ResourceCard
                  :resource="resource"
                  view-mode="grid"
                  @click="handleResourceClick"
                />
              </el-col>
            </el-row>

            <!-- 空状态 -->
            <el-empty v-if="!loading && resources.length === 0" description="暂无资源" />
          </section>
        </el-col>

        <!-- 右侧：侧边栏 -->
        <el-col :xs="24" :sm="24" :md="8" :lg="8">
          <aside class="sidebar">
            <!-- 热门标签 -->
            <div class="sidebar-widget">
              <div class="widget-header">
                <h4 class="widget-title">
                  <el-icon><PriceTag /></el-icon>
                  热门标签
                </h4>
              </div>
              <div class="tag-cloud">
                <el-tag
                  v-for="tag in hotTags.slice(0, 15)"
                  :key="tag.id"
                  class="tag-item"
                  @click="handleTagClick(tag)"
                >
                  {{ tag.name }}
                </el-tag>
              </div>
            </div>

            <!-- 下载排行榜 -->
            <div class="sidebar-widget">
              <div class="widget-header">
                <h4 class="widget-title">
                  <el-icon><TrendCharts /></el-icon>
                  下载排行榜
                </h4>
              </div>
              <div class="ranking-list">
                <div
                  v-for="(item, index) in topDownloads"
                  :key="item.id"
                  class="ranking-item"
                  @click="handleResourceClick(item)"
                >
                  <div class="ranking-index" :class="`top-${index + 1}`">{{ index + 1 }}</div>
                  <div class="ranking-info">
                    <div class="ranking-title">{{ item.title }}</div>
                    <div class="ranking-meta">
                      <span><el-icon><Download /></el-icon> {{ item.downloadCount }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 最新公告 -->
            <div class="sidebar-widget">
              <div class="widget-header">
                <h4 class="widget-title">
                  <el-icon><Bell /></el-icon>
                  最新公告
                </h4>
              </div>
              <div class="notice-list">
                <div v-for="notice in notices" :key="notice.id" class="notice-item">
                  <el-tag :type="notice.type" size="small">{{ notice.tag }}</el-tag>
                  <span class="notice-text">{{ notice.title }}</span>
                </div>
              </div>
            </div>
          </aside>
        </el-col>
      </el-row>
    </div>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useResourceStore } from '@/stores/resource'
import { useUserStore } from '@/stores/user'
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'
import ResourceCard from '@/components/ResourceCard.vue'
import LoadingSkeleton from '@/components/LoadingSkeleton.vue'
import {
  Grid,
  Folder,
  Document,
  ArrowRight,
  Search,
  Upload,
  Memo,
  PriceTag,
  TrendCharts,
  Bell,
  Download
} from '@element-plus/icons-vue'

const router = useRouter()
const resourceStore = useResourceStore()
const userStore = useUserStore()

// 数据
const loading = ref(false)
const categories = ref([])
const resources = ref([])
const hotTags = ref([])

// 统计数据
const stats = ref({
  totalResources: 0,
  totalUsers: 0,
  todayDownloads: 0
})

// 下载排行榜
const topDownloads = ref([])

// 公告
const notices = ref([
  { id: 1, type: 'success', tag: '更新', title: '平台已升级到新版本' },
  { id: 2, type: 'info', tag: '活动', title: '上传资源赢取积分' },
  { id: 3, type: 'warning', tag: '通知', title: '资源审核规则调整' }
])

// 获取分类列表
const fetchCategories = async () => {
  const result = await resourceStore.fetchCategories()
  if (result.success) {
    categories.value = result.data.slice(0, 8)
  }
}

// 获取资源列表
const fetchResources = async () => {
  loading.value = true
  try {
    const { getResourceList } = await import('@/api/resource')
    const res = await getResourceList({ page: 1, limit: 12, status: 1 })
    if (res.code === 0) {
      resources.value = res.data || []
      // 下载排行榜取前5名
      topDownloads.value = [...res.data]
        .sort((a, b) => (b.downloadCount || 0) - (a.downloadCount || 0))
        .slice(0, 5)
    }
  } catch (error) {
    console.error('获取资源失败:', error)
  } finally {
    loading.value = false
  }
}

// 获取热门标签
const fetchHotTags = async () => {
  const result = await resourceStore.fetchHotTags(15)
  if (result.success) {
    hotTags.value = result.data
  }
}

// 获取统计数据
const fetchStats = async () => {
  // TODO: 对接后端统计接口
  stats.value = {
    totalResources: 1234,
    totalUsers: 567,
    todayDownloads: 89
  }
}

// 格式化数字
const formatNumber = (num) => {
  if (!num) return '0'
  if (num >= 10000) {
    return (num / 10000).toFixed(1) + '万'
  }
  if (num >= 1000) {
    return (num / 1000).toFixed(1) + 'k'
  }
  return num.toString()
}

// 获取分类颜色
const getCategoryColor = (id) => {
  const colors = ['#409EFF', '#67C23A', '#E6A23C', '#F56C6C', '#909399', '#00D4FF', '#FF6B9D', '#9B59B6']
  return colors[id % colors.length]
}

// 上传资源
const handleUpload = () => {
  if (userStore.isLoggedIn) {
    router.push('/upload')
  } else {
    router.push('/login')
  }
}

// 分类点击
const handleCategoryClick = (category) => {
  router.push({
    path: '/resources',
    query: { categoryId: category.categoryId }
  })
}

// 标签点击
const handleTagClick = (tag) => {
  router.push({
    path: '/resources',
    query: { tagId: tag.id }
  })
}

// 资源点击
const handleResourceClick = (resource) => {
  router.push(`/resource/${resource.resourceId}`)
}

onMounted(async () => {
  await Promise.all([
    fetchCategories(),
    fetchResources(),
    fetchHotTags(),
    fetchStats()
  ])
})
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.home-page {
  min-height: 100vh;
  background-color: $bg-secondary;
  padding-top: 64px; // header高度
}

// Hero区域
.hero-section {
  position: relative;
  padding: $spacing-xxxl 0;
  background: $gradient-hero;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
    opacity: 0.4;
  }
}

.hero-bg {
  max-width: $container-xxl;
  margin: 0 auto;
  padding: 0 $spacing-lg;
  position: relative;
  z-index: 1;
}

.hero-content {
  text-align: center;
  color: white;
}

.hero-title {
  font-size: $font-size-xxxl;
  font-weight: $font-weight-bold;
  margin: 0 0 $spacing-lg 0;

  @include respond-to('sm') {
    font-size: $font-size-xxl;
  }

  .gradient-text {
    background: linear-gradient(135deg, #ffffff 0%, #f0f0f0 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
}

.hero-slogan {
  font-size: $font-size-lg;
  opacity: 0.9;
  margin: 0 0 $spacing-xxl 0;

  @include respond-to('sm') {
    font-size: $font-size-md;
  }
}

.hero-stats {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: $spacing-xl;
  margin-bottom: $spacing-xxl;

  @include respond-to('sm') {
    gap: $spacing-md;
  }
}

.stat-item {
  text-align: center;
}

.stat-number {
  font-size: $font-size-xxl;
  font-weight: $font-weight-bold;
  margin-bottom: $spacing-xs;

  @include respond-to('sm') {
    font-size: $font-size-xl;
  }
}

.stat-label {
  font-size: $font-size-sm;
  opacity: 0.8;
}

.stat-divider {
  width: 1px;
  height: 40px;
  background: rgba(255, 255, 255, 0.3);
}

.hero-actions {
  display: flex;
  justify-content: center;
  gap: $spacing-md;
  flex-wrap: wrap;

  .el-button {
    height: 44px;
    padding: 0 $spacing-xl;
    font-size: $font-size-md;

    @include respond-to('sm') {
      width: 100%;
    }
  }
}

// 主内容区
.main-container {
  max-width: $container-xxl;
  margin: 0 auto;
  padding: $spacing-xxl $spacing-lg;
}

// 分类区域
.categories-section {
  margin-bottom: $spacing-xxl;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: $spacing-lg;
}

.section-title {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
  font-size: $font-size-xl;
  font-weight: $font-weight-semibold;
  color: $text-primary;
  margin: 0;
}

.category-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: $spacing-md;

  @include respond-to('sm') {
    grid-template-columns: repeat(2, 1fr);
  }
}

.category-card {
  display: flex;
  align-items: center;
  gap: $spacing-md;
  padding: $spacing-lg;
  background: $bg-primary;
  border-radius: $border-radius-lg;
  box-shadow: $shadow-sm;
  cursor: pointer;
  transition: $transition-base;

  &:hover {
    box-shadow: $shadow-md;
    transform: translateY(-2px);
  }
}

.category-icon {
  flex-shrink: 0;
}

.category-info {
  flex: 1;
  min-width: 0;
}

.category-name {
  font-size: $font-size-md;
  font-weight: $font-weight-medium;
  color: $text-primary;
  margin-bottom: $spacing-xs;
  @include text-ellipsis();
}

.category-count {
  font-size: $font-size-sm;
  color: $text-secondary;
}

// 资源区域
.resources-section {
  margin-bottom: $spacing-xxl;
}

// 侧边栏
.sidebar {
  display: flex;
  flex-direction: column;
  gap: $spacing-lg;
}

.sidebar-widget {
  background: $bg-primary;
  border-radius: $border-radius-lg;
  padding: $spacing-lg;
  box-shadow: $shadow-sm;
}

.widget-header {
  margin-bottom: $spacing-md;
  padding-bottom: $spacing-md;
  border-bottom: 1px solid $border-lighter;
}

.widget-title {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
  font-size: $font-size-md;
  font-weight: $font-weight-semibold;
  color: $text-primary;
  margin: 0;
}

// 标签云
.tag-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: $spacing-sm;

  .tag-item {
    cursor: pointer;
    transition: $transition-fast;

    &:hover {
      opacity: 0.8;
      transform: scale(1.05);
    }
  }
}

// 排行榜
.ranking-list {
  display: flex;
  flex-direction: column;
  gap: $spacing-md;
}

.ranking-item {
  display: flex;
  align-items: center;
  gap: $spacing-md;
  cursor: pointer;
  transition: $transition-fast;

  &:hover {
    background-color: $bg-secondary;
    padding: $spacing-sm;
    margin: 0 (-$spacing-sm);
    border-radius: $border-radius-base;
  }
}

.ranking-index {
  flex-shrink: 0;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: $bg-secondary;
  border-radius: $border-radius-base;
  font-size: $font-size-sm;
  font-weight: $font-weight-semibold;
  color: $text-secondary;

  &.top-1 {
    background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
    color: white;
  }

  &.top-2 {
    background: linear-gradient(135deg, #C0C0C0 0%, #A8A8A8 100%);
    color: white;
  }

  &.top-3 {
    background: linear-gradient(135deg, #CD7F32 0%, #B87333 100%);
    color: white;
  }
}

.ranking-info {
  flex: 1;
  min-width: 0;
}

.ranking-title {
  font-size: $font-size-sm;
  color: $text-primary;
  margin-bottom: $spacing-xs;
  @include text-ellipsis();
}

.ranking-meta {
  font-size: $font-size-xs;
  color: $text-secondary;

  span {
    display: flex;
    align-items: center;
    gap: 4px;
  }
}

// 公告列表
.notice-list {
  display: flex;
  flex-direction: column;
  gap: $spacing-sm;
}

.notice-item {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
  padding: $spacing-sm;
  border-radius: $border-radius-base;
  transition: $transition-fast;

  &:hover {
    background-color: $bg-secondary;
  }
}

.notice-text {
  flex: 1;
  font-size: $font-size-sm;
  color: $text-regular;
  @include text-ellipsis();
}
</style>
