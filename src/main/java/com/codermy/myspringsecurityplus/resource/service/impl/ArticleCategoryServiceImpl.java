package com.codermy.myspringsecurityplus.resource.service.impl;

import com.codermy.myspringsecurityplus.resource.dao.ArticleCategoryDao;
import com.codermy.myspringsecurityplus.resource.dto.CategoryDto;
import com.codermy.myspringsecurityplus.resource.entity.ArticleCategory;
import com.codermy.myspringsecurityplus.resource.service.ArticleCategoryService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 文章分类服务实现类
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Service
public class ArticleCategoryServiceImpl implements ArticleCategoryService {

    @Autowired
    private ArticleCategoryDao articleCategoryDao;

    @Override
    public List<ArticleCategory> getAllCategories() {
        return articleCategoryDao.getAllCategories();
    }

    @Override
    public List<ArticleCategory> getCategoriesByParentId(Integer parentId) {
        return articleCategoryDao.getCategoriesByParentId(parentId);
    }

    @Override
    public ArticleCategory getCategoryById(Integer categoryId) {
        return articleCategoryDao.getCategoryById(categoryId);
    }

    @Override
    @Transactional
    public int save(ArticleCategory category) {
        // 检查名称唯一性
        if (!checkCategoryNameUnique(category.getCategoryName(), null)) {
            throw new RuntimeException("分类名称已存在");
        }

        return articleCategoryDao.save(category);
    }

    @Override
    @Transactional
    public int update(ArticleCategory category) {
        // 检查名称唯一性
        if (!checkCategoryNameUnique(category.getCategoryName(), category.getCategoryId())) {
            throw new RuntimeException("分类名称已存在");
        }

        return articleCategoryDao.update(category);
    }

    @Override
    @Transactional
    public int delete(Integer categoryId) {
        // TODO: 检查是否有子分类
        // TODO: 检查是否有关联的文章

        return articleCategoryDao.delete(categoryId);
    }

    @Override
    public boolean checkCategoryNameUnique(String categoryName, Integer categoryId) {
        ArticleCategory category = articleCategoryDao.checkCategoryNameUnique(categoryName, categoryId);
        return category == null;
    }

    @Override
    public List<CategoryDto> buildCategoryTree() {
        return articleCategoryDao.buildCategoryTree();
    }

    @Override
    public List<CategoryDto> buildCategoryTreeExcluding(Integer excludeId) {
        if (excludeId == null || excludeId == 0) {
            // 如果没有指定排除ID或为顶级分类，返回全部
            return buildCategoryTree();
        }
        return articleCategoryDao.buildCategoryTreeExcluding(excludeId);
    }
}
