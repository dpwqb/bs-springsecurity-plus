package com.codermy.myspringsecurityplus.resource.service;

import com.codermy.myspringsecurityplus.resource.entity.FavoriteRecord;

import java.util.List;
import java.util.Map;

/**
 * 收藏记录服务接口
 * @author codermy
 * @createTime 2025/2/8
 */
public interface FavoriteService {

    /**
     * 保存收藏记录
     * @param resourceId 资源ID
     * @param userId 用户ID
     * @return 影响行数
     */
    int save(Integer resourceId, Integer userId);

    /**
     * 取消收藏
     * @param resourceId 资源ID
     * @param userId 用户ID
     * @return 影响行数
     */
    int delete(Integer resourceId, Integer userId);

    /**
     * 查询用户的收藏记录
     * @param userId 用户ID
     * @param params 查询参数
     * @return 收藏记录列表
     */
    List<FavoriteRecord> getFavoriteRecordsByUserId(Integer userId, Map<String, Object> params);

    /**
     * 检查是否已收藏
     * @param resourceId 资源ID
     * @param userId 用户ID
     * @return true: 已收藏, false: 未收藏
     */
    boolean checkFavorited(Integer resourceId, Integer userId);

    /**
     * 切换收藏状态
     * @param resourceId 资源ID
     * @param userId 用户ID
     * @return true: 已收藏, false: 已取消收藏
     */
    boolean toggleFavorite(Integer resourceId, Integer userId);
}
