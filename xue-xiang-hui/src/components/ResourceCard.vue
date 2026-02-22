<template>
  <el-card
    class="resource-card"
    :class="[`view-mode-${viewMode}`, { 'is-hoverable': hoverable }]"
    @click="handleClick"
  >
    <!-- 网格视图 -->
    <template v-if="viewMode === 'grid'">
      <!-- 卡片头部 -->
      <div class="card-header">
        <div class="file-type-badge" :class="`type-${resource.fileType}`">
          <el-icon :size="24">
            <Document v-if="['doc', 'docx'].includes(resource.fileType)" />
            <DocumentCopy v-else-if="['ppt', 'pptx'].includes(resource.fileType)" />
            <Tickets v-else-if="['xls', 'xlsx'].includes(resource.fileType)" />
            <Document v-else />
          </el-icon>
          <span>{{ fileTypeText }}</span>
        </div>
        <el-dropdown trigger="click" @command="handleAction" stop>
          <el-icon class="more-btn" :size="18"><MoreFilled /></el-icon>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="favorite">
                <el-icon><StarFilled /></el-icon>
                {{ isFavorited ? '取消收藏' : '收藏' }}
              </el-dropdown-item>
              <el-dropdown-item command="share">
                <el-icon><Share /></el-icon>
                分享
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>

      <!-- 卡片内容 -->
      <div class="card-content">
        <h4 class="resource-title" :title="resource.title">
          {{ resource.title }}
        </h4>
        <p class="resource-desc" :title="resource.description">
          {{ resource.description || '暂无描述' }}
        </p>
        <div class="resource-tags" v-if="resource.tags && resource.tags.length">
          <el-tag
            v-for="tag in resource.tags.slice(0, 3)"
            :key="tag.id"
            size="small"
            type="info"
          >
            {{ tag.name }}
          </el-tag>
        </div>
      </div>

      <!-- 卡片底部 -->
      <div class="card-footer">
        <div class="author-info">
          <el-avatar :size="24">{{ resource.uploaderName?.charAt(0) }}</el-avatar>
          <span>{{ resource.uploaderName || '匿名' }}</span>
        </div>
        <div class="resource-stats">
          <span>
            <el-icon><View /></el-icon>
            {{ formatNumber(resource.viewCount) }}
          </span>
          <span>
            <el-icon><Download /></el-icon>
            {{ formatNumber(resource.downloadCount) }}
          </span>
        </div>
      </div>
    </template>

    <!-- 列表视图 -->
    <template v-else>
      <div class="list-view-content">
        <div class="file-icon">
          <el-icon :size="40" :color="fileTypeColor">
            <Document />
          </el-icon>
        </div>
        <div class="resource-info">
          <h4 class="resource-title">{{ resource.title }}</h4>
          <p class="resource-desc">{{ resource.description || '暂无描述' }}</p>
          <div class="resource-meta">
            <span>
              <el-icon><User /></el-icon>
              {{ resource.uploaderName || '匿名' }}
            </span>
            <span>
              <el-icon><Clock /></el-icon>
              {{ formatDate(resource.createTime) }}
            </span>
            <span>
              <el-icon><View /></el-icon>
              {{ formatNumber(resource.viewCount) }} 浏览
            </span>
            <span>
              <el-icon><Download /></el-icon>
              {{ formatNumber(resource.downloadCount) }} 下载
            </span>
          </div>
        </div>
        <div class="list-actions">
          <el-button type="primary" @click.stop="handleDownload">
            <el-icon><Download /></el-icon>
            下载
          </el-button>
          <el-button @click.stop="handleAction('favorite')">
            <el-icon><StarFilled /></el-icon>
          </el-button>
        </div>
      </div>
    </template>
  </el-card>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'
import {
  Document,
  DocumentCopy,
  Tickets,
  MoreFilled,
  StarFilled,
  Share,
  View,
  Download,
  User,
  Clock
} from '@element-plus/icons-vue'

