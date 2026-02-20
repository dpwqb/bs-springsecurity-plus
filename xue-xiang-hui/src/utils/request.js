import axios from 'axios'
import { ElMessage } from 'element-plus'

// 创建axios实例
const request = axios.create({
  baseURL: '/api',
  timeout: 90000
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    // 从localStorage获取token
    const token = localStorage.getItem('token')
    if (token) {
      config.headers['Authorization'] = 'Bearer ' + token
    }

    // 清洗参数，移除 NaN、undefined、null 等无效值
    if (config.params) {
      Object.keys(config.params).forEach(key => {
        const value = config.params[key]
        if (value === undefined ||
            value === null ||
            (typeof value === 'number' && isNaN(value)) ||
            (typeof value === 'string' && value === 'NaN')) {
          delete config.params[key]
        }
      })
    }

    // 同样处理 data 中的参数（用于 POST/PUT 请求）
    // 注意：FormData 对象不应被遍历和修改，否则会破坏 multipart 数据
    if (config.data && typeof config.data === 'object' && !(config.data instanceof FormData)) {
      Object.keys(config.data).forEach(key => {
        const value = config.data[key]
        if (value === undefined ||
            value === null ||
            (typeof value === 'number' && isNaN(value)) ||
            (typeof value === 'string' && value === 'NaN')) {
          delete config.data[key]
        }
      })
    }

    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  response => {
    const res = response.data

    // 处理 blob 响应（文件下载）
    if (response.config.responseType === 'blob') {
      // 检查 blob 响应是否为错误（后端可能返回 JSON 错误作为 blob）
      return new Promise((resolve, reject) => {
        const reader = new FileReader()
        reader.onload = () => {
          try {
            const result = JSON.parse(reader.result)
            // 如果能解析为 JSON 且包含错误码，说明是错误响应
            if (result.code !== 0) {
              ElMessage.error(result.message || '请求失败')

              // 401: 未登录
              if (result.code === 401) {
                localStorage.removeItem('token')
                window.location.href = '/login'
              }

              reject(new Error(result.message || '请求失败'))
            } else {
              resolve(response)
            }
          } catch {
            // 无法解析为 JSON，说明是正常的文件 blob
            resolve(response)
          }
        }
        reader.onerror = () => resolve(response)
        reader.readAsText(res)
      })
    }

    // 如果返回的状态码不是0，判断为错误
    if (res.code !== 0) {
      ElMessage.error(res.message || '请求失败')

      // 401: 未登录
      if (res.code === 401) {
        localStorage.removeItem('token')
        window.location.href = '/login'
      }

      return Promise.reject(new Error(res.message || '请求失败'))
    }

    return res
  },
  error => {
    console.error('响应错误:', error)
    ElMessage.error(error.message || '网络错误')
    return Promise.reject(error)
  }
)

/**
 * 下载文件（带认证）
 * @param {string} url - 下载地址
 * @param {string} filename - 文件名（可选）
 * @returns {Promise}
 */
export function downloadFile(url, filename) {
  return request({
    url,
    method: 'get',
    responseType: 'blob'
  }).then(response => {
    const blob = response.data

    // 从响应头获取文件名（如果后端设置了）
    const contentDisposition = response.headers['content-disposition']
    if (contentDisposition && !filename) {
      const match = contentDisposition.match(/filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/)
      if (match && match[1]) {
        filename = match[1].replace(/['"]/g, '')
        // 解码 URL 编码的文件名
        try {
          filename = decodeURIComponent(filename)
        } catch {
          // 使用原始文件名
        }
      }
    }

    // 创建下载链接
    const downloadUrl = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = downloadUrl
    link.download = filename || 'download'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(downloadUrl)
  }).catch(error => {
    console.error('下载失败:', error)
    // 如果是 401 错误，已经在响应拦截器中处理了
    // 这里只处理其他错误
    if (error.message && !error.message.includes('401')) {
      throw error
    }
  })
}

export default request
