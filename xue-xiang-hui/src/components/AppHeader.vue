<template>
  <header class="app-header">
    <div class="header-container">
      <!-- Logo -->
      <div class="logo" @click="router.push('/')">
        <el-icon :size="32" color="#409EFF"><Reading /></el-icon>
        <span class="logo-text">学享汇</span>
      </div>

      <!-- 导航菜单 -->
      <nav class="nav-menu" :class="{ 'menu-open': mobileMenuOpen }">
        <router-link to="/" class="nav-item" @click="closeMenu">
          <el-icon><HomeFilled /></el-icon>
          <span>首页</span>
        </router-link>
        <router-link to="/resources" class="nav-item" @click="closeMenu">
          <el-icon><Document /></el-icon>
          <span>资源库</span>
        </router-link>
        <router-link to="/articles" class="nav-item" @click="closeMenu">
          <el-icon><Memo /></el-icon>
          <span>文章广场</span>
        </router-link>
      </nav>

      <!-- 搜索框 -->
      <div class="search-box">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索资源、文章..."
          class="search-input"
          @keyup.enter="handleSearch"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>

      <!-- 用户操作区 -->
      <div class="user-actions">
        <el-button type="primary" @click="handleUpload">
          <el-icon><Upload /></el-icon>
          <span class="action-text">上传资源</span>
        </el-button>

        <!-- 已登录：显示用户头像下拉菜单 -->
        <el-dropdown v-if="userStore.isLoggedIn" trigger="click" @command="handleCommand">
          <div class="user-avatar">
            <el-avatar :size="36">
              {{ userStore.userName?.charAt(0)?.toUpperCase() }}
            </el-avatar>
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="/my-resources">
                <el-icon><Document /></el-icon>
                我的资源
              </el-dropdown-item>
              <el-dropdown-item command="/my-favorites">
                <el-icon><StarFilled /></el-icon>
                我的收藏
              </el-dropdown-item>
              <el-dropdown-item command="/my-downloads">
                <el-icon><Download /></el-icon>
                下载历史
              </el-dropdown-item>
              <el-dropdown-item command="/my-articles" divided>
                <el-icon><Memo /></el-icon>
                我的文章
              </el-dropdown-item>
              <el-dropdown-item command="logout" divided>
                <el-icon><SwitchButton /></el-icon>
                退出登录
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>

        <!-- 未登录：显示登录按钮 -->
        <el-button v-else type="primary" plain @click="router.push('/login')">
          登录 / 注册
        </el-button>

        <!-- 移动端菜单按钮 -->
        <el-button
          class="mobile-menu-btn"
          text
          @click="toggleMobileMenu"
        >
          <el-icon :size="24"><Menu /></el-icon>
        </el-button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useResourceStore } from '@/stores/resource'
import {
  Reading,
  HomeFilled,
  Document,
  Memo,
  Search,
  Upload,
  StarFilled,
  Download,
  SwitchButton,
  Menu
} from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()
const resourceStore = useResourceStore()

const searchKeyword = ref('')
const mobileMenuOpen = ref(false)

// 搜索
const handleSearch = () => {
  if (searchKeyword.value.trim()) {
    resourceStore.addSearchHistory(searchKeyword.value.trim())
    router.push({
      path: '/resources',
      query: { keyword: searchKeyword.value.trim() }
    })
  }
}

// 上传资源
const handleUpload = () => {
  if (userStore.isLoggedIn) {
    router.push('/upload')
  } else {
    router.push('/login')
  }
}

// 处理下拉菜单命令
const handleCommand = (command) => {
  if (command === 'logout') {
    userStore.logout()
    router.push('/')
  } else {
    router.push(command)
  }
}

// 切换移动端菜单
const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
}

// 关闭移动端菜单
const closeMenu = () => {
  mobileMenuOpen.value = false
}
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.app-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: $z-index-fixed;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  box-shadow: $shadow-sm;
  transition: $transition-base;
}

.header-container {
  display: flex;
  align-items: center;
  max-width: $container-xxl;
  margin: 0 auto;
  padding: 0 $spacing-lg;
  height: 64px;
}

.logo {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
  margin-right: $spacing-xl;
  cursor: pointer;
  transition: $transition-fast;

  &:hover {
    opacity: 0.8;
  }

  .logo-text {
    font-size: $font-size-xl;
    font-weight: $font-weight-bold;
    color: $primary-color;
  }
}

.nav-menu {
  display: flex;
  align-items: center;
  gap: $spacing-xs;
  flex: 1;

  .nav-item {
    display: flex;
    align-items: center;
    gap: $spacing-xs;
    padding: $spacing-sm $spacing-lg;
    color: $text-regular;
    text-decoration: none;
    border-radius: $border-radius-base;
    transition: $transition-fast;
    position: relative;

    &:hover {
      color: $primary-color;
      background-color: $primary-lighter;
    }

    &.router-link-active {
      color: $primary-color;
      font-weight: $font-weight-medium;

      &::after {
        content: '';
        position: absolute;
        bottom: -20px;
        left: 50%;
        transform: translateX(-50%);
        width: 20px;
        height: 3px;
        background-color: $primary-color;
        border-radius: 2px;
      }
    }

    span {
      font-size: $font-size-md;
    }
  }
}

.search-box {
  margin: 0 $spacing-lg;

  .search-input {
    width: 250px;

    :deep(.el-input__wrapper) {
      border-radius: $border-radius-round;
      background-color: $bg-secondary;
      box-shadow: none;
      border: 1px solid transparent;

      &:hover {
        border-color: $border-light;
      }

      &.is-focus {
        background-color: $bg-primary;
        border-color: $primary-color;
      }
    }
  }
}

.user-actions {
  display: flex;
  align-items: center;
  gap: $spacing-md;

  .action-text {
    @include respond-to('sm') {
      display: none;
    }
  }

  .user-avatar {
    cursor: pointer;
    transition: $transition-fast;

    &:hover {
      opacity: 0.8;
    }
  }

  .mobile-menu-btn {
    display: none;
  }
}

// 移动端适配
@include respond-to('md') {
  .header-container {
    padding: 0 $spacing-md;
  }

  .logo {
    margin-right: $spacing-md;

    .logo-text {
      font-size: $font-size-lg;
    }
  }

  .nav-menu {
    position: fixed;
    top: 64px;
    left: 0;
    right: 0;
    flex-direction: column;
    background: $bg-primary;
    padding: $spacing-md;
    gap: 0;
    box-shadow: $shadow-lg;
    transform: translateY(-100%);
    opacity: 0;
    visibility: hidden;
    transition: $transition-base;

    &.menu-open {
      transform: translateY(0);
      opacity: 1;
      visibility: visible;
    }

    .nav-item {
      width: 100%;
      padding: $spacing-md;
      border-radius: $border-radius-base;

      &.router-link-active::after {
        display: none;
      }

      &.router-link-active {
        background-color: $primary-lighter;
      }
    }
  }

  .search-box {
    display: none;
  }

  .user-actions {
    .mobile-menu-btn {
      display: flex;
    }

    .action-text {
      display: none;
    }
  }
}
</style>
