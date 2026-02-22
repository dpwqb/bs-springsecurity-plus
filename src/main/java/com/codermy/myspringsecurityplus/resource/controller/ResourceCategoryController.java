package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.resource.entity.ResourceCategory;
import com.codermy.myspringsecurityplus.resource.service.ResourceCategoryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 资源分类管理Controller
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Controller
@RequestMapping("/api/resource/category")
@Api(tags = "资源分类管理")
public class ResourceCategoryController {

    @Autowired
    private ResourceCategoryService resourceCategoryService;

    @GetMapping
    @ResponseBody
    @ApiOperation(value = "查询所有分类")
    public Result<ResourceCategory> list() {
        List<ResourceCategory> categories = resourceCategoryService.getAllCategories();
        return Result.ok()
                .data(categories)
                .message("查询成功");
    }

    @GetMapping("/tree")
    @ResponseBody
    @ApiOperation(value = "查询分类树")
    public Result<ResourceCategory> tree() {
        // TODO: 构建树形结构
        List<ResourceCategory> categories = resourceCategoryService.getAllCategories();
        return Result.ok()
                .data(categories)
                .message("查询成功");
    }

    @GetMapping("/{categoryId}")
    @ResponseBody
    @ApiOperation(value = "根据ID查询分类")
    public Result<ResourceCategory> getById(@PathVariable Integer categoryId) {
        ResourceCategory category = resourceCategoryService.getCategoryById(categoryId);
        if (category == null) {
            return Result.error().message("分类不存在");
        }
        return Result.ok()
                .data(java.util.Collections.singletonList(category))
                .message("查询成功");
    }

    @GetMapping("/hot")
    @ResponseBody
    @ApiOperation(value = "查询热门分类")
    public Result getHotCategories() {
        List<Map<String, Object>> categories = resourceCategoryService.getHotCategories();
        return Result.ok()
                .data(categories)
                .message("查询成功");
    }

    @PostMapping
    @ResponseBody
    @ApiOperation(value = "新增分类")
    @PreAuthorize("hasAnyAuthority('resource:manage')")
    @MyLog("新增资源分类")
    public Result save(@RequestBody ResourceCategory category) {
        try {
            int result = resourceCategoryService.save(category);
            return Result.judge(result, "新增");
        } catch (Exception e) {
            log.error("新增分类失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @PutMapping
    @ResponseBody
    @ApiOperation(value = "修改分类")
    @PreAuthorize("hasAnyAuthority('resource:manage')")
    @MyLog("修改资源分类")
    public Result update(@RequestBody ResourceCategory category) {
        try {
            int result = resourceCategoryService.update(category);
            return Result.judge(result, "修改");
        } catch (Exception e) {
            log.error("修改分类失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @DeleteMapping("/{categoryId}")
    @ResponseBody
    @ApiOperation(value = "删除分类")
    @PreAuthorize("hasAnyAuthority('resource:manage')")
    @MyLog("删除资源分类")
    public Result delete(@PathVariable Integer categoryId) {
        try {
            int result = resourceCategoryService.delete(categoryId);
            return Result.judge(result, "删除");
        } catch (Exception e) {
            log.error("删除分类失败", e);
            return Result.error().message(e.getMessage());
        }
    }
}
