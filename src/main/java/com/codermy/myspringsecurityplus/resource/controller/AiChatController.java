package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.resource.dto.AiChatRequestDto;
import com.codermy.myspringsecurityplus.resource.dto.AiChatResponseDto;
import com.codermy.myspringsecurityplus.resource.entity.AiChatHistory;
import com.codermy.myspringsecurityplus.resource.service.AiChatService;
import com.codermy.myspringsecurityplus.common.utils.SecurityUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * AI对话Controller（创新功能核心）
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Controller
@RequestMapping("/api/ai")
@Api(tags = "AI对话功能")
public class AiChatController {

    @Autowired
    private AiChatService aiChatService;

    @PostMapping("/chat")
    @ResponseBody
    @ApiOperation(value = "AI对话")
    @MyLog("AI对话")
    public Result<AiChatResponseDto> chat(@RequestBody AiChatRequestDto request) {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();

            // 如果没有sessionId，生成新的UUID
            if (request.getSessionId() == null || request.getSessionId().isEmpty()) {
                request.setSessionId(UUID.randomUUID().toString());
            }

            String answer = aiChatService.chat(
                    request.getSessionId(),
                    request.getSelectedText(),
                    request.getQuestion(),
                    request.getContext(),
                    userId
            );

            AiChatResponseDto responseDto = new AiChatResponseDto();
            responseDto.setAnswer(answer);

            return Result.ok()
                    .data(java.util.Collections.singletonList(responseDto))
                    .message("AI回答成功");

        } catch (Exception e) {
            log.error("AI对话失败", e);
            return Result.error().message("AI服务暂时不可用：" + e.getMessage());
        }
    }

    @GetMapping("/history/{sessionId}")
    @ResponseBody
    @ApiOperation(value = "获取对话历史")
    public Result<AiChatHistory> getHistory(@PathVariable String sessionId) {
        try {
            List<AiChatHistory> history = aiChatService.getChatHistory(sessionId);

            return Result.ok()
                    .data(history)
                    .message("查询成功");

        } catch (Exception e) {
            log.error("查询对话历史失败", e);
            return Result.error().message("查询失败：" + e.getMessage());
        }
    }

    @DeleteMapping("/history/{sessionId}")
    @ResponseBody
    @ApiOperation(value = "清空对话历史")
    @MyLog("清空AI对话历史")
    public Result clearHistory(@PathVariable String sessionId) {
        try {
            int result = aiChatService.clearChatHistory(sessionId);
            return Result.judge(result, "清空");
        } catch (Exception e) {
            log.error("清空对话历史失败", e);
            return Result.error().message("清空失败：" + e.getMessage());
        }
    }

    @GetMapping("/tokens")
    @ResponseBody
    @ApiOperation(value = "获取我的token消耗统计")
    public Result getTotalTokens() {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            Long totalTokens = aiChatService.getTotalTokens(userId);

            return Result.ok()
                    .data(java.util.Collections.singletonList(totalTokens))
                    .message("查询成功");

        } catch (Exception e) {
            log.error("查询token统计失败", e);
            return Result.error().message("查询失败：" + e.getMessage());
        }
    }
}
