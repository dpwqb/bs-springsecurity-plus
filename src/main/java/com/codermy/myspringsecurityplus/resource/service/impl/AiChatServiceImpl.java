package com.codermy.myspringsecurityplus.resource.service.impl;

import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.codermy.myspringsecurityplus.resource.config.AiServiceConfig;
import com.codermy.myspringsecurityplus.resource.dao.AiChatDao;
import com.codermy.myspringsecurityplus.resource.entity.AiChatHistory;
import com.codermy.myspringsecurityplus.resource.service.AiChatService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * AI对话服务实现类（创新功能核心）
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Service
public class AiChatServiceImpl implements AiChatService {

    @Autowired
    private AiChatDao aiChatDao;

    @Autowired
    private AiServiceConfig aiServiceConfig;

    @Override
    @Transactional
    public String chat(String sessionId, String selectedText, String question, String context, Integer userId) {
        // 1. 检查AI配置
        if (!aiServiceConfig.isValid()) {
            throw new RuntimeException("AI服务未配置或配置无效");
        }

        // 2. 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", aiServiceConfig.getModel());
        requestBody.put("messages", buildMessages(selectedText, question, context));
        requestBody.put("temperature", 0.7);
        requestBody.put("max_tokens", aiServiceConfig.getMaxTokens());

        // 3. 调用OpenAI兼容API
        String answer = null;
        int tokensUsed = 0;
        try {
            HttpResponse response = HttpRequest.post(aiServiceConfig.getBaseUrl() + "/v1/chat/completions")
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + aiServiceConfig.getKey())
                    .timeout(aiServiceConfig.getTimeout())
                    .body(JSONUtil.toJsonStr(requestBody))
                    .execute();

            if (!response.isOk()) {
                throw new RuntimeException("AI调用失败：" + response.getStatus());
            }

            String responseBody = response.body();
            JSONObject jsonResponse = JSONUtil.parseObj(responseBody);

            // 4. 解析响应
            if (jsonResponse.containsKey("error")) {
                throw new RuntimeException("AI返回错误：" + jsonResponse.getStr("error"));
            }

            answer = jsonResponse.getByPath("choices[0].message.content", String.class);

            // 获取token使用量
            if (jsonResponse.containsKey("usage")) {
                JSONObject usage = jsonResponse.getJSONObject("usage");
                tokensUsed = usage.getInt("total_tokens", 0);
            }

            log.info("AI调用成功：userId={}, sessionId={}, tokens={}", userId, sessionId, tokensUsed);

        } catch (Exception e) {
            log.error("AI调用失败", e);
            throw new RuntimeException("AI服务暂时不可用：" + e.getMessage());
        }

        // 5. 保存对话记录
        AiChatHistory history = new AiChatHistory();
        history.setUserId(userId);
        history.setSessionId(sessionId);
        history.setQuestionText(selectedText);
        history.setQuestionContext(context);
        history.setAnswerText(answer);
        history.setModelName(aiServiceConfig.getModel());
        history.setTokensUsed(tokensUsed);
        history.setCreateTime(new Date());

        aiChatDao.save(history);

        // 6. 返回结果
        return answer;
    }

    @Override
    public List<AiChatHistory> getChatHistory(String sessionId) {
        return aiChatDao.getChatsBySessionId(sessionId);
    }

    @Override
    public List<AiChatHistory> getChatsByUserId(Integer userId) {
        return aiChatDao.getChatsByUserId(userId);
    }

    @Override
    public int clearChatHistory(String sessionId) {
        return aiChatDao.deleteBySessionId(sessionId);
    }

    @Override
    public Long getTotalTokens(Integer userId) {
        return aiChatDao.sumTokensByUserId(userId);
    }

    /**
     * 构建消息列表
     */
    private List<Map<String, String>> buildMessages(String selectedText, String question, String context) {
        List<Map<String, String>> messages = new ArrayList<>();

        // 系统提示词
        Map<String, String> systemMsg = new HashMap<>();
        systemMsg.put("role", "system");
        systemMsg.put("content",
                "你是一个专业的计算机学习助手。请用简洁易懂的语言解释专业概念。" +
                "回答控制在200字以内，适当举例说明。");
        messages.add(systemMsg);

        // 用户消息
        Map<String, String> userMsg = new HashMap<>();
        userMsg.put("role", "user");

        StringBuilder prompt = new StringBuilder();
        if (selectedText != null && !selectedText.isEmpty()) {
            prompt.append("我选中了以下内容：\n");
            prompt.append(selectedText);
            prompt.append("\n\n");
        }

        if (context != null && !context.isEmpty()) {
            prompt.append("上下文：\n");
            prompt.append(context);
            prompt.append("\n\n");
        }

        prompt.append("我的问题是：");
        prompt.append(question);

        userMsg.put("content", prompt.toString());
        messages.add(userMsg);

        return messages;
    }
}
