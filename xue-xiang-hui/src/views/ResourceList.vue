<template>
  <div class="resource-list-container">
    <el-container>
      <!-- 顶部导航（复用Home的导航） -->
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
            <el-button type="primary" @click="handleUpload">
              <el-icon><Upload /></el-icon>
              上传资源
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
          <el-col :span="6">
            <el-select
              v-model="queryParams.fileType"
              placeholder="文件类型"
              clearable
              @change="handleSearch"
            >
              <el-option label="PDF" value="pdf" />
              <el-option label="Word" value="doc" />
              <el-option label="Word" value="docx" />
              <el-option label="PPT" value="ppt" />
              <el-option label="PPT" value="pptx" />
              <el-option label="TXT" value="txt" />
            </el-select>
          </el-col>
          <el-col :span="12">
            <el-input
              v-model="queryParams.keyword"
              placeholder="搜索资源标题、描述..."
              @keyup.enter="handleSearch"
            >
              <template #append>
                <el-button :icon="Search" @click="handleSearch" />
              </template>
            </el-input>
          </el-col>
        </el-row>
      </div>

      <!-- 资源列表 -->
      <el-main class="main-content">
        <el-row :gutter="20" v-loading="loading">
          <el-col
            v-for="resource in resources"
            :key="resource.id"
            :xs="24"
            :sm="12"
            :md="8"
            :lg="6"
          >
            <el-card class="resource-card" @click="viewResource(resource.id)">
              <div class="file-icon">
                <el-icon :size="50" :color="getFileColor(resource.fileType)">
                  <Document />
                </el-icon>
              </div>
              <div class="resource-info">
                <h4 class="resource-title" :title="resource.title">
                  {{ resource.title }}
                </h4>
                <p class="resource-desc" :title="resource.description">
                  {{ resource.description || '暂无描述' }}
                </p>
                <div class="resource-meta">
                  <span>
                    <el-icon><User /></el-icon>
                    {{ resource.uploaderName }}
                  </span>
                  <span>
                    <el-icon><View /></el-icon>
                    {{ resource.viewCount || 0 }}
                  </span>
                  <span>
                    <el-icon><Download /></el-icon>
                    {{ resource.downloadCount || 0 }}
                  </span>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>

        <!-- 空状态 -->
        <el-empty v-if="!loading && resources.length === 0" description="暂无资源" />

        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="resources.length > 0">
          <el-pagination
            v-model:current-page="queryParams.page"
            v-model:page-size="queryParams.limit"
            :total="total"
            :page-sizes="[12, 24, 48, 96]"
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
import { ref, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Search, Document, Upload, User, View, Download } from '@element-plus/icons-vue'
import { getResourceList, getResourceCategories } from '@/api/resource'

const router = useRouter()
const route = useRoute()
const activeMenu = ref('/resources')
const loading = ref(false)
const resources = ref([])
const categories = ref([])
const total = ref(0)

const queryParams = ref({
  page: 1,
  limit: 12,
  keyword: '',
  categoryId: null,
  fileType: '',
  status: 1
})

// 获取资源列表
const fetchResources = async () => {
  loading.value = true
  try {
    const res = await getResourceList(queryParams.value)
    if (res.code === 200) {
      resources.value = res.data || []
      // TODO: 从后端返回total字段
      total.value = res.data?.length || 0
    }
  } catch (error) {
    console.error('获取资源列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 获取分类列表
const fetchCategories = async () => {
  try {
    const res = await getResourceCategories()
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
  fetchResources()
}

// 页码改变
const handlePageChange = (page) => {
  queryParams.value.page = page
  fetchResources()
}

// 每页数量改变
const handleSizeChange = (size) => {
  queryParams.value.limit = size
  queryParams.value.page = 1
  fetchResources()
}

// 查看资源详情
const viewResource = (id) => {
  router.push(`/resource/${id}`)
}

// 上传资源
const handleUpload = () => {
  // TODO: 实现上传功能
  console.log('上传资源')
}

// 菜单选择
const handleMenuSelect = (index) => {
  router.push(index)
}

// 根据文件类型获取图标颜色
const getFileColor = (fileType) => {
  const colorMap = {
    pdf: '#F56C6C',
    doc: '#409EFF',
    docx: '#409EFF',
    ppt: '#E6A23C',
    pptx: '#E6A23C',
    txt: '#909399'
  }
  return colorMap[fileType] || '#909399'
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
    fetchResources()
  },
  { immediate: true }
)

onMounted(() => {
  fetchCategories()
  if (!route.query.keyword && !route.query.categoryId) {
    fetchResources()
  }
})
</script>

<style scoped>
.resource-list-container {
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
  max-width: 1400px;
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
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
}

.resource-card {
  cursor: pointer;
  transition: all 0.3s;
  margin-bottom: 20px;
}

.resource-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.file-icon {
  text-align: center;
  padding: 30px 0;
  background: #f5f7fa;
  border-radius: 8px;
  margin-bottom: 15px;
}

.resource-info {
  text-align: center;
}

.resource-title {
  font-size: 16px;
  font-weight: 500;
  color: #303133;
  margin: 0 0 10px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.resource-desc {
  font-size: 12px;
  color: #909399;
  margin: 0 0 15px 0;
  height: 36px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.resource-meta {
  font-size: 12px;
  color: #909399;
  display: flex;
  justify-content: space-around;
  padding-top: 10px;
  border-top: 1px solid #ebeef5;
}

.resource-meta span {
  display: flex;
  align-items: center;
  gap: 4px;
}

.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 40px;
}
</style>
