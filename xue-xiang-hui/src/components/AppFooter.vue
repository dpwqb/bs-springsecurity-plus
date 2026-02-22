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
            <li><a href="#" @click.prevent="openUserAgreement">使用协议</a></li>
            <li><a href="#" @click.prevent="openPrivacyPolicy">隐私政策</a></li>
            <li><a href="#" @click.prevent="openCopyrightNotice">版权声明</a></li>
            <li><a href="#" @click.prevent="openContactUs">联系我们</a></li>
          </ul>
        </div>

        <!-- 联系方式 -->
        <div class="footer-section">
          <h4 class="section-title">联系我们</h4>
          <ul class="contact-list">
            <li>
              <el-icon><Message /></el-icon>
              <a href="mailto:hyh@xuexianghui.com">hyh@xuexianghui.com</a>
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
          &copy; {{ currentYear }} 学享汇 All Rights Reserved.
        </p>
        <p class="icp">
          <a href="https://beian.miit.gov.cn" target="_blank" rel="noopener">
            辽ICP备{{ currentYear }}000000号-1
          </a>
        </p>
      </div>
    </div>

    <!-- 使用协议 Modal -->
    <el-dialog
      v-model="userAgreementDialogVisible"
      title="使用协议"
      width="700px"
      :close-on-click-modal="true"
    >
      <div class="modal-content">
        <div class="modal-section">
          <h5 class="modal-section-title">1. 服务条款</h5>
          <div class="modal-section-content">
            <p>欢迎使用学享汇平台。在使用本平台服务前，请仔细阅读以下条款：</p>
            <ul>
              <li>您注册账号即表示您同意本协议的全部内容</li>
              <li>用户应提供真实、准确的注册信息</li>
              <li>禁止发布违法、有害、虚假信息</li>
              <li>禁止传播垃圾信息或恶意软件</li>
            </ul>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">2. 内容规范</h5>
          <div class="modal-section-content">
            <p>用户上传的内容应当符合以下要求：</p>
            <ul>
              <li>不得侵犯他人知识产权</li>
              <li>不得上传违法违规内容</li>
              <li>平台有权对违规内容进行删除或下架</li>
            </ul>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">3. 用户权利与责任</h5>
          <div class="modal-section-content">
            <ul>
              <li>用户可以免费下载平台资源用于个人学习</li>
              <li>使用资源时应注明来源</li>
              <li>禁止将资源用于商业目的</li>
              <li>用户对自己的账号安全负责</li>
            </ul>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">4. 违约处理</h5>
          <div class="modal-section-content">
            <p>对于违反本协议的用户，平台有权采取以下措施：</p>
            <ul>
              <li>警告并要求整改</li>
              <li>暂停或限制账号功能</li>
              <li>永久封禁账号</li>
              <li>保留追究法律责任的权利</li>
            </ul>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 隐私政策 Modal -->
    <el-dialog
      v-model="privacyPolicyDialogVisible"
      title="隐私政策"
      width="700px"
      :close-on-click-modal="true"
    >
      <div class="modal-content">
        <div class="modal-section">
          <h5 class="modal-section-title">1. 信息收集</h5>
          <div class="modal-section-content">
            <p>我们可能收集以下信息：</p>
            <ul>
              <li>注册信息：邮箱地址、用户名</li>
              <li>使用数据：浏览记录、下载记录</li>
              <li>设备信息：IP地址、浏览器类型</li>
            </ul>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">2. 信息使用</h5>
          <div class="modal-section-content">
            <p>我们使用收集的信息用于：</p>
            <ul>
              <li>提供和改进服务</li>
              <li>发送重要通知</li>
              <li>分析平台使用情况</li>
              <li>防止欺诈和滥用</li>
            </ul>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">3. 信息保护</h5>
          <div class="modal-section-content">
            <ul>
              <li>采用行业标准的安全措施保护数据</li>
              <li>定期进行安全审计</li>
              <li>限制内部人员访问用户数据</li>
              <li>用户可以要求删除个人数据</li>
            </ul>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">4. 第三方服务</h5>
          <div class="modal-section-content">
            <p>本平台使用以下第三方服务：</p>
            <ul>
              <li>内容分发网络(CDN)</li>
              <li>数据分析服务</li>
              <li>我们不会向第三方出售您的个人信息</li>
            </ul>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 版权声明 Modal -->
    <el-dialog
      v-model="copyrightNoticeDialogVisible"
      title="版权声明"
      width="700px"
      :close-on-click-modal="true"
    >
      <div class="modal-content">
        <div class="modal-section">
          <h5 class="modal-section-title">1. 平台版权</h5>
          <div class="modal-section-content">
            <p>学享汇平台的以下内容受版权保护：</p>
            <ul>
              <li>网站设计与界面</li>
              <li>平台功能代码</li>
              <li>平台文字内容</li>
              <li>学享汇商标及标识</li>
            </ul>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">2. 用户内容</h5>
          <div class="modal-section-content">
            <ul>
              <li>用户对其上传的内容保留著作权</li>
              <li>上传即表示授权平台在展示资源时使用</li>
              <li>用户应确保拥有所上传内容的合法权利</li>
              <li>平台不承担用户内容的版权责任</li>
            </ul>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">3. 侵权处理</h5>
          <div class="modal-section-content">
            <p>如发现侵权内容，请通过以下方式举报：</p>
            <ul>
              <li>发送邮件至：hyh@xuexianghui.com</li>
              <li>提供侵权内容的详细位置</li>
              <li>提供版权证明材料</li>
              <li>我们将在核实后及时处理</li>
            </ul>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">4. 合理使用</h5>
          <div class="modal-section-content">
            <ul>
              <li>下载的资源仅供个人学习使用</li>
              <li>引用资源时应注明来源</li>
              <li>不得用于商业目的</li>
              <li>不得去除资源中的版权声明</li>
            </ul>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 联系我们 Modal -->
    <el-dialog
      v-model="contactUsDialogVisible"
      title="联系我们"
      width="600px"
      :close-on-click-modal="true"
    >
      <div class="modal-content">
        <div class="contact-info-item">
          <el-icon><Message /></el-icon>
          <div class="contact-text">
            <span class="contact-label">邮箱地址</span>
            <a href="mailto:hyh@xuexianghui.com" class="contact-value">hyh@xuexianghui.com</a>
          </div>
        </div>
        <div class="contact-info-item">
          <el-icon><Clock /></el-icon>
          <div class="contact-text">
            <span class="contact-label">回复时间</span>
            <span class="contact-value">1-3个工作日</span>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">咨询类别</h5>
          <div class="modal-section-content">
            <p>欢迎就以下事项与我们联系：</p>
            <ul>
              <li>技术支持：平台使用问题、功能建议</li>
              <li>商务合作：合作推广、广告咨询</li>
              <li>版权问题：侵权举报、版权咨询</li>
              <li>用户反馈：意见建议、问题报告</li>
            </ul>
          </div>
        </div>
        <div class="modal-section">
          <h5 class="modal-section-title">温馨提示</h5>
          <div class="modal-section-content">
            <p>为了更快地处理您的问题，请在邮件中说明：</p>
            <ul>
              <li>您的联系方式</li>
              <li>问题描述的详细情况</li>
              <li>相关截图或附件（如适用）</li>
            </ul>
          </div>
        </div>
      </div>
    </el-dialog>
  </footer>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Message, ChatDotRound, Clock } from '@element-plus/icons-vue'

