package com.codermy.myspringsecurityplus.resource.dao;

import com.codermy.myspringsecurityplus.resource.entity.MyArticle;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 文章数据访问层
 * @author codermy
 * @createTime 2025/2/8
 */
@Mapper
public interface ArticleDao {

    /**
     * 分页查询文章列表
     * @param params 查询参数
     * @return 文章列表
     */
    List<MyArticle> getArticleByPage(@Param("params") Map<String, Object> params);

    /**
     * 根据ID查询文章详情
     * @param articleId 文章ID
     * @return 文章详情
     */
    MyArticle getArticleById(Integer articleId);

    /**
     * 保存文章
     * @param article 文章信息
     * @return 影响行数
     */
    int save(MyArticle article);

    /**
     * 更新文章
     * @param article 文章信息
     * @return 影响行数
     */
    int update(MyArticle article);

    /**
     * 删除文章
     * @param articleId 文章ID
     * @return 影响行数
     */
    int delete(Integer articleId);

    /**
     * 增加浏览量
     * @param articleId 文章ID
     * @return 影响行数
     */
    int increaseViewCount(Integer articleId);

    /**
     * 增加点赞数
     * @param articleId 文章ID
     * @return 影响行数
     */
    int increaseLikeCount(Integer articleId);

    /**
     * 增加收藏数
     * @param articleId 文章ID
     * @return 影响行数
     */
    int increaseCollectCount(Integer articleId);

    /**
     * 查询用户的文章列表
     * @param authorId 作者ID
     * @param params 查询参数
     * @return 文章列表
     */
    List<MyArticle> getArticlesByAuthorId(@Param("authorId") Integer authorId, @Param("params") Map<String, Object> params);

    /**
     * 保存文章浏览记录
     * @param articleId 文章ID
     * @param userId 用户ID
     * @return 影响行数
     */
    int saveViewRecord(@Param("articleId") Integer articleId, @Param("userId") Integer userId);
}
