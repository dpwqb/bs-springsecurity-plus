package com.codermy.myspringsecurityplus.resource.service;

import com.codermy.myspringsecurityplus.resource.entity.ResourceTag;

import java.util.List;

/**
 * 标签服务接口
 * @author codermy
 * @createTime 2025/2/8
 */
public interface TagService {

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
     * 获取热门标签（按使用次数排序）
     * @param limit 返回数量
     * @return 标签列表
     */
    List<ResourceTag> getHotTags(Integer limit);
}
