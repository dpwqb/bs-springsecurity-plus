package com.codermy.myspringsecurityplus.resource.service;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.resource.dto.DownloadQueryDto;
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

    /**
     * 分页查询所有下载记录（管理员）
     * @param offset 起始位置
     * @param limit 每页数量
     * @param queryDto 查询条件
     * @return 分页结果
     */
    Result<DownloadRecord> getDownloadRecordsForAdmin(Integer offset, Integer limit, DownloadQueryDto queryDto);

    /**
     * 删除单条下载记录
     * @param recordId 记录ID
     * @return 影响行数
     */
    int deleteDownloadRecord(Integer recordId);

    /**
     * 批量删除下载记录
     * @param recordIds 记录ID列表
     * @return 影响行数
     */
    int batchDeleteDownloadRecords(List<Integer> recordIds);

    /**
     * 删除所有下载记录
     * @return 影响行数
     */
    int deleteAllDownloadRecords();

    /**
     * 获取最近6个月的下载趋势数据
     * @return 月份和下载次数的列表
     */
    List<Map<String, Object>> getDownloadTrendLast6Months();

    /**
     * 统计今日下载次数
     * @return 今日下载次数
     */
    Integer countTodayDownloads();
}
