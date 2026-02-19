package com.codermy.myspringsecurityplus.resource.service.impl;

import com.codermy.myspringsecurityplus.resource.dao.TagDao;
import com.codermy.myspringsecurityplus.resource.entity.ResourceTag;
import com.codermy.myspringsecurityplus.resource.service.TagService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 标签服务实现类
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Service
public class TagServiceImpl implements TagService {

    @Autowired
    private TagDao tagDao;

    @Override
    public List<ResourceTag> getAllTags() {
        return tagDao.getAllTags();
    }

    @Override
    public ResourceTag getTagById(Integer tagId) {
        return tagDao.getTagById(tagId);
    }

    @Override
    public ResourceTag getTagByName(String tagName) {
        return tagDao.getTagByName(tagName);
    }

    @Override
    @Transactional
    public int save(ResourceTag tag) {
        // 检查标签名称是否已存在
        ResourceTag existingTag = tagDao.getTagByName(tag.getTagName());
        if (existingTag != null) {
            throw new RuntimeException("标签名称已存在");
        }

        return tagDao.save(tag);
    }

    @Override
    @Transactional
    public int delete(Integer tagId) {
        // 先删除文章标签关联
        tagDao.deleteArticleTagRelationByTagId(tagId);
        // 再删除资源标签关联
        tagDao.deleteResourceTagRelationByTagId(tagId);
        // 最后删除标签
        return tagDao.delete(tagId);
    }

    @Override
    public List<ResourceTag> getTagsByResourceId(Integer resourceId) {
        return tagDao.getTagsByResourceId(resourceId);
    }

    @Override
    public List<ResourceTag> getTagsByArticleId(Integer articleId) {
        return tagDao.getTagsByArticleId(articleId);
    }

    @Override
    public List<ResourceTag> getHotTags(Integer limit) {
        List<ResourceTag> allTags = tagDao.getAllTags();

        // 按使用次数排序（降序）
        allTags.sort((a, b) -> b.getUseCount().compareTo(a.getUseCount()));

        // 返回前N个
        if (limit != null && limit > 0 && allTags.size() > limit) {
            return allTags.subList(0, limit);
        }

        return allTags;
    }
}
