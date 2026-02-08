package com.codermy.myspringsecurityplus.resource.service;

import com.codermy.myspringsecurityplus.resource.entity.AiChatHistory;

import java.util.List;

/**
 * AI对话服务接口（创新功能）
 * @author codermy
 * @createTime 2025/2/8
 */
public interface AiChatService {

    /**
     * AI对话
     * @param sessionId 会话ID
     * @param selectedText 用户选中的文本
     * @param question 用户问题
     * @param context 问题上下文
     * @param userId 用户ID
     * @return AI回答
     */
    String chat(String sessionId, String selectedText, String question, String context, Integer userId);

    /**
     * 获取对话历史
     * @param sessionId 会话ID
     * @return 对话历史列表
     */
    List<AiChatHistory> getChatHistory(String sessionId);

    /**
     * 获取用户的所有对话
     * @param userId 用户ID
     * @return 对话历史列表
     */
    List<AiChatHistory> getChatsByUserId(Integer userId);

    /**
     * 清空会话历史
     * @param sessionId 会话ID
     * @return 影响行数
     */
    int clearChatHistory(String sessionId);

    /**
     * 统计用户消耗的token数
     * @param userId 用户ID
     * @return token总数
     */
    Long getTotalTokens(Integer userId);
}
