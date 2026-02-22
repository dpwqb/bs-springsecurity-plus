<template>
  <div class="terms-page">
    <div class="terms-header">
      <div class="header-container">
        <el-button
          class="back-btn"
          :icon="ArrowLeft"
          circle
          @click="goBack"
        />
        <h1 class="page-title">用户协议</h1>
      </div>
    </div>

    <div class="terms-container">
      <div class="terms-content">
        <div class="effective-date">
          <p><strong>生效日期：</strong>2025年09月01日</p>
          <p><strong>更新日期：</strong>2026年03月01日</p>
        </div>

        <section class="terms-section">
          <h2>1. 协议的接受</h2>
          <p>欢迎使用学享汇（以下简称"本平台"）。本用户协议（以下简称"本协议"）是您与本平台之间就使用本平台服务所订立的协议。请您仔细阅读本协议，特别是免除或限制责任的条款。</p>
          <p>当您在本平台注册账号或使用本平台服务时，即表示您已阅读、理解并同意接受本协议的全部内容。如果您不同意本协议的任何条款，请立即停止使用本平台。</p>
        </section>

        <section class="terms-section">
          <h2>2. 账户注册</h2>
          <p>2.1 您需要通过本平台指定的方式注册一个账户才能使用本平台的某些功能。注册时，您应当提供真实、准确、完整的个人信息。</p>
          <p>2.2 您对您的账户和密码的安全负有全部责任。任何在您的账户下发生的活动均被视为您本人的行为。</p>
          <p>2.3 您应妥善保管您的账户信息，不得转让、出借或分享给他人。如发现他人未经授权使用您的账户，您应立即通知本平台。</p>
        </section>

        <section class="terms-section">
          <h2>3. 用户义务</h2>
          <p>3.1 在使用本平台服务时，您必须遵守中华人民共和国相关法律法规。</p>
          <p>3.2 您不得利用本平台从事任何违法或不当活动，包括但不限于：</p>
          <ul>
            <li>发布违法、有害、虚假、侮辱、诽谤、淫秽、色情、暴力等信息</li>
            <li>侵犯他人知识产权、商业秘密、隐私权等合法权益</li>
            <li>干扰或破坏本平台的正常运行</li>
            <li>恶意攻击、破坏本平台安全系统</li>
            <li>利用本平台收集或窃取他人信息</li>
          </ul>
        </section>

        <section class="terms-section">
          <h2>4. 内容规范</h2>
          <p>4.1 本平台允许用户上传、分享学习资源和文章。您保证您上传的内容符合法律法规，且不侵犯任何第三方的合法权益。</p>
          <p>4.2 您上传的内容应具有教育意义，不得含有违法、有害、虚假或误导性信息。</p>
          <p>4.3 本平台有权对用户上传的内容进行审核，对于违反本协议的内容，本平台有权删除或拒绝发布。</p>
        </section>

        <section class="terms-section">
          <h2>5. 知识产权</h2>
          <p>5.1 本平台的所有内容，包括但不限于文字、图片、软件、程序、版面设计等，均受知识产权法保护。</p>
          <p>5.2 未经本平台书面授权，您不得复制、传播、展示、镜像、上载、下载本平台的内容。</p>
          <p>5.3 您上传到本平台的内容，您保留该内容的知识产权，但您授予本平台在全球范围内免费、非独家、可再许可的使用权，用于本平台的运营和推广。</p>
        </section>

        <section class="terms-section">
          <h2>6. 免责声明</h2>
          <p>6.1 本平台仅提供信息存储空间服务，用户上传的内容不代表本平台的观点。</p>
          <p>6.2 本平台不对用户上传内容的准确性、完整性、合法性承担责任。</p>
          <p>6.3 因不可抗力、网络故障、系统维护等原因导致的服务中断或延迟，本平台不承担责任。</p>
          <p>6.4 本平台保留随时修改或中断服务的权利，无需对用户或第三方负责。</p>
        </section>

        <section class="terms-section">
          <h2>7. 隐私保护</h2>
          <p>本平台重视用户隐私保护。关于个人信息的收集、使用和保护，请参阅《<router-link to="/privacy" class="highlight-link">隐私政策</router-link>》。</p>
        </section>

        <section class="terms-section">
          <h2>8. 协议修改</h2>
          <p>本平台有权根据需要修改本协议，修改后的协议将在本平台上公布。如您继续使用本平台，即表示您同意接受修改后的协议。</p>
        </section>

        <section class="terms-section">
          <h2>9. 违约责任</h2>
          <p>如您违反本协议的任何条款，本平台有权采取包括但不限于警告、限制功能、暂停或终止服务、删除内容等措施，并保留追究法律责任的权利。</p>
        </section>

        <section class="terms-section">
          <h2>10. 法律适用与争议解决</h2>
          <p>10.1 本协议的订立、执行和解释均适用中华人民共和国法律。</p>
          <p>10.2 如双方就本协议内容或其执行发生争议，双方应友好协商解决；协商不成的，任何一方均可向本平台所在地人民法院提起诉讼。</p>
        </section>

        <section class="terms-section">
          <h2>11. 联系我们</h2>
          <p>如您对本协议有任何疑问，请通过以下方式联系我们：</p>
          <p>邮箱：support@xuexianghui.com</p>
          <p>电话：400-123-4567</p>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { ArrowLeft } from '@element-plus/icons-vue'

