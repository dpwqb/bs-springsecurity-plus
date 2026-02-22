package com.codermy.myspringsecurityplus.resource.service.impl;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.common.utils.ResultCode;
import com.codermy.myspringsecurityplus.log.utils.LogUtils;
import com.codermy.myspringsecurityplus.log.utils.RequestHolder;
import com.codermy.myspringsecurityplus.resource.dao.DownloadDao;
import com.codermy.myspringsecurityplus.resource.dao.ResourceDao;
import com.codermy.myspringsecurityplus.resource.dto.DownloadQueryDto;
import com.codermy.myspringsecurityplus.resource.entity.DownloadRecord;
import com.codermy.myspringsecurityplus.resource.service.DownloadService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 下载记录服务实现类
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Service
public class DownloadServiceImpl implements DownloadService {

    @Autowired
    private DownloadDao downloadDao;

    @Autowired
    private ResourceDao resourceDao;

    @Override
    @Transactional
    public int save(Integer resourceId, Integer userId, String userName) {
        // 查询资源信息获取标题
        String resourceTitle = null;
        try {
            resourceTitle = resourceDao.getResourceById(resourceId).getTitle();
        } catch (Exception e) {
            log.warn("获取资源标题失败，resourceId={}", resourceId, e);
        }

        // 保存下载记录
        DownloadRecord record = new DownloadRecord();
        record.setResourceId(resourceId);
        record.setUserId(userId);
        record.setUserName(userName);
        record.setResourceTitle(resourceTitle);
        record.setDownloadTime(new Date());
        record.setIpAddress(LogUtils.getIp(RequestHolder.getHttpServletRequest()));

        int result = downloadDao.save(record);

        // 增加资源下载量
        resourceDao.increaseDownloadCount(resourceId);

        log.info("保存下载记录：resourceId={}, userId={}, resourceTitle={}", resourceId, userId, resourceTitle);
        return result;
    }

    @Override
    public List<DownloadRecord> getDownloadRecordsByUserId(Integer userId, Map<String, Object> params) {
        return downloadDao.getDownloadRecordsByUserId(userId, params);
    }

    @Override
    public Long countDownloadsByUserId(Integer userId) {
        return downloadDao.countDownloadsByUserId(userId);
    }

    @Override
    public Result<DownloadRecord> getDownloadRecordsForAdmin(Integer offset, Integer limit, DownloadQueryDto queryDto) {
        // 处理null值，设置默认值
        if (offset == null) {
            offset = 0;
        }
        if (limit == null) {
            limit = 10;
        }

        Page page = PageHelper.offsetPage(offset, limit);

        Map<String, Object> params = new HashMap<>();
        if (queryDto != null) {
            params.put("userName", queryDto.getUserName());
            params.put("resourceTitle", queryDto.getResourceTitle());
            params.put("startTime", queryDto.getStartTime());
            params.put("endTime", queryDto.getEndTime());
            params.put("ipAddress", queryDto.getIpAddress());
        }

        List<DownloadRecord> records = downloadDao.getDownloadRecordsForAdmin(params);
        return Result.ok()
                .count(page.getTotal())
                .data(records)
                .code(ResultCode.TABLE_SUCCESS);
    }

    @Override
    @Transactional
    public int deleteDownloadRecord(Integer recordId) {
        log.info("删除下载记录：recordId={}", recordId);
        return downloadDao.deleteByRecordId(recordId);
    }

    @Override
    @Transactional
    public int batchDeleteDownloadRecords(List<Integer> recordIds) {
        log.info("批量删除下载记录：recordIds={}", recordIds);
        return downloadDao.batchDelete(recordIds);
    }

    @Override
    @Transactional
    public int deleteAllDownloadRecords() {
        log.info("清空所有下载记录");
        return downloadDao.deleteAll();
    }

    @Override
    public List<Map<String, Object>> getDownloadTrendLast6Months() {
        return downloadDao.getDownloadTrendLast6Months();
    }

    @Override
    public Integer countTodayDownloads() {
        return downloadDao.countTodayDownloads();
    }
}
