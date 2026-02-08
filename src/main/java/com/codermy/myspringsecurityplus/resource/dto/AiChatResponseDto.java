package com.codermy.myspringsecurityplus.resource.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * AI对话响应DTO
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@ApiModel("AI对话响应")
public class AiChatResponseDto {

    @ApiModelProperty(value = "AI回答内容")
    private String answer;

    @ApiModelProperty(value = "对话记录ID")
    private Integer chatId;

    @ApiModelProperty(value = "消耗的token数")
    private Integer tokensUsed;
}
