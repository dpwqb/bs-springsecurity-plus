<template>
  <div class="my-downloads-container">
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
            <el-menu-item index="/my-downloads">下载历史</el-menu-item>
          </el-menu>
        </div>
      </el-header>

      <!-- 主内容 -->
      <el-main class="main-content">
        <!-- 统计卡片 -->
        <el-card class="stats-card">
          <div class="stats-content">
            <div class="stat-item">
              <el-icon :size="36" color="#409EFF"><Download /></el-icon>
              <div class="stat-info">
                <div class="stat-value">{{ downloadStats.total || 0 }}</div>
                <div class="stat-label">累计下载次数</div>
              </div>
            </div>
            <el-divider direction="vertical" style="height: 60px" />
            <div class="stat-item">
              <el-icon :size="36" color="#67C23A"><Document /></el-icon>
              <div class="stat-info">
                <div class="stat-value">{{ downloadStats.unique || 0 }}</div>
                <div class="stat-label">下载资源数</div>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 下载记录表格 -->
        <el-card class="table-card">
          <template #header>
            <h3>下载记录</h3>
          </template>

          <el-table
            v-loading="loading"
            :data="downloads"
            style="width: 100%"
            stripe
          >
            <el-table-column prop="title" label="资源名称" min-width="300">
              <template #default="{ row }">
                <div class="resource-name">
                  <el-link
                    type="primary"
                    @click="viewResource(row.resourceId)"
                    :underline="false"
                  >
                    {{ row.title }}
                  </el-link>
                  <el-tag
                    v-if="row.status === 2"
                    type="danger"
                    size="small"
                    style="margin-left: 8px"
                  >
                    已下架
                  </el-tag>
                </div>
              </template>
            </el-table-column>

            <el-table-column label="文件类型" width="100" align="center">
              <template #default="{ row }">
                <el-tag size="small">
                  {{ getFileType(row.fileName) }}
                </el-tag>
              </template>
            </el-table-column>

            <el-table-column label="文件大小" width="120" align="center">
              <template #default="{ row }">
                <span>{{ formatFileSize(row.fileSize) }}</span>
              </template>
            </el-table-column>

            <el-table-column prop="uploaderName" label="上传者" width="150">
              <template #default="{ row }">
                <div class="uploader-info">
                  <el-icon><User /></el-icon>
                  <span>{{ row.uploaderName || '未知' }}</span>
                </div>
              </template>
            </el-table-column>

            <el-table-column prop="downloadTime" label="下载时间" width="180">
              <template #default="{ row }">
                <div class="time-info">
                  <el-icon><Clock /></el-icon>
                  <span>{{ formatDateTime(row.downloadTime) }}</span>
                </div>
              </template>
            </el-table-column>

            <el-table-column label="操作" width="150" align="center" fixed="right">
              <template #default="{ row }">
                <el-button
                  type="primary"
                  size="small"
                  @click="handleDownload(row.resourceId)"
                  :disabled="row.status === 2"
                >
                  <el-icon><Download /></el-icon>
                  重新下载
                </el-button>
              </template>
            </el-table-column>
          </el-table>

          <!-- 空状态 -->
          <el-empty
            v-if="!loading && downloads.length === 0"
            description="暂无下载记录"
          >
            <el-button type="primary" @click="router.push('/resources')">
              去资源库看看
            </el-button>
          </el-empty>

          <!-- 分页 -->
          <div class="pagination-wrapper" v-if="downloads.length > 0">
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
        </el-card>
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import {
  Download,
  Document,
  User,
  Clock
} from '@element-plus/icons-vue'
import { getMyDownloads, getDownloadStats, downloadResource } from '@/api/resource'

const router = useRouter()
const activeMenu = ref('/my-downloads')

const loading = ref(false)
const downloads = ref([])
const total = ref(0)
const downloadStats = ref({
  total: 0,
  unique: 0
})

const queryParams = ref({
  page: 1,
  limit: 10
})

// 获取下载统计
const fetchDownloadStats = async () => {
  try {
    const res = await getDownloadStats()
    if (res.code === 200) {
      const stats = res.data?.[0] || {}
      downloadStats.value = {
        total: stats.total || 0,
        unique: stats.unique || 0
      }
    }
  } catch (error) {
    console.error('获取下载统计失败:', error)
  }
}

// 获取下载记录
const fetchDownloads = async () => {
  loading.value = true
  try {
    const res = await getMyDownloads(queryParams.value)
    if (res.code === 200) {
      downloads.value = res.data || []
      total.value = res.data?.length || 0
    }
  } catch (error) {
    console.error('获取下载记录失败:', error)
  } finally {
    loading.value = false
  }
}

// 页码改变
const handlePageChange = (page) => {
  queryParams.value.page = page
  fetchDownloads()
}

// 每页数量改变
const handleSizeChange = (size) => {
  queryParams.value.limit = size
  queryParams.value.page = 1
  fetchDownloads()
}

// 查看资源详情
const viewResource = (id) => {
  router.push(`/resource/${id}`)
}

// 下载资源
const handleDownload = (id) => {
  const url = downloadResource(id)
  window.open(url, '_blank')
}

// 菜单选择
const handleMenuSelect = (index) => {
  router.push(index)
}

// 格式化文件大小
const formatFileSize = (bytes) => {
  if (!bytes) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i]
}

// 获取文件类型
const getFileType = (fileName) => {
  if (!fileName) return '未知'
  const ext = fileName.split('.').pop().toLowerCase()
  const typeMap = {
    pdf: 'PDF',
    doc: 'Word',
    docx: 'Word',
    ppt: 'PPT',
    pptx: 'PPT',
    txt: 'TXT',
    zip: 'ZIP',
    '7z': '7Z',
    rar: 'RAR'
  }
  return typeMap[ext] || ext.toUpperCase()
}

// 格式化日期时间
const formatDateTime = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN')
}

onMounted(() => {
  fetchDownloadStats()
  fetchDownloads()
})
</script>

<style scoped>
.my-downloads-container {
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

.stats-card {
  margin-bottom: 20px;
}

.stats-content {
  display: flex;
  align-items: center;
  gap: 40px;
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
  font-size: 28px;
  font-weight: bold;
  color: #303133;
}

.stat-label {
  font-size: 13px;
  color: #909399;
  margin-top: 5px;
}

.table-card {
  margin-bottom: 20px;
}

.table-card h3 {
  margin: 0;
  font-size: 18px;
  color: #303133;
}

.resource-name {
  display: flex;
  align-items: center;
}

.uploader-info {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #606266;
}

.time-info {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #606266;
}

.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #ebeef5;
}

:deep(.el-table) {
  font-size: 14px;
}

:deep(.el-table th) {
  background-color: #fafafa;
}

:deep(.el-table .cell) {
  padding: 8px 0;
}
</style>
