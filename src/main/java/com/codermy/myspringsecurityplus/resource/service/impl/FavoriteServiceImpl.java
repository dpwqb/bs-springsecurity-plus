package com.codermy.myspringsecurityplus.resource.service.impl;

import com.codermy.myspringsecurityplus.resource.dao.FavoriteDao;
import com.codermy.myspringsecurityplus.resource.dao.ResourceDao;
import com.codermy.myspringsecurityplus.resource.entity.FavoriteRecord;
import com.codermy.myspringsecurityplus.resource.service.FavoriteService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 收藏记录服务实现类
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Service
public class FavoriteServiceImpl implements FavoriteService {

    @Autowired
    private FavoriteDao favoriteDao;

    @Autowired
    private ResourceDao resourceDao;

    @Override
    @Transactional
    public int save(Integer resourceId, Integer userId) {
        // 检查是否已收藏
        if (checkFavorited(resourceId, userId)) {
            throw new RuntimeException("已收藏该资源");
        }

        // 保存收藏记录
        FavoriteRecord record = new FavoriteRecord();
        record.setResourceId(resourceId);
        record.setUserId(userId);
        record.setCreateTime(new Date());

        int result = favoriteDao.save(record);

        // 增加资源收藏量
        resourceDao.increaseCollectCount(resourceId);

        log.info("保存收藏记录：resourceId={}, userId={}", resourceId, userId);
        return result;
    }

    @Override
    @Transactional
    public int delete(Integer resourceId, Integer userId) {
        int result = favoriteDao.delete(userId, resourceId);

        // 减少资源收藏量
        if (result > 0) {
            // TODO: 需要在ResourceDao中添加decreaseCollectCount方法
            // resourceDao.decreaseCollectCount(resourceId);
        }

        log.info("取消收藏：resourceId={}, userId={}", resourceId, userId);
        return result;
    }

    @Override
    public List<FavoriteRecord> getFavoriteRecordsByUserId(Integer userId, Map<String, Object> params) {
        return favoriteDao.getFavoriteRecordsByUserId(userId, params);
    }

    @Override
    public boolean checkFavorited(Integer resourceId, Integer userId) {
        FavoriteRecord record = favoriteDao.checkFavorited(userId, resourceId);
        return record != null;
    }

    @Override
    @Transactional
    public boolean toggleFavorite(Integer resourceId, Integer userId) {
        if (checkFavorited(resourceId, userId)) {
            delete(resourceId, userId);
            return false;
        } else {
            save(resourceId, userId);
            return true;
        }
    }
}
