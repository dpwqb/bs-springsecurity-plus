<template>
  <div class="article-editor-page">
    <AppHeader />
    <div class="editor-container">
      <div class="editor-header">
        <el-button @click="router.back()">
          <el-icon><Back /></el-icon>
          返回
        </el-button>
        <h1>{{ isEdit ? '编辑文章' : '写文章' }}</h1>
        <div class="header-actions">
          <el-button @click="handleSaveDraft" :loading="saving">保存草稿</el-button>
          <el-button type="primary" @click="publish" :loading="publishing">发布</el-button>
        </div>
      </div>

      <el-form :model="articleForm" label-width="80px" class="editor-form">
        <el-form-item label="文章标题">
          <el-input
            v-model="articleForm.title"
            placeholder="请输入文章标题"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>

        <el-form-item label="文章分类">
          <el-select v-model="articleForm.categoryId" placeholder="选择分类">
            <el-option
              v-for="category in categories"
              :key="category.id"
              :label="category.name"
              :value="category.id"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="文章摘要">
          <el-input
            v-model="articleForm.summary"
            type="textarea"
            :rows="3"
            placeholder="请输入文章摘要"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>

        <el-form-item label="文章标签">
          <el-select
            v-model="articleForm.tags"
            multiple
            filterable
            allow-create
            placeholder="选择或创建标签"
          >
            <el-option
              v-for="tag in tags"
              :key="tag.id"
              :label="tag.name"
              :value="tag.id"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="封面图片">
          <el-upload
            class="cover-uploader"
            action="#"
            :show-file-list="false"
            :before-upload="beforeCoverUpload"
          >
            <img v-if="articleForm.cover" :src="articleForm.cover" class="cover-img" />
            <el-icon v-else class="cover-uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>

        <el-form-item label="文章内容" class="content-item">
          <div class="editor-wrapper">
            <Toolbar
              class="editor-toolbar"
              :editor="editorRef"
              :defaultConfig="toolbarConfig"
              mode="default"
            />
            <Editor
              class="editor-content"
              :style="{ height: '500px' }"
              v-model="articleForm.content"
              :defaultConfig="editorConfig"
              mode="default"
              @onCreated="handleCreated"
            />
          </div>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, shallowRef, onMounted, onBeforeUnmount, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import '@wangeditor/editor/dist/css/style.css'
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'
import { ElMessage } from 'element-plus'
import AppHeader from '@/components/AppHeader.vue'
import { Back, Plus } from '@element-plus/icons-vue'
import { getArticleCategories, getArticleDetail, publishArticle, saveDraft } from '@/api/article'

const router = useRouter()
const route = useRoute()

const editorRef = shallowRef()
const saving = ref(false)
const publishing = ref(false)
const categories = ref([])
const tags = ref([])

const articleId = computed(() => route.params.id)
const isEdit = computed(() => !!articleId.value)

const articleForm = ref({
  title: '',
  categoryId: null,
  summary: '',
  content: '',
  cover: '',
  tags: []
})

const toolbarConfig = {}
const editorConfig = {
  placeholder: '请输入文章内容...',
  MENU_CONF: {
    uploadImage: {
      server: '/api/upload/image',
      fieldName: 'file',
      maxFileSize: 5 * 1024 * 1024
    }
  }
}

const handleCreated = (editor) => {
  editorRef.value = editor
}

const beforeCoverUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!')
    return false
  }

  // TODO: 上传图片到服务器
  const reader = new FileReader()
  reader.readAsDataURL(file)
  reader.onload = () => {
    articleForm.value.cover = reader.result
  }

  return false
}

const handleSaveDraft = async () => {
  if (!articleForm.value.title) {
    ElMessage.warning('请输入文章标题')
    return
  }

  saving.value = true
  try {
    const res = await saveDraft(articleForm.value)
    if (res.code === 0) {
      ElMessage.success('草稿保存成功')
    }
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

const publish = async () => {
  if (!articleForm.value.title) {
    ElMessage.warning('请输入文章标题')
    return
  }
  if (!articleForm.value.content) {
    ElMessage.warning('请输入文章内容')
    return
  }

  publishing.value = true
  try {
    const res = await publishArticle(articleForm.value)
    if (res.code === 0) {
      ElMessage.success('发布成功')
      router.push('/article/' + res.data.id)
    }
  } catch (error) {
    ElMessage.error('发布失败')
  } finally {
    publishing.value = false
  }
}

const loadArticle = async () => {
  if (!articleId.value) return

  try {
    const res = await getArticleDetail(articleId.value)
    if (res.code === 0) {
      const article = res.data
      articleForm.value = {
        title: article.title,
        categoryId: article.categoryId,
        summary: article.summary,
        content: article.content,
        cover: article.coverImage,
        tags: article.tags?.map(t => t.id) || []
      }
      // 更新编辑器内容
      if (editorRef.value) {
        editorRef.value.setHtml(article.content)
      }
    }
  } catch (error) {
    ElMessage.error('加载文章失败')
  }
}

const loadCategories = async () => {
  try {
    const res = await getArticleCategories()
    if (res.code === 0) {
      categories.value = res.data || []
    }
  } catch (error) {
    console.error('获取分类失败:', error)
  }
}

onMounted(async () => {
  await loadCategories()
  if (isEdit.value) {
    await loadArticle()
  }
})

onBeforeUnmount(() => {
  const editor = editorRef.value
  if (editor == null) return
  editor.destroy()
})
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.article-editor-page {
  min-height: 100vh;
  background-color: $bg-secondary;
  padding-top: 64px;
}

.editor-container {
  max-width: 900px;
  margin: 0 auto;
  padding: $spacing-xl $spacing-lg;
}

.editor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: $spacing-xl;
  padding-bottom: $spacing-lg;
  border-bottom: 1px solid $border-lighter;

  h1 {
    font-size: $font-size-xxl;
    font-weight: $font-weight-semibold;
    color: $text-primary;
    margin: 0;
  }

  .header-actions {
    display: flex;
    gap: $spacing-md;
  }
}

.editor-form {
  background: $bg-primary;
  padding: $spacing-xxl;
  border-radius: $border-radius-lg;
  box-shadow: $shadow-sm;
}

.content-item :deep(.el-form-item__content) {
  line-height: normal;
}

.editor-wrapper {
  border: 1px solid $border-base;
  border-radius: $border-radius-base;
  overflow: hidden;
}

.editor-toolbar {
  border-bottom: 1px solid $border-base;
}

.editor-content {
  overflow-y: auto;
}

.cover-uploader {
  .cover-img {
    width: 200px;
    height: 150px;
    object-fit: cover;
    display: block;
  }

  .cover-uploader-icon {
    font-size: 28px;
    color: $text-placeholder;
    width: 200px;
    height: 150px;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px dashed $border-base;
    border-radius: $border-radius-base;
    cursor: pointer;

    &:hover {
      border-color: $primary-color;
      color: $primary-color;
    }
  }
}

// 移动端适配
@include respond-to('sm') {
  .editor-header {
    flex-direction: column;
    align-items: stretch;
    gap: $spacing-md;
  }

  .header-actions {
    justify-content: flex-end;
  }

  .editor-form {
    padding: $spacing-lg;
  }
}
</style>
