import request from '@/utils/request'

/**
 * 资源列表
 */
export function getResourceList(params) {
  return request({
    url: '/resource',
    method: 'get',
    params
  })
}

/**
 * 资源详情
 */
export function getResourceDetail(id) {
  return request({
    url: `/resource/${id}`,
    method: 'get'
  })
}

/**
 * 上传资源
 */
export function uploadResource(data, onProgress) {
  return request({
    url: '/resource/upload',
    method: 'post',
    data,
    onUploadProgress: onProgress ? (progressEvent) => {
      if (progressEvent.total > 0) {
        const percent = Math.round((progressEvent.loaded * 100) / progressEvent.total)
        onProgress(percent)
      }
    } : undefined
  })
}

/**
 * 下载资源
 */
export function downloadResource(id) {
  return `/api/resource/download/${id}`
}

/**
 * 我的资源
 */
export function getMyResources(params) {
  return request({
    url: '/resource/my',
    method: 'get',
    params
  })
}

/**
 * 删除资源
 */
export function deleteResource(id) {
  return request({
    url: `/resource/${id}`,
    method: 'delete'
  })
}

/**
 * 收藏资源
 */
export function addFavorite(resourceId) {
  return request({
    url: `/favorite/${resourceId}`,
    method: 'post'
  })
}

/**
 * 取消收藏
 */
export function removeFavorite(resourceId) {
  return request({
    url: `/favorite/${resourceId}`,
    method: 'delete'
  })
}

/**
 * 切换收藏状态
 */
export function toggleFavorite(resourceId) {
  return request({
    url: `/favorite/toggle/${resourceId}`,
    method: 'post'
  })
}

/**
 * 检查是否已收藏
 */
export function checkFavorited(resourceId) {
  return request({
    url: `/favorite/check/${resourceId}`,
    method: 'get'
  })
}

/**
 * 我的收藏列表
 */
export function getMyFavorites(params) {
  return request({
    url: '/favorite/my',
    method: 'get',
    params
  })
}

/**
 * 资源分类列表
 */
export function getResourceCategories() {
  return request({
    url: '/resource/category',
    method: 'get'
  })
}

/**
 * 热门分类列表（带资源数量）
 */
export function getHotCategories() {
  return request({
    url: '/resource/category/hot',
    method: 'get'
  })
}

/**
 * 标签列表
 */
export function getTags() {
  return request({
    url: '/tag',
    method: 'get'
  })
}

/**
 * 热门标签
 */
export function getHotTags(limit = 20) {
  return request({
    url: '/tag/hot',
    method: 'get',
    params: { limit }
  })
}

/**
 * 我的下载记录
 */
export function getMyDownloads(params) {
  return request({
    url: '/download/my',
    method: 'get',
    params
  })
}

/**
 * 下载统计
 */
export function getDownloadStats() {
  return request({
    url: '/download/count',
    method: 'get'
  })
}

/**
 * 更新资源状态
 */
export function updateResourceStatus(resourceId, status) {
  return request({
    url: `/resource/${resourceId}/status`,
    method: 'put',
    params: { status }
  })
}

/**
 * 平台统计数据（公开）
 */
export function getPlatformStatistics() {
  return request({
    url: '/resource/statistics',
    method: 'get'
  })
}
