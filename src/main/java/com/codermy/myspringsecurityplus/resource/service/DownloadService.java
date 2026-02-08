package com.codermy.myspringsecurityplus.resource.service;

import com.codermy.myspringsecurityplus.resource.entity.DownloadRecord;

import java.util.List;
import java.util.Map;

/**
 * 下载记录服务接口
 * @author codermy
 * @createTime 2025/2/8
 */
public interface DownloadService {

    /**
     * 保存下载记录
     * @param resourceId 资源ID
     * @param userId 用户ID
     * @param userName 用户名
     * @return 影响行数
     */
    int save(Integer resourceId, Integer userId, String userName);

    /**
     * 查询用户的下载记录
     * @param userId 用户ID
     * @param params 查询参数
     * @return 下载记录列表
     */
    List<DownloadRecord> getDownloadRecordsByUserId(Integer userId, Map<String, Object> params);

    /**
     * 统计用户下载次数
     * @param userId 用户ID
     * @return 下载次数
     */
    Long countDownloadsByUserId(Integer userId);
}
