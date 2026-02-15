<template>
  <div class="resource-detail-container">
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
        </div>
      </el-header>

      <!-- 主要内容 -->
      <el-main class="main-content" v-loading="loading">
        <el-row :gutter="30">
          <!-- 左侧：资源详情 -->
          <el-col :xs="24" :sm="24" :md="16" :lg="16">
            <el-card class="detail-card">
              <template #header>
                <div class="card-header">
                  <h1>{{ resource.title }}</h1>
                  <el-tag :type="getStatusType(resource.status)">
                    {{ getStatusText(resource.status) }}
                  </el-tag>
                </div>
              </template>

              <!-- 资源信息 -->
              <div class="resource-info">
                <el-descriptions :column="2" border>
                  <el-descriptions-item label="文件名">
                    {{ resource.fileName }}
                  </el-descriptions-item>
                  <el-descriptions-item label="文件大小">
                    {{ formatFileSize(resource.fileSize) }}
                  </el-descriptions-item>
                  <el-descriptions-item label="文件类型">
                    <el-tag>{{ resource.fileType?.toUpperCase() }}</el-tag>
                  </el-descriptions-item>
                  <el-descriptions-item label="上传者">
                    {{ resource.uploaderName }}
                  </el-descriptions-item>
                  <el-descriptions-item label="上传时间">
                    {{ formatDate(resource.createTime) }}
                  </el-descriptions-item>
                  <el-descriptions-item label="浏览量">
                    {{ resource.viewCount || 0 }} 次
                  </el-descriptions-item>
                </el-descriptions>

                <!-- 描述 -->
                <div class="description-section" v-if="resource.description">
                  <h3>资源描述</h3>
                  <p class="description">{{ resource.description }}</p>
                </div>

                <!-- 标签 -->
                <div class="tags-section" v-if="resource.tags && resource.tags.length > 0">
                  <h3>标签</h3>
                  <div class="tags">
                    <el-tag
                      v-for="tag in resource.tags"
                      :key="tag.id"
                      type="info"
                    >
                      {{ tag.name }}
                    </el-tag>
                  </div>
                </div>

                <!-- 操作按钮 -->
                <div class="action-buttons">
                  <el-button type="primary" size="large" @click="handleDownload">
                    <el-icon><Download /></el-icon>
                    下载资源
                  </el-button>
                  <el-button
                    :type="isFavorited ? 'danger' : 'default'"
                    size="large"
                    @click="handleToggleFavorite"
                    :loading="favoriteLoading"
                  >
                    <el-icon>
                      <Star v-if="!isFavorited" />
                      <StarFilled v-else />
                    </el-icon>
                    {{ isFavorited ? '已收藏' : '收藏' }}
                  </el-button>
                </div>
              </div>
            </el-card>

            <!-- 文本内容（用于AI选择） -->
            <el-card class="content-card" v-if="resource.description">
              <template #header>
                <h3>资源内容</h3>
              </template>
              <div
                class="content-text"
                @mouseup="handleTextSelection"
                ref="contentRef"
              >
                {{ resource.description }}
              </div>
            </el-card>
          </el-col>

          <!-- 右侧：统计信息 -->
          <el-col :xs="24" :sm="24" :md="8" :lg="8">
            <el-card class="stats-card">
              <template #header>
                <h3>资源统计</h3>
              </template>
              <div class="stats">
                <div class="stat-item">
                  <el-icon :size="30" color="#409EFF"><View /></el-icon>
                  <div class="stat-info">
                    <div class="stat-value">{{ resource.viewCount || 0 }}</div>
                    <div class="stat-label">浏览量</div>
                  </div>
                </div>
                <div class="stat-item">
                  <el-icon :size="30" color="#67C23A"><Download /></el-icon>
                  <div class="stat-info">
                    <div class="stat-value">{{ resource.downloadCount || 0 }}</div>
                    <div class="stat-label">下载量</div>
                  </div>
                </div>
                <div class="stat-item">
                  <el-icon :size="30" color="#F56C6C"><StarFilled /></el-icon>
                  <div class="stat-info">
                    <div class="stat-value">{{ resource.collectCount || 0 }}</div>
                    <div class="stat-label">收藏量</div>
                  </div>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </el-main>

      <!-- AI对话侧边栏 -->
      <el-drawer
        v-model="aiDrawerVisible"
        title="AI 智能助手"
        size="450px"
        direction="rtl"
      >
        <AiChatSidebar
          :selected-text="selectedText"
          :resource-id="resourceId"
          @close="aiDrawerVisible = false"
        />
      </el-drawer>

      <!-- 浮动AI按钮 -->
      <transition name="fade">
        <div
          v-if="selectedText"
          class="ai-float-button"
          @click="openAiChat"
        >
          <el-icon :size="24"><ChatDotRound /></el-icon>
          <span>AI 解读</span>
        </div>
      </transition>
    </el-container>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Download, Star, StarFilled, View, ChatDotRound } from '@element-plus/icons-vue'
