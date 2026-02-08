package com.codermy.myspringsecurityplus.resource.dao;

import com.codermy.myspringsecurityplus.resource.entity.ResourceCategory;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 资源分类数据访问层
 * @author codermy
 * @createTime 2025/2/8
 */
@Mapper
public interface ResourceCategoryDao {

    /**
     * 查询所有分类
     * @return 分类列表
     */
    List<ResourceCategory> getAllCategories();

    /**
     * 根据父ID查询子分类
     * @param parentId 父分类ID
     * @return 子分类列表
     */
    List<ResourceCategory> getCategoriesByParentId(Integer parentId);

    /**
     * 根据ID查询分类
     * @param categoryId 分类ID
     * @return 分类信息
     */
    ResourceCategory getCategoryById(Integer categoryId);

    /**
     * 保存分类
     * @param category 分类信息
     * @return 影响行数
     */
    int save(ResourceCategory category);

    /**
     * 更新分类
     * @param category 分类信息
     * @return 影响行数
     */
    int update(ResourceCategory category);

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
     * @return 分类信息
     */
    ResourceCategory checkCategoryNameUnique(String categoryName, Integer categoryId);
}
