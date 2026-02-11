<template>
  <div class="register-page">
    <div class="register-container">
      <!-- 左侧：品牌信息 -->
      <div class="register-brand">
        <div class="brand-content">
          <h1 class="brand-title">加入学享汇</h1>
          <p class="brand-slogan">开启你的学习之旅</p>
          <div class="brand-stats">
            <div class="stat-item">
              <div class="stat-number">10W+</div>
              <div class="stat-label">注册用户</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">50W+</div>
              <div class="stat-label">优质资源</div>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧：注册表单 -->
      <div class="register-form-wrapper">
        <div class="form-container">
          <div class="form-header">
            <h2>创建账号</h2>
            <p>填写信息，开始使用</p>
          </div>

          <el-form
            ref="formRef"
            :model="registerForm"
            :rules="registerRules"
            size="large"
            @submit.prevent="handleRegister"
          >
            <el-form-item prop="username">
              <el-input
                v-model="registerForm.username"
                placeholder="请输入用户名"
                :prefix-icon="User"
                clearable
              />
            </el-form-item>

            <el-form-item prop="email">
              <el-input
                v-model="registerForm.email"
                placeholder="请输入邮箱"
                :prefix-icon="Message"
                clearable
              />
            </el-form-item>

            <el-form-item prop="password">
              <el-input
                v-model="registerForm.password"
                type="password"
                placeholder="请输入密码"
                :prefix-icon="Lock"
                show-password
                clearable
              />
            </el-form-item>

            <el-form-item prop="confirmPassword">
              <el-input
                v-model="registerForm.confirmPassword"
                type="password"
                placeholder="请确认密码"
                :prefix-icon="Lock"
                show-password
                clearable
                @keyup.enter="handleRegister"
              />
            </el-form-item>

            <el-form-item prop="captcha">
              <div class="captcha-input">
                <el-input
                  v-model="registerForm.captcha"
                  placeholder="请输入验证码"
                  :prefix-icon="Key"
                  clearable
                  @keyup.enter="handleRegister"
                />
                <div class="captcha-img" @click="refreshCaptcha">
                  <img v-if="captchaUrl" :src="captchaUrl" alt="验证码" />
                  <span v-else>获取验证码</span>
                </div>
              </div>
            </el-form-item>

            <el-form-item prop="agreement">
              <el-checkbox v-model="registerForm.agreement">
                我已阅读并同意
                <el-link type="primary" @click.prevent="showTerms">《用户协议》</el-link>
                和
                <el-link type="primary" @click.prevent="showPrivacy">《隐私政策》</el-link>
              </el-checkbox>
            </el-form-item>

            <el-form-item>
              <el-button
                type="primary"
                native-type="submit"
                :loading="loading"
                class="register-btn"
              >
                {{ loading ? '注册中...' : '注册' }}
              </el-button>
            </el-form-item>
          </el-form>

          <div class="form-footer">
            <span class="footer-text">已有账号？</span>
            <el-link type="primary" @click="router.push('/login')">
              立即登录
            </el-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Message, Lock, Key } from '@element-plus/icons-vue'

const router = useRouter()

const formRef = ref(null)
const loading = ref(false)
const captchaUrl = ref('')

const registerForm = reactive({
  username: '',
  email: '',
  password: '',
  confirmPassword: '',
  captcha: '',
  agreement: false
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const registerRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在3-20个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在6-20个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ],
  captcha: [
    { required: true, message: '请输入验证码', trigger: 'blur' }
  ],
  agreement: [
    {
      type: 'enum',
      enum: [true],
      message: '请阅读并同意用户协议和隐私政策',
      trigger: 'change'
    }
  ]
}

// 获取验证码
const refreshCaptcha = () => {
  captchaUrl.value = `/captcha?t=${Date.now()}`
}

// 注册
const handleRegister = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (!valid) return

    loading.value = true
    try {
      // 对接后端注册接口
      const response = await fetch('/api/auth/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          username: registerForm.username,
          email: registerForm.email,
          password: registerForm.password,
          captcha: registerForm.captcha
        })
      })

      const result = await response.json()

      if (result.code === 200) {
        ElMessage.success('注册成功，请登录')
        router.push('/login')
      } else {
        ElMessage.error(result.message || '注册失败')
        refreshCaptcha()
      }
    } catch (error) {
      ElMessage.error('注册失败，请稍后重试')
    } finally {
      loading.value = false
    }
  })
}

// 显示用户协议
const showTerms = () => {
  ElMessage.info('用户协议页面即将开放')
}

// 显示隐私政策
const showPrivacy = () => {
  ElMessage.info('隐私政策页面即将开放')
}

onMounted(() => {
  refreshCaptcha()
})
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.register-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: $spacing-lg;
}

.register-container {
  display: flex;
  max-width: 1000px;
  width: 100%;
  background: $bg-primary;
  border-radius: $border-radius-xl;
  box-shadow: $shadow-2xl;
  overflow: hidden;
}

.register-brand {
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

.brand-stats {
  display: flex;
  justify-content: center;
  gap: $spacing-xxl;
  margin-top: $spacing-xxl;
}

.stat-item {
  text-align: center;
}

.stat-number {
  font-size: $font-size-xxl;
  font-weight: $font-weight-bold;
  margin-bottom: $spacing-xs;
}

.stat-label {
  font-size: $font-size-sm;
  opacity: 0.8;
}

.register-form-wrapper {
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

.register-btn {
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
  .register-page {
    padding: $spacing-md;
  }

  .register-form-wrapper {
    padding: $spacing-xl;
  }

  .brand-title {
    font-size: 32px;
  }
}
</style>
