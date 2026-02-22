package com.codermy.myspringsecurityplus.resource.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * AI对话请求DTO（创新功能）
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@ApiModel("AI对话请求")
public class AiChatRequestDto {

    @ApiModelProperty(value = "会话ID（UUID，用于多轮对话）", required = true)
    private String sessionId;

    @ApiModelProperty(value = "用户选中的文本")
    private String selectedText;

    @ApiModelProperty(value = "用户问题", required = true)
    private String question;

    @ApiModelProperty(value = "问题上下文（网页内容片段）")
    private String context;
}
