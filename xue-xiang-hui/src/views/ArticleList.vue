<template>
  <div class="article-list-container">
    <el-container>
      <!-- 顶部导航 -->
      <el-header class="header">
        <div class="header-content">
          <div class="logo" @click="router.push('/')">
            <h2>📚 学享汇</h2>
          </div>
          <el-menu
            :default-active="activeMenu"
            class="menu"
            mode="horizontal"
            @select="handleMenuSelect"
          >
            <el-menu-item index="/">首页</el-menu-item>
            <el-menu-item index="/resources">资源库</el-menu-item>
            <el-menu-item index="/articles">文章广场</el-menu-item>
          </el-menu>
          <div class="user-actions">
            <el-button type="primary" @click="handlePublish">
              <el-icon><Edit /></el-icon>
              写文章
            </el-button>
          </div>
        </div>
      </el-header>

      <!-- 筛选栏 -->
      <div class="filter-bar">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-select
              v-model="queryParams.categoryId"
              placeholder="选择分类"
              clearable
              @change="handleSearch"
            >
              <el-option
                v-for="category in categories"
                :key="category.id"
                :label="category.name"
                :value="category.id"
              />
            </el-select>
          </el-col>
          <el-col :span="18">
            <el-input
              v-model="queryParams.keyword"
              placeholder="搜索文章标题、摘要..."
              @keyup.enter="handleSearch"
            >
              <template #append>
                <el-button :icon="Search" @click="handleSearch" />
              </template>
            </el-input>
          </el-col>
        </el-row>
      </div>

      <!-- 文章列表 -->
      <el-main class="main-content">
        <div v-loading="loading">
          <el-card
            v-for="article in articles"
            :key="article.id"
            class="article-card"
            @click="viewArticle(article.id)"
          >
            <div class="article-content">
              <h3 class="article-title">{{ article.title }}</h3>
              <p class="article-summary">{{ article.summary }}</p>
              <div class="article-meta">
                <span>
                  <el-icon><User /></el-icon>
                  {{ article.authorName }}
                </span>
                <span>
                  <el-icon><View /></el-icon>
                  {{ article.viewCount || 0 }}
                </span>
                <span>
                  <el-icon><StarFilled /></el-icon>
                  {{ article.likeCount || 0 }}
                </span>
                <span>
                  <el-icon><CollectionTag /></el-icon>
                  {{ formatDate(article.publishTime) }}
                </span>
              </div>
            </div>
            <div class="article-cover" v-if="article.coverImage">
              <el-image
                :src="article.coverImage"
                fit="cover"
                style="width: 100%; height: 100%;"
              />
            </div>
          </el-card>
        </div>

        <!-- 空状态 -->
        <el-empty v-if="!loading && articles.length === 0" description="暂无文章" />

        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="articles.length > 0">
          <el-pagination
            v-model:current-page="queryParams.page"
            v-model:page-size="queryParams.limit"
            :total="total"
            :page-sizes="[10, 20, 50]"
            layout="total, sizes, prev, pager, next, jumper"
            @size-change="handleSizeChange"
            @current-change="handlePageChange"
          />
        </div>
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Search, Edit, User, View, StarFilled, CollectionTag } from '@element-plus/icons-vue'
import { getArticleList, getArticleCategories } from '@/api/article'

const router = useRouter()
const activeMenu = ref('/articles')
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
    if (res.code === 200) {
      articles.value = res.data || []
      total.value = res.data?.length || 0
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
    if (res.code === 200) {
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
  // TODO: 跳转到文章发布页面
  console.log('发布文章')
}

// 菜单选择
const handleMenuSelect = (index) => {
  router.push(index)
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN')
}

onMounted(() => {
  fetchCategories()
  fetchArticles()
})
</script>

<style scoped>
.article-list-container {
  min-height: 100vh;
  background-color: #f5f7fa;
}

.header {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 0;
}

.header-content {
  display: flex;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.logo {
  margin-right: 40px;
  cursor: pointer;
}

.logo h2 {
  margin: 0;
  color: #409EFF;
}

.menu {
  flex: 1;
  border-bottom: none;
}

.filter-bar {
  background: white;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.article-card {
  cursor: pointer;
  transition: all 0.3s;
  margin-bottom: 20px;
  display: flex;
  gap: 20px;
}

.article-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.article-content {
  flex: 1;
}

.article-title {
  font-size: 20px;
  font-weight: 500;
  color: #303133;
  margin: 0 0 10px 0;
}

.article-summary {
  font-size: 14px;
  color: #606266;
  line-height: 1.6;
  margin: 0 0 15px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.article-meta {
  display: flex;
  gap: 20px;
  font-size: 13px;
  color: #909399;
}

.article-meta span {
  display: flex;
  align-items: center;
  gap: 4px;
}

.article-cover {
  width: 200px;
  height: 120px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 40px;
}
</style>
