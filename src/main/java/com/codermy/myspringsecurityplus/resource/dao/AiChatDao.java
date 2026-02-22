package com.codermy.myspringsecurityplus.resource.dao;

import com.codermy.myspringsecurityplus.resource.entity.AiChatHistory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * AI对话记录数据访问层（创新功能）
 * @author codermy
 * @createTime 2025/2/8
 */
@Mapper
public interface AiChatDao {

    /**
     * 保存对话记录
     * @param history 对话记录
     * @return 影响行数
     */
    int save(AiChatHistory history);

    /**
     * 根据会话ID查询对话历史
     * @param sessionId 会话ID
     * @return 对话记录列表
     */
    List<AiChatHistory> getChatsBySessionId(String sessionId);

    /**
     * 根据用户ID查询对话历史
     * @param userId 用户ID
     * @return 对话记录列表
     */
    List<AiChatHistory> getChatsByUserId(Integer userId);

    /**
     * 删除会话的所有对话
     * @param sessionId 会话ID
     * @return 影响行数
     */
    int deleteBySessionId(String sessionId);

    /**
     * 统计用户消耗的token数
     * @param userId 用户ID
     * @return token总数
     */
    Long sumTokensByUserId(Integer userId);
}
