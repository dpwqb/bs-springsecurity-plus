package com.codermy.myspringsecurityplus.resource.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.Arrays;
import java.util.List;

/**
 * 文件上传配置类
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "upload")
public class FileUploadConfig {

    /**
     * 文件存储路径
     */
    private String path = "D:/learn-share/uploads/";

    /**
     * 最大文件大小（字节）
     */
    private Long maxSize = 52428800L; // 50MB

    /**
     * 允许的文件类型
     */
    private String allowedTypes = "pdf,doc,docx,ppt,pptx,txt";

    /**
     * 获取允许的文件类型列表
     */
    public List<String> getAllowedTypeList() {
        return Arrays.asList(allowedTypes.split(","));
    }

    /**
     * 检查文件类型是否允许
     */
    public boolean isAllowedType(String fileType) {
        return getAllowedTypeList().contains(fileType.toLowerCase());
    }
}
