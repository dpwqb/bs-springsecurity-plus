package com.codermy.myspringsecurityplus.resource.dao;

import com.codermy.myspringsecurityplus.resource.entity.DownloadRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 下载记录数据访问层
 * @author codermy
 * @createTime 2025/2/8
 */
@Mapper
public interface DownloadDao {

    /**
     * 保存下载记录
     * @param record 下载记录
     * @return 影响行数
     */
    int save(DownloadRecord record);

    /**
     * 查询用户的下载记录
     * @param userId 用户ID
     * @param params 查询参数
     * @return 下载记录列表
     */
    List<DownloadRecord> getDownloadRecordsByUserId(@Param("userId") Integer userId, @Param("params") Map<String, Object> params);

    /**
     * 查询资源的下载记录
     * @param resourceId 资源ID
     * @return 下载记录列表
     */
    List<DownloadRecord> getDownloadRecordsByResourceId(Integer resourceId);

    /**
     * 统计用户下载次数
     * @param userId 用户ID
     * @return 下载次数
     */
    Long countDownloadsByUserId(Integer userId);
}
