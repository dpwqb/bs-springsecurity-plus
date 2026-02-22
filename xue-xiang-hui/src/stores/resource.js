/**
 * 资源状态管理
 * 处理资源分类、标签、搜索历史等
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getResourceCategories, getTags, getHotTags } from '@/api/resource'

export const useResourceStore = defineStore('resource', () => {
  // 状态
  const categories = ref([])
  const tags = ref([])
  const hotTags = ref([])
  const searchHistory = ref([])
  const loading = ref(false)

  /**
   * 获取资源分类列表
   * @param {boolean} force - 是否强制刷新
   * @returns {Promise}
   */
  async function fetchCategories(force = false) {
    // 如果已有数据且不强制刷新，直接返回
    if (categories.value.length > 0 && !force) {
      return { success: true, data: categories.value }
    }

    loading.value = true
    try {
      const res = await getResourceCategories()
      if (res.code === 0) {
        categories.value = res.data || []
        return { success: true, data: categories.value }
      }
      return { success: false, message: res.message }
    } catch (error) {
      console.error('获取分类失败:', error)
      return { success: false, message: error.message }
    } finally {
      loading.value = false
    }
  }

  /**
   * 获取标签列表
   * @param {boolean} force - 是否强制刷新
   * @returns {Promise}
   */
  async function fetchTags(force = false) {
    if (tags.value.length > 0 && !force) {
      return { success: true, data: tags.value }
    }

    loading.value = true
    try {
      const res = await getTags()
      if (res.code === 0) {
        tags.value = res.data || []
        return { success: true, data: tags.value }
      }
      return { success: false, message: res.message }
    } catch (error) {
      console.error('获取标签失败:', error)
      return { success: false, message: error.message }
    } finally {
      loading.value = false
    }
  }

  /**
   * 获取热门标签
   * @param {number} limit - 限制数量
   * @param {boolean} force - 是否强制刷新
   * @returns {Promise}
   */
  async function fetchHotTags(limit = 20, force = false) {
    if (hotTags.value.length > 0 && !force) {
      return { success: true, data: hotTags.value }
    }

    loading.value = true
    try {
      const res = await getHotTags(limit)
      if (res.code === 0) {
        hotTags.value = res.data || []
        return { success: true, data: hotTags.value }
      }
      return { success: false, message: res.message }
    } catch (error) {
      console.error('获取热门标签失败:', error)
      return { success: false, message: error.message }
    } finally {
      loading.value = false
    }
  }

  /**
   * 根据ID获取分类
   * @param {number} categoryId - 分类ID
   * @returns {Object|null}
   */
  function getCategoryById(categoryId) {
    return categories.value.find(c => c.id === categoryId) || null
  }

  /**
   * 根据ID获取标签
   * @param {number} tagId - 标签ID
   * @returns {Object|null}
   */
  function getTagById(tagId) {
    return tags.value.find(t => t.id === tagId) || null
  }

  /**
   * 添加搜索历史
   * @param {string} keyword - 搜索关键词
   */
  function addSearchHistory(keyword) {
    if (!keyword || keyword.trim() === '') {
      return
    }

    keyword = keyword.trim()

    // 移除已存在的相同关键词
    const index = searchHistory.value.indexOf(keyword)
    if (index > -1) {
      searchHistory.value.splice(index, 1)
    }

    // 添加到开头
    searchHistory.value.unshift(keyword)

    // 限制历史记录数量（最多保存20条）
    if (searchHistory.value.length > 20) {
      searchHistory.value = searchHistory.value.slice(0, 20)
    }

    // 持久化到localStorage
    localStorage.setItem('searchHistory', JSON.stringify(searchHistory.value))
  }

  /**
   * 清空搜索历史
   */
  function clearSearchHistory() {
    searchHistory.value = []
    localStorage.removeItem('searchHistory')
  }

  /**
   * 删除指定的搜索历史记录
   * @param {string} keyword - 搜索关键词
   */
  function removeSearchHistory(keyword) {
    const index = searchHistory.value.indexOf(keyword)
    if (index > -1) {
      searchHistory.value.splice(index, 1)
      localStorage.setItem('searchHistory', JSON.stringify(searchHistory.value))
    }
  }

  /**
   * 从localStorage恢复搜索历史
   */
  function restoreSearchHistory() {
    const saved = localStorage.getItem('searchHistory')
    if (saved) {
      try {
        searchHistory.value = JSON.parse(saved)
      } catch (error) {
        console.error('解析搜索历史失败:', error)
        searchHistory.value = []
      }
    }
  }

  /**
   * 初始化资源数据
   */
  async function init() {
    restoreSearchHistory()
    await Promise.all([
      fetchCategories(),
      fetchHotTags()
    ])
  }

  // 初始化时恢复搜索历史
  restoreSearchHistory()

  return {
    // 状态
    categories,
    tags,
    hotTags,
    searchHistory,
    loading,

    // 方法
    fetchCategories,
    fetchTags,
    fetchHotTags,
    getCategoryById,
    getTagById,
    addSearchHistory,
    clearSearchHistory,
    removeSearchHistory,
    restoreSearchHistory,
    init
  }
})
