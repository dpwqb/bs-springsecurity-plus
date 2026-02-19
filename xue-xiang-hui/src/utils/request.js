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

export default request
