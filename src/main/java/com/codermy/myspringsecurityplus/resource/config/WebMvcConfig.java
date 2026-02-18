package com.codermy.myspringsecurityplus.resource.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web MVC 配置
 * 配置静态资源映射，使上传的文件可以通过 HTTP 访问
 *
 * @author codermy
 * @createTime 2025/2/15
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private FileUploadConfig fileUploadConfig;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 映射 /uploads/** 到文件上传目录
        String uploadPath = fileUploadConfig.getPath();

        // 确保路径以 file: 开头，并且以 / 结尾
        if (!uploadPath.startsWith("file:")) {
            uploadPath = "file:" + uploadPath;
        }
        if (!uploadPath.endsWith("/") && !uploadPath.endsWith("\\")) {
            uploadPath = uploadPath + "/";
        }

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadPath)
                .setCachePeriod(3600); // 缓存1小时

        System.out.println("静态资源映射已配置：/uploads/** -> " + uploadPath);
    }
}
