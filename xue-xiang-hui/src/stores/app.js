/**
 * 应用全局状态管理
 * 处理全局加载状态、视图模式、侧边栏等
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useAppStore = defineStore('app', () => {
  // 全局加载状态
  const loading = ref(false)

  // 视图模式：grid（网格）、list（列表）
  const viewMode = ref(localStorage.getItem('viewMode') || 'grid')

  // 侧边栏状态
  const sidebarCollapsed = ref(false)

  // 移动端菜单状态
  const mobileMenuOpen = ref(false)

  // 当前页面标题
  const pageTitle = ref('学享汇 - 资源共享平台')

  // 全局消息通知数
  const notificationCount = ref(0)

  /**
   * 设置全局加载状态
   * @param {boolean} status - 加载状态
   */
  function setLoading(status) {
    loading.value = status
  }

  /**
   * 设置视图模式
   * @param {string} mode - 视图模式 'grid' | 'list'
   */
  function setViewMode(mode) {
    if (['grid', 'list'].includes(mode)) {
      viewMode.value = mode
      localStorage.setItem('viewMode', mode)
    }
  }

  /**
   * 切换视图模式
   */
  function toggleViewMode() {
    setViewMode(viewMode.value === 'grid' ? 'list' : 'grid')
  }

  /**
   * 设置侧边栏折叠状态
   * @param {boolean} collapsed - 是否折叠
   */
  function setSidebarCollapsed(collapsed) {
    sidebarCollapsed.value = collapsed
  }

  /**
   * 切换侧边栏
   */
  function toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value
  }

  /**
   * 设置移动端菜单状态
   * @param {boolean} open - 是否打开
   */
  function setMobileMenuOpen(open) {
    mobileMenuOpen.value = open
  }

  /**
   * 切换移动端菜单
   */
  function toggleMobileMenu() {
    mobileMenuOpen.value = !mobileMenuOpen.value
  }

  /**
   * 关闭移动端菜单
   */
  function closeMobileMenu() {
    mobileMenuOpen.value = false
  }

  /**
   * 设置页面标题
   * @param {string} title - 页面标题
   */
  function setPageTitle(title) {
    pageTitle.value = title
    document.title = title
  }

  /**
   * 设置通知数量
   * @param {number} count - 通知数量
   */
  function setNotificationCount(count) {
    notificationCount.value = count
  }

  /**
   * 增加通知数量
   * @param {number} num - 增加数量
   */
  function increaseNotificationCount(num = 1) {
    notificationCount.value += num
  }

  /**
   * 减少通知数量
   * @param {number} num - 减少数量
   */
  function decreaseNotificationCount(num = 1) {
    notificationCount.value = Math.max(0, notificationCount.value - num)
  }

  /**
   * 清空通知
   */
  function clearNotifications() {
    notificationCount.value = 0
  }

  /**
   * 恢复设置
   */
  function restoreSettings() {
    const savedViewMode = localStorage.getItem('viewMode')
    if (savedViewMode) {
      viewMode.value = savedViewMode
    }
  }

  return {
    // 状态
    loading,
    viewMode,
    sidebarCollapsed,
    mobileMenuOpen,
    pageTitle,
    notificationCount,

    // 方法
    setLoading,
    setViewMode,
    toggleViewMode,
    setSidebarCollapsed,
    toggleSidebar,
    setMobileMenuOpen,
    toggleMobileMenu,
    closeMobileMenu,
    setPageTitle,
    setNotificationCount,
    increaseNotificationCount,
    decreaseNotificationCount,
    clearNotifications,
    restoreSettings
  }
})
