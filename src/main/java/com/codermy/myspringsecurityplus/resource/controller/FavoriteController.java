package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.resource.entity.FavoriteRecord;
import com.codermy.myspringsecurityplus.resource.service.FavoriteService;
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
 * 收藏管理Controller
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Controller
@RequestMapping("/api/favorite")
@Api(tags = "收藏管理")
public class FavoriteController {

    @Autowired
    private FavoriteService favoriteService;

    @PostMapping("/{resourceId}")
    @ResponseBody
    @ApiOperation(value = "收藏资源")
    @MyLog("收藏资源")
    public Result add(@PathVariable Integer resourceId) {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            int result = favoriteService.save(resourceId, userId);
            return Result.judge(result, "收藏");
        } catch (Exception e) {
            log.error("收藏失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @DeleteMapping("/{resourceId}")
    @ResponseBody
    @ApiOperation(value = "取消收藏")
    @MyLog("取消收藏")
    public Result delete(@PathVariable Integer resourceId) {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            int result = favoriteService.delete(resourceId, userId);
            return Result.judge(result, "取消收藏");
        } catch (Exception e) {
            log.error("取消收藏失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @PostMapping("/toggle/{resourceId}")
    @ResponseBody
    @ApiOperation(value = "切换收藏状态")
    @MyLog("切换收藏状态")
    public Result toggle(@PathVariable Integer resourceId) {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            boolean isFavorited = favoriteService.toggleFavorite(resourceId, userId);

            return Result.ok()
                    .data(java.util.Collections.singletonList(isFavorited))
                    .message(isFavorited ? "收藏成功" : "已取消收藏");

        } catch (Exception e) {
            log.error("切换收藏状态失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @GetMapping("/my")
    @ResponseBody
    @ApiOperation(value = "我的收藏列表")
    public Result<FavoriteRecord> getMyFavorites(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer limit) {

        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);

            return Result.ok()
                    .data(favoriteService.getFavoriteRecordsByUserId(userId, params))
                    .message("查询成功");

        } catch (Exception e) {
            log.error("查询收藏列表失败", e);
            return Result.error().message("查询失败：" + e.getMessage());
        }
    }

    @GetMapping("/check/{resourceId}")
    @ResponseBody
    @ApiOperation(value = "检查是否已收藏")
    public Result check(@PathVariable Integer resourceId) {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            boolean isFavorited = favoriteService.checkFavorited(resourceId, userId);

            return Result.ok()
                    .data(java.util.Collections.singletonList(isFavorited))
                    .message("查询成功");

        } catch (Exception e) {
            log.error("检查收藏状态失败", e);
            return Result.error().message("查询失败：" + e.getMessage());
        }
    }
}
