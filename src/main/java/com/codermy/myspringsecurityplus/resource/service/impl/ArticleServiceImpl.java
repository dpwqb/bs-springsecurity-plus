package com.codermy.myspringsecurityplus.resource.service.impl;

import com.codermy.myspringsecurityplus.resource.dao.ArticleDao;
import com.codermy.myspringsecurityplus.resource.dao.TagDao;
import com.codermy.myspringsecurityplus.resource.dto.ArticlePublishDto;
import com.codermy.myspringsecurityplus.resource.entity.MyArticle;
import com.codermy.myspringsecurityplus.resource.entity.ResourceTag;
import com.codermy.myspringsecurityplus.resource.service.ArticleService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 文章服务实现类
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Service
public class ArticleServiceImpl implements ArticleService {

    @Autowired
    private ArticleDao articleDao;

    @Autowired
    private TagDao tagDao;

    @Override
    public List<MyArticle> getArticlesByPage(Map<String, Object> params) {
        return articleDao.getArticleByPage(params);
    }

    @Override
    public MyArticle getArticleById(Integer articleId) {
        return articleDao.getArticleById(articleId);
    }

    @Override
    @Transactional
    public MyArticle publish(ArticlePublishDto dto, Integer userId, String userName) {
        MyArticle article = new MyArticle();
        article.setTitle(dto.getTitle());
        article.setContent(dto.getContent());

        // 如果没有摘要，自动生成（截取前200字）
        if (dto.getSummary() == null || dto.getSummary().trim().isEmpty()) {
            String summary = generateSummary(dto.getContent());
            article.setSummary(summary);
        } else {
            article.setSummary(dto.getSummary());
        }

        article.setCategoryId(dto.getCategoryId());
        article.setAuthorId(userId);
        article.setAuthorName(userName);
        article.setRelatedResourceId(dto.getRelatedResourceId());
        article.setIsOriginal(dto.getIsOriginal() != null ? dto.getIsOriginal() : 1);
        article.setStatus(1); // 已发布
        article.setViewCount(0);
        article.setLikeCount(0);
        article.setCollectCount(0);
        article.setCreateTime(new Date());
        article.setUpdateTime(new Date());

        articleDao.save(article);

        // 处理标签
        if (dto.getTags() != null && !dto.getTags().trim().isEmpty()) {
            saveTags(article.getArticleId(), dto.getTags());
        }

        log.info("文章发布成功：articleId={}, title={}", article.getArticleId(), dto.getTitle());
        return article;
    }

    @Override
    @Transactional
    public MyArticle saveDraft(ArticlePublishDto dto, Integer userId, String userName) {
        MyArticle article = new MyArticle();
        article.setTitle(dto.getTitle());
        article.setContent(dto.getContent());

        // 如果没有摘要，自动生成
        if (dto.getSummary() == null || dto.getSummary().trim().isEmpty()) {
            String summary = generateSummary(dto.getContent());
            article.setSummary(summary);
        } else {
            article.setSummary(dto.getSummary());
        }

        article.setCategoryId(dto.getCategoryId());
        article.setAuthorId(userId);
        article.setAuthorName(userName);
        article.setRelatedResourceId(dto.getRelatedResourceId());
        article.setIsOriginal(dto.getIsOriginal() != null ? dto.getIsOriginal() : 1);
        article.setStatus(0); // 草稿
        article.setViewCount(0);
        article.setLikeCount(0);
        article.setCollectCount(0);
        article.setCreateTime(new Date());
        article.setUpdateTime(new Date());

        articleDao.save(article);

        // 处理标签
        if (dto.getTags() != null && !dto.getTags().trim().isEmpty()) {
            saveTags(article.getArticleId(), dto.getTags());
        }

        log.info("草稿保存成功：articleId={}, title={}", article.getArticleId(), dto.getTitle());
        return article;
    }

    @Override
    @Transactional
    public int deleteArticle(Integer articleId) {
        return articleDao.delete(articleId);
    }

    @Override
    public void increaseViewCount(Integer articleId) {
        articleDao.increaseViewCount(articleId);
    }

    @Override
    public void increaseLikeCount(Integer articleId) {
        articleDao.increaseLikeCount(articleId);
    }

    @Override
    public void increaseCollectCount(Integer articleId) {
        articleDao.increaseCollectCount(articleId);
    }

    @Override
    public List<MyArticle> getArticlesByAuthorId(Integer authorId, Map<String, Object> params) {
        return articleDao.getArticlesByAuthorId(authorId, params);
    }

    @Override
    @Transactional
    public void saveViewRecord(Integer articleId, Integer userId) {
        articleDao.saveViewRecord(articleId, userId);
    }

    /**
     * 生成摘要（去除HTML标签，截取前200字）
     */
    private String generateSummary(String htmlContent) {
        if (htmlContent == null || htmlContent.isEmpty()) {
            return "";
        }

        // 简单去除HTML标签
        String text = htmlContent.replaceAll("<[^>]+>", "");
        text = text.replaceAll("&nbsp;", " ");
        text = text.replaceAll("&lt;", "<");
        text = text.replaceAll("&gt;", ">");
        text = text.replaceAll("&amp;", "&");
        text = text.replaceAll("&quot;", "\"");

        // 截取前200字
        if (text.length() > 200) {
            text = text.substring(0, 200) + "...";
        }

        return text;
    }

    /**
     * 保存标签
     */
    private void saveTags(Integer articleId, String tags) {
        String[] tagArray = tags.split(",");
        for (String tagName : tagArray) {
            tagName = tagName.trim();
            if (tagName.isEmpty()) {
                continue;
            }

            // 查询或创建标签
            ResourceTag tag = tagDao.getTagByName(tagName);
            if (tag == null) {
                tag = new ResourceTag();
                tag.setTagName(tagName);
                tag.setUseCount(0);
                tagDao.save(tag);
            }

            // 保存关联关系
            tagDao.saveArticleTagRelation(articleId, tag.getTagId());
            tagDao.increaseUseCount(tag.getTagId());
        }
    }
}
