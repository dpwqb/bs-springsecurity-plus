import request from '@/utils/request'

/**
 * 文章列表
 */
export function getArticleList(params) {
  return request({
    url: '/article',
    method: 'get',
    params
  })
}

/**
 * 文章详情
 */
export function getArticleDetail(id) {
  return request({
    url: `/article/${id}`,
    method: 'get'
  })
}

/**
 * 发布文章
 */
export function publishArticle(data) {
  return request({
    url: '/article/publish',
    method: 'post',
    data
  })
}

/**
 * 保存草稿
 */
export function saveDraft(data) {
  return request({
    url: '/article/draft',
    method: 'post',
    data
  })
}

/**
 * 我的文章
 */
export function getMyArticles(params) {
  return request({
    url: '/article/my',
    method: 'get',
    params
  })
}

/**
 * 删除文章
 */
export function deleteArticle(id) {
  return request({
    url: `/article/${id}`,
    method: 'delete'
  })
}

/**
 * 点赞文章
 */
export function likeArticle(id) {
  return request({
    url: `/article/${id}/like`,
    method: 'post'
  })
}

/**
 * 文章分类列表
 */
export function getArticleCategories() {
  return request({
    url: '/article/category',
    method: 'get'
  })
}

/**
 * 上传文章封面图片
 */
export function uploadArticleCover(formData) {
  return request({
    url: '/article/upload-cover',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

/**
 * 获取所有标签
 */
export function getTags() {
  return request({
    url: '/tag',
    method: 'get'
  })
}

/**
 * 获取文章点赞状态
 */
export function getArticleLikeStatus(id) {
  return request({
    url: `/article/${id}/like-status`,
    method: 'get'
  })
}
