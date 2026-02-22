package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.resource.dto.CategoryDto;
import com.codermy.myspringsecurityplus.resource.entity.ArticleCategory;
import com.codermy.myspringsecurityplus.resource.service.ArticleCategoryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 文章分类管理Controller
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Controller
@RequestMapping("/api/article/category")
@Api(tags = "文章分类管理")
public class ArticleCategoryController {

    @Autowired
    private ArticleCategoryService articleCategoryService;

    @GetMapping
    @ResponseBody
    @ApiOperation(value = "查询所有分类")
    public Result<ArticleCategory> list() {
        List<ArticleCategory> categories = articleCategoryService.getAllCategories();
        return Result.ok()
                .data(categories)
                .message("查询成功");
    }

    @GetMapping("/tree")
    @ResponseBody
    @ApiOperation(value = "查询分类树（用于dtree组件）")
    public Result buildTree(@RequestParam(required = false) Integer excludeId) {
        List<CategoryDto> tree;

        if (excludeId != null && excludeId > 0) {
            // 编辑模式：排除当前分类及其子分类
            tree = articleCategoryService.buildCategoryTreeExcluding(excludeId);
        } else {
            // 新增模式：返回所有分类
            tree = articleCategoryService.buildCategoryTree();
        }

        return Result.ok()
                .code(200)  // 确保 dtree 能正确识别成功状态
                .data(tree)
                .message("查询成功");
    }

    @GetMapping("/{categoryId}")
    @ResponseBody
    @ApiOperation(value = "根据ID查询分类")
    public Result<ArticleCategory> getById(@PathVariable Integer categoryId) {
        ArticleCategory category = articleCategoryService.getCategoryById(categoryId);
        if (category == null) {
            return Result.error().message("分类不存在");
        }
        return Result.ok()
                .data(java.util.Collections.singletonList(category))
                .message("查询成功");
    }

    @PostMapping
    @ResponseBody
    @ApiOperation(value = "新增分类")
    @PreAuthorize("hasAnyAuthority('article:manage')")
    @MyLog("新增文章分类")
    public Result save(@RequestBody ArticleCategory category) {
        try {
            int result = articleCategoryService.save(category);
            return Result.judge(result, "新增");
        } catch (Exception e) {
            log.error("新增分类失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @PutMapping
    @ResponseBody
    @ApiOperation(value = "修改分类")
    @PreAuthorize("hasAnyAuthority('article:manage')")
    @MyLog("修改文章分类")
    public Result update(@RequestBody ArticleCategory category) {
        try {
            int result = articleCategoryService.update(category);
            return Result.judge(result, "修改");
        } catch (Exception e) {
            log.error("修改分类失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @DeleteMapping("/{categoryId}")
    @ResponseBody
    @ApiOperation(value = "删除分类")
    @PreAuthorize("hasAnyAuthority('article:manage')")
    @MyLog("删除文章分类")
    public Result delete(@PathVariable Integer categoryId) {
        try {
            int result = articleCategoryService.delete(categoryId);
            return Result.judge(result, "删除");
        } catch (Exception e) {
            log.error("删除分类失败", e);
            return Result.error().message(e.getMessage());
        }
    }
}
