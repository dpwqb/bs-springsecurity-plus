<template>
  <div class="upload-container">
    <el-container>
      <!-- 顶部导航 -->
      <el-header class="header">
        <div class="header-content">
          <div class="logo" @click="router.push('/')">
            <h2>📚 学享汇</h2>
          </div>
          <el-menu
            :default-active="activeMenu"
            class="menu"
            mode="horizontal"
            @select="handleMenuSelect"
          >
            <el-menu-item index="/">首页</el-menu-item>
            <el-menu-item index="/resources">资源库</el-menu-item>
            <el-menu-item index="/articles">文章广场</el-menu-item>
            <el-menu-item index="/upload">上传资源</el-menu-item>
          </el-menu>
        </div>
      </el-header>

      <!-- 上传内容 -->
      <el-main class="main-content">
        <el-card class="upload-card">
          <template #header>
            <h2>上传资源</h2>
          </template>

          <el-form
            ref="formRef"
            :model="formData"
            :rules="formRules"
            label-width="100px"
            v-loading="uploading"
            :element-loading-text="loadingText"
          >
            <!-- 文件上传 -->
            <el-form-item label="选择文件" required>
              <el-upload
                ref="uploadRef"
                class="upload-demo"
                drag
                :action="uploadAction"
                :auto-upload="false"
                :on-change="handleFileChange"
                :before-upload="beforeUpload"
                :limit="1"
                :on-exceed="handleExceed"
                :file-list="fileList"
              >
                <el-icon class="el-icon--upload"><UploadFilled /></el-icon>
                <div class="el-upload__text">
                  将文件拖到此处，或<em>点击上传</em>
                </div>
                <template #tip>
                  <div class="el-upload__tip">
                    支持 PDF、Word、PPT、TXT、ZIP 等格式，文件大小不超过 50MB
                  </div>
                </template>
              </el-upload>
            </el-form-item>

            <!-- 文件信息预览 -->
            <div v-if="selectedFile" class="file-info">
              <el-descriptions :column="2" border>
                <el-descriptions-item label="文件名">
                  {{ selectedFile.name }}
                </el-descriptions-item>
                <el-descriptions-item label="文件大小">
                  {{ formatFileSize(selectedFile.size) }}
                </el-descriptions-item>
                <el-descriptions-item label="文件类型">
                  <el-tag>{{ getFileType(selectedFile.name) }}</el-tag>
                </el-descriptions-item>
              </el-descriptions>
            </div>

            <!-- 资源标题 -->
            <el-form-item label="资源标题" prop="title">
              <el-input
                v-model="formData.title"
                placeholder="请输入资源标题"
                maxlength="100"
                show-word-limit
              />
            </el-form-item>

            <!-- 资源分类 -->
            <el-form-item label="资源分类" prop="categoryId">
              <el-select
                v-model="formData.categoryId"
                placeholder="请选择分类"
                style="width: 100%"
              >
                <el-option
                  v-for="category in categories"
                  :key="category.categoryId"
                  :label="category.categoryName"
                  :value="category.categoryId"
                />
              </el-select>
            </el-form-item>

            <!-- 资源描述 -->
            <el-form-item label="资源描述" prop="description">
              <el-input
                v-model="formData.description"
                type="textarea"
                :rows="5"
                placeholder="请输入资源描述，介绍资源的主要内容和特点"
                maxlength="500"
                show-word-limit
              />
            </el-form-item>

            <!-- 资源标签 -->
            <el-form-item label="资源标签">
              <el-select
                v-model="formData.tagIds"
                multiple
                filterable
                allow-create
                placeholder="请选择或创建标签"
                style="width: 100%"
              >
                <el-option
                  v-for="tag in tags"
                  :key="tag.tagId"
                  :label="tag.tagName"
                  :value="tag.tagId"
                />
              </el-select>
            </el-form-item>

            <!-- 上传进度 -->
            <div v-if="uploadProgress > 0 && uploadProgress < 100" class="progress-wrapper">
              <el-progress :percentage="uploadProgress" :status="uploadStatus" />
            </div>

            <!-- 操作按钮 -->
            <el-form-item>
              <el-button type="primary" size="large" @click="handleSubmit" :loading="uploading">
                <el-icon><Upload /></el-icon>
                立即上传
              </el-button>
              <el-button size="large" @click="handleReset">
                <el-icon><RefreshLeft /></el-icon>
                重置
              </el-button>
              <el-button size="large" @click="router.back()">
                <el-icon><Back /></el-icon>
                返回
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { UploadFilled, Upload, RefreshLeft, Back } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { uploadResource, getResourceCategories, getTags } from '@/api/resource'

