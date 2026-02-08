package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.resource.entity.DownloadRecord;
import com.codermy.myspringsecurityplus.resource.service.DownloadService;
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
 * 下载记录管理Controller
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Controller
@RequestMapping("/api/download")
@Api(tags = "下载记录管理")
public class DownloadController {

    @Autowired
    private DownloadService downloadService;

    @GetMapping("/my")
    @ResponseBody
    @ApiOperation(value = "我的下载记录")
    public Result<DownloadRecord> getMyDownloads(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer limit) {

        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);

            return Result.ok()
                    .data(downloadService.getDownloadRecordsByUserId(userId, params))
                    .message("查询成功");

        } catch (Exception e) {
            log.error("查询下载记录失败", e);
            return Result.error().message("查询失败：" + e.getMessage());
        }
    }

    @GetMapping("/count")
    @ResponseBody
    @ApiOperation(value = "我的下载次数统计")
    public Result getTotalDownloads() {
        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            Long totalDownloads = downloadService.countDownloadsByUserId(userId);

            return Result.ok()
                    .data(java.util.Collections.singletonList(totalDownloads))
                    .message("查询成功");

        } catch (Exception e) {
            log.error("查询下载统计失败", e);
            return Result.error().message("查询失败：" + e.getMessage());
        }
    }
}
