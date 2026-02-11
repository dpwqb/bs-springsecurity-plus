<template>
  <footer class="app-footer">
    <div class="footer-container">
      <!-- 主要内容 -->
      <div class="footer-main">
        <!-- 关于我们 -->
        <div class="footer-section">
          <h4 class="section-title">关于学享汇</h4>
          <p class="section-desc">
            学享汇是一个免费的文档资源共享平台，致力于为学习者提供优质的学习资料和交流空间。
          </p>
        </div>

        <!-- 快速链接 -->
        <div class="footer-section">
          <h4 class="section-title">快速链接</h4>
          <ul class="link-list">
            <li><router-link to="/resources">资源库</router-link></li>
            <li><router-link to="/articles">文章广场</router-link></li>
            <li><router-link to="/upload">上传资源</router-link></li>
            <li><router-link to="/my-favorites">我的收藏</router-link></li>
          </ul>
        </div>

        <!-- 帮助中心 -->
        <div class="footer-section">
          <h4 class="section-title">帮助中心</h4>
          <ul class="link-list">
            <li><a href="#" @click.prevent>使用协议</a></li>
            <li><a href="#" @click.prevent>隐私政策</a></li>
            <li><a href="#" @click.prevent>版权声明</a></li>
            <li><a href="#" @click.prevent>联系我们</a></li>
          </ul>
        </div>

        <!-- 联系方式 -->
        <div class="footer-section">
          <h4 class="section-title">联系我们</h4>
          <ul class="contact-list">
            <li>
              <el-icon><Message /></el-icon>
              <span>support@xuexianghui.com</span>
            </li>
            <li>
              <el-icon><ChatDotRound /></el-icon>
              <span>在线客服</span>
            </li>
          </ul>
        </div>
      </div>

      <!-- 分割线 -->
      <el-divider />

      <!-- 底部版权 -->
      <div class="footer-bottom">
        <p class="copyright">
          © {{ currentYear }} 学享汇 All Rights Reserved.
        </p>
        <p class="icp">
          <a href="https://beian.miit.gov.cn" target="_blank" rel="noopener">
            备案号：京ICP备XXXXXXXX号
          </a>
        </p>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { computed } from 'vue'
import { Message, ChatDotRound } from '@element-plus/icons-vue'

const currentYear = computed(() => new Date().getFullYear())
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.app-footer {
  background-color: $bg-primary;
  border-top: 1px solid $border-lighter;
  margin-top: auto;
}

.footer-container {
  max-width: $container-xxl;
  margin: 0 auto;
  padding: $spacing-xxl $spacing-lg;
}

.footer-main {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: $spacing-xxl;
  margin-bottom: $spacing-xl;
}

.footer-section {
  .section-title {
    font-size: $font-size-md;
    font-weight: $font-weight-semibold;
    color: $text-primary;
    margin: 0 0 $spacing-md 0;
  }

  .section-desc {
    font-size: $font-size-sm;
    color: $text-secondary;
    line-height: $line-height-lg;
    margin: 0;
  }

  .link-list {
    list-style: none;
    padding: 0;
    margin: 0;

    li {
      margin-bottom: $spacing-sm;

      a {
        color: $text-secondary;
        text-decoration: none;
        font-size: $font-size-sm;
        transition: $transition-fast;

        &:hover {
          color: $primary-color;
        }
      }
    }
  }

  .contact-list {
    list-style: none;
    padding: 0;
    margin: 0;

    li {
      display: flex;
      align-items: center;
      gap: $spacing-sm;
      margin-bottom: $spacing-sm;
      color: $text-secondary;
      font-size: $font-size-sm;

      .el-icon {
        color: $primary-color;
      }
    }
  }
}

.el-divider {
  margin: $spacing-xl 0;
}

.footer-bottom {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: $spacing-sm;

  .copyright,
  .icp {
    font-size: $font-size-sm;
    color: $text-secondary;
    margin: 0;
  }

  .icp a {
    color: $text-secondary;
    text-decoration: none;
    transition: $transition-fast;

    &:hover {
      color: $primary-color;
    }
  }
}

// 移动端适配
@include respond-to('sm') {
  .footer-container {
    padding: $spacing-xl $spacing-md;
  }

  .footer-main {
    grid-template-columns: 1fr;
    gap: $spacing-lg;
  }

  .footer-bottom {
    text-align: center;
  }
}
</style>
