<template>
  <div class="home-container">
    <!-- 顶部导航 -->
    <el-header class="header">
      <div class="header-content">
        <div class="logo">
          <h2>📚 学享汇</h2>
          <span class="slogan">免费文档资源共享平台</span>
        </div>
        <el-menu
          :default-active="activeMenu"
          class="menu"
          mode="horizontal"
          :ellipsis="false"
          @select="handleMenuSelect"
        >
          <el-menu-item index="/">首页</el-menu-item>
          <el-menu-item index="/resources">资源库</el-menu-item>
          <el-menu-item index="/articles">文章广场</el-menu-item>
        </el-menu>
        <div class="user-actions">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索资源/文章..."
            class="search-input"
            @keyup.enter="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          <el-button type="primary" @click="handleUpload">
            <el-icon><Upload /></el-icon>
            上传资源
          </el-button>
        </div>
      </div>
    </el-header>

    <!-- 主要内容区 -->
    <el-main class="main-content">
      <!-- 热门分类 -->
      <div class="categories-section">
        <h3>热门分类</h3>
        <div class="category-tags">
          <el-tag
            v-for="category in categories"
            :key="category.id"
            class="category-tag"
            @click="handleCategoryClick(category)"
          >
            {{ category.name }}
          </el-tag>
        </div>
      </div>

      <!-- 资源列表 -->
      <div class="resources-section">
        <div class="section-header">
          <h3>最新资源</h3>
          <el-link type="primary" @click="viewMore('resources')">查看更多 →</el-link>
        </div>
        <el-row :gutter="20">
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
                <el-icon :size="40" :color="getFileColor(resource.fileType)">
                  <Document />
                </el-icon>
              </div>
              <div class="resource-info">
                <h4 class="resource-title" :title="resource.title">
                  {{ resource.title }}
                </h4>
                <p class="resource-meta">
                  <el-icon><View /></el-icon>
                  {{ resource.viewCount || 0 }} 浏览
                  <el-icon><Download /></el-icon>
                  {{ resource.downloadCount || 0 }} 下载
                </p>
                <div class="resource-tags">
                  <el-tag
                    v-for="tag in resource.tags"
                    :key="tag.id"
                    size="small"
                    type="info"
                  >
                    {{ tag.name }}
                  </el-tag>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getResourceList, getResourceCategories } from '@/api/resource'

const router = useRouter()
const activeMenu = ref('/')
const searchKeyword = ref('')
const categories = ref([])
const resources = ref([])

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

// 获取资源列表
const fetchResources = async () => {
  try {
    const res = await getResourceList({ page: 1, limit: 8, status: 1 })
    if (res.code === 200) {
      resources.value = res.data || []
    }
  } catch (error) {
    console.error('获取资源失败:', error)
  }
}

// 菜单选择
const handleMenuSelect = (index) => {
  router.push(index)
}

// 搜索
const handleSearch = () => {
  if (searchKeyword.value) {
    router.push({
      path: '/resources',
      query: { keyword: searchKeyword.value }
    })
  }
}

// 上传资源
const handleUpload = () => {
  // TODO: 跳转到上传页面或显示上传对话框
  console.log('上传资源')
}

// 分类点击
const handleCategoryClick = (category) => {
  router.push({
    path: '/resources',
    query: { categoryId: category.id }
  })
}

// 查看更多
const viewMore = (type) => {
  router.push(`/${type}`)
}

// 查看资源详情
const viewResource = (id) => {
  router.push(`/resource/${id}`)
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

onMounted(() => {
  fetchCategories()
  fetchResources()
})
</script>

<style scoped>
.home-container {
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
  display: flex;
  align-items: baseline;
  margin-right: 40px;
}

.logo h2 {
  margin: 0;
  color: #409EFF;
}

.slogan {
  margin-left: 10px;
  font-size: 12px;
  color: #909399;
}

.menu {
  flex: 1;
  border-bottom: none;
}

.user-actions {
  display: flex;
  align-items: center;
  gap: 15px;
}

.search-input {
  width: 250px;
}

.main-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 30px 20px;
}

.categories-section {
  background: white;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 30px;
}

.categories-section h3 {
  margin: 0 0 15px 0;
  font-size: 16px;
  color: #303133;
}

.category-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.category-tag {
  cursor: pointer;
  transition: all 0.3s;
}

.category-tag:hover {
  transform: translateY(-2px);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3);
}

.resources-section {
  background: white;
  padding: 20px;
  border-radius: 8px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-header h3 {
  margin: 0;
  font-size: 18px;
  color: #303133;
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
  padding: 20px 0;
}

.resource-info {
  text-align: center;
}

.resource-title {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  margin: 10px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.resource-meta {
  font-size: 12px;
  color: #909399;
  margin: 8px 0;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 15px;
}

.resource-meta .el-icon {
  margin-right: 4px;
}

.resource-tags {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 5px;
  margin-top: 10px;
}
</style>
