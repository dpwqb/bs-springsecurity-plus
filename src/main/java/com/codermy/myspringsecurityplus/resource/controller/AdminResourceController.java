package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.common.utils.ResultCode;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.resource.dto.ResourceStatisticsDto;
import com.codermy.myspringsecurityplus.resource.entity.ResourceInfo;
import com.codermy.myspringsecurityplus.resource.service.ResourceService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

/**
 * 资源管理后台控制器
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Controller
@RequestMapping("/admin/resource")
@Api(tags = "后台资源管理")
public class AdminResourceController {

    @Autowired
    private ResourceService resourceService;

    /**
     * 资源列表页面
     */
    @GetMapping("/list")
    @PreAuthorize("hasAnyAuthority('resource:list')")
    public String list() {
        return "admin/resource/list";
    }

    /**
     * 资源分类页面
     */
    @GetMapping("/category")
    @PreAuthorize("hasAnyAuthority('resource:category:list')")
    public String category() {
        return "admin/resource/category";
    }

    /**
     * 资源标签页面
     */
    @GetMapping("/tag")
    @PreAuthorize("hasAnyAuthority('resource:tag:list')")
    public String tag() {
        return "admin/resource/tag";
    }

    /**
     * 下载记录页面
     */
    @GetMapping("/download")
    @PreAuthorize("hasAnyAuthority('resource:download:list')")
    public String download() {
        return "admin/resource/download";
    }

    /**
     * 获取资源列表（数据接口）
     */
    @GetMapping
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:list')")
    @ApiOperation(value = "获取资源列表")
    public Result getResourceList(@RequestParam java.util.Map<String, Object> params) {
        List<ResourceInfo> resources = resourceService.getAllResources(params);
        return Result.ok().data(resources).code(ResultCode.SUCCESS);
    }

    /**
     * 获取资源统计
     */
    @GetMapping("/statistics")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:list')")
    @ApiOperation(value = "获取资源统计")
    public Result getStatistics() {
        ResourceStatisticsDto stats = resourceService.getResourceStatistics();
        return Result.ok().data(java.util.Arrays.asList(stats));
    }

    /**
     * 发布资源
     */
    @PutMapping("/publish/{resourceId}")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:publish')")
    @MyLog("发布资源")
    @ApiOperation(value = "发布资源")
    public Result publishResource(@PathVariable Integer resourceId) {
        boolean success = resourceService.updateStatus(resourceId, 1);
        return Result.judge(success ? 1 : 0, "发布");
    }

    /**
     * 下架资源
     */
    @PutMapping("/offline/{resourceId}")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:offline')")
    @MyLog("下架资源")
    @ApiOperation(value = "下架资源")
    public Result offlineResource(@PathVariable Integer resourceId) {
        boolean success = resourceService.updateStatus(resourceId, 0);
        return Result.judge(success ? 1 : 0, "下架");
    }

    /**
     * 批量下架
     */
    @PutMapping("/batch/offline")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:offline')")
    @MyLog("批量下架资源")
    @ApiOperation(value = "批量下架资源")
    public Result batchOffline(@RequestParam("resourceIds") String resourceIds) {
        String[] ids = resourceIds.split(",");
        Integer[] idArray = Arrays.stream(ids).map(Integer::parseInt).toArray(Integer[]::new);
        boolean success = resourceService.batchUpdateStatus(idArray, 0);
        return Result.judge(success ? 1 : 0, "批量下架");
    }

    /**
     * 删除资源
     */
    @DeleteMapping("/{resourceId}")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:delete')")
    @MyLog("删除资源")
    @ApiOperation(value = "删除资源")
    public Result deleteResource(@PathVariable Integer resourceId) {
        int count = resourceService.deleteResource(resourceId);
        return Result.judge(count, "删除");
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/batch")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:delete')")
    @MyLog("批量删除资源")
    @ApiOperation(value = "批量删除资源")
    public Result batchDelete(@RequestParam("resourceIds") String resourceIds) {
        String[] ids = resourceIds.split(",");
        int successCount = 0;
        for (String idStr : ids) {
            Integer id = Integer.parseInt(idStr);
            successCount += resourceService.deleteResource(id);
        }
        return Result.judge(successCount, "批量删除");
    }

    /**
     * 查看资源详情
     */
    @GetMapping("/detail/{resourceId}")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:list')")
    @ApiOperation(value = "查看资源详情")
    public Result getResourceDetail(@PathVariable Integer resourceId) {
        ResourceInfo resource = resourceService.getResourceById(resourceId);
        if (resource == null) {
            return Result.error().message("资源不存在");
        }
        return Result.ok().data(Arrays.asList(resource));
    }
}
