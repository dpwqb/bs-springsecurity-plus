package com.codermy.myspringsecurityplus.resource.service;

import com.codermy.myspringsecurityplus.resource.dto.ArticlePublishDto;
import com.codermy.myspringsecurityplus.resource.entity.MyArticle;
import com.codermy.myspringsecurityplus.resource.dto.ArticleStatisticsDto;

import java.util.Map;
import java.util.List;

/**
 * 文章服务接口
 * @author codermy
 * @createTime 2025/2/8
 */
public interface ArticleService {

    /**
     * 分页查询文章列表
     * @param params 查询参数（keyword, categoryId, status等）
     * @return 文章列表
     */
    List<MyArticle> getArticlesByPage(Map<String, Object> params);

    /**
     * 根据ID查询文章详情
     * @param articleId 文章ID
     * @return 文章详情
     */
    MyArticle getArticleById(Integer articleId);

    /**
     * 发布文章
     * @param dto 文章发布请求DTO
     * @param userId 作者ID
     * @param userName 作者名称
     * @return 文章信息
     */
    MyArticle publish(ArticlePublishDto dto, Integer userId, String userName);

    /**
     * 保存草稿
     * @param dto 文章发布请求DTO
     * @param userId 作者ID
     * @param userName 作者名称
     * @return 文章信息
     */
    MyArticle saveDraft(ArticlePublishDto dto, Integer userId, String userName);

    /**
     * 删除文章
     * @param articleId 文章ID
     * @return 影响行数
     */
    int deleteArticle(Integer articleId);

    /**
     * 增加浏览量
     * @param articleId 文章ID
     */
    void increaseViewCount(Integer articleId);

    /**
     * 增加点赞数
     * @param articleId 文章ID
     */
    void increaseLikeCount(Integer articleId);

    /**
     * 增加收藏数
     * @param articleId 文章ID
     */
    void increaseCollectCount(Integer articleId);

    /**
     * 查询用户的文章列表
     * @param authorId 作者ID
     * @param params 查询参数
     * @return 文章列表
     */
    List<MyArticle> getArticlesByAuthorId(Integer authorId, Map<String, Object> params);

    /**
     * 保存文章浏览记录
     * @param articleId 文章ID
     * @param userId 用户ID
     * @return 影响行数
     */
    void saveViewRecord(Integer articleId, Integer userId);

    /**
     * 管理员获取所有文章（包括草稿和已下架）
     * @param params 查询参数
     * @return 文章列表
     */
    List<MyArticle> getAllArticlesForAdmin(Map<String, Object> params);

    /**
     * 更新文章状态
     * @param articleId 文章ID
     * @param status 状态（0:草稿 1:已发布 2:已下架）
     * @return 影响行数
     */
    boolean updateArticleStatus(Integer articleId, Integer status);

    /**
     * 批量更新文章状态
     * @param articleIds 文章ID数组
     * @param status 状态（0:草稿 1:已发布 2:已下架）
     * @return 影响行数
     */
    boolean batchUpdateArticleStatus(Integer[] articleIds, Integer status);

    /**
     * 获取文章统计
     * @return 统计数据
     */
    ArticleStatisticsDto getArticleStatistics();
}