const currentYear = computed(() => new Date().getFullYear())

// Modal visibility states
const userAgreementDialogVisible = ref(false)
const privacyPolicyDialogVisible = ref(false)
const copyrightNoticeDialogVisible = ref(false)
const contactUsDialogVisible = ref(false)

// Modal open handlers
const openUserAgreement = () => { userAgreementDialogVisible.value = true }
const openPrivacyPolicy = () => { privacyPolicyDialogVisible.value = true }
const openCopyrightNotice = () => { copyrightNoticeDialogVisible.value = true }
const openContactUs = () => { contactUsDialogVisible.value = true }
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

// Modal content styling
.modal-content {
  max-height: 60vh;
  overflow-y: auto;
  padding: $spacing-sm 0;

  @include custom-scrollbar(8px, $border-base, $bg-secondary);
}

.modal-section {
  margin-bottom: $spacing-xl;

  &:last-child {
    margin-bottom: 0;
  }
}

.modal-section-title {
  font-size: $font-size-md;
  font-weight: $font-weight-semibold;
  color: $text-primary;
  margin: 0 0 $spacing-md 0;
  padding-bottom: $spacing-sm;
  border-bottom: 2px solid $primary-lighter;
}

.modal-section-content {
  font-size: $font-size-base;
  color: $text-regular;
  line-height: $line-height-lg;
  margin: 0;

  p {
    margin-bottom: $spacing-md;

    &:last-child {
      margin-bottom: 0;
    }
  }

  ul, ol {
    margin: $spacing-sm 0;
    padding-left: $spacing-lg;

    li {
      margin-bottom: $spacing-sm;
      color: $text-regular;

      &:last-child {
        margin-bottom: 0;
      }
    }
  }
}

.contact-info-item {
  display: flex;
  align-items: center;
  gap: $spacing-md;
  margin-bottom: $spacing-md;
  padding: $spacing-md;
  background-color: $bg-secondary;
  border-radius: $border-radius-md;

  .el-icon {
    font-size: $font-size-xl;
    color: $primary-color;
  }

  .contact-text {
    flex: 1;

    .contact-label {
      display: block;
      font-size: $font-size-sm;
      color: $text-secondary;
      margin-bottom: $spacing-xs;
    }

    .contact-value {
      display: block;
      font-size: $font-size-base;
      color: $text-primary;
      font-weight: $font-weight-medium;
      text-decoration: none;

      &:hover {
        color: $primary-color;
      }
    }
  }
}

// Mobile responsive
@include respond-to('sm') {
  .el-dialog {
    width: 95% !important;
    margin: $spacing-lg auto;
  }

  .modal-content {
    max-height: 70vh;
  }

  .modal-section {
    margin-bottom: $spacing-lg;
  }

  .modal-section-title {
    font-size: $font-size-base;
  }

  .modal-section-content {
    font-size: $font-size-sm;
  }
}
</style>
