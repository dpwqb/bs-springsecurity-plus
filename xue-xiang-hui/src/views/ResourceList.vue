<template>
  <div class="resource-list-page">
    <AppHeader />

    <div class="page-container">
      <!-- 页面头部 -->
      <div class="page-header">
        <el-breadcrumb>
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>资源库</el-breadcrumb-item>
        </el-breadcrumb>
        <h1 class="page-title">资源库</h1>
      </div>

      <!-- 增强筛选栏 -->
      <el-card class="filter-card" shadow="never">
        <el-row :gutter="16">
          <!-- 分类筛选 -->
          <el-col :xs="24" :sm="12" :md="6" :lg="4">
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

          <!-- 文件类型Tab -->
          <el-col :xs="24" :sm="12" :md="6" :lg="5">
            <el-segmented
              v-model="queryParams.fileType"
              :options="fileTypeOptions"
              @change="handleSearch"
              class="filter-segmented"
            />
          </el-col>

          <!-- 排序方式 -->
          <el-col :xs="24" :sm="12" :md="6" :lg="5">
            <el-select
              v-model="queryParams.sortBy"
              placeholder="排序方式"
              @change="handleSearch"
              class="filter-select"
            >
              <el-option label="综合排序" value="default" />
              <el-option label="最新上传" value="createTime" />
              <el-option label="最多下载" value="downloadCount" />
              <el-option label="最多浏览" value="viewCount" />
            </el-select>
          </el-col>

          <!-- 搜索框 -->
          <el-col :xs="24" :sm="12" :md="6" :lg="6">
            <el-input
              v-model="queryParams.keyword"
              placeholder="搜索资源标题、描述..."
              clearable
              @keyup.enter="handleSearch"
              @clear="handleSearch"
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
              <template #append>
                <el-button :icon="Search" @click="handleSearch" />
              </template>
            </el-input>
          </el-col>

          <!-- 视图切换 -->
          <el-col :xs="24" :sm="12" :md="6" :lg="4">
            <el-button-group class="view-toggle">
              <el-button
                :type="viewMode === 'grid' ? 'primary' : ''"
                @click="viewMode = 'grid'"
              >
                <el-icon><Grid /></el-icon>
              </el-button>
              <el-button
                :type="viewMode === 'list' ? 'primary' : ''"
                @click="viewMode = 'list'"
              >
                <el-icon><List /></el-icon>
              </el-button>
            </el-button-group>
          </el-col>
        </el-row>

        <!-- 选中的标签筛选 -->
        <div v-if="selectedTags.length > 0" class="tags-filter">
          <span class="tags-label">已选标签:</span>
          <el-tag
            v-for="tag in selectedTags"
            :key="tag.id"
            closable
            @close="removeTag(tag)"
            class="tag-item"
          >
            {{ tag.name }}
          </el-tag>
          <el-button link type="primary" @click="clearTags" class="clear-tags">
            清空
          </el-button>
        </div>
      </el-card>

      <!-- 资源列表 -->
      <div v-loading="loading" class="resource-list">
        <!-- 网格视图 -->
        <template v-if="viewMode === 'grid'">
          <el-row :gutter="20">
            <el-col
              v-for="resource in resources"
              :key="resource.id"
              :xs="24"
              :sm="12"
              :md="8"
              :lg="6"
            >
              <ResourceCard
                :resource="resource"
                view-mode="grid"
                @favorite="handleFavorite"
                @share="handleShare"
                @download="handleDownload"
              />
            </el-col>
          </el-row>
        </template>

        <!-- 列表视图 -->
        <template v-else>
          <el-card
            v-for="resource in resources"
            :key="resource.id"
            class="list-item-card"
            shadow="hover"
          >
            <ResourceCard
              :resource="resource"
              view-mode="list"
              @favorite="handleFavorite"
              @share="handleShare"
              @download="handleDownload"
            />
          </el-card>
        </template>

        <!-- 空状态 -->
        <el-empty
          v-if="!loading && resources.length === 0"
          description="暂无资源"
          :image-size="200"
        >
          <el-button type="primary" @click="handleUpload">上传资源</el-button>
        </el-empty>
      </div>

      <!-- 分页 -->
      <div v-if="resources.length > 0" class="pagination-wrapper">
        <el-pagination
          v-model:current-page="queryParams.page"
          v-model:page-size="queryParams.limit"
          :total="total"
          :page-sizes="[12, 24, 48, 96]"
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
import { ref, onMounted, watch, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useResourceStore } from '@/stores/resource'
import { useUserStore } from '@/stores/user'
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'
import ResourceCard from '@/components/ResourceCard.vue'
import { ElMessage } from 'element-plus'
import {
  Search,
  Grid,
  List,
  Upload,
  Download
} from '@element-plus/icons-vue'
import { getResourceList } from '@/api/resource'

