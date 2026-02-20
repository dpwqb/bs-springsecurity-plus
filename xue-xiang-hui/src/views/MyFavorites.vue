<template>
  <div class="my-favorites-page">
    <AppHeader />

    <!-- 主内容 -->
    <div class="page-container">
        <!-- 统计和排序栏 -->
        <el-card class="toolbar-card">
          <div class="toolbar">
            <div class="stats">
              <h3>我的收藏</h3>
              <span class="count">共 {{ total }} 个资源</span>
            </div>
            <div class="sort-options">
              <span class="sort-label">排序方式：</span>
              <el-radio-group v-model="sortBy" @change="handleSortChange">
                <el-radio-button label="time">按时间</el-radio-button>
                <el-radio-button label="downloads">按热度</el-radio-button>
              </el-radio-group>
            </div>
          </div>
        </el-card>

        <!-- 收藏列表 -->
        <div v-loading="loading" class="favorites-list">
          <el-card
            v-for="item in favorites"
            :key="item.id"
            class="favorite-card"
          >
            <div class="favorite-content">
              <div class="favorite-header">
                <h3
                  class="resource-title"
                  @click="viewResource(item.resourceId)"
                >
                  {{ item.title }}
                </h3>
                <el-button
                  type="danger"
                  size="small"
                  plain
                  @click="handleRemoveFavorite(item)"
                >
                  <el-icon><StarFilled /></el-icon>
                  取消收藏
                </el-button>
              </div>

              <p class="resource-description">{{ item.description }}</p>

              <div class="resource-meta">
                <span>
                  <el-icon><User /></el-icon>
                  {{ item.uploaderName || '未知' }}
                </span>
                <span>
                  <el-icon><Folder /></el-icon>
                  {{ item.categoryName || '未分类' }}
                </span>
                <span>
                  <el-icon><Download /></el-icon>
                  {{ item.downloadCount || 0 }} 下载
                </span>
                <span>
                  <el-icon><View /></el-icon>
                  {{ item.viewCount || 0 }} 浏览
                </span>
                <span>
                  <el-icon><CollectionTag /></el-icon>
                  {{ formatDate(item.favoriteTime) }}
                </span>
              </div>

              <div class="resource-tags" v-if="item.tags && item.tags.length > 0">
                <el-tag
                  v-for="tag in item.tags.slice(0, 3)"
                  :key="tag.id"
                  size="small"
                  type="info"
                >
                  {{ tag.name }}
                </el-tag>
              </div>

              <div class="resource-actions">
                <el-button
                  type="primary"
                  size="small"
                  @click="handleDownload(item.resourceId)"
                >
                  <el-icon><Download /></el-icon>
                  下载资源
                </el-button>
                <el-button
                  size="small"
                  @click="viewResource(item.resourceId)"
                >
                  <el-icon><View /></el-icon>
                  查看详情
                </el-button>
              </div>
            </div>
          </el-card>
        </div>

        <!-- 空状态 -->
        <el-empty
          v-if="!loading && favorites.length === 0"
          description="暂无收藏的资源"
        >
          <el-button type="primary" @click="router.push('/resources')">
            去资源库看看
          </el-button>
        </el-empty>

        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="favorites.length > 0">
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
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import {
  StarFilled,
  User,
  Folder,
  Download,
  View,
  CollectionTag
} from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  getMyFavorites,
  removeFavorite,
  downloadResourceFile
} from '@/api/resource'
import AppHeader from '@/components/AppHeader.vue'

const router = useRouter()

const loading = ref(false)
const favorites = ref([])
const total = ref(0)
const sortBy = ref('time')

const queryParams = ref({
  page: 1,
  limit: 10
})

