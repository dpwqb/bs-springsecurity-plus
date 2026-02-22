package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.common.utils.ResultCode;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.resource.dto.ArticleStatisticsDto;
import com.codermy.myspringsecurityplus.resource.entity.MyArticle;
import com.codermy.myspringsecurityplus.resource.service.ArticleService;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * 文章管理后台控制器
 * @author codermy
 * @createTime 2025/2/11
 */
@Slf4j
@Controller
@RequestMapping("/api/admin/article")
@Api(tags = "后台文章管理")
public class AdminArticleController {

    @Autowired
    private ArticleService articleService;

    /**
     * 文章列表页面
     */
    @GetMapping("/list")
    @PreAuthorize("hasAnyAuthority('article:list')")
    public String list() {
        return "admin/article/list";
    }

    /**
     * 文章分类页面
     */
    @GetMapping("/category")
    @PreAuthorize("hasAnyAuthority('article:category:list')")
    public String category() {
        return "admin/article/category";
    }

    /**
     * 获取文章列表（数据接口）
     */
    @GetMapping
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('article:list')")
    @ApiOperation(value = "获取文章列表")
    public Result getArticleList(@RequestParam Map<String, Object> params) {
        List<MyArticle> articles = articleService.getAllArticlesForAdmin(params);
        return Result.ok().data(articles).code(ResultCode.TABLE_SUCCESS);
    }

    /**
     * 获取文章统计
     */
    @GetMapping("/statistics")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('article:list')")
    @ApiOperation(value = "获取文章统计")
    public Result getStatistics() {
        ArticleStatisticsDto stats = articleService.getArticleStatistics();
        return Result.ok().data(java.util.Arrays.asList(stats));
    }

    /**
     * 发布文章
     */
    @PutMapping("/publish/{articleId}")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('article:publish')")
    @MyLog("发布文章")
    @ApiOperation(value = "发布文章")
    public Result publishArticle(@PathVariable Integer articleId) {
        boolean success = articleService.updateArticleStatus(articleId, 1);
        return Result.judge(success ? 1 : 0, "发布");
    }

    /**
     * 下架文章
     */
    @PutMapping("/offline/{articleId}")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('article:offline')")
    @MyLog("下架文章")
    @ApiOperation(value = "下架文章")
    public Result offlineArticle(@PathVariable Integer articleId) {
        boolean success = articleService.updateArticleStatus(articleId, 2);
        return Result.judge(success ? 1 : 0, "下架");
    }

    /**
     * 删除文章
     */
    @DeleteMapping("/{articleId}")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('article:delete')")
    @MyLog("删除文章")
    @ApiOperation(value = "删除文章")
    public Result deleteArticle(@PathVariable Integer articleId) {
        int count = articleService.deleteArticle(articleId);
        return Result.judge(count, "删除");
    }

    /**
     * 批量下架
     */
    @PutMapping("/batch/offline")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('article:offline')")
    @MyLog("批量下架文章")
    @ApiOperation(value = "批量下架文章")
    public Result batchOffline(@RequestParam("articleIds") String articleIds) {
        String[] ids = articleIds.split(",");
        Integer[] idArray = Arrays.stream(ids).map(Integer::parseInt).toArray(Integer[]::new);
        boolean success = articleService.batchUpdateArticleStatus(idArray, 2);
        return Result.judge(success ? 1 : 0, "批量下架");
    }
}