const router = useRouter()
const route = useRoute()
const resourceStore = useResourceStore()
const userStore = useUserStore()

// 状态
const loading = ref(false)
const resources = ref([])
const categories = ref([])
const total = ref(0)
const viewMode = ref('grid')
const selectedTags = ref([])

// 文件类型选项
const fileTypeOptions = [
  { label: '全部', value: '' },
  { label: 'PDF', value: 'pdf' },
  { label: 'Word', value: 'doc' },
  { label: 'PPT', value: 'ppt' },
  { label: '其他', value: 'other' }
]

// 查询参数
const queryParams = ref({
  page: 1,
  limit: 12,
  keyword: '',
  categoryId: null,
  fileType: '',
  sortBy: 'default',
  status: 1
})

// 获取资源列表
const fetchResources = async () => {
  loading.value = true
  try {
    const res = await getResourceList(queryParams.value)
    if (res.code === 0) {
      resources.value = res.data || []
      total.value = res.total || res.data?.length || 0
    }
  } catch (error) {
    console.error('获取资源列表失败:', error)
    ElMessage.error('获取资源列表失败')
  } finally {
    loading.value = false
  }
}

// 获取分类列表
const fetchCategories = async () => {
  const result = await resourceStore.fetchCategories()
  if (result.success) {
    categories.value = result.data
  }
}

// 搜索
const handleSearch = () => {
  queryParams.value.page = 1
  fetchResources()
}

// 页码改变
const handlePageChange = (page) => {
  queryParams.value.page = page
  fetchResources()
  // 滚动到顶部
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

// 每页数量改变
const handleSizeChange = (size) => {
  queryParams.value.limit = size
  queryParams.value.page = 1
  fetchResources()
}

// 移除标签筛选
const removeTag = (tag) => {
  const index = selectedTags.value.findIndex(t => t.id === tag.id)
  if (index > -1) {
    selectedTags.value.splice(index, 1)
    handleSearch()
  }
}

// 清空标签
const clearTags = () => {
  selectedTags.value = []
  handleSearch()
}

// 收藏
const handleFavorite = async (resource) => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    router.push('/login')
    return
  }

  try {
    const { toggleFavorite } = await import('@/api/resource')
    const res = await toggleFavorite(resource.id)
    if (res.code === 0) {
      ElMessage.success(res.message || '操作成功')
      fetchResources()
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

// 分享
const handleShare = (resource) => {
  const url = `${window.location.origin}/resource/${resource.id}`
  navigator.clipboard.writeText(url).then(() => {
    ElMessage.success('链接已复制到剪贴板')
  }).catch(() => {
    ElMessage.error('复制失败')
  })
}

// 下载
const handleDownload = (resource) => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    router.push('/login')
    return
  }

  const { downloadResource } = require('@/api/resource')
  const url = downloadResource(resource.id)
  window.open(url, '_blank')
}

// 上传资源
const handleUpload = () => {
  if (userStore.isLoggedIn) {
    router.push('/upload')
  } else {
    router.push('/login')
  }
}

// 监听路由参数变化
watch(
  () => route.query,
  (newQuery) => {
    if (newQuery.keyword) {
      queryParams.value.keyword = newQuery.keyword
    }
    if (newQuery.categoryId) {
      queryParams.value.categoryId = parseInt(newQuery.categoryId)
    }
    if (newQuery.tagId) {
      // 从store获取标签信息
      const tag = resourceStore.tags.find(t => t.id === parseInt(newQuery.tagId))
      if (tag && !selectedTags.value.find(t => t.id === tag.id)) {
        selectedTags.value.push(tag)
      }
    }
    fetchResources()
  },
  { immediate: true }
)

onMounted(() => {
  fetchCategories()
  // 初始化资源store
  resourceStore.fetchTags()
})
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.resource-list-page {
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

.filter-select,
.filter-segmented {
  width: 100%;
}

.tags-filter {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
  margin-top: $spacing-md;
  padding-top: $spacing-md;
  border-top: 1px solid $border-lighter;

  .tags-label {
    font-size: $font-size-sm;
    color: $text-secondary;
    flex-shrink: 0;
  }

  .tag-item {
    margin: 0;
  }

  .clear-tags {
    font-size: $font-size-sm;
  }
}

.view-toggle {
  width: 100%;

  .el-button {
    flex: 1;
  }
}

.resource-list {
  min-height: 400px;
  margin-bottom: $spacing-xl;
}

.list-item-card {
  margin-bottom: $spacing-md;

  :deep(.el-card__body) {
    padding: 0;
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

  .filter-card {
    :deep(.el-card__body) {
      padding: $spacing-md;
    }
  }

  .filter-select,
  .filter-segmented {
    margin-bottom: $spacing-md;
  }

  .page-title {
    font-size: $font-size-xl;
  }
}
</style>
