<template>
  <div class="login-page">
    <div class="login-container">
      <!-- 左侧：品牌信息 -->
      <div class="login-brand">
        <div class="brand-content">
          <h1 class="brand-title">学享汇</h1>
          <p class="brand-slogan">免费文档资源共享平台</p>
          <div class="brand-features">
            <div class="feature-item">
              <el-icon :size="24"><Document /></el-icon>
              <span>海量优质资源</span>
            </div>
            <div class="feature-item">
              <el-icon :size="24"><Download /></el-icon>
              <span>免费下载分享</span>
            </div>
            <div class="feature-item">
              <el-icon :size="24"><ChatDotRound /></el-icon>
              <span>AI智能助手</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧：登录表单 -->
      <div class="login-form-wrapper">
        <div class="form-container">
          <div class="form-header">
            <h2>账号登录</h2>
            <p>欢迎回到学享汇</p>
          </div>

          <el-form
            ref="formRef"
            :model="loginForm"
            :rules="loginRules"
            size="large"
            @submit.prevent="handleLogin"
          >
            <el-form-item prop="username">
              <el-input
                v-model="loginForm.username"
                placeholder="请输入用户名/邮箱"
                :prefix-icon="User"
                clearable
              />
            </el-form-item>

            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                placeholder="请输入密码"
                :prefix-icon="Lock"
                show-password
                clearable
                @keyup.enter="handleLogin"
              />
            </el-form-item>

            <el-form-item v-if="showCaptcha" prop="captcha">
              <div class="captcha-input">
                <el-input
                  v-model="loginForm.captcha"
                  placeholder="请输入验证码"
                  :prefix-icon="Key"
                  clearable
                  @keyup.enter="handleLogin"
                />
                <div class="captcha-img" @click="refreshCaptcha">
                  <img v-if="captchaUrl" :src="captchaUrl" alt="验证码" />
                  <span v-else>获取验证码</span>
                </div>
              </div>
            </el-form-item>

            <el-form-item>
              <div class="form-options">
                <el-checkbox v-model="loginForm.remember">记住我</el-checkbox>
                <el-link type="primary" @click="router.push('/forgot-password')">
                  忘记密码？
                </el-link>
              </div>
            </el-form-item>

            <el-form-item>
              <el-button
                type="primary"
                native-type="submit"
                :loading="loading"
                class="login-btn"
              >
                {{ loading ? '登录中...' : '登录' }}
              </el-button>
            </el-form-item>
          </el-form>

          <div class="form-footer">
            <span class="footer-text">还没有账号？</span>
            <el-link type="primary" @click="router.push('/register')">
              立即注册
            </el-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'
import { User, Lock, Key, Document, Download, ChatDotRound } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const formRef = ref(null)
const loading = ref(false)
const showCaptcha = ref(false)
const captchaUrl = ref('')

const loginForm = reactive({
  username: '',
  password: '',
  captcha: '',
  remember: false
})

const loginRules = {
  username: [
    { required: true, message: '请输入用户名/邮箱', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
  ],
  captcha: [
    { required: true, message: '请输入验证码', trigger: 'blur' }
  ]
}

// 获取验证码
const refreshCaptcha = async () => {
  try {
    // 对接后端验证码接口
    captchaUrl.value = `/captcha?t=${Date.now()}`
  } catch (error) {
    console.error('获取验证码失败:', error)
  }
}

// 登录
const handleLogin = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (!valid) return

    loading.value = true
    try {
      const result = await userStore.login({
        username: loginForm.username,
        password: loginForm.password,
        captcha: loginForm.captcha
      })

      if (result.success) {
        ElMessage.success('登录成功')
        // 跳转到原访问页面或首页
        const redirect = route.query.redirect || '/'
        router.push(redirect)
      } else {
        ElMessage.error(result.message || '登录失败')
        if (showCaptcha.value) {
          refreshCaptcha()
        }
      }
    } catch (error) {
      ElMessage.error('登录失败，请稍后重试')
    } finally {
      loading.value = false
    }
  })
}

onMounted(() => {
  // 检查是否需要验证码
  showCaptcha.value = true
  if (showCaptcha.value) {
    refreshCaptcha()
  }
})
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: $spacing-lg;
}

.login-container {
  display: flex;
  max-width: 1000px;
  width: 100%;
  background: $bg-primary;
  border-radius: $border-radius-xl;
  box-shadow: $shadow-2xl;
  overflow: hidden;
}

.login-brand {
  flex: 1;
  padding: $spacing-xxxl;
  background: $gradient-hero;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;

  @include respond-to('sm') {
    display: none;
  }
}

.brand-content {
  text-align: center;
}

.brand-title {
  font-size: 48px;
  font-weight: $font-weight-bold;
  margin: 0 0 $spacing-md 0;
}

.brand-slogan {
  font-size: $font-size-lg;
  opacity: 0.9;
  margin: 0 0 $spacing-xxl 0;
}

.brand-features {
  display: flex;
  flex-direction: column;
  gap: $spacing-lg;
  margin-top: $spacing-xxl;
}

.feature-item {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: $spacing-md;
  font-size: $font-size-md;
}

.login-form-wrapper {
  flex: 1;
  padding: $spacing-xxxl;
  display: flex;
  align-items: center;
  justify-content: center;
}

.form-container {
  width: 100%;
  max-width: 400px;
}

.form-header {
  text-align: center;
  margin-bottom: $spacing-xxl;

  h2 {
    font-size: $font-size-xxl;
    font-weight: $font-weight-semibold;
    color: $text-primary;
    margin: 0 0 $spacing-sm 0;
  }

  p {
    font-size: $font-size-md;
    color: $text-secondary;
    margin: 0;
  }
}

.captcha-input {
  display: flex;
  gap: $spacing-md;
  width: 100%;

  .el-input {
    flex: 1;
  }

  .captcha-img {
    flex-shrink: 0;
    width: 120px;
    height: 40px;
    border: 1px solid $border-base;
    border-radius: $border-radius-base;
    overflow: hidden;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    background: $bg-secondary;
    font-size: $font-size-sm;
    color: $text-secondary;

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    &:hover {
      border-color: $primary-color;
    }
  }
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}

.login-btn {
  width: 100%;
  height: 44px;
  font-size: $font-size-md;
}

.form-footer {
  text-align: center;
  margin-top: $spacing-lg;

  .footer-text {
    color: $text-secondary;
    margin-right: $spacing-xs;
  }
}

// 移动端适配
@include respond-to('sm') {
  .login-page {
    padding: $spacing-md;
  }

  .login-form-wrapper {
    padding: $spacing-xl;
  }

  .brand-title {
    font-size: 32px;
  }
}
</style>
