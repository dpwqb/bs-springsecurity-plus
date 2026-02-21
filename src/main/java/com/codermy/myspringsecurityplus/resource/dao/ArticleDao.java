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
     * @param ipAddress 浏览IP地址
     * @return 影响行数
     */
    int saveViewRecord(@Param("articleId") Integer articleId, @Param("userId") Integer userId, @Param("ipAddress") String ipAddress);

    /**
     * 管理员获取所有文章（包括草稿和已下架）
     * @param params 查询参数
     * @return 文章列表
     */
    List<MyArticle> getAllArticlesForAdmin(@Param("params") Map<String, Object> params);

    /**
     * 更新文章状态
     * @param articleId 文章ID
     * @param status 状态（0:草稿 1:已发布 2:已下架）
     * @return 影响行数
     */
    int updateArticleStatus(@Param("articleId") Integer articleId, @Param("status") Integer status);

    /**
     * 批量更新文章状态
     * @param articleIds 文章ID数组
     * @param status 状态（0:草稿 1:已发布 2:已下架）
     * @return 影响行数
     */
    int batchUpdateArticleStatus(@Param("articleIds") List<Integer> articleIds, @Param("status") Integer status);

    /**
     * 获取文章统计
     * @return 统计数据
     */
    Map<String, Object> getArticleStatistics();

    /**
     * 检查用户是否已点赞
     * @param articleId 文章ID
     * @param userId 用户ID
     * @return 记录ID，未点赞返回null
     */
    Integer checkUserLike(@Param("articleId") Integer articleId, @Param("userId") Integer userId);

    /**
     * 添加点赞记录
     * @param articleId 文章ID
     * @param userId 用户ID
     * @param userName 用户名
     * @param articleTitle 文章标题
     * @return 影响行数
     */
    int addLikeRecord(@Param("articleId") Integer articleId,
                      @Param("userId") Integer userId,
                      @Param("userName") String userName,
                      @Param("articleTitle") String articleTitle);

    /**
     * 取消点赞（软删除）
     * @param recordId 记录ID
     * @return 影响行数
     */
    int cancelLike(@Param("recordId") Integer recordId);

    /**
     * 减少点赞数
     * @param articleId 文章ID
     * @return 影响行数
     */
    int decreaseLikeCount(Integer articleId);
}
