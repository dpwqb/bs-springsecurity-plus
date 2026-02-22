package com.codermy.myspringsecurityplus.resource.dao;

import com.codermy.myspringsecurityplus.resource.entity.FavoriteRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 收藏记录数据访问层
 * @author codermy
 * @createTime 2025/2/8
 */
@Mapper
public interface FavoriteDao {

    /**
     * 保存收藏记录
     * @param record 收藏记录
     * @return 影响行数
     */
    int save(FavoriteRecord record);

    /**
     * 删除收藏记录
     * @param userId 用户ID
     * @param resourceId 资源ID
     * @return 影响行数
     */
    int delete(@Param("userId") Integer userId, @Param("resourceId") Integer resourceId);

    /**
     * 查询用户的收藏记录
     * @param userId 用户ID
     * @param params 查询参数
     * @return 收藏记录列表
     */
    List<FavoriteRecord> getFavoriteRecordsByUserId(@Param("userId") Integer userId, @Param("params") Map<String, Object> params);

    /**
     * 检查是否已收藏
     * @param userId 用户ID
     * @param resourceId 资源ID
     * @return 收藏记录
     */
    FavoriteRecord checkFavorited(@Param("userId") Integer userId, @Param("resourceId") Integer resourceId);

    /**
     * 统计资源收藏次数
     * @param resourceId 资源ID
     * @return 收藏次数
     */
    Long countFavoritesByResourceId(Integer resourceId);
}
