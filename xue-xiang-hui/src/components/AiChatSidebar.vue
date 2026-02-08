<template>
  <div class="ai-chat-sidebar">
    <!-- 对话历史 -->
    <div class="chat-history" ref="chatHistoryRef">
      <div
        v-for="(message, index) in messages"
        :key="index"
        class="message-wrapper"
        :class="message.role"
      >
        <div class="avatar">
          <el-icon v-if="message.role === 'user'" :size="24"><User /></el-icon>
          <el-icon v-else :size="24" color="#67C23A"><ChatDotRound /></el-icon>
        </div>
        <div class="message-content">
          <div class="message-text" v-html="formatMessage(message.content)"></div>
          <div class="message-time">{{ formatTime(message.time) }}</div>
        </div>
      </div>

      <!-- 空状态 -->
      <el-empty
        v-if="messages.length === 0"
        description="开始与AI对话吧！"
        :image-size="80"
      />

      <!-- 加载状态 -->
      <div v-if="loading" class="loading-wrapper">
        <el-skeleton :rows="3" animated />
      </div>
    </div>

    <!-- 选中的文本 -->
    <div v-if="selectedText" class="selected-text">
      <div class="selected-text-header">
        <el-icon><Select /></el-icon>
        <span>选中的文本</span>
      </div>
      <div class="selected-text-content">{{ selectedText }}</div>
    </div>

    <!-- 输入框 -->
    <div class="chat-input">
      <el-input
        v-model="question"
        type="textarea"
        :rows="3"
        placeholder="输入你的问题..."
        @keydown.enter.ctrl="handleSend"
        :disabled="loading"
      />
      <div class="input-actions">
        <span class="hint">Ctrl + Enter 发送</span>
        <el-button
          type="primary"
          :loading="loading"
          @click="handleSend"
        >
          发送
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, nextTick } from 'vue'
import { User, ChatDotRound, Select } from '@element-plus/icons-vue'
import { aiChat, getChatHistory } from '@/api/ai'

const props = defineProps({
  selectedText: {
    type: String,
    default: ''
  },
  resourceId: {
    type: Number,
    default: null
  }
})

const emit = defineEmits(['close'])

const messages = ref([])
const question = ref('')
const loading = ref(false)
const chatHistoryRef = ref(null)
const sessionId = ref(generateSessionId())

// 生成会话ID
function generateSessionId() {
  return 'session-' + Date.now() + '-' + Math.random().toString(36).substr(2, 9)
}

// 发送消息
const handleSend = async () => {
  if (!question.value.trim() || loading.value) {
    return
  }

  // 添加用户消息
  const userMessage = {
    role: 'user',
    content: question.value,
    time: new Date()
  }
  messages.value.push(userMessage)

  const currentQuestion = question.value
  question.value = ''

  // 滚动到底部
  await scrollToBottom()

  // 调用AI API
  loading.value = true
  try {
    const res = await aiChat({
      sessionId: sessionId.value,
      selectedText: props.selectedText,
      question: currentQuestion,
      context: '' // 可以传入页面上下文
    })

    if (res.code === 200) {
      const answer = res.data?.[0]?.answer || '抱歉，我无法回答这个问题。'
      messages.value.push({
        role: 'assistant',
        content: answer,
        time: new Date()
      })
    } else {
      messages.value.push({
        role: 'assistant',
        content: '抱歉，AI服务暂时不可用，请稍后再试。',
        time: new Date()
      })
    }
  } catch (error) {
    console.error('AI对话失败:', error)
    messages.value.push({
      role: 'assistant',
      content: '抱歉，AI服务暂时不可用，请稍后再试。',
      time: new Date()
    })
  } finally {
    loading.value = false
    await scrollToBottom()
  }
}

// 滚动到底部
const scrollToBottom = async () => {
  await nextTick()
  if (chatHistoryRef.value) {
    chatHistoryRef.value.scrollTop = chatHistoryRef.value.scrollHeight
  }
}

// 格式化消息（支持简单的markdown）
const formatMessage = (content) => {
  if (!content) return ''

  // 转义HTML
  let formatted = content
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')

  // 简单的markdown解析
  // 代码块
  formatted = formatted.replace(/```(\w+)?\n([\s\S]*?)```/g, '<pre><code>$2</code></pre>')
  // 行内代码
  formatted = formatted.replace(/`([^`]+)`/g, '<code>$1</code>')
  // 粗体
  formatted = formatted.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
  // 换行
  formatted = formatted.replace(/\n/g, '<br>')

  return formatted
}

// 格式化时间
const formatTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  return date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
}

// 监听选中文本变化，自动添加到输入框
watch(
  () => props.selectedText,
  (newText) => {
    if (newText && question.value === '') {
      question.value = `请帮我解释这段内容："${newText.substring(0, 50)}${newText.length > 50 ? '...' : ''}"`
    }
  }
)
</script>

<style scoped>
.ai-chat-sidebar {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 60px);
  background: #f5f7fa;
}

.chat-history {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background: white;
}

.message-wrapper {
  display: flex;
  margin-bottom: 20px;
  gap: 12px;
}

.message-wrapper.user {
  flex-direction: row-reverse;
}

.avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.message-content {
  max-width: 70%;
}

.message-text {
  padding: 10px 14px;
  border-radius: 8px;
  font-size: 14px;
  line-height: 1.6;
  word-wrap: break-word;
}

.message-wrapper.user .message-text {
  background: #409EFF;
  color: white;
  border-bottom-right-radius: 2px;
}

.message-wrapper.assistant .message-text {
  background: #f0f0f0;
  color: #303133;
  border-bottom-left-radius: 2px;
}

.message-text :deep(pre) {
  background: #2d2d2d;
  color: #ccc;
  padding: 10px;
  border-radius: 4px;
  overflow-x: auto;
  margin: 8px 0;
}

.message-text :deep(code) {
  background: rgba(0, 0, 0, 0.1);
  padding: 2px 6px;
  border-radius: 3px;
  font-family: 'Courier New', monospace;
}

.message-wrapper.user .message-text :deep(code) {
  background: rgba(255, 255, 255, 0.2);
}

.message-time {
  font-size: 11px;
  color: #909399;
  margin-top: 4px;
}

.message-wrapper.user .message-time {
  text-align: right;
}

.loading-wrapper {
  padding: 10px 14px;
  background: #f0f0f0;
  border-radius: 8px;
  max-width: 70%;
  margin-left: 48px;
}

.selected-text {
  padding: 15px;
  background: #fff9e6;
  border: 1px solid #ffe58f;
  border-radius: 8px;
  margin: 10px;
}

.selected-text-header {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  font-weight: 500;
  color: #e6a23c;
  margin-bottom: 8px;
}

.selected-text-content {
  font-size: 13px;
  color: #606266;
  line-height: 1.6;
  max-height: 100px;
  overflow-y: auto;
  user-select: text;
}

.chat-input {
  padding: 15px;
  background: white;
  border-top: 1px solid #ebeef5;
}

.input-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 10px;
}

.hint {
  font-size: 12px;
  color: #909399;
}
</style>
