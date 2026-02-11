/**
 * 用户状态管理
 * 处理用户登录、登出、用户信息等
 */
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useUserStore = defineStore('user', () => {
  // 状态
  const userInfo = ref(null)
  const token = ref(localStorage.getItem('token') || '')
  const permissions = ref([])

  // 计算属性
  const isLoggedIn = computed(() => !!token.value)
  const userName = computed(() => userInfo.value?.nickName || userInfo.value?.userName || '游客')
  const userId = computed(() => userInfo.value?.id || null)
  const userAvatar = computed(() => userInfo.value?.avatar || '')

  /**
   * 设置Token
   * @param {string} newToken - JWT Token
   */
  function setToken(newToken) {
    token.value = newToken
    if (newToken) {
      localStorage.setItem('token', newToken)
    } else {
      localStorage.removeItem('token')
    }
  }

  /**
   * 设置用户信息
   * @param {Object} info - 用户信息
   */
  function setUserInfo(info) {
    userInfo.value = info
    // 持久化用户信息到localStorage
    if (info) {
      localStorage.setItem('userInfo', JSON.stringify(info))
    } else {
      localStorage.removeItem('userInfo')
    }
  }

  /**
   * 设置权限列表
   * @param {Array} perms - 权限列表
   */
  function setPermissions(perms) {
    permissions.value = perms || []
  }

  /**
   * 检查是否有指定权限
   * @param {string} permission - 权限标识
   * @returns {boolean}
   */
  function hasPermission(permission) {
    if (!permissions.value || permissions.value.length === 0) {
      return false
    }
    return permissions.value.includes(permission)
  }

  /**
   * 检查是否有任一权限
   * @param {Array} permissionList - 权限列表
   * @returns {boolean}
   */
  function hasAnyPermission(permissionList) {
    if (!permissionList || permissionList.length === 0) {
      return true
    }
    return permissionList.some(p => hasPermission(p))
  }

  /**
   * 登录
   * @param {Object} credentials - 登录凭证 {username, password, captcha}
   * @returns {Promise}
   */
  async function login(credentials) {
    try {
      // Spring Security使用 /login 端点，需要FormData格式
      const formData = new FormData()
      formData.append('username', credentials.username)
      formData.append('password', credentials.password)
      if (credentials.captcha) {
        formData.append('captcha', credentials.captcha)
      }

      const response = await fetch('/login', {
        method: 'POST',
        body: formData
        // 不设置Content-Type，让浏览器自动设置multipart/form-data边界
      })

      const data = await response.json()

      if (data.code === 200) {
        // 后端返回格式: {code: 200, jwt: "token", data: [userDetails], message: "登录成功"}
        setToken(data.jwt)
        // data是数组，取第一个元素
        const userDetails = Array.isArray(data.data) ? data.data[0] : data.data
        setUserInfo(userDetails)

        // 提取权限信息
        if (userDetails && userDetails.permissions) {
          setPermissions(userDetails.permissions)
        }

        return { success: true, data: userDetails }
      } else {
        return { success: false, message: data.message || '登录失败' }
      }
    } catch (error) {
      console.error('登录错误:', error)
      return { success: false, message: error.message || '登录失败，请稍后重试' }
    }
  }

  /**
   * 登出
   * 由于使用JWT无状态认证，登出主要是清除本地token
   */
  async function logout() {
    try {
      // 可选：调用后端登出接口通知服务器
      // await fetch('/logout', { method: 'POST' })
    } catch (error) {
      console.error('登出错误:', error)
    } finally {
      // 清除本地状态（这是主要的登出逻辑）
      setToken('')
      setUserInfo(null)
      setPermissions([])
    }
  }

  /**
   * 获取用户信息
   * 由于使用JWT，用户信息已经在登录时返回并存储
   * 这个方法主要用于从本地存储恢复用户信息
   * @returns {Promise}
   */
  async function fetchUserInfo() {
    // 如果已有用户信息，直接返回
    if (userInfo.value) {
      return { success: true, data: userInfo.value }
    }

    // 尝试从localStorage恢复
    const savedUserInfo = localStorage.getItem('userInfo')
    if (savedUserInfo) {
      try {
        const parsed = JSON.parse(savedUserInfo)
        setUserInfo(parsed)
        return { success: true, data: parsed }
      } catch (error) {
        console.error('解析用户信息失败:', error)
        return { success: false, message: '用户信息解析失败' }
      }
    }

    return { success: false, message: '未找到用户信息' }
  }

  /**
   * 从localStorage恢复用户信息
   */
  function restoreUser() {
    const savedToken = localStorage.getItem('token')
    const savedUserInfo = localStorage.getItem('userInfo')

    if (savedToken) {
      token.value = savedToken
    }

    if (savedUserInfo) {
      try {
        userInfo.value = JSON.parse(savedUserInfo)
      } catch (error) {
        console.error('解析用户信息失败:', error)
        localStorage.removeItem('userInfo')
      }
    }
  }

  // 初始化时恢复用户信息
  restoreUser()

  return {
    // 状态
    userInfo,
    token,
    permissions,

    // 计算属性
    isLoggedIn,
    userName,
    userId,
    userAvatar,

    // 方法
    setToken,
    setUserInfo,
    setPermissions,
    hasPermission,
    hasAnyPermission,
    login,
    logout,
    fetchUserInfo,
    restoreUser
  }
})
