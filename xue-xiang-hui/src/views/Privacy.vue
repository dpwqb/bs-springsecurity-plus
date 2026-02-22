<template>
  <div class="privacy-page">
    <div class="privacy-header">
      <div class="header-container">
        <el-button
          class="back-btn"
          :icon="ArrowLeft"
          circle
          @click="goBack"
        />
        <h1 class="page-title">隐私政策</h1>
      </div>
    </div>

    <div class="privacy-container">
      <div class="privacy-content">
        <div class="effective-date">
          <p><strong>生效日期：</strong>2025年09月01日</p>
          <p><strong>更新日期：</strong>2026年03月01日</p>
        </div>

        <div class="intro-text">
          <p>学享汇（以下简称"我们"或"本平台"）非常重视用户的隐私保护。本隐私政策将帮助您了解我们如何收集、使用、存储和保护您的个人信息。使用本平台即表示您同意本隐私政策的全部内容。</p>
        </div>

        <section class="privacy-section">
          <h2>1. 我们收集的信息</h2>
          <h3>1.1 您主动提供的信息</h3>
          <p>当您注册账户时，我们会收集：</p>
          <ul>
            <li>账户信息：用户名、邮箱地址、密码（加密存储）</li>
            <li>个人资料：您可选择提供的头像、个人简介等信息</li>
          </ul>

          <h3>1.2 自动收集的信息</h3>
          <p>当您使用本平台时，我们会自动收集：</p>
          <ul>
            <li>设备信息：设备型号、操作系统、浏览器类型</li>
            <li>日志信息：IP地址、访问时间、访问页面</li>
            <li>使用数据：浏览记录、搜索记录、下载记录</li>
          </ul>
        </section>

        <section class="privacy-section">
          <h2>2. 信息的使用</h2>
          <p>我们使用收集的信息用于：</p>
          <ul>
            <li>提供、维护和改进本平台的服务</li>
            <li>处理您的注册、登录和其他请求</li>
            <li>向您发送重要通知、更新和安全警报</li>
            <li>个性化您的内容推荐和用户体验</li>
            <li>分析平台使用情况，优化服务功能</li>
            <li>防范欺诈、滥用和安全威胁</li>
            <li>遵守法律法规要求</li>
          </ul>
        </section>

        <section class="privacy-section">
          <h2>3. 信息的共享</h2>
          <p>除以下情况外，我们不会与第三方共享您的个人信息：</p>
          <ul>
            <li><strong>征得同意：</strong>事先获得您的明确同意</li>
            <li><strong>服务提供：</strong>向协助我们提供服务的第三方服务提供商（如云服务提供商）共享必要信息</li>
            <li><strong>法律要求：</strong>根据法律法规、政府主管部门或司法机关的要求</li>
            <li><strong>保护权益：</strong>为保护我们或他人的权利、财产或安全</li>
            <li><strong>业务转让：</strong>在合并、收购或资产转让的情况下</li>
          </ul>
        </section>

        <section class="privacy-section">
          <h2>4. 信息的存储</h2>
          <p>4.1 <strong>存储地点：</strong>您的个人信息将存储在中华人民共和国境内的服务器上。</p>
          <p>4.2 <strong>存储期限：</strong>我们仅在实现本政策所述目的所需的期限内保留您的个人信息。当您注销账户后，我们将在合理期限内删除或匿名化处理您的个人信息。</p>
          <p>4.3 <strong>安全措施：</strong>我们采取合理的技术和管理措施保护您的个人信息，包括：</p>
          <ul>
            <li>数据加密传输和存储</li>
            <li>访问权限控制</li>
            <li>安全审计和监控</li>
            <li>定期安全评估</li>
          </ul>
        </section>

        <section class="privacy-section">
          <h2>5. 您的权利</h2>
          <p>您对个人信息享有以下权利：</p>
          <ul>
            <li><strong>访问权：</strong>您有权访问您的个人信息</li>
            <li><strong>更正权：</strong>您有权要求更正不准确的个人信息</li>
            <li><strong>删除权：</strong>在特定情况下，您有权要求删除个人信息</li>
            <li><strong>注销权：</strong>您有权注销您的账户</li>
            <li><strong>撤回同意：</strong>您有权撤回之前给予的同意</li>
            <li><strong>投诉权：</strong>您有权向相关部门投诉</li>
          </ul>
          <p>如需行使上述权利，请通过本政策第10条提供的方式联系我们。</p>
        </section>

        <section class="privacy-section">
          <h2>6. Cookies的使用</h2>
          <p>6.1 我们使用Cookies和类似技术来改善用户体验。Cookies是存储在您设备上的小型文本文件。</p>
          <p>6.2 Cookies的用途包括：</p>
          <ul>
            <li>记住您的登录状态</li>
            <li>记住您的偏好设置</li>
            <li>分析平台使用情况</li>
            <li>提供个性化内容</li>
          </ul>
          <p>6.3 您可以通过浏览器设置管理或删除Cookies，但这可能影响部分功能的正常使用。</p>
        </section>

        <section class="privacy-section">
          <h2>7. 第三方链接</h2>
          <p>本平台可能包含指向第三方网站的链接。这些第三方网站有自己的隐私政策，我们不对这些网站的内容或隐私实践负责。建议您仔细阅读这些第三方的隐私政策。</p>
        </section>

        <section class="privacy-section">
          <h2>8. 未成年人保护</h2>
          <p>8.1 本平台主要面向成年用户。如果您是未成年人（未满18周岁），请在监护人的指导下使用本平台。</p>
          <p>8.2 我们不会故意收集未成年人的个人信息。如发现误收，我们将及时删除。</p>
          <p>8.3 若您是未成年人的监护人，发现未成年人提供了个人信息，请联系我们，我们将及时处理。</p>
        </section>

        <section class="privacy-section">
          <h2>9. 政策更新</h2>
          <p>我们可能不时更新本隐私政策。更新后的政策将在本平台上公布，并在政策顶部注明更新日期。重大变更时，我们会通过显著方式通知您。</p>
          <p>请您定期查看本隐私政策，以及时了解我们如何保护您的信息。</p>
        </section>

        <section class="privacy-section">
          <h2>10. 联系我们</h2>
          <p>如您对本隐私政策有任何疑问、意见或建议，或需要行使您的权利，请通过以下方式联系我们：</p>
          <div class="contact-info">
            <p><strong>邮箱：</strong>privacy@xuexianghui.com</p>
            <p><strong>电话：</strong>400-123-4567</p>
            <p><strong>地址：</strong>大连交通大学旅顺口校区一期4号贝壳楼</p>
          </div>
          <p>我们将在15个工作日内回复您的请求。</p>
        </section>

        <section class="privacy-section">
          <h2>11. 隐私政策摘要</h2>
          <div class="summary-box">
            <div class="summary-item">
              <span class="summary-icon">🔐</span>
              <div class="summary-content">
                <strong>加密存储</strong>
                <p>您的密码和敏感信息均采用加密技术存储</p>
              </div>
            </div>
            <div class="summary-item">
              <span class="summary-icon">🎯</span>
              <div class="summary-content">
                <strong>最小收集</strong>
                <p>仅收集提供服务所必需的信息</p>
              </div>
            </div>
            <div class="summary-item">
              <span class="summary-icon">👤</span>
              <div class="summary-content">
                <strong>用户控制</strong>
                <p>您可以随时查看、修改或删除个人信息</p>
              </div>
            </div>
            <div class="summary-item">
              <span class="summary-icon">🛡️</span>
              <div class="summary-content">
                <strong>安全保护</strong>
                <p>采取多种措施确保您的数据安全</p>
              </div>
            </div>
          </div>
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

