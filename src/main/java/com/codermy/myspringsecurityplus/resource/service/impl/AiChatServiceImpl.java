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
import java.util.Calendar;
import java.util.stream.Collectors;

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
        requestBody.put("messages", buildMessages(sessionId, selectedText, question, context));
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
        history.setQuestionText(question);  // 保存用户的真实问题
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
     * 构建系统提示词
     */
    private String buildSystemPrompt() {
        // return "你是「学享汇」平台的AI文章解读助手，专门帮助用户理解技术文章内容。\n\n" +
        //         "## 你的角色定位\n" +
        //         "- 你是一位经验丰富的技术导师，擅长用简洁明了的语言解释复杂概念\n" +
        //         "- 你的目标是帮助用户更好地理解文章内容，而不是替代用户阅读\n" +
        //         "- 你需要基于用户提供的文章片段进行解读，避免编造文章外的内容\n\n" +
        //         "## 回答规范\n" +
        //         "1. 长度控制：回答控制在300字以内，重点突出\n" +
        //         "2. 语言风格：使用通俗易懂的语言，避免过于学术化的表述\n" +
        //         "3. 结构清晰：使用分段、列表等方式组织内容\n" +
        //         "4. 举例说明：适当使用生活中的例子类比技术概念\n" +
        //         "5. 多轮对话：记住之前的对话内容，保持上下文连贯性\n\n" +
        //         "## 处理用户选中的文本\n" +
        //         "- 当用户选中文章中的某段文字时，重点解读该段内容\n" +
        //         "- 解释专业术语、技术原理、代码逻辑\n" +
        //         "- 必要时提供背景知识补充\n\n" +
        //         "## 应对用户提问\n" +
        //         "- 如果问题与选中内容直接相关，优先基于选中内容回答\n" +
        //         "- 如果需要更多上下文才能准确回答，明确告知用户\n" +
        //         "- 如果问题超出文章范围，诚实告知，不要编造\n\n" +
        //         "请始终保持专业、友好、耐心的态度。";
        return "请配合用户进行AI功能调试。";
    }

    /**
     * 从数据库获取历史对话并添加到消息列表
     */
    private void addHistoryMessages(String sessionId, List<Map<String, String>> messages) {
        // 1. 检查是否启用多轮对话
        if (!aiServiceConfig.getEnableMultiTurnChat()) {
            log.debug("多轮对话功能未启用，跳过加载历史对话");
            return;
        }

        try {
            // 2. 从数据库获取历史对话（已有方法：aiChatDao.getChatsBySessionId）
            List<AiChatHistory> historyList = aiChatDao.getChatsBySessionId(sessionId);
            if (historyList == null || historyList.isEmpty()) {
                log.debug("会话 {} 没有历史对话记录", sessionId);
                return;
            }

            // 3. 计算时间过滤边界
            Date timeBoundary = calculateTimeBoundary();

            // 4. 过滤并排序历史对话
            List<AiChatHistory> filteredHistory = historyList.stream()
                .filter(h -> h.getCreateTime() != null && h.getCreateTime().after(timeBoundary))
                .filter(h -> h.getQuestionText() != null && !h.getQuestionText().isEmpty()
                        && h.getAnswerText() != null && !h.getAnswerText().isEmpty())
                .sorted(Comparator.comparing(AiChatHistory::getCreateTime))
                .skip(Math.max(0, historyList.size() - aiServiceConfig.getMaxHistoryTurns()))
                .collect(Collectors.toList());

            // 5. 转换为OpenAI消息格式并添加
            for (AiChatHistory history : filteredHistory) {
                // 用户消息
                Map<String, String> userMsg = new HashMap<>();
                userMsg.put("role", "user");
                userMsg.put("content", buildHistoryUserPrompt(history));
                messages.add(userMsg);

                // AI助手消息
                Map<String, String> assistantMsg = new HashMap<>();
                assistantMsg.put("role", "assistant");
                assistantMsg.put("content", history.getAnswerText());
                messages.add(assistantMsg);
            }

            log.info("已加载 {} 条历史对话记录", filteredHistory.size());
        } catch (Exception e) {
            log.error("加载历史对话失败，使用无历史模式继续对话", e);
        }
    }

    /**
     * 计算时间过滤边界
     */
    private Date calculateTimeBoundary() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -aiServiceConfig.getHistoryDaysLimit());
        return calendar.getTime();
    }

    /**
     * 从历史记录构建用户消息
     */
    private String buildHistoryUserPrompt(AiChatHistory history) {
        // 直接返回用户的问题
        return history.getQuestionText();
    }

    /**
     * 构建当前用户消息
     */
    private String buildCurrentUserPrompt(String selectedText, String question, String context) {
        StringBuilder prompt = new StringBuilder();
        if (selectedText != null && !selectedText.isEmpty()) {
            prompt.append("我选中了文章中的以下内容：\n");
            prompt.append(selectedText);
            prompt.append("\n\n");
        }
        if (context != null && !context.isEmpty()) {
            prompt.append("文章上下文：\n");
            prompt.append(context);
            prompt.append("\n\n");
        }
        prompt.append("我的问题是：\n");
        prompt.append(question);
        return prompt.toString();
    }

    /**
     * 构建消息列表（支持多轮对话）
     */
    private List<Map<String, String>> buildMessages(String sessionId, String selectedText, String question, String context) {
        List<Map<String, String>> messages = new ArrayList<>();

        // 1. 添加系统提示词
        Map<String, String> systemMsg = new HashMap<>();
        systemMsg.put("role", "system");
        systemMsg.put("content", buildSystemPrompt());
        messages.add(systemMsg);

        // 2. 添加历史对话
        addHistoryMessages(sessionId, messages);

        // 3. 构建当前用户消息
        Map<String, String> userMsg = new HashMap<>();
        userMsg.put("role", "user");
        userMsg.put("content", buildCurrentUserPrompt(selectedText, question, context));
        messages.add(userMsg);

        return messages;
    }
}