const props = defineProps({
  resource: {
    type: Object,
    required: true
  },
  viewMode: {
    type: String,
    default: 'grid' // 'grid' | 'list'
  },
  hoverable: {
    type: Boolean,
    default: true
  },
  isFavorited: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['click', 'favorite', 'share', 'download'])

const router = useRouter()
const userStore = useUserStore()

// 文件类型文本
const fileTypeText = computed(() => {
  const type = props.resource.fileType?.toUpperCase()
  return type || 'FILE'
})

// 文件类型颜色
const fileTypeColor = computed(() => {
  const colorMap = {
    pdf: '#F56C6C',
    doc: '#409EFF',
    docx: '#409EFF',
    ppt: '#E6A23C',
    pptx: '#E6A23C',
    xls: '#67C23A',
    xlsx: '#67C23A',
    txt: '#909399'
  }
  return colorMap[props.resource.fileType] || '#909399'
})

// 格式化数字
const formatNumber = (num) => {
  if (!num) return '0'
  if (num >= 10000) {
    return (num / 10000).toFixed(1) + 'w'
  }
  if (num >= 1000) {
    return (num / 1000).toFixed(1) + 'k'
  }
  return num.toString()
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  const now = new Date()
  const diff = now - date
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))

  if (days === 0) return '今天'
  if (days === 1) return '昨天'
  if (days < 7) return `${days}天前`
  return date.toLocaleDateString()
}

// 点击卡片
const handleClick = () => {
  emit('click', props.resource)
  router.push(`/resource/${props.resource.resourceId}`)
}

// 处理操作
const handleAction = (command) => {
  if (command === 'favorite') {
    if (!userStore.isLoggedIn) {
      ElMessage.warning('请先登录')
      router.push('/login')
      return
    }
    emit('favorite', props.resource)
  } else if (command === 'share') {
    emit('share', props.resource)
  }
}

// 下载
const handleDownload = () => {
  emit('download', props.resource)
}
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.resource-card {
  border: none;
  box-shadow: $shadow-sm;
  transition: $transition-base;
  cursor: pointer;
  overflow: hidden;

  &.is-hoverable:hover {
    box-shadow: $shadow-lg;
    transform: translateY(-4px);
  }

  :deep(.el-card__body) {
    padding: 0;
  }

  // 网格视图
  &.view-mode-grid {
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: $spacing-md;
      background: $bg-secondary;
    }

    .file-type-badge {
      display: flex;
      align-items: center;
      gap: $spacing-xs;
      padding: $spacing-xs $spacing-sm;
      border-radius: $border-radius-base;
      font-size: $font-size-xs;
      font-weight: $font-weight-medium;

      &.type-pdf { background: #fef0f0; color: #F56C6C; }
      &.type-doc, &.type-docx { background: #ecf5ff; color: #409EFF; }
      &.type-ppt, &.type-pptx { background: #fdf6ec; color: #E6A23C; }
      &.type-xls, &.type-xlsx { background: #f0f9ff; color: #67C23A; }
      &:not([class*="type-"]) { background: $bg-secondary; color: $text-secondary; }
    }

    .more-btn {
      color: $text-secondary;
      cursor: pointer;
      padding: $spacing-xs;

      &:hover {
        color: $primary-color;
      }
    }

    .card-content {
      padding: $spacing-md;
      text-align: center;
    }

    .resource-title {
      font-size: $font-size-md;
      font-weight: $font-weight-medium;
      color: $text-primary;
      margin: 0 0 $spacing-sm 0;
      @include text-ellipsis(2);
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
    }

    .resource-desc {
      font-size: $font-size-sm;
      color: $text-secondary;
      margin: 0 0 $spacing-md 0;
      @include text-ellipsis(2);
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
    }

    .resource-tags {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      gap: $spacing-xs;
    }

    .card-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: $spacing-md;
      border-top: 1px solid $border-lighter;
    }

    .author-info {
      display: flex;
      align-items: center;
      gap: $spacing-xs;
      font-size: $font-size-sm;
      color: $text-regular;
    }

    .resource-stats {
      display: flex;
      gap: $spacing-md;
      font-size: $font-size-xs;
      color: $text-secondary;

      span {
        display: flex;
        align-items: center;
        gap: 4px;
      }
    }
  }

  // 列表视图
  &.view-mode-list {
    .list-view-content {
      display: flex;
      align-items: center;
      gap: $spacing-md;
      padding: $spacing-md;
    }

    .file-icon {
      flex-shrink: 0;
    }

    .resource-info {
      flex: 1;
      min-width: 0;
    }

    .resource-title {
      font-size: $font-size-md;
      font-weight: $font-weight-medium;
      color: $text-primary;
      margin: 0 0 $spacing-xs 0;
      @include text-ellipsis();
    }

    .resource-desc {
      font-size: $font-size-sm;
      color: $text-secondary;
      margin: 0 0 $spacing-sm 0;
      @include text-ellipsis();
    }

    .resource-meta {
      display: flex;
      gap: $spacing-md;
      font-size: $font-size-xs;
      color: $text-secondary;

      span {
        display: flex;
        align-items: center;
        gap: 4px;
      }
    }

    .list-actions {
      display: flex;
      gap: $spacing-sm;
      flex-shrink: 0;
    }
  }
}
</style>
