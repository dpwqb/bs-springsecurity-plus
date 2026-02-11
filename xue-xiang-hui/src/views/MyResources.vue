<template>
  <div class="my-resources-container">
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
            <el-menu-item index="/my-resources">我的资源</el-menu-item>
          </el-menu>
        </div>
      </el-header>

      <!-- 主内容 -->
      <el-main class="main-content">
        <!-- 统计卡片 -->
        <el-row :gutter="20" class="stats-row">
          <el-col :xs="12" :sm="6" :md="6" :lg="6">
            <el-card class="stat-card">
              <div class="stat-item">
                <el-icon :size="32" color="#409EFF"><Document /></el-icon>
                <div class="stat-info">
                  <div class="stat-value">{{ stats.total || 0 }}</div>
                  <div class="stat-label">全部资源</div>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6" :md="6" :lg="6">
            <el-card class="stat-card">
              <div class="stat-item">
                <el-icon :size="32" color="#67C23A"><CircleCheck /></el-icon>
                <div class="stat-info">
                  <div class="stat-value">{{ stats.published || 0 }}</div>
                  <div class="stat-label">已发布</div>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6" :md="6" :lg="6">
            <el-card class="stat-card">
              <div class="stat-item">
                <el-icon :size="32" color="#E6A23C"><EditPen /></el-icon>
                <div class="stat-info">
                  <div class="stat-value">{{ stats.draft || 0 }}</div>
                  <div class="stat-label">草稿</div>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6" :md="6" :lg="6">
            <el-card class="stat-card">
              <div class="stat-item">
                <el-icon :size="32" color="#F56C6C"><Download /></el-icon>
                <div class="stat-info">
                  <div class="stat-value">{{ stats.totalDownloads || 0 }}</div>
                  <div class="stat-label">总下载量</div>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>

        <!-- 筛选和操作栏 -->
        <el-card class="filter-card">
          <el-tabs v-model="activeStatus" @tab-change="handleStatusChange">
            <el-tab-pane label="全部" name="all" />
            <el-tab-pane label="已发布" name="published" />
            <el-tab-pane label="草稿" name="draft" />
          </el-tabs>
        </el-card>

        <!-- 资源列表 -->
        <div v-loading="loading" class="resource-list">
          <el-card
            v-for="resource in resources"
            :key="resource.id"
            class="resource-card"
          >
            <div class="resource-content">
              <div class="resource-header">
                <h3 class="resource-title" @click="viewResource(resource.id)">
                  {{ resource.title }}
                </h3>
                <el-tag :type="getStatusType(resource.status)">
                  {{ getStatusText(resource.status) }}
                </el-tag>
              </div>

              <p class="resource-description">{{ resource.description }}</p>

              <div class="resource-meta">
                <span>
                  <el-icon><Folder /></el-icon>
                  {{ resource.categoryName || '未分类' }}
                </span>
                <span>
                  <el-icon><Download /></el-icon>
                  {{ resource.downloadCount || 0 }} 下载
                </span>
                <span>
                  <el-icon><View /></el-icon>
                  {{ resource.viewCount || 0 }} 浏览
                </span>
                <span>
                  <el-icon><CollectionTag /></el-icon>
                  {{ formatDate(resource.createTime) }}
                </span>
              </div>

              <div class="resource-tags" v-if="resource.tags && resource.tags.length > 0">
                <el-tag
                  v-for="tag in resource.tags.slice(0, 3)"
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
                  @click="editResource(resource)"
                >
                  <el-icon><Edit /></el-icon>
                  编辑
                </el-button>
                <el-button
                  :type="resource.status === 1 ? 'warning' : 'success'"
                  size="small"
                  @click="toggleStatus(resource)"
                >
                  <el-icon><Refresh /></el-icon>
                  {{ resource.status === 1 ? '下架' : '发布' }}
                </el-button>
                <el-button
                  type="danger"
                  size="small"
                  @click="handleDelete(resource)"
                >
                  <el-icon><Delete /></el-icon>
                  删除
                </el-button>
              </div>
            </div>
          </el-card>
        </div>

        <!-- 空状态 -->
        <el-empty
          v-if="!loading && resources.length === 0"
          description="暂无资源"
        >
          <el-button type="primary" @click="router.push('/upload')">
            立即上传
          </el-button>
        </el-empty>

        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="resources.length > 0">
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

    <!-- 编辑对话框 -->
    <el-dialog
      v-model="editDialogVisible"
      title="编辑资源"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="editFormRef"
        :model="editForm"
        :rules="editFormRules"
        label-width="100px"
      >
        <el-form-item label="资源标题" prop="title">
          <el-input
            v-model="editForm.title"
            placeholder="请输入资源标题"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>

        <el-form-item label="资源分类" prop="categoryId">
          <el-select
            v-model="editForm.categoryId"
            placeholder="请选择分类"
            style="width: 100%"
          >
            <el-option
              v-for="category in categories"
              :key="category.id"
              :label="category.name"
              :value="category.id"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="资源描述" prop="description">
          <el-input
            v-model="editForm.description"
            type="textarea"
            :rows="5"
            placeholder="请输入资源描述"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveEdit" :loading="saving">
          保存
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import {
  Document,
  CircleCheck,
  EditPen,
  Download,
  Folder,
  View,
  CollectionTag,
  Edit,
  Delete,
  Refresh
} from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  getMyResources,
  deleteResource,
  getResourceCategories
} from '@/api/resource'

