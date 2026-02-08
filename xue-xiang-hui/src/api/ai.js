import request from '@/utils/request'

/**
 * AI对话
 */
export function aiChat(data) {
  return request({
    url: '/ai/chat',
    method: 'post',
    data
  })
}

/**
 * 获取对话历史
 */
export function getChatHistory(sessionId) {
  return request({
    url: `/ai/history/${sessionId}`,
    method: 'get'
  })
}

/**
 * 清空对话历史
 */
export function clearChatHistory(sessionId) {
  return request({
    url: `/ai/history/${sessionId}`,
    method: 'delete'
  })
}

/**
 * 获取Token消耗统计
 */
export function getTokenStats() {
  return request({
    url: '/ai/tokens',
    method: 'get'
  })
}
