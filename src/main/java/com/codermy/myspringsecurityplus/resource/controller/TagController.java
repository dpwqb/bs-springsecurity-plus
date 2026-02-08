package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.resource.entity.ResourceTag;
import com.codermy.myspringsecurityplus.resource.service.TagService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 标签管理Controller
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Controller
@RequestMapping("/api/tag")
@Api(tags = "标签管理")
public class TagController {

    @Autowired
    private TagService tagService;

    @GetMapping
    @ResponseBody
    @ApiOperation(value = "查询所有标签")
    public Result<ResourceTag> list() {
        List<ResourceTag> tags = tagService.getAllTags();
        return Result.ok()
                .data(tags)
                .message("查询成功");
    }

    @GetMapping("/hot")
    @ResponseBody
    @ApiOperation(value = "查询热门标签")
    public Result<ResourceTag> hotTags(@RequestParam(defaultValue = "20") Integer limit) {
        List<ResourceTag> tags = tagService.getHotTags(limit);
        return Result.ok()
                .data(tags)
                .message("查询成功");
    }

    @GetMapping("/{tagId}")
    @ResponseBody
    @ApiOperation(value = "根据ID查询标签")
    public Result<ResourceTag> getById(@PathVariable Integer tagId) {
        ResourceTag tag = tagService.getTagById(tagId);
        if (tag == null) {
            return Result.error().message("标签不存在");
        }
        return Result.ok()
                .data(java.util.Collections.singletonList(tag))
                .message("查询成功");
    }

    @PostMapping
    @ResponseBody
    @ApiOperation(value = "新增标签")
    @PreAuthorize("hasAnyAuthority('tag:manage')")
    @MyLog("新增标签")
    public Result save(@RequestBody ResourceTag tag) {
        try {
            int result = tagService.save(tag);
            return Result.judge(result, "新增");
        } catch (Exception e) {
            log.error("新增标签失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @DeleteMapping("/{tagId}")
    @ResponseBody
    @ApiOperation(value = "删除标签")
    @PreAuthorize("hasAnyAuthority('tag:manage')")
    @MyLog("删除标签")
    public Result delete(@PathVariable Integer tagId) {
        try {
            int result = tagService.delete(tagId);
            return Result.judge(result, "删除");
        } catch (Exception e) {
            log.error("删除标签失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @GetMapping("/resource/{resourceId}")
    @ResponseBody
    @ApiOperation(value = "查询资源的标签")
    public Result<ResourceTag> getTagsByResourceId(@PathVariable Integer resourceId) {
        List<ResourceTag> tags = tagService.getTagsByResourceId(resourceId);
        return Result.ok()
                .data(tags)
                .message("查询成功");
    }

    @GetMapping("/article/{articleId}")
    @ResponseBody
    @ApiOperation(value = "查询文章的标签")
    public Result<ResourceTag> getTagsByArticleId(@PathVariable Integer articleId) {
        List<ResourceTag> tags = tagService.getTagsByArticleId(articleId);
        return Result.ok()
                .data(tags)
                .message("查询成功");
    }
}