// 获取收藏列表
const fetchFavorites = async () => {
  loading.value = true
  try {
    const res = await getMyFavorites(queryParams.value)
    if (res.code === 0) {
      let list = res.data || []
      total.value = list.length

      // 映射后端返回的字段到前端需要的格式
      favorites.value = list.map(item => ({
        id: item.favoriteId,           // 使用后端返回的 favoriteId
        favoriteId: item.favoriteId,
        resourceId: item.resourceId,
        title: item.title,
        description: item.description,
        uploaderName: item.uploaderName,
        categoryName: item.categoryName,
        downloadCount: item.downloadCount,
        viewCount: item.viewCount,
        fileType: item.fileType,
        coverImage: item.coverImage,
        favoriteTime: item.createTime   // 使用后端返回的 createTime
      }))

      // 排序
      if (sortBy.value === 'time') {
        favorites.value.sort((a, b) => new Date(b.favoriteTime) - new Date(a.favoriteTime))
      } else if (sortBy.value === 'downloads') {
        favorites.value.sort((a, b) => (b.downloadCount || 0) - (a.downloadCount || 0))
      }
    }
  } catch (error) {
    console.error('获取收藏列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 排序变化
const handleSortChange = () => {
  fetchFavorites()
}

// 页码改变
const handlePageChange = (page) => {
  queryParams.value.page = page
  fetchFavorites()
}

// 每页数量改变
const handleSizeChange = (size) => {
  queryParams.value.limit = size
  queryParams.value.page = 1
  fetchFavorites()
}

// 查看资源详情
const viewResource = (id) => {
  router.push(`/resource/${id}`)
}

// 下载资源
const handleDownload = async (id) => {
  try {
    await downloadResourceFile(id)
  } catch (error) {
    // 错误已经在 downloadFile 和 request.js 中处理
    console.error('下载失败:', error)
  }
}

// 取消收藏
const handleRemoveFavorite = (item) => {
  ElMessageBox.confirm(
    `确定要取消收藏「${item.title}」吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      const res = await removeFavorite(item.resourceId)
      if (res.code === 0) {
        ElMessage.success('已取消收藏')
        fetchFavorites()
      } else {
        ElMessage.error(res.msg || '操作失败')
      }
    } catch (error) {
      console.error('取消收藏失败:', error)
      ElMessage.error('操作失败')
    }
  }).catch(() => {})
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN')
}

onMounted(() => {
  fetchFavorites()
})
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.my-favorites-page {
  min-height: 100vh;
  background-color: $bg-secondary;
  padding-top: 64px;
}

.page-container {
  max-width: $container-xxl;
  margin: 0 auto;
  padding: $spacing-xxl $spacing-lg;

  @include respond-to('sm') {
    padding: $spacing-xl $spacing-md;
  }
}

.toolbar-card {
  margin-bottom: $spacing-lg;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 15px;
}

.stats {
  display: flex;
  align-items: baseline;
  gap: 10px;
}

.stats h3 {
  margin: 0;
  font-size: 18px;
  color: #303133;
}

.count {
  font-size: 14px;
  color: #909399;
}

.sort-options {
  display: flex;
  align-items: center;
  gap: 10px;
}

.sort-label {
  font-size: 14px;
  color: #606266;
}

.favorites-list {
  min-height: 400px;
}

.favorite-card {
  margin-bottom: 20px;
  transition: all 0.3s;
}

.favorite-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.favorite-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 10px;
}

.resource-title {
  margin: 0;
  font-size: 18px;
  font-weight: 500;
  color: #303133;
  cursor: pointer;
  flex: 1;
  padding-right: 20px;
}

.resource-title:hover {
  color: #409EFF;
}

.resource-description {
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

.resource-meta {
  display: flex;
  gap: 20px;
  font-size: 13px;
  color: #909399;
  margin-bottom: 10px;
  flex-wrap: wrap;
}

.resource-meta span {
  display: flex;
  align-items: center;
  gap: 4px;
}

.resource-tags {
  display: flex;
  gap: 8px;
  margin-bottom: 15px;
  flex-wrap: wrap;
}

.resource-actions {
  display: flex;
  gap: 10px;
  padding-top: 15px;
  border-top: 1px solid #ebeef5;
}

.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 40px;
}
</style>
