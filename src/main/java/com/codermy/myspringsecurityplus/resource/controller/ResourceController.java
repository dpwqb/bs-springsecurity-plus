package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.log.aop.MyLog;
import com.codermy.myspringsecurityplus.resource.entity.ResourceInfo;
import com.codermy.myspringsecurityplus.resource.service.ResourceService;
import com.codermy.myspringsecurityplus.resource.service.DownloadService;
import com.codermy.myspringsecurityplus.resource.config.FileUploadConfig;
import com.codermy.myspringsecurityplus.common.utils.SecurityUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

/**
 * 资源管理Controller
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Controller
@RequestMapping("/api/resource")
@Api(tags = "资源管理")
public class ResourceController {

    @Autowired
    private ResourceService resourceService;

    @Autowired
    private DownloadService downloadService;

    @Autowired
    private FileUploadConfig fileUploadConfig;

    @GetMapping
    @ResponseBody
    @ApiOperation(value = "资源列表（分页、搜索）")
    public Result<ResourceInfo> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "12") Integer limit,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) String fileType) {

        Map<String, Object> params = new HashMap<>();
        params.put("page", page);
        params.put("limit", limit);
        params.put("keyword", keyword);
        params.put("categoryId", categoryId);
        params.put("fileType", fileType);
        params.put("status", 1); // 只显示已发布的资源

        return Result.ok()
                .data(resourceService.getResourcesByPage(params))
                .message("查询成功");
    }

    @GetMapping("/{resourceId}")
    @ResponseBody
    @ApiOperation(value = "资源详情")
    public Result<ResourceInfo> getDetail(@PathVariable Integer resourceId) {
        ResourceInfo resource = resourceService.getResourceById(resourceId);
        if (resource == null) {
            return Result.error().message("资源不存在");
        }

        // 增加浏览量
        resourceService.increaseViewCount(resourceId);

        return Result.ok()
                .data(java.util.Collections.singletonList(resource))
                .message("查询成功");
    }

    @PostMapping("/upload")
    @ResponseBody
    @ApiOperation(value = "上传资源")
    @MyLog("上传资源")
    public Result upload(
            @RequestParam("file") MultipartFile file,
            @RequestParam("title") String title,
            @RequestParam("categoryId") Integer categoryId,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "tags", required = false) String tags) {

        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            String userName = SecurityUtils.getCurrentUser().getMyUser().getNickName();

            ResourceInfo resource = resourceService.upload(
                    file, title, categoryId, description, tags, userId, userName);

            return Result.ok()
                    .data(java.util.Collections.singletonList(resource))
                    .message("上传成功！");

        } catch (Exception e) {
            log.error("资源上传失败", e);
            return Result.error().message(e.getMessage());
        }
    }

    @GetMapping("/download/{resourceId}")
    @ApiOperation(value = "下载资源")
    @MyLog("下载资源")
    public void download(
            @PathVariable Integer resourceId,
            HttpServletResponse response) {

        try {
            ResourceInfo resource = resourceService.getResourceById(resourceId);
            if (resource == null) {
                response.setStatus(404);
                return;
            }

            // 获取用户信息并保存下载记录
            try {
                Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
                String userName = SecurityUtils.getCurrentUser().getMyUser().getNickName();
                downloadService.save(resourceId, userId, userName);
            } catch (Exception e) {
                // 未登录用户不保存下载记录，但允许下载
                log.warn("未登录用户下载资源：resourceId={}", resourceId);
                resourceService.increaseDownloadCount(resourceId);
            }

            // 构建文件路径（使用配置的上传路径）
            String filePath = fileUploadConfig.getPath() + resource.getFilePath();
            File file = new File(filePath);

            if (!file.exists()) {
                response.setStatus(404);
                return;
            }

            // 设置响应头
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition",
                    "attachment; filename=" + URLEncoder.encode(resource.getFileName(), "UTF-8"));

            // 写入文件流
            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream os = response.getOutputStream()) {

                byte[] buffer = new byte[1024];
                int len;
                while ((len = fis.read(buffer)) > 0) {
                    os.write(buffer, 0, len);
                }
                os.flush();
            }

        } catch (Exception e) {
            log.error("资源下载失败", e);
        }
    }

    @GetMapping("/my")
    @ResponseBody
    @ApiOperation(value = "我上传的资源")
    public Result<ResourceInfo> getMyResources(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer limit) {

        try {
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);
            params.put("status", null); // 显示所有状态

            return Result.ok()
                    .data(resourceService.getResourcesByUploaderId(userId, params))
                    .message("查询成功");

        } catch (Exception e) {
            log.error("查询我的资源失败", e);
            return Result.error().message("查询失败：" + e.getMessage());
        }
    }

    @DeleteMapping("/{resourceId}")
    @ResponseBody
    @ApiOperation(value = "删除资源")
    @PreAuthorize("hasAnyAuthority('resource:delete')")
    @MyLog("删除资源")
    public Result delete(@PathVariable Integer resourceId) {
        try {
            int result = resourceService.deleteResource(resourceId);
            return Result.judge(result, "删除");
        } catch (Exception e) {
            log.error("删除资源失败", e);
            return Result.error().message("删除失败：" + e.getMessage());
        }
    }
}
