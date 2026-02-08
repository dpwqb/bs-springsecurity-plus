package com.codermy.myspringsecurityplus.resource.service;

import com.codermy.myspringsecurityplus.resource.entity.ArticleCategory;

import java.util.List;

/**
 * 文章分类服务接口
 * @author codermy
 * @createTime 2025/2/8
 */
public interface ArticleCategoryService {

    /**
     * 查询所有分类
     * @return 分类列表
     */
    List<ArticleCategory> getAllCategories();

    /**
     * 根据父ID查询子分类
     * @param parentId 父分类ID
     * @return 子分类列表
     */
    List<ArticleCategory> getCategoriesByParentId(Integer parentId);

    /**
     * 根据ID查询分类
     * @param categoryId 分类ID
     * @return 分类信息
     */
    ArticleCategory getCategoryById(Integer categoryId);

    /**
     * 保存分类
     * @param category 分类信息
     * @return 影响行数
     */
    int save(ArticleCategory category);

    /**
     * 更新分类
     * @param category 分类信息
     * @return 影响行数
     */
    int update(ArticleCategory category);

    /**
     * 删除分类
     * @param categoryId 分类ID
     * @return 影响行数
     */
    int delete(Integer categoryId);

    /**
     * 检查分类名称是否唯一
     * @param categoryName 分类名称
     * @param categoryId 分类ID（编辑时传入）
     * @return true: 唯一, false: 不唯一
     */
    boolean checkCategoryNameUnique(String categoryName, Integer categoryId);
}
