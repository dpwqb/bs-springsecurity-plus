package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.PageTableRequest;
import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.resource.dto.DownloadQueryDto;
import com.codermy.myspringsecurityplus.resource.entity.DownloadRecord;
import com.codermy.myspringsecurityplus.resource.service.DownloadService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 下载记录管理后台Controller
 * @author codermy
 * @createTime 2025/2/22
 */
@Slf4j
@Controller
@RequestMapping("/api/admin/resource/download")
@Api(tags = "后台下载记录管理")
public class AdminDownloadController {

    @Autowired
    private DownloadService downloadService;

    /**
     * 下载记录管理页面
     */
    @GetMapping
    @ApiOperation(value = "下载记录管理页面")
    public String index() {
        return "admin/resource/download";
    }

    /**
     * 分页查询下载记录
     */
    @GetMapping("/list")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:download:list')")
    @ApiOperation(value = "分页查询下载记录")
    public Result<DownloadRecord> getDownloadRecords(
            PageTableRequest pageTableRequest,
            DownloadQueryDto queryDto) {
        pageTableRequest.countOffset();
        return downloadService.getDownloadRecordsForAdmin(
                pageTableRequest.getOffset(),
                pageTableRequest.getLimit(),
                queryDto
        );
    }

    /**
     * 删除单条下载记录
     */
    @DeleteMapping("/{recordId}")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:download:delete')")
    @MyLog("删除下载记录")
    @ApiOperation(value = "删除下载记录")
    public Result deleteDownloadRecord(@PathVariable Integer recordId) {
        int count = downloadService.deleteDownloadRecord(recordId);
        return Result.judge(count, "删除");
    }

    /**
     * 批量删除下载记录
     */
    @DeleteMapping("/batch")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:download:delete')")
    @MyLog("批量删除下载记录")
    @ApiOperation(value = "批量删除下载记录")
    public Result batchDelete(@RequestParam("recordIds") String recordIds) {
        String[] ids = recordIds.split(",");
        List<Integer> idList = Arrays.stream(ids)
                .map(Integer::parseInt)
                .collect(Collectors.toList());
        int count = downloadService.batchDeleteDownloadRecords(idList);
        return Result.judge(count, "批量删除");
    }

    /**
     * 清空所有下载记录
     */
    @DeleteMapping("/all")
    @ResponseBody
    @PreAuthorize("hasAnyAuthority('resource:download:delete')")
    @MyLog("清空所有下载记录")
    @ApiOperation(value = "清空所有下载记录")
    public Result deleteAll() {
        int count = downloadService.deleteAllDownloadRecords();
        return Result.judge(count, "清空");
    }
}
