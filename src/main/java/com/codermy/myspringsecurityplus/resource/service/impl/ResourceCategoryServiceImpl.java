package com.codermy.myspringsecurityplus.resource.service.impl;

import com.codermy.myspringsecurityplus.resource.dao.ResourceCategoryDao;
import com.codermy.myspringsecurityplus.resource.entity.ResourceCategory;
import com.codermy.myspringsecurityplus.resource.service.ResourceCategoryService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 资源分类服务实现类
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Service
public class ResourceCategoryServiceImpl implements ResourceCategoryService {

    @Autowired
    private ResourceCategoryDao resourceCategoryDao;

    @Override
    public List<ResourceCategory> getAllCategories() {
        return resourceCategoryDao.getAllCategories();
    }

    @Override
    public List<ResourceCategory> getCategoriesByParentId(Integer parentId) {
        return resourceCategoryDao.getCategoriesByParentId(parentId);
    }

    @Override
    public ResourceCategory getCategoryById(Integer categoryId) {
        return resourceCategoryDao.getCategoryById(categoryId);
    }

    @Override
    @Transactional
    public int save(ResourceCategory category) {
        // 检查名称唯一性
        if (!checkCategoryNameUnique(category.getCategoryName(), null)) {
            throw new RuntimeException("分类名称已存在");
        }

        return resourceCategoryDao.save(category);
    }

    @Override
    @Transactional
    public int update(ResourceCategory category) {
        // 检查名称唯一性
        if (!checkCategoryNameUnique(category.getCategoryName(), category.getCategoryId())) {
            throw new RuntimeException("分类名称已存在");
        }

        return resourceCategoryDao.update(category);
    }

    @Override
    @Transactional
    public int delete(Integer categoryId) {
        // TODO: 检查是否有子分类
        // TODO: 检查是否有关联的资源

        return resourceCategoryDao.delete(categoryId);
    }

    @Override
    public boolean checkCategoryNameUnique(String categoryName, Integer categoryId) {
        ResourceCategory category = resourceCategoryDao.checkCategoryNameUnique(categoryName, categoryId);
        return category == null;
    }
}
