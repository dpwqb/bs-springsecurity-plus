<template>
  <div class="article-list-page">
    <AppHeader />
    <div class="page-container">
      <div class="page-header">
        <el-breadcrumb>
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>文章广场</el-breadcrumb-item>
        </el-breadcrumb>
        <div class="header-actions">
          <h1 class="page-title">文章广场</h1>
          <el-button type="primary" @click="handlePublish">
            <el-icon><Edit /></el-icon>
            写文章
          </el-button>
        </div>
      </div>

      <!-- 筛选栏 -->
      <el-card class="filter-card" shadow="never">
        <el-row :gutter="16">
          <el-col :xs="24" :sm="12" :md="6">
            <el-select
              v-model="queryParams.categoryId"
              placeholder="选择分类"
              clearable
              @change="handleSearch"
              class="filter-select"
            >
              <el-option
                v-for="category in categories"
                :key="category.id"
                :label="category.name"
                :value="category.id"
              />
            </el-select>
          </el-col>
          <el-col :xs="24" :sm="12" :md="18">
            <el-input
              v-model="queryParams.keyword"
              placeholder="搜索文章标题、内容..."
              clearable
              @keyup.enter="handleSearch"
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
              <template #append>
                <el-button :icon="Search" @click="handleSearch" />
              </template>
            </el-input>
          </el-col>
        </el-row>
      </el-card>

      <!-- 文章列表 -->
      <div v-loading="loading" class="article-list">
        <el-card
          v-for="article in articles"
          :key="article.id"
          class="article-card"
          shadow="hover"
          @click="viewArticle(article.id)"
        >
          <div class="article-cover" v-if="article.coverImage">
            <el-image :src="article.coverImage" fit="cover" />
          </div>
          <div class="article-content">
            <h3 class="article-title">{{ article.title }}</h3>
            <p class="article-summary">{{ article.summary || '暂无摘要' }}</p>
            <div class="article-meta">
              <span class="author">
                <el-icon><User /></el-icon>
                {{ article.authorName }}
              </span>
              <span class="time">
                <el-icon><CollectionTag /></el-icon>
                {{ formatDate(article.publishTime) }}
              </span>
              <span class="stats">
                <el-icon><View /></el-icon>
                {{ article.viewCount || 0 }}
              </span>
              <span class="stats">
                <el-icon><StarFilled /></el-icon>
                {{ article.likeCount || 0 }}
              </span>
            </div>
          </div>
        </el-card>
      </div>

      <!-- 空状态 -->
      <el-empty v-if="!loading && articles.length === 0" description="暂无文章" />

      <!-- 分页 -->
      <div v-if="articles.length > 0" class="pagination-wrapper">
        <el-pagination
          v-model:current-page="queryParams.page"
          v-model:page-size="queryParams.limit"
          :total="total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          background
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </div>
    <AppFooter />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'
import { ElMessage } from 'element-plus'
import { Search, Edit, User, View, StarFilled, CollectionTag } from '@element-plus/icons-vue'
import { getArticleList, getArticleCategories } from '@/api/article'

const router = useRouter()
const userStore = useUserStore()

const loading = ref(false)
const articles = ref([])
const categories = ref([])
const total = ref(0)

const queryParams = ref({
  page: 1,
  limit: 10,
  keyword: '',
  categoryId: null,
  status: 1
})