import { getResourceDetail, downloadResource, toggleFavorite, checkFavorited } from '@/api/resource'
import AiChatSidebar from '@/components/AiChatSidebar.vue'
import { ElMessage } from 'element-plus'

const router = useRouter()
const route = useRoute()
const activeMenu = ref('/resources')

const loading = ref(false)
const favoriteLoading = ref(false)
const resource = ref({})
const isFavorited = ref(false)
const selectedText = ref('')
const aiDrawerVisible = ref(false)
const contentRef = ref(null)

const resourceId = computed(() => {
  const id = Number(route.params.id)
  return isNaN(id) ? null : id
})

// 监听路由参数变化，验证 ID 有效性
watch(() => route.params.id, (newId) => {
  const id = Number(newId)
  // 只在 ID 真正存在且无效时才报错
  if (newId !== undefined && (isNaN(id) || id <= 0)) {
    ElMessage.error('资源ID无效')
    router.push('/resources')
  }
})

// 获取资源详情
const fetchResourceDetail = async () => {
  console.log('===== 开始获取资源详情 =====')
  console.log('1. resourceId.value:', resourceId.value)
  console.log('2. resourceId类型:', typeof resourceId.value)

  if (!resourceId.value) {
    console.log('❌ resourceId为空，终止请求')
    return
  }

  loading.value = true
  try {
    console.log('3. 发起API请求，URL:', `/api/resource/${resourceId.value}`)
    const res = await getResourceDetail(resourceId.value)
    console.log('4. API完整响应:', res)
    console.log('5. res.code:', res.code)
    console.log('6. res.data:', res.data)
    console.log('7. res.data类型:', Array.isArray(res.data) ? '数组，长度:' + res.data.length : typeof res.data)

    if (res.code === 0) {
      // 兼容处理：后端可能返回数组或对象
      if (Array.isArray(res.data)) {
        console.log('8. 数据是数组，取第一个元素')
        console.log('9. 数组第一个元素:', res.data[0])
        resource.value = res.data[0] || {}
      } else {
        console.log('8. 数据是对象')
        console.log('9. 对象内容:', res.data)
        resource.value = res.data || {}
      }
      console.log('10. 最终resource.value:', resource.value)
      console.log('11. resource.value的keys:', Object.keys(resource.value))
      console.log('12. resource.title:', resource.value.title)
      console.log('13. resource.fileName:', resource.value.fileName)
      // 检查收藏状态
      checkFavoriteStatus()
    } else {
      console.log('❌ API返回错误码:', res.code, '消息:', res.message)
      ElMessage.error(res.message || '获取资源详情失败')
    }
  } catch (error) {
    console.error('❌ 获取资源详情异常:', error)
    console.error('错误堆栈:', error.stack)
    ElMessage.error('获取资源详情失败，请稍后重试')
  } finally {
    loading.value = false
    console.log('===== 获取资源详情结束 =====')
  }
}

