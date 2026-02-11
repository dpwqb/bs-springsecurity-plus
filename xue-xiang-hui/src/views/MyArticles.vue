<template>
  <div class="my-articles-page">
    <AppHeader />
    <div class="page-container">
      <div class="page-header">
        <el-breadcrumb>
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>个人中心</el-breadcrumb-item>
          <el-breadcrumb-item>我的文章</el-breadcrumb-item>
        </el-breadcrumb>
        <div class="header-actions">
          <h1 class="page-title">我的文章</h1>
          <el-button type="primary" @click="router.push('/article/edit')">
            <el-icon><Edit /></el-icon>
            写文章
          </el-button>
        </div>
      </div>

      <!-- 统计卡片 -->
      <el-row :gutter="16" class="stats-row">
        <el-col :xs="12" :sm="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-number">{{ stats.total }}</div>
              <div class="stat-label">全部</div>
            </div>
          </el-card>
        </el-col>
        <el-col :xs="12" :sm="6">
          <el-card class="stat-card published">
            <div class="stat-content">
              <div class="stat-number">{{ stats.published }}</div>
              <div class="stat-label">已发布</div>
            </div>
          </el-card>
        </el-col>
        <el-col :xs="12" :sm="6">
          <el-card class="stat-card draft">
            <div class="stat-content">
              <div class="stat-number">{{ stats.draft }}</div>
              <div class="stat-label">草稿</div>
            </div>
          </el-card>
        </el-col>
        <el-col :xs="12" :sm="6">
          <el-card class="stat-card views">
            <div class="stat-content">
              <div class="stat-number">{{ stats.totalViews }}</div>
              <div class="stat-label">总浏览</div>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <!-- 文章列表 -->
      <el-card class="articles-card" shadow="never">
        <el-table v-loading="loading" :data="articles" style="width: 100%">
          <el-table-column prop="title" label="文章标题" min-width="200">
            <template #default="{ row }">
              <div class="title-cell">
                <span class="title-text">{{ row.title }}</span>
                <el-tag v-if="row.status === 0" type="info" size="small">草稿</el-tag>
                <el-tag v-else type="success" size="small">已发布</el-tag>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="categoryName" label="分类" width="120" />
          <el-table-column prop="viewCount" label="浏览" width="80" align="center">
            <template #default="{ row }">
              <span>{{ row.viewCount || 0 }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="likeCount" label="点赞" width="80" align="center">
            <template #default="{ row }">
              <span>{{ row.likeCount || 0 }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="创建时间" width="160">
            <template #default="{ row }">
              {{ formatDate(row.createTime) }}
            </template>
          </el-table-column>
          <el-table-column label="操作" width="180" fixed="right">
            <template #default="{ row }">
              <el-button link type="primary" @click="editArticle(row.id)">
                <el-icon><Edit /></el-icon>
                编辑
              </el-button>
              <el-button link type="primary" @click="viewArticle(row.id)">
                <el-icon><View /></el-icon>
                查看
              </el-button>
              <el-popconfirm
                title="确定删除这篇文章吗？"
                confirm-button-text="确定"
                cancel-button-text="取消"
                @confirm="deleteArticle(row.id)"
              >
                <template #reference>
                  <el-button link type="danger">
                    <el-icon><Delete /></el-icon>
                    删除
                  </el-button>
                </template>
              </el-popconfirm>
            </template>
          </el-table-column>
        </el-table>

        <!-- 空状态 -->
        <el-empty v-if="!loading && articles.length === 0" description="暂无文章">
          <el-button type="primary" @click="router.push('/article/edit')">
            写第一篇文章
          </el-button>
        </el-empty>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AppHeader from '@/components/AppHeader.vue'
import { ElMessage } from 'element-plus'
import { Edit, View, Delete } from '@element-plus/icons-vue'
import { getMyArticles, deleteArticle as deleteArticleApi } from '@/api/article'

const router = useRouter()

const loading = ref(false)
const articles = ref([])
const stats = ref({
  total: 0,
  published: 0,
  draft: 0,
  totalViews: 0
})

const fetchArticles = async () => {
  loading.value = true
  try {
    const res = await getMyArticles({ page: 1, limit: 100 })
    if (res.code === 200) {
      articles.value = res.data || []
      updateStats()
    }
  } catch (error) {
    ElMessage.error('获取文章列表失败')
  } finally {
    loading.value = false
  }
}

const updateStats = () => {
  stats.value.total = articles.value.length
  stats.value.published = articles.value.filter(a => a.status === 1).length
  stats.value.draft = articles.value.filter(a => a.status === 0).length
  stats.value.totalViews = articles.value.reduce((sum, a) => sum + (a.viewCount || 0), 0)
}

const editArticle = (id) => {
  router.push(`/article/edit/${id}`)
}

const viewArticle = (id) => {
  router.push(`/article/${id}`)
}

const deleteArticle = async (id) => {
  try {
    const res = await deleteArticleApi(id)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      fetchArticles()
    }
  } catch (error) {
    ElMessage.error('删除失败')
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}

onMounted(() => {
  fetchArticles()
})
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.my-articles-page {
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

.stats-row {
  margin-bottom: $spacing-lg;
}

.stat-card {
  text-align: center;
  border: none;
  box-shadow: $shadow-sm;

  :deep(.el-card__body) {
    padding: $spacing-lg;
  }

  &.published {
    background: linear-gradient(135deg, #e1f3d8 0%, #ffffff 100%);
  }

  &.draft {
    background: linear-gradient(135deg, #f4f4f5 0%, #ffffff 100%);
  }

  &.views {
    background: linear-gradient(135deg, #ecf5ff 0%, #ffffff 100%);
  }
}

.stat-content {
  .stat-number {
    font-size: $font-size-xxl;
    font-weight: $font-weight-bold;
    color: $primary-color;
    margin-bottom: $spacing-xs;
  }

  .stat-label {
    font-size: $font-size-sm;
    color: $text-secondary;
  }
}

.articles-card {
  border: none;
  box-shadow: $shadow-sm;
}

.title-cell {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
}

.title-text {
  flex: 1;
  @include text-ellipsis();
}

// 移动端适配
@include respond-to('sm') {
  .page-container {
    padding: $spacing-lg $spacing-md;
  }

  .stats-row {
    :deep(.el-col) {
      margin-bottom: $spacing-md;
    }
  }

  .stat-content {
    .stat-number {
      font-size: $font-size-xl;
    }
  }
}
</style>
