<template>
  <div class="article-detail-container">
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

      <!-- 文章内容 -->
      <el-main class="main-content" v-loading="loading">
        <el-card class="article-card">
          <h1 class="article-title">{{ article.title }}</h1>

          <div class="article-meta">
            <span>
              <el-icon><User /></el-icon>
              {{ article.authorName }}
            </span>
            <span>
              <el-icon><Calendar /></el-icon>
              {{ formatDate(article.publishTime) }}
            </span>
            <span>
              <el-icon><View /></el-icon>
              {{ article.viewCount || 0 }} 浏览
            </span>
            <span>
              <el-icon><StarFilled /></el-icon>
              {{ article.likeCount || 0 }} 点赞
            </span>
          </div>

          <el-divider />

          <div class="article-content" v-html="article.content"></div>

          <el-divider />

          <!-- 操作按钮 -->
          <div class="action-buttons">
            <el-button type="primary" @click="handleLike" :loading="likeLoading">
              <el-icon><StarFilled /></el-icon>
              点赞 ({{ article.likeCount || 0 }})
            </el-button>
            <el-button @click="router.back()">
              <el-icon><Back /></el-icon>
              返回列表
            </el-button>
          </div>
        </el-card>

        <!-- AI助手 -->
        <el-card class="ai-card">
          <template #header>
            <div class="ai-header">
              <h3>
                <el-icon><ChatDotRound /></el-icon>
                AI 智能解读
              </h3>
              <p class="ai-hint">选中文章内容，点击"AI 解读"按钮获取智能解答</p>
            </div>
          </template>

          <!-- 文章内容用于选择 -->
          <div
            class="article-text"
            @mouseup="handleTextSelection"
            ref="contentRef"
          >
            {{ stripHtml(article.content) }}
          </div>
        </el-card>
      </el-main>
    </el-container>

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

    <!-- AI对话抽屉 -->
    <el-drawer
      v-model="aiDrawerVisible"
      title="AI 智能助手"
      size="450px"
      direction="rtl"
    >
      <AiChatSidebar
        :selected-text="selectedText"
        :article-id="articleId"
        @close="aiDrawerVisible = false"
      />
    </el-drawer>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import {
  User, Calendar, View, StarFilled, ChatDotRound, Back
} from '@element-plus/icons-vue'
import { getArticleDetail, likeArticle } from '@/api/article'
import AiChatSidebar from '@/components/AiChatSidebar.vue'

const router = useRouter()
const route = useRoute()
const activeMenu = ref('/articles')

const loading = ref(false)
const likeLoading = ref(false)
const article = ref({})
const selectedText = ref('')
const aiDrawerVisible = ref(false)
const contentRef = ref(null)

const articleId = computed(() => parseInt(route.params.id))

// 获取文章详情
const fetchArticleDetail = async () => {
  loading.value = true
  try {
    const res = await getArticleDetail(articleId.value)
    if (res.code === 0) {
      article.value = res.data?.[0] || {}
    }
  } catch (error) {
    console.error('获取文章详情失败:', error)
  } finally {
    loading.value = false
  }
}

// 点赞
const handleLike = async () => {
  likeLoading.value = true
  try {
    const res = await likeArticle(articleId.value)
    if (res.code === 0) {
      article.value.likeCount = (article.value.likeCount || 0) + 1
    }
  } catch (error) {
    console.error('点赞失败:', error)
  } finally {
    likeLoading.value = false
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

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN')
}

// 去除HTML标签
const stripHtml = (html) => {
  if (!html) return ''
  return html.replace(/<[^>]+>/g, '')
}

onMounted(() => {
  fetchArticleDetail()

  // 监听全局点击事件
  document.addEventListener('click', (e) => {
    if (contentRef.value && !contentRef.value.contains(e.target)) {
      selectedText.value = ''
    }
  })
})
</script>

<style scoped>
.article-detail-container {
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
  max-width: 1000px;
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
  max-width: 1000px;
  margin: 0 auto;
  padding: 30px 20px;
}

.article-card {
  margin-bottom: 20px;
}

.article-title {
  font-size: 28px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 20px 0;
}

.article-meta {
  display: flex;
  gap: 20px;
  font-size: 14px;
  color: #909399;
}

.article-meta span {
  display: flex;
  align-items: center;
  gap: 6px;
}

.article-content {
  font-size: 16px;
  line-height: 1.8;
  color: #303133;
}

.article-content :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
  margin: 20px 0;
}

.article-content :deep(pre) {
  background: #2d2d2d;
  color: #ccc;
  padding: 15px;
  border-radius: 8px;
  overflow-x: auto;
  margin: 15px 0;
}

.article-content :deep(code) {
  background: #f0f0f0;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
}

.action-buttons {
  display: flex;
  gap: 15px;
  justify-content: center;
}

.ai-card {
  margin-top: 20px;
}

.ai-header h3 {
  margin: 0;
  font-size: 18px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.ai-hint {
  margin: 8px 0 0 0;
  font-size: 13px;
  color: #909399;
}

.article-text {
  font-size: 14px;
  line-height: 1.8;
  color: #606266;
  padding: 15px;
  background: #f5f7fa;
  border-radius: 4px;
  max-height: 300px;
  overflow-y: auto;
  user-select: text;
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