const router = useRouter()
const activeMenu = ref('/upload')

const formRef = ref(null)
const uploadRef = ref(null)
const uploading = ref(false)
const uploadProgress = ref(0)
const uploadStatus = ref('')
const loadingText = ref('上传中...')
const fileList = ref([])
const selectedFile = ref(null)
const categories = ref([])
const tags = ref([])

const uploadAction = ref('/api/resource/upload')

const formData = ref({
  title: '',
  categoryId: null,
  description: '',
  tagIds: []
})

const formRules = {
  title: [
    { required: true, message: '请输入资源标题', trigger: 'blur' },
    { min: 2, max: 100, message: '标题长度在 2 到 100 个字符', trigger: 'blur' }
  ],
  categoryId: [
    { required: true, message: '请选择资源分类', trigger: 'change' }
  ],
  description: [
    { required: true, message: '请输入资源描述', trigger: 'blur' },
    { min: 10, max: 500, message: '描述长度在 10 到 500 个字符', trigger: 'blur' }
  ]
}

// 获取分类列表
const fetchCategories = async () => {
  try {
    const res = await getResourceCategories()
    if (res.code === 0) {
      categories.value = res.data || []
    }
  } catch (error) {
    console.error('获取分类失败:', error)
  }
}

// 获取标签列表
const fetchTags = async () => {
  try {
    const res = await getTags()
    if (res.code === 0) {
      tags.value = res.data || []
    }
  } catch (error) {
    console.error('获取标签失败:', error)
  }
}

// 文件选择变化
const handleFileChange = (file) => {
  selectedFile.value = file.raw
  // 自动填充标题（使用文件名，去掉扩展名）
  if (!formData.value.title) {
    const fileName = file.name
    const lastDotIndex = fileName.lastIndexOf('.')
    if (lastDotIndex > 0) {
      formData.value.title = fileName.substring(0, lastDotIndex)
    } else {
      formData.value.title = fileName
    }
  }
}

// 上传前验证
const beforeUpload = (file) => {
  const allowedTypes = ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'txt', 'zip', '7z', 'rar']
  const ext = file.name.split('.').pop().toLowerCase()

  if (!allowedTypes.includes(ext)) {
    ElMessage.error('不支持的文件类型，请上传 PDF、Word、PPT、TXT 或压缩文件')
    return false
  }

  const maxSize = 50 * 1024 * 1024 // 50MB
  if (file.size > maxSize) {
    ElMessage.error('文件大小不能超过 50MB')
    return false
  }

  return true
}

// 文件超出限制
const handleExceed = () => {
  ElMessage.warning('只能上传一个文件，请先删除已有文件')
}

// 格式化文件大小
const formatFileSize = (bytes) => {
  if (!bytes) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i]
}

// 获取文件类型
const getFileType = (fileName) => {
  const ext = fileName.split('.').pop().toLowerCase()
  const typeMap = {
    pdf: 'PDF',
    doc: 'Word',
    docx: 'Word',
    ppt: 'PPT',
    pptx: 'PPT',
    txt: 'TXT',
    zip: 'ZIP',
    '7z': '7Z',
    rar: 'RAR'
  }
  return typeMap[ext] || ext.toUpperCase()
}

