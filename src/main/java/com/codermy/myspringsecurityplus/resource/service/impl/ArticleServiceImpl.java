package com.codermy.myspringsecurityplus.resource.service.impl;

import com.codermy.myspringsecurityplus.resource.config.FileUploadConfig;
import com.codermy.myspringsecurityplus.resource.dao.ArticleDao;
import com.codermy.myspringsecurityplus.resource.dao.TagDao;
import com.codermy.myspringsecurityplus.resource.dto.ArticlePublishDto;
import com.codermy.myspringsecurityplus.resource.dto.ArticleStatisticsDto;
import com.codermy.myspringsecurityplus.resource.entity.MyArticle;
import com.codermy.myspringsecurityplus.resource.entity.ResourceTag;
import com.codermy.myspringsecurityplus.resource.service.ArticleService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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

    @Autowired
    private FileUploadConfig fileUploadConfig;

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
        MyArticle article;

        // 判断是新建还是更新
        if (dto.getArticleId() != null && dto.getArticleId() > 0) {
            // 更新模式：从草稿发布
            article = articleDao.getArticleById(dto.getArticleId());
            if (article == null) {
                throw new RuntimeException("文章不存在");
            }

            // 验证权限：只能发布自己的文章
            if (!article.getAuthorId().equals(userId)) {
                throw new RuntimeException("无权发布他人文章");
            }

            // 更新字段
            article.setTitle(dto.getTitle());
            article.setContent(dto.getContent());
            article.setSummary(dto.getSummary() != null ? dto.getSummary() : generateSummary(dto.getContent()));
            article.setCategoryId(dto.getCategoryId());

            // 保留已有封面，如果DTO中有新封面则更新
            if (dto.getCoverImage() != null && !dto.getCoverImage().isEmpty()) {
                article.setCoverImage(dto.getCoverImage());
            }
            // 如果草稿有封面但DTO为空，保留草稿的封面
            else if (article.getCoverImage() == null || article.getCoverImage().isEmpty()) {
                article.setCoverImage(dto.getCoverImage());
            }

            article.setRelatedResourceId(dto.getRelatedResourceId());
            article.setIsOriginal(dto.getIsOriginal() != null ? dto.getIsOriginal() : 1);
            article.setStatus(1); // 已发布
            article.setPublishTime(new Date()); // 设置发布时间
            article.setUpdateTime(new Date());

            articleDao.update(article);

            // 删除旧标签关联，插入新标签
            if (dto.getTags() != null) {
                saveArticleTags(article.getArticleId(), dto.getTags());
            }

            log.info("文章从草稿发布成功：articleId={}, title={}", article.getArticleId(), dto.getTitle());

        } else {
            // 新建模式：直接发布
            article = new MyArticle();
            article.setTitle(dto.getTitle());
            article.setContent(dto.getContent());
            article.setSummary(dto.getSummary() != null ? dto.getSummary() : generateSummary(dto.getContent()));
            article.setCategoryId(dto.getCategoryId());
            article.setCoverImage(dto.getCoverImage()); // 直接使用封面
            article.setAuthorId(userId);
            article.setAuthorName(userName);
            article.setRelatedResourceId(dto.getRelatedResourceId());
            article.setIsOriginal(dto.getIsOriginal() != null ? dto.getIsOriginal() : 1);
            article.setStatus(1); // 已发布
            article.setViewCount(0);
            article.setLikeCount(0);
            article.setCollectCount(0);
            article.setPublishTime(new Date()); // 设置发布时间
            article.setCreateTime(new Date());
            article.setUpdateTime(new Date());

            articleDao.save(article);

            // 插入标签关联
            if (dto.getTags() != null && !dto.getTags().isEmpty()) {
                saveArticleTags(article.getArticleId(), dto.getTags());
            }

            log.info("文章发布成功：articleId={}, title={}", article.getArticleId(), dto.getTitle());
        }

        return article;
    }

    @Override
    public String saveCoverImage(MultipartFile file, Integer userId, String userName) {
        // 1. 生成唯一文件名
        String originalName = file.getOriginalFilename();
        String extension = getFileExtension(originalName);
        String newFileName = UUID.randomUUID().toString().replace("-", "") + "." + extension;

        // 2. 按日期创建目录: uploads/article/2024/02/
        String datePath = new SimpleDateFormat("yyyy/MM").format(new Date());
        String relativePath = "article/" + datePath + "/" + newFileName;
        String fullPath = fileUploadConfig.getPath() + relativePath;

        // 3. 保存文件
        try {
            File destFile = new File(fullPath);
            if (!destFile.getParentFile().exists()) {
                destFile.getParentFile().mkdirs();
            }
            file.transferTo(destFile);
            log.info("文章封面保存成功：userId={}, path={}", userId, relativePath);
        } catch (Exception e) {
            log.error("文章封面保存失败", e);
            throw new RuntimeException("图片保存失败：" + e.getMessage());
        }

        return relativePath;
    }

    private String getFileExtension(String filename) {
        if (filename == null || filename.isEmpty()) {
            return "";
        }
        int lastDot = filename.lastIndexOf(".");
        return lastDot > 0 ? filename.substring(lastDot + 1).toLowerCase() : "";
    }

    @Override
    @Transactional
    public MyArticle saveDraft(ArticlePublishDto dto, Integer userId, String userName) {
        MyArticle article;

        // 判断是新建还是更新草稿
        if (dto.getArticleId() != null && dto.getArticleId() > 0) {
            // 更新现有草稿
            article = articleDao.getArticleById(dto.getArticleId());
            if (article == null) {
                throw new RuntimeException("文章不存在");
            }

            // 验证权限
            if (!article.getAuthorId().equals(userId)) {
                throw new RuntimeException("无权编辑他人文章");
            }

            article.setTitle(dto.getTitle());
            article.setContent(dto.getContent());
            article.setSummary(dto.getSummary() != null ? dto.getSummary() : generateSummary(dto.getContent()));
            article.setCategoryId(dto.getCategoryId());
            article.setCoverImage(dto.getCoverImage()); // 保存封面
            article.setRelatedResourceId(dto.getRelatedResourceId());
            article.setIsOriginal(dto.getIsOriginal() != null ? dto.getIsOriginal() : 1);
            article.setStatus(0); // 保持草稿状态
            article.setUpdateTime(new Date());

            articleDao.update(article);

            // 更新标签
            if (dto.getTags() != null) {
                saveArticleTags(article.getArticleId(), dto.getTags());
            }

            log.info("草稿更新成功：articleId={}, title={}", article.getArticleId(), dto.getTitle());

        } else {
            // 创建新草稿
            article = new MyArticle();
            article.setTitle(dto.getTitle());
            article.setContent(dto.getContent());
            article.setSummary(dto.getSummary() != null ? dto.getSummary() : generateSummary(dto.getContent()));
            article.setCategoryId(dto.getCategoryId());
            article.setCoverImage(dto.getCoverImage()); // 保存封面
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

            if (dto.getTags() != null && !dto.getTags().isEmpty()) {
                saveArticleTags(article.getArticleId(), dto.getTags());
            }

            log.info("草稿保存成功：articleId={}, title={}", article.getArticleId(), dto.getTitle());
        }

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
     * 保存文章标签关联（使用标签ID列表）
     * @param articleId 文章ID
     * @param tagIds 标签ID列表
     */
    private void saveArticleTags(Integer articleId, List<Integer> tagIds) {
        if (tagIds == null || tagIds.isEmpty()) {
            return;
        }

        // 1. 先删除该文章的所有旧标签关联
        tagDao.deleteArticleTagRelation(articleId);

        // 2. 验证并插入新的标签关联
        for (Integer tagId : tagIds) {
            if (tagId == null) {
                continue;
            }

            // 验证标签是否存在
            ResourceTag tag = tagDao.getTagById(tagId);
            if (tag != null) {
                // 保存关联关系
                tagDao.saveArticleTagRelation(articleId, tagId);
                // 增加标签使用次数
                tagDao.increaseUseCount(tagId);
            } else {
                log.warn("标签ID不存在: {}", tagId);
            }
        }
    }

    /**
     * 管理员获取所有文章（包括草稿和已下架）
     * @param params 查询参数
     * @return 文章列表
     */
    @Override
    public List<MyArticle> getAllArticlesForAdmin(Map<String, Object> params) {
        return articleDao.getAllArticlesForAdmin(params);
    }

    /**
     * 更新文章状态
     * @param articleId 文章ID
     * @param status 状态（0:草稿 1:已发布 2:已下架）
     * @return 影响行数
     */
    @Override
    @Transactional
    public boolean updateArticleStatus(Integer articleId, Integer status) {
        return articleDao.updateArticleStatus(articleId, status) > 0;
    }

    /**
     * 批量更新文章状态
     * @param articleIds 文章ID数组
     * @param status 状态（0:草稿 1:已发布 2:已下架）
     * @return 影响行数
     */
    @Override
    @Transactional
    public boolean batchUpdateArticleStatus(Integer[] articleIds, Integer status) {
        return articleDao.batchUpdateArticleStatus(Arrays.asList(articleIds), status) > 0;
    }

    /**
     * 获取文章统计
     * @return 统计数据
     */
    @Override
    public ArticleStatisticsDto getArticleStatistics() {
        Map<String, Object> map = articleDao.getArticleStatistics();
        ArticleStatisticsDto dto = new ArticleStatisticsDto();
        dto.setTotalArticles(((Number) map.getOrDefault("totalArticles", 0)).longValue());
        dto.setTodayArticles(((Number) map.getOrDefault("todayArticles", 0)).intValue());
        dto.setTotalViews(((Number) map.getOrDefault("totalViews", 0)).longValue());
        dto.setTotalLikes(((Number) map.getOrDefault("totalLikes", 0)).longValue());
        return dto;
    }

    @Override
    @Transactional
    public boolean toggleLike(Integer articleId, Integer userId, String userName) {
        MyArticle article = articleDao.getArticleById(articleId);
        if (article == null) {
            throw new RuntimeException("文章不存在");
        }

        // 检查是否已点赞
        Integer recordId = articleDao.checkUserLike(articleId, userId);

        if (recordId != null) {
            // 已点赞，执行取消点赞
            articleDao.cancelLike(recordId);
            articleDao.decreaseLikeCount(articleId);
            log.info("用户取消点赞：articleId={}, userId={}", articleId, userId);
            return false; // 返回false表示未点赞状态
        } else {
            // 未点赞，执行点赞
            articleDao.addLikeRecord(articleId, userId, userName, article.getTitle());
            articleDao.increaseLikeCount(articleId);
            log.info("用户点赞：articleId={}, userId={}", articleId, userId);
            return true; // 返回true表示已点赞状态
        }
    }

    @Override
    public boolean checkUserLiked(Integer articleId, Integer userId) {
        return articleDao.checkUserLike(articleId, userId) != null;
    }
}