.privacy-page {
  min-height: 100vh;
  background: $bg-secondary;
}

.privacy-header {
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

.privacy-container {
  max-width: 900px;
  margin: 0 auto;
  padding: $spacing-xxl;
}

.privacy-content {
  background: $bg-primary;
  border-radius: $border-radius-lg;
  padding: $spacing-xxxl;
  box-shadow: $shadow-base;
}

.effective-date {
  padding: $spacing-lg;
  background: $bg-secondary;
  border-radius: $border-radius-md;
  margin-bottom: $spacing-lg;
  border-left: 4px solid $primary-color;

  p {
    margin: $spacing-xs 0;
    color: $text-regular;
    font-size: $font-size-md;
  }
}

.intro-text {
  padding: $spacing-lg;
  background: $primary-lighter;
  border-radius: $border-radius-md;
  margin-bottom: $spacing-xxl;

  p {
    margin: 0;
    color: $text-primary;
    line-height: $line-height-lg;
    font-size: $font-size-md;
  }
}

.privacy-section {
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

  h3 {
    font-size: $font-size-md;
    font-weight: $font-weight-semibold;
    color: $text-primary;
    margin: $spacing-lg 0 $spacing-sm 0;
  }

  p {
    color: $text-regular;
    line-height: $line-height-lg;
    margin-bottom: $spacing-md;
    font-size: $font-size-md;

    strong {
      color: $text-primary;
    }
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

      strong {
        color: $text-primary;
      }
    }
  }

  .contact-info {
    background: $bg-secondary;
    padding: $spacing-lg;
    border-radius: $border-radius-md;
    margin: $spacing-md 0;

    p {
      margin-bottom: $spacing-sm;
      font-size: $font-size-md;

      &:last-child {
        margin-bottom: 0;
      }
    }
  }

  .summary-box {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: $spacing-lg;
    margin-top: $spacing-lg;
  }

  .summary-item {
    display: flex;
    gap: $spacing-md;
    padding: $spacing-lg;
    background: $bg-secondary;
    border-radius: $border-radius-md;
    transition: $transition-base;

    &:hover {
      transform: translateY(-2px);
      box-shadow: $shadow-md;
    }
  }

  .summary-icon {
    font-size: 28px;
    flex-shrink: 0;
  }

  .summary-content {
    strong {
      display: block;
      color: $text-primary;
      font-size: $font-size-md;
      margin-bottom: $spacing-xs;
    }

    p {
      margin: 0;
      font-size: $font-size-sm;
      color: $text-secondary;
      line-height: $line-height-base;
    }
  }
}

// 移动端适配
@include respond-to('sm') {
  .privacy-container {
    padding: $spacing-lg;
  }

  .privacy-content {
    padding: $spacing-xl;
  }

  .header-container {
    padding: $spacing-lg $spacing-md;
  }

  .page-title {
    font-size: $font-size-lg;
  }

  .privacy-section {
    h2 {
      font-size: $font-size-md;
    }

    h3 {
      font-size: $font-size-base;
    }

    p, ul li {
      font-size: $font-size-sm;
    }

    .summary-box {
      grid-template-columns: 1fr;
    }
  }

  .summary-item {
    flex-direction: column;
    gap: $spacing-sm;
  }
}
</style>
