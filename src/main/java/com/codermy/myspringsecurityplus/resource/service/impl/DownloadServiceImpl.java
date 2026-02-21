package com.codermy.myspringsecurityplus.resource.service.impl;

import com.codermy.myspringsecurityplus.log.utils.LogUtils;
import com.codermy.myspringsecurityplus.log.utils.RequestHolder;
import com.codermy.myspringsecurityplus.resource.dao.DownloadDao;
import com.codermy.myspringsecurityplus.resource.dao.ResourceDao;
import com.codermy.myspringsecurityplus.resource.entity.DownloadRecord;
import com.codermy.myspringsecurityplus.resource.service.DownloadService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
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
        // 保存下载记录
        DownloadRecord record = new DownloadRecord();
        record.setResourceId(resourceId);
        record.setUserId(userId);
        record.setUserName(userName);
        record.setDownloadTime(new Date());
        record.setIpAddress(LogUtils.getIp(RequestHolder.getHttpServletRequest()));

        int result = downloadDao.save(record);

        // 增加资源下载量
        resourceDao.increaseDownloadCount(resourceId);

        log.info("保存下载记录：resourceId={}, userId={}", resourceId, userId);
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
}
