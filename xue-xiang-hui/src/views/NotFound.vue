<template>
  <div class="not-found-page">
    <AppHeader />
    <div class="not-found-container">
      <div class="not-found-content">
        <h1 class="error-code">404</h1>
        <h2 class="error-title">页面不存在</h2>
        <p class="error-desc">抱歉，您访问的页面不存在或已被删除</p>
        <div class="error-actions">
          <el-button type="primary" @click="router.push('/')">
            <el-icon><HomeFilled /></el-icon>
            返回首页
          </el-button>
          <el-button @click="router.back()">
            <el-icon><Back /></el-icon>
            返回上一页
          </el-button>
        </div>
      </div>
    </div>
    <AppFooter />
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'
import { HomeFilled, Back } from '@element-plus/icons-vue'

const router = useRouter()
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.not-found-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: $bg-secondary;
}

.not-found-container {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 64px $spacing-lg $spacing-lg;
}

.not-found-content {
  text-align: center;
  max-width: 600px;
}

.error-code {
  font-size: 120px;
  font-weight: $font-weight-bold;
  color: $primary-color;
  margin: 0 0 $spacing-lg 0;
  line-height: 1;
}

.error-title {
  font-size: $font-size-xxl;
  font-weight: $font-weight-semibold;
  color: $text-primary;
  margin: 0 0 $spacing-md 0;
}

.error-desc {
  font-size: $font-size-md;
  color: $text-secondary;
  margin: 0 0 $spacing-xxl 0;
}

.error-actions {
  display: flex;
  justify-content: center;
  gap: $spacing-md;
}

// 移动端适配
@include respond-to('sm') {
  .error-code {
    font-size: 80px;
  }

  .error-title {
    font-size: $font-size-xl;
  }

  .error-actions {
    flex-direction: column;
    align-items: stretch;

    .el-button {
      width: 100%;
    }
  }
}
</style>