// 获取文章列表
const fetchArticles = async () => {
  loading.value = true
  try {
    const res = await getArticleList(queryParams.value)
    if (res.code === 0) {
      articles.value = res.data || []
      total.value = res.total || res.data?.length || 0
    }
  } catch (error) {
    console.error('获取文章列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 获取分类列表
const fetchCategories = async () => {
  try {
    const res = await getArticleCategories()
    if (res.code === 0) {
      categories.value = res.data || []
    }
  } catch (error) {
    console.error('获取分类失败:', error)
  }
}

// 搜索
const handleSearch = () => {
  queryParams.value.page = 1
  fetchArticles()
}

// 页码改变
const handlePageChange = (page) => {
  queryParams.value.page = page
  fetchArticles()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

// 每页数量改变
const handleSizeChange = (size) => {
  queryParams.value.limit = size
  queryParams.value.page = 1
  fetchArticles()
}

// 查看文章详情
const viewArticle = (id) => {
  router.push(`/article/${id}`)
}

// 发布文章
const handlePublish = () => {
  if (userStore.isLoggedIn) {
    router.push('/article/edit')
  } else {
    ElMessage.warning('请先登录')
    router.push('/login')
  }
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  const now = new Date()
  const diff = now - date
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))

  if (days === 0) return '今天'
  if (days === 1) return '昨天'
  if (days < 7) return `${days}天前`
  if (days < 30) return `${Math.floor(days / 7)}周前`
  return date.toLocaleDateString('zh-CN')
}

onMounted(() => {
  fetchCategories()
  fetchArticles()
})
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.article-list-page {
  min-height: 100vh;
  background-color: $bg-secondary;
  padding-top: 64px;
}

.page-container {
  max-width: $container-xxl;
  margin: 0 auto;
  padding: $spacing-xl $spacing-lg;
}

.page-header {
  margin-bottom: $spacing-xl;
}

.header-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: $spacing-lg;

  @include respond-to('sm') {
    flex-direction: column;
    align-items: stretch;
  }
}

.page-title {
  font-size: $font-size-xxl;
  font-weight: $font-weight-bold;
  color: $text-primary;
  margin: $spacing-md 0 0 0;
}

.filter-card {
  margin-bottom: $spacing-lg;
  border: none;
  box-shadow: $shadow-sm;

  :deep(.el-card__body) {
    padding: $spacing-lg;
  }
}

.filter-select {
  width: 100%;
}

.article-list {
  min-height: 400px;
  margin-bottom: $spacing-xl;
}

.article-card {
  margin-bottom: $spacing-md;
  cursor: pointer;
  transition: $transition-base;
  display: flex;
  gap: $spacing-lg;

  &:hover {
    box-shadow: $shadow-md;
    transform: translateY(-2px);
  }

  :deep(.el-card__body) {
    padding: $spacing-lg;
    display: flex;
    gap: $spacing-lg;
  }
}

.article-cover {
  flex-shrink: 0;
  width: 200px;
  height: 150px;
  border-radius: $border-radius-lg;
  overflow: hidden;

  .el-image {
    width: 100%;
    height: 100%;
  }

  @include respond-to('sm') {
    width: 100px;
    height: 100px;
  }
}

.article-content {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

.article-title {
  font-size: $font-size-lg;
  font-weight: $font-weight-semibold;
  color: $text-primary;
  margin: 0 0 $spacing-sm 0;
  @include text-ellipsis();
}

.article-summary {
  font-size: $font-size-sm;
  color: $text-secondary;
  margin: 0 0 $spacing-md 0;
  line-height: $line-height-lg;
  @include text-ellipsis(2);
  flex: 1;
}

.article-meta {
  display: flex;
  align-items: center;
  gap: $spacing-lg;
  font-size: $font-size-sm;
  color: $text-secondary;

  .author,
  .time,
  .stats {
    display: flex;
    align-items: center;
    gap: 4px;
  }

  @include respond-to('sm') {
    gap: $spacing-sm;
    font-size: $font-size-xs;
  }
}

.pagination-wrapper {
  display: flex;
  justify-content: center;
  padding: $spacing-xl 0;
}

// 移动端适配
@include respond-to('sm') {
  .page-container {
    padding: $spacing-lg $spacing-md;
  }

  .article-card {
    :deep(.el-card__body) {
      flex-direction: column;
      padding: $spacing-md;
    }
  }

  .article-cover {
    width: 100%;
    height: 180px;
  }
}
</style>