// 提交上传
const handleSubmit = async () => {
  // 验证表单
  if (!formRef.value) return

  try {
    await formRef.value.validate()
  } catch (error) {
    ElMessage.warning('请完善表单信息')
    return
  }

  // 验证文件
  if (!selectedFile.value) {
    ElMessage.warning('请选择要上传的文件')
    return
  }

  // 验证文件类型和大小
  if (!beforeUpload(selectedFile.value)) {
    return
  }

  uploading.value = true
  uploadProgress.value = 0
  uploadStatus.value = ''
  loadingText.value = '正在上传...'

  // 创建FormData
  const formDataToSend = new FormData()
  formDataToSend.append('file', selectedFile.value)
  formDataToSend.append('title', formData.value.title)
  formDataToSend.append('categoryId', formData.value.categoryId)
  formDataToSend.append('description', formData.value.description)
  if (formData.value.tagIds && formData.value.tagIds.length > 0) {
    formData.value.tagIds.forEach(tagId => {
      formDataToSend.append('tagIds', tagId)
    })
  }

  try {
    const res = await uploadResource(formDataToSend, (percent) => {
      uploadProgress.value = percent
      loadingText.value = `正在上传... ${percent}%`
    })

    if (res.code === 0) {
      uploadProgress.value = 100
      uploadStatus.value = 'success'
      loadingText.value = '上传成功！'
      ElMessage.success('资源上传成功！')

      // 延迟跳转，显示成功状态
      setTimeout(() => {
        const resourceId = res.data?.[0]?.resourceId
        if (resourceId) {
          router.push(`/resource/${resourceId}`)
        } else {
          router.push('/my-resources')
        }
      }, 1000)
    } else {
      uploadStatus.value = 'exception'
      ElMessage.error(res.msg || '上传失败，请重试')
    }
  } catch (error) {
    console.error('上传失败:', error)
    uploadStatus.value = 'exception'
    ElMessage.error('上传失败：' + (error.message || '网络错误'))
  } finally {
    uploading.value = false
  }
}

// 重置表单
const handleReset = () => {
  formRef.value?.resetFields()
  fileList.value = []
  selectedFile.value = null
  uploadProgress.value = 0
  uploadStatus.value = ''
}

// 菜单选择
const handleMenuSelect = (index) => {
  router.push(index)
}

onMounted(() => {
  fetchCategories()
  fetchTags()
})
</script>

<style scoped>
.upload-container {
  min-height: 100vh;
  background-color: #f5f7fa;
}

.header {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 0;
}

.header-content {
  display: flex;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.logo {
  margin-right: 40px;
  cursor: pointer;
}

.logo h2 {
  margin: 0;
  color: #409EFF;
}

.menu {
  flex: 1;
  border-bottom: none;
}

.main-content {
  max-width: 1000px;
  margin: 0 auto;
  padding: 30px 20px;
}

.upload-card {
  margin-bottom: 20px;
}

.upload-card h2 {
  margin: 0;
  font-size: 24px;
  color: #303133;
}

.upload-demo {
  width: 100%;
}

.el-icon--upload {
  font-size: 67px;
  color: #409EFF;
}

.el-upload__text {
  font-size: 14px;
  color: #606266;
  margin-top: 10px;
}

.el-upload__text em {
  color: #409EFF;
  font-style: normal;
}

.el-upload__tip {
  font-size: 12px;
  color: #909399;
  margin-top: 10px;
  line-height: 1.5;
}

.file-info {
  margin-bottom: 20px;
  padding: 15px;
  background: #f5f7fa;
  border-radius: 4px;
}

.progress-wrapper {
  margin: 20px 0;
  padding: 15px;
  background: #f5f7fa;
  border-radius: 4px;
}

.el-form-item {
  margin-bottom: 22px;
}
</style>