// 检查收藏状态
const checkFavoriteStatus = async () => {
  if (!resourceId.value) {
    return
  }

  try {
    const res = await checkFavorited(resourceId.value)
    if (res.code === 0) {
      // 兼容处理：后端可能返回数组或对象
      if (Array.isArray(res.data)) {
        isFavorited.value = res.data[0] || false
      } else {
        isFavorited.value = res.data || false
      }
    }
  } catch (error) {
    console.error('检查收藏状态失败:', error)
  }
}

// 下载资源
const handleDownload = () => {
  if (!resourceId.value) {
    return
  }

  const url = downloadResource(resourceId.value)
  window.open(url, '_blank')
}

// 切换收藏状态
const handleToggleFavorite = async () => {
  if (!resourceId.value) {
    return
  }

  favoriteLoading.value = true
  try {
    const res = await toggleFavorite(resourceId.value)
    if (res.code === 0) {
      // 兼容处理：后端可能返回数组或对象
      if (Array.isArray(res.data)) {
        isFavorited.value = res.data[0] || false
      } else {
        isFavorited.value = res.data || false
      }
    }
  } catch (error) {
    console.error('切换收藏状态失败:', error)
  } finally {
    favoriteLoading.value = false
  }
}

// 处理文本选择
const handleTextSelection = () => {
  const selection = window.getSelection()
  const text = selection.toString().trim()

  if (text.length > 0) {
    selectedText.value = text
  } else {
    selectedText.value = ''
  }
}

// 打开AI对话
const openAiChat = () => {
  aiDrawerVisible.value = true
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

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN')
}

// 获取状态类型
const getStatusType = (status) => {
  const typeMap = {
    0: 'info',
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
  fetchResourceDetail()

  // 监听全局点击事件，取消文本选择
  document.addEventListener('click', (e) => {
    if (contentRef.value && !contentRef.value.contains(e.target)) {
      selectedText.value = ''
    }
  })
})
</script>

<style scoped>
.resource-detail-container {
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
  padding: 30px 20px;
}

.detail-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h1 {
  margin: 0;
  font-size: 24px;
  color: #303133;
}

.description-section {
  margin: 20px 0;
}

.description-section h3 {
  font-size: 16px;
  margin-bottom: 10px;
  color: #303133;
}

.description {
  font-size: 14px;
  line-height: 1.8;
  color: #606266;
  white-space: pre-wrap;
}

.tags-section {
  margin: 20px 0;
}

.tags-section h3 {
  font-size: 16px;
  margin-bottom: 10px;
  color: #303133;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.action-buttons {
  display: flex;
  gap: 15px;
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #ebeef5;
}

.content-card {
  margin-top: 20px;
}

.content-card h3 {
  margin: 0;
  font-size: 16px;
}

.content-text {
  font-size: 14px;
  line-height: 1.8;
  color: #606266;
  white-space: pre-wrap;
  user-select: text;
  padding: 15px;
  background: #f5f7fa;
  border-radius: 4px;
}

.stats-card {
  position: sticky;
  top: 20px;
}

.stats-card h3 {
  margin: 0;
  font-size: 16px;
}

.stats {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px;
  background: #f5f7fa;
  border-radius: 8px;
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
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

/* 浮动AI按钮 */
.ai-float-button {
  position: fixed;
  bottom: 100px;
  right: 50px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 12px 24px;
  border-radius: 30px;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
  display: flex;
  align-items: center;
  gap: 8px;
  z-index: 1000;
  transition: all 0.3s;
  animation: pulse 2s infinite;
}

.ai-float-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(102, 126, 234, 0.5);
}

@keyframes pulse {
  0%, 100% {
    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
  }
  50% {
    box-shadow: 0 4px 20px rgba(102, 126, 234, 0.6);
  }
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
