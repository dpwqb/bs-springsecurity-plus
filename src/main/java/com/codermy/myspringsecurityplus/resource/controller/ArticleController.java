package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.log.utils.LogUtils;
import com.codermy.myspringsecurityplus.log.utils.RequestHolder;
import com.codermy.myspringsecurityplus.resource.dto.ArticlePublishDto;
import com.codermy.myspringsecurityplus.resource.dto.ArticleListResponseDto;
import com.codermy.myspringsecurityplus.resource.dto.ArticleResponseDto;
import com.codermy.myspringsecurityplus.resource.entity.MyArticle;
import com.codermy.myspringsecurityplus.resource.entity.ResourceTag;
import com.codermy.myspringsecurityplus.resource.service.ArticleService;
import com.codermy.myspringsecurityplus.resource.service.TagService;
import com.codermy.myspringsecurityplus.common.utils.SecurityUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
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

    @Autowired
    private TagService tagService;

    @GetMapping
    @ResponseBody
    @ApiOperation(value = "文章列表（分页、搜索）")
    public Result<ArticleListResponseDto> list(
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
                .data(articleService.getArticleListDtosByPage(params))
                .message("查询成功");
    }

    @GetMapping("/{articleId}")
    @ResponseBody
    @ApiOperation(value = "文章详情")
    public Result getDetail(@PathVariable Integer articleId) {
        MyArticle article = articleService.getArticleById(articleId);
        if (article == null) {
            return Result.error().message("文章不存在");
        }

        // 保存浏览记录
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            String ipAddress = LogUtils.getIp(RequestHolder.getHttpServletRequest());
            articleService.saveViewRecord(articleId, userId, ipAddress);
        } catch (Exception e) {
            // 未登录用户不记录浏览记录
        }

        // 增加浏览量
        articleService.increaseViewCount(articleId);

        // 获取文章标签
        List<ResourceTag> tags = tagService.getTagsByArticleId(articleId);

        // 构造返回数据（包含标签）
        Map<String, Object> data = new HashMap<>();
        data.put("article", article);
        data.put("tags", tags);

        return Result.ok()
                .data(java.util.Collections.singletonList(data))
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
    public Result<ArticleListResponseDto> getMyArticles(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer limit) {

        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);
            params.put("status", null); // 显示所有状态

            return Result.ok()
                    .data(articleService.getArticleListDtosByAuthorId(userId, params))
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
    @ApiOperation(value = "点赞/取消点赞文章")
    @MyLog("点赞文章")
    public Result like(@PathVariable Integer articleId) {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            String userName = SecurityUtils.getCurrentUser().getMyUser().getNickName();

            boolean isLiked = articleService.toggleLike(articleId, userId, userName);

            Map<String, Object> result = new HashMap<>();
            result.put("isLiked", isLiked);

            return Result.ok()
                    .data(java.util.Collections.singletonList(result))
                    .message(isLiked ? "点赞成功" : "已取消点赞");
        } catch (Exception e) {
            log.error("点赞操作失败", e);
            return Result.error().message("操作失败：" + e.getMessage());
        }
    }

    @GetMapping("/{articleId}/like-status")
    @ResponseBody
    @ApiOperation(value = "获取用户点赞状态")
    public Result getLikeStatus(@PathVariable Integer articleId) {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            boolean isLiked = articleService.checkUserLiked(articleId, userId);

            Map<String, Object> result = new HashMap<>();
            result.put("isLiked", isLiked);

            return Result.ok()
                    .data(java.util.Collections.singletonList(result))
                    .message("查询成功");
        } catch (Exception e) {
            Map<String, Object> result = new HashMap<>();
            result.put("isLiked", false);
            return Result.ok()
                    .data(java.util.Collections.singletonList(result))
                    .message("未登录");
        }
    }

    @PostMapping("/upload-cover")
    @ResponseBody
    @ApiOperation(value = "上传文章封面图片")
    @MyLog("上传文章封面")
    public Result uploadCover(@RequestParam("file") MultipartFile file) {
        try {
            // 1. 文件校验
            if (file == null || file.isEmpty()) {
                return Result.error().message("请选择要上传的图片");
            }

            // 2. 校验文件类型（只允许图片）
            String originalName = file.getOriginalFilename();
            String extension = getFileExtension(originalName);
            if (!isImageFile(extension)) {
                return Result.error().message("只支持上传图片文件（jpg, jpeg, png, gif）");
            }

            // 3. 校验文件大小（最大2MB）
            if (file.getSize() > 2 * 1024 * 1024) {
                return Result.error().message("图片大小不能超过2MB");
            }

            // 4. 保存文件
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            String userName = SecurityUtils.getCurrentUser().getMyUser().getNickName();

            String relativePath = articleService.saveCoverImage(file, userId, userName);

            // 5. 返回完整路径（包含 /uploads/ 前缀）
            String fullPath = "/uploads/" + relativePath;
            return Result.ok()
                    .data(java.util.Collections.singletonList(fullPath))
                    .message("图片上传成功");

        } catch (Exception e) {
            log.error("封面图片上传失败", e);
            return Result.error().message("上传失败：" + e.getMessage());
        }
    }

    private String getFileExtension(String filename) {
        if (filename == null || filename.isEmpty()) {
            return "";
        }
        int lastDot = filename.lastIndexOf(".");
        return lastDot > 0 ? filename.substring(lastDot + 1).toLowerCase() : "";
    }

    private boolean isImageFile(String extension) {
        return extension.equals("jpg") ||
                extension.equals("jpeg") ||
                extension.equals("png") ||
                extension.equals("gif");
    }
}
