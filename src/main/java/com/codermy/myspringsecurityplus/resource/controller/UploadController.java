package com.codermy.myspringsecurityplus.resource.controller;

import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.common.utils.SecurityUtils;
import com.codermy.myspringsecurityplus.resource.service.ArticleService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.util.Collections;

/**
 * 文件上传Controller
 * 处理通用的文件上传请求（如富文本编辑器图片上传）
 *
 * @author codermy
 * @createTime 2025/2/21
 */
@Slf4j
@Controller
@RequestMapping("/api/upload")
@Api(tags = "文件上传")
public class UploadController {

    @Autowired
    private ArticleService articleService;

    /**
     * 上传图片（通用接口，用于富文本编辑器等）
     *
     * @param file 上传的图片文件
     * @return 包含完整访问路径的响应
     */
    @PostMapping("/image")
    @ResponseBody
    @ApiOperation(value = "上传图片（通用）")
    public Result uploadImage(@RequestParam("file") MultipartFile file) {
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

            // 3. 校验文件大小（最大5MB）
            if (file.getSize() > 5 * 1024 * 1024) {
                return Result.error().message("图片大小不能超过5MB");
            }

            // 4. 保存文件
            Integer userId = SecurityUtils.getCurrentUser().getMyUser().getUserId();
            String userName = SecurityUtils.getCurrentUser().getMyUser().getNickName();

            String relativePath = articleService.saveCoverImage(file, userId, userName);

            // 5. 返回完整路径（包含 /uploads/ 前缀）
            String fullPath = "/uploads/" + relativePath;
            return Result.ok()
                    .data(Collections.singletonList(fullPath))
                    .message("图片上传成功");

        } catch (Exception e) {
            log.error("图片上传失败", e);
            return Result.error().message("上传失败：" + e.getMessage());
        }
    }

    /**
     * 获取文件扩展名
     */
    private String getFileExtension(String filename) {
        if (filename == null || filename.isEmpty()) {
            return "";
        }
        int lastDot = filename.lastIndexOf(".");
        return lastDot > 0 ? filename.substring(lastDot + 1).toLowerCase() : "";
    }

    /**
     * 判断是否为图片文件
     */
    private boolean isImageFile(String extension) {
        return extension.equals("jpg") ||
                extension.equals("jpeg") ||
                extension.equals("png") ||
                extension.equals("gif") ||
                extension.equals("webp");
    }
}
