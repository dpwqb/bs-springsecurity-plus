package com.codermy.myspringsecurityplus.resource.dao;

import com.codermy.myspringsecurityplus.resource.entity.ResourceTag;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 标签数据访问层（复用于资源和文章）
 * @author codermy
 * @createTime 2025/2/8
 */
@Mapper
public interface TagDao {

    /**
     * 查询所有标签
     * @return 标签列表
     */
    List<ResourceTag> getAllTags();

    /**
     * 根据ID查询标签
     * @param tagId 标签ID
     * @return 标签信息
     */
    ResourceTag getTagById(Integer tagId);

    /**
     * 根据名称查询标签
     * @param tagName 标签名称
     * @return 标签信息
     */
    ResourceTag getTagByName(String tagName);

    /**
     * 保存标签
     * @param tag 标签信息
     * @return 影响行数
     */
    int save(ResourceTag tag);

    /**
     * 更新标签使用次数
     * @param tagId 标签ID
     * @return 影响行数
     */
    int increaseUseCount(Integer tagId);

    /**
     * 删除标签
     * @param tagId 标签ID
     * @return 影响行数
     */
    int delete(Integer tagId);

    /**
     * 根据资源ID查询标签列表
     * @param resourceId 资源ID
     * @return 标签列表
     */
    List<ResourceTag> getTagsByResourceId(Integer resourceId);

    /**
     * 根据文章ID查询标签列表
     * @param articleId 文章ID
     * @return 标签列表
     */
    List<ResourceTag> getTagsByArticleId(Integer articleId);

    /**
     * 保存资源标签关联
     * @param resourceId 资源ID
     * @param tagId 标签ID
     * @return 影响行数
     */
    int saveResourceTagRelation(@Param("resourceId") Integer resourceId, @Param("tagId") Integer tagId);

    /**
     * 保存文章标签关联
     * @param articleId 文章ID
     * @param tagId 标签ID
     * @return 影响行数
     */
    int saveArticleTagRelation(@Param("articleId") Integer articleId, @Param("tagId") Integer tagId);

    /**
     * 删除资源标签关联
     * @param resourceId 资源ID
     * @return 影响行数
     */
    int deleteResourceTagRelation(Integer resourceId);

    /**
     * 删除文章标签关联
     * @param articleId 文章ID
     * @return 影响行数
     */
    int deleteArticleTagRelation(Integer articleId);
}