const router = useRouter()

const goBack = () => {
  router.back()
}
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.terms-page {
  min-height: 100vh;
  background: $bg-secondary;
}

.terms-header {
  background: $bg-primary;
  box-shadow: $shadow-sm;
  position: sticky;
  top: 0;
  z-index: $z-index-sticky;
}

.header-container {
  max-width: 900px;
  margin: 0 auto;
  padding: $spacing-lg;
  display: flex;
  align-items: center;
  position: relative;
}

.back-btn {
  position: absolute;
  left: 0;
}

.page-title {
  flex: 1;
  text-align: center;
  font-size: $font-size-xl;
  font-weight: $font-weight-semibold;
  color: $text-primary;
  margin: 0;
}

.terms-container {
  max-width: 900px;
  margin: 0 auto;
  padding: $spacing-xxl;
}

.terms-content {
  background: $bg-primary;
  border-radius: $border-radius-lg;
  padding: $spacing-xxxl;
  box-shadow: $shadow-base;
}

.effective-date {
  padding: $spacing-lg;
  background: $bg-secondary;
  border-radius: $border-radius-md;
  margin-bottom: $spacing-xxl;
  border-left: 4px solid $primary-color;

  p {
    margin: $spacing-xs 0;
    color: $text-regular;
    font-size: $font-size-md;
  }
}

.terms-section {
  margin-bottom: $spacing-xxl;

  &:last-child {
    margin-bottom: 0;
  }

  h2 {
    font-size: $font-size-lg;
    font-weight: $font-weight-semibold;
    color: $text-primary;
    margin: 0 0 $spacing-md 0;
    padding-bottom: $spacing-sm;
    border-bottom: 2px solid $border-light;
  }

  p {
    color: $text-regular;
    line-height: $line-height-lg;
    margin-bottom: $spacing-md;
    font-size: $font-size-md;
  }

  ul {
    list-style-position: inside;
    margin: $spacing-md 0;

    li {
      color: $text-regular;
      line-height: $line-height-lg;
      margin-bottom: $spacing-sm;
      padding-left: $spacing-lg;
      font-size: $font-size-md;
    }
  }

  .highlight-link {
    color: $primary-color;
    text-decoration: none;
    font-weight: $font-weight-medium;

    &:hover {
      text-decoration: underline;
    }
  }
}

// 移动端适配
@include respond-to('sm') {
  .terms-container {
    padding: $spacing-lg;
  }

  .terms-content {
    padding: $spacing-xl;
  }

  .header-container {
    padding: $spacing-lg $spacing-md;
  }

  .page-title {
    font-size: $font-size-lg;
  }

  .terms-section {
    h2 {
      font-size: $font-size-md;
    }

    p, ul li {
      font-size: $font-size-sm;
    }
  }
}
</style>
