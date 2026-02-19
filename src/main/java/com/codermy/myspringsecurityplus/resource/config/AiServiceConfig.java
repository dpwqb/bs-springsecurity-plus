package com.codermy.myspringsecurityplus.resource.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * AI服务配置类
 * 支持任意OpenAI兼容的API（OpenAI、DeepSeek、通义千问等）
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "ai.api")
public class AiServiceConfig {

    /**
     * API基础URL
     * 例如：https://api.openai.com 或 https://api.deepseek.com
     */
    private String baseUrl = "https://api.openai.com";

    /**
     * API密钥
     */
    private String key = "your-api-key-here";

    /**
     * 使用的模型
     * 例如：gpt-3.5-turbo、gpt-4、deepseek-chat等
     */
    private String model = "gpt-3.5-turbo";

    /**
     * 请求超时时间（毫秒）
     */
    private Integer timeout = 120000;

    /**
     * 最大token数
     */
    private Integer maxTokens = 1000;

    /**
     * 是否启用多轮对话（默认启用）
     */
    private Boolean enableMultiTurnChat = true;

    /**
     * 获取历史对话的最大轮数（默认10轮）
     */
    private Integer maxHistoryTurns = 10;

    /**
     * 历史对话的时间范围（天，默认7天）
     * 超过此天数的历史对话将被忽略
     */
    private Integer historyDaysLimit = 7;

    /**
     * 检查配置是否有效
     */
    public boolean isValid() {
        return baseUrl != null && !baseUrl.isEmpty()
                && key != null && !key.isEmpty()
                && !"your-api-key-here".equals(key);
    }
}
