<template>
  <div class="article-detail-page">
    <AppHeader />

    <!-- 文章内容 -->
    <div class="page-container" v-loading="loading">
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

          <div
            class="article-content"
            v-html="article.content"
            @mouseup="handleTextSelection"
          ></div>

          <!-- 标签展示 -->
          <div class="article-tags" v-if="article.tags && article.tags.length > 0">
            <el-tag
              v-for="tag in article.tags"
              :key="tag.tagId"
              type="info"
              size="small"
              style="margin-right: 8px; margin-bottom: 8px;"
            >
              {{ tag.tagName }}
            </el-tag>
          </div>

          <el-divider />

          <!-- 操作按钮 -->
          <div class="action-buttons">
            <el-button
              :type="isLiked ? 'primary' : 'default'"
              @click="handleLike"
              :loading="likeLoading"
            >
              <el-icon><StarFilled /></el-icon>
              {{ isLiked ? '已点赞' : '点赞' }} ({{ article.likeCount || 0 }})
            </el-button>
            <el-button @click="router.back()">
              <el-icon><Back /></el-icon>
              返回列表
            </el-button>
          </div>
        </el-card>

        <!-- AI助手提示卡片 -->
        <el-card class="ai-card">
          <template #header>
            <div class="ai-header">
              <h3>
                <el-icon><ChatDotRound /></el-icon>
                AI 智能解读
              </h3>
              <p class="ai-hint">💡 选中上方文章中的任意文本，即可唤起 AI 智能解读功能</p>
            </div>
          </template>
        </el-card>
    </div>

    <!-- 浮动AI按钮 -->
    <transition name="fade">
      <div
        v-if="selectedText"
        class="ai-float-button"
        @click.stop="openAiChat"
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
        :force-update="aiForceUpdate"
        @close="aiDrawerVisible = false"
      />
    </el-drawer>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import {
  User, Calendar, View, StarFilled, ChatDotRound, Back
} from '@element-plus/icons-vue'
import { getArticleDetail, likeArticle, getArticleLikeStatus } from '@/api/article'
import AiChatSidebar from '@/components/AiChatSidebar.vue'
import AppHeader from '@/components/AppHeader.vue'
import { ElMessage } from 'element-plus'

const router = useRouter()
const route = useRoute()

const loading = ref(false)
const likeLoading = ref(false)
const article = ref({})
const selectedText = ref('')
const aiDrawerVisible = ref(false)
const aiForceUpdate = ref(false)
const isLiked = ref(false)

const articleId = computed(() => {
  const id = Number(route.params.id)
  return isNaN(id) ? null : id
})

// 监听路由参数变化，验证 ID 有效性
watch(() => route.params.id, (newId) => {
  const id = Number(newId)
  // 只在 ID 真正存在且无效时才报错
  if (newId !== undefined && (isNaN(id) || id <= 0)) {
    ElMessage.error('文章ID无效')
    router.push('/articles')
  }
})

// 获取文章详情
const fetchArticleDetail = async () => {
  if (!articleId.value) {
    return
  }

  loading.value = true
  try {
    const res = await getArticleDetail(articleId.value)
    if (res.code === 0) {
      // 兼容处理：后端返回的数据结构是 [{ article: {...}, tags: [] }]
      if (Array.isArray(res.data)) {
        article.value = res.data[0].article || {}
      } else {
        article.value = res.data || {}
      }
      console.log('文章详情数据:', article.value)
    } else {
      ElMessage.error(res.message || '获取文章详情失败')
    }
  } catch (error) {
    console.error('获取文章详情失败:', error)
    ElMessage.error('获取文章详情失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 获取点赞状态
const fetchLikeStatus = async () => {
  try {
    const res = await getArticleLikeStatus(articleId.value)
    if (res.code === 0) {
      isLiked.value = res.data[0].isLiked
    }
  } catch (error) {
    console.error('获取点赞状态失败:', error)
  }
}

// 点赞
const handleLike = async () => {
  likeLoading.value = true
  try {
    const res = await likeArticle(articleId.value)
    if (res.code === 0) {
      isLiked.value = res.data[0].isLiked
      // 根据操作类型更新计数
      if (isLiked.value) {
        article.value.likeCount = (article.value.likeCount || 0) + 1
      } else {
        article.value.likeCount = Math.max(0, (article.value.likeCount || 0) - 1)
      }
    }
  } catch (error) {
    console.error('点赞操作失败:', error)
    ElMessage.error('操作失败')
  } finally {
    likeLoading.value = false
  }
}

// 处理文本选择
const handleTextSelection = () => {
  const selection = window.getSelection()
  const text = selection.toString().trim()

  if (text.length > 0) {
    const range = selection.getRangeAt(0)
    const container = range.commonAncestorContainer

    // 检查选中的文本是否在文章内容区域内
    const articleContent = document.querySelector('.article-content')
    if (articleContent && articleContent.contains(container)) {
      // 确保选中的是有效文本内容（至少2个字符）
      const cleanText = text.replace(/\s+/g, ' ').trim()
      if (cleanText.length >= 2) {
        selectedText.value = cleanText
      } else {
        selectedText.value = ''
      }
    } else {
      selectedText.value = ''
    }
  } else {
    selectedText.value = ''
  }
}

// 打开AI对话
const openAiChat = async () => {
  // 先打开抽屉
  aiDrawerVisible.value = true
  // 等待组件挂载
  await nextTick()
  // 再切换强制更新标志，确保输入框能正确填充选中文本
  aiForceUpdate.value = !aiForceUpdate.value
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN')
}

onMounted(() => {
  fetchArticleDetail()
  fetchLikeStatus()

  // 监听全局点击事件
  document.addEventListener('click', (e) => {
    // 点击文章内容区域外部时，清除选中文本
    const articleContent = document.querySelector('.article-content')
    const aiButton = document.querySelector('.ai-float-button')
    if (articleContent && !articleContent.contains(e.target) &&
        (!aiButton || !aiButton.contains(e.target))) {
      selectedText.value = ''
    }
  })
})
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.article-detail-page {
  min-height: 100vh;
  background-color: $bg-secondary;
  padding-top: 64px; // AppHeader 高度
}

.page-container {
  max-width: $container-xxl;
  margin: 0 auto;
  padding: $spacing-xxl $spacing-lg;

  @include respond-to('sm') {
    padding: $spacing-xl $spacing-md;
  }
}

.article-card {
  margin-bottom: $spacing-xl;
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
  user-select: text; /* 确保文本可选择 */
  cursor: text; /* 文本选择光标 */
}

/* 选中文本的高亮样式 */
.article-content ::selection {
  background: rgba(64, 158, 255, 0.2);
  color: #303133;
}

.article-content ::-moz-selection {
  background: rgba(64, 158, 255, 0.2);
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

.article-tags {
  margin: 20px 0;
  padding: 15px;
  background: #f5f7fa;
  border-radius: 8px;
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
