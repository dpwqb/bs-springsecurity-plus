package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.resource.dto.ArticlePublishDto;
import com.codermy.myspringsecurityplus.resource.entity.MyArticle;
import com.codermy.myspringsecurityplus.resource.service.ArticleService;
import com.codermy.myspringsecurityplus.common.utils.SecurityUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 文章管理Controller
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Controller
@RequestMapping("/api/article")
@Api(tags = "文章管理")
public class ArticleController {

    @Autowired
    private ArticleService articleService;

    @GetMapping
    @ResponseBody
    @ApiOperation(value = "文章列表（分页、搜索）")
    public Result<MyArticle> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer limit,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) Integer status) {

        Map<String, Object> params = new HashMap<>();
        params.put("page", page);
        params.put("limit", limit);
        params.put("keyword", keyword);
        params.put("categoryId", categoryId);
        params.put("status", status); // null: 全部, 0: 草稿, 1: 已发布

        return Result.ok()
                .data(articleService.getArticlesByPage(params))
                .message("查询成功");
    }

    @GetMapping("/{articleId}")
    @ResponseBody
    @ApiOperation(value = "文章详情")
    public Result<MyArticle> getDetail(@PathVariable Integer articleId) {
        MyArticle article = articleService.getArticleById(articleId);
        if (article == null) {
            return Result.error().message("文章不存在");
        }

        // 保存浏览记录
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            articleService.saveViewRecord(articleId, userId);
        } catch (Exception e) {
            // 未登录用户不记录浏览记录
        }

        // 增加浏览量
        articleService.increaseViewCount(articleId);

        return Result.ok()
                .data(java.util.Collections.singletonList(article))
                .message("查询成功");
    }

    @PostMapping("/publish")
    @ResponseBody
    @ApiOperation(value = "发布文章")
    @MyLog("发布文章")
    public Result publish(@RequestBody ArticlePublishDto dto) {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            String userName = SecurityUtils.getCurrentUser().getMyUser().getNickName();

            MyArticle article = articleService.publish(dto, userId, userName);

            return Result.ok()
                    .data(java.util.Collections.singletonList(article))
                    .message("文章发布成功！");

        } catch (Exception e) {
            log.error("文章发布失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @PostMapping("/draft")
    @ResponseBody
    @ApiOperation(value = "保存草稿")
    @MyLog("保存文章草稿")
    public Result saveDraft(@RequestBody ArticlePublishDto dto) {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            String userName = SecurityUtils.getCurrentUser().getMyUser().getNickName();

            MyArticle article = articleService.saveDraft(dto, userId, userName);

            return Result.ok()
                    .data(java.util.Collections.singletonList(article))
                    .message("草稿保存成功！");

        } catch (Exception e) {
            log.error("草稿保存失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @GetMapping("/my")
    @ResponseBody
    @ApiOperation(value = "我的文章")
    public Result<MyArticle> getMyArticles(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer limit) {

        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);
            params.put("status", null); // 显示所有状态

            return Result.ok()
                    .data(articleService.getArticlesByAuthorId(userId, params))
                    .message("查询成功");

        } catch (Exception e) {
            log.error("查询我的文章失败", e);
            return Result.error().message("查询失败：" + e.getMessage());
        }
    }

    @DeleteMapping("/{articleId}")
    @ResponseBody
    @ApiOperation(value = "删除文章")
    @MyLog("删除文章")
    public Result delete(@PathVariable Integer articleId) {
        try {
            int result = articleService.deleteArticle(articleId);
            return Result.judge(result, "删除");
        } catch (Exception e) {
            log.error("删除文章失败", e);
            return Result.error().message("删除失败：" + e.getMessage());
        }
    }

    @PostMapping("/{articleId}/like")
    @ResponseBody
    @ApiOperation(value = "点赞文章")
    @MyLog("点赞文章")
    public Result like(@PathVariable Integer articleId) {
        try {
            articleService.increaseLikeCount(articleId);
            return Result.ok().message("点赞成功");
        } catch (Exception e) {
            log.error("点赞失败", e);
            return Result.error().message("点赞失败：" + e.getMessage());
        }
    }
}
