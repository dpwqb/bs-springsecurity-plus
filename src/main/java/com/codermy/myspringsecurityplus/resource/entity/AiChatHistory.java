package com.codermy.myspringsecurityplus.resource.entity;

import com.codermy.myspringsecurityplus.admin.entity.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * AI对话记录实体（创新功能）
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class AiChatHistory extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 对话ID */
    private Integer chatId;

    /** 用户ID */
    private Integer userId;

    /** 会话ID（UUID） */
    private String sessionId;

    /** 用户选中的问题文本 */
    private String questionText;

    /** 问题上下文（网页内容片段） */
    private String questionContext;

    /** AI回答内容 */
    private String answerText;

    /** 使用的模型 */
    private String modelName;

    /** 消耗的token数 */
    private Integer tokensUsed;

    /** 对话时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;
}