const router = useRouter()
const activeMenu = ref('/my-resources')

const loading = ref(false)
const saving = ref(false)
const resources = ref([])
const total = ref(0)
const categories = ref([])
const activeStatus = ref('all')

const stats = computed(() => {
  const allResources = resources.value
  return {
    total: allResources.length,
    published: allResources.filter(r => r.status === 1).length,
    draft: allResources.filter(r => r.status === 0).length,
    totalDownloads: allResources.reduce((sum, r) => sum + (r.downloadCount || 0), 0)
  }
})

const queryParams = ref({
  page: 1,
  limit: 10,
  keyword: '',
  status: null
})

const editDialogVisible = ref(false)
const editFormRef = ref(null)
const editForm = ref({
  id: null,
  title: '',
  categoryId: null,
  description: ''
})

const editFormRules = {
  title: [
    { required: true, message: '请输入资源标题', trigger: 'blur' },
    { min: 2, max: 100, message: '标题长度在 2 到 100 个字符', trigger: 'blur' }
  ],
  categoryId: [
    { required: true, message: '请选择资源分类', trigger: 'change' }
  ],
  description: [
    { required: true, message: '请输入资源描述', trigger: 'blur' },
    { min: 10, max: 500, message: '描述长度在 10 到 500 个字符', trigger: 'blur' }
  ]
}

// 获取资源列表
const fetchResources = async () => {
  loading.value = true
  try {
    const params = { ...queryParams.value }
    if (activeStatus.value !== 'all') {
      params.status = activeStatus.value === 'published' ? 1 : 0
    } else {
      delete params.status
    }

    const res = await getMyResources(params)
    if (res.code === 200) {
      resources.value = res.data || []
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

// 状态切换
const handleStatusChange = () => {
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

// 编辑资源
const editResource = (resource) => {
  editForm.value = {
    id: resource.id,
    title: resource.title,
    categoryId: resource.categoryId,
    description: resource.description
  }
  editDialogVisible.value = true
}

// 保存编辑
const handleSaveEdit = async () => {
  if (!editFormRef.value) return

  try {
    await editFormRef.value.validate()
  } catch (error) {
    return
  }

  saving.value = true
  try {
    // TODO: 调用更新接口
    ElMessage.success('保存成功')
    editDialogVisible.value = false
    fetchResources()
  } catch (error) {
    console.error('保存失败:', error)
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

// 切换发布状态
const toggleStatus = (resource) => {
  const newStatus = resource.status === 1 ? 0 : 1
  const statusText = newStatus === 1 ? '发布' : '下架'

  ElMessageBox.confirm(
    `确定要${statusText}该资源吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(() => {
    // TODO: 调用更新状态接口
    resource.status = newStatus
    ElMessage.success(`${statusText}成功`)
  }).catch(() => {})
}

// 删除资源
const handleDelete = (resource) => {
  ElMessageBox.confirm(
    '确定要删除该资源吗？删除后无法恢复！',
    '警告',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      const res = await deleteResource(resource.id)
      if (res.code === 200) {
        ElMessage.success('删除成功')
        fetchResources()
      } else {
        ElMessage.error(res.msg || '删除失败')
      }
    } catch (error) {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
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

// 获取状态类型
const getStatusType = (status) => {
  const typeMap = {
    0: 'warning',
    1: 'success',
    2: 'danger'
  }
  return typeMap[status] || 'info'
}

// 获取状态文本
const getStatusText = (status) => {
  const textMap = {
    0: '草稿',
    1: '已发布',
    2: '已下架'
  }
  return textMap[status] || '未知'
}

onMounted(() => {
  fetchCategories()
  fetchResources()
})
</script>

<style scoped>
.my-resources-container {
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

.main-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
}

.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  cursor: default;
  transition: all 0.3s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 15px;
}

.stat-info {
  display: flex;
  flex-direction: column;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}

.stat-label {
  font-size: 13px;
  color: #909399;
  margin-top: 5px;
}

.filter-card {
  margin-bottom: 20px;
}

.resource-list {
  min-height: 400px;
}

.resource-card {
  margin-bottom: 20px;
  transition: all 0.3s;
}

.resource-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.resource-header {
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
