package com.codermy.myspringsecurityplus.resource.config;

import org.springframework.stereotype.Component;

import java.util.*;

/**
 * 文件类型分类配置
 * 定义文件类型分类映射关系，支持一个筛选条件匹配多个文件扩展名
 */
@Component
public class FileTypeConfig {

    /**
     * 文件类型分类映射
     * Key: 前端传递的分类标识
     * Value: 该分类包含的所有扩展名
     */
    private static final Map<String, List<String>> FILE_TYPE_MAPPING = new HashMap<>();

    static {
        FILE_TYPE_MAPPING.put("pdf", Arrays.asList("pdf"));
        FILE_TYPE_MAPPING.put("word", Arrays.asList("doc", "docx"));
        FILE_TYPE_MAPPING.put("ppt", Arrays.asList("ppt", "pptx"));
        FILE_TYPE_MAPPING.put("archive", Arrays.asList("zip", "7z", "rar"));
        FILE_TYPE_MAPPING.put("text", Arrays.asList("txt"));
    }

    /**
     * 根据分类获取对应的文件扩展名列表
     *
     * @param category 分类标识（如word、ppt、archive等）
     * @return 扩展名列表，如果分类不存在返回空列表
     */
    public List<String> getExtensionsByCategory(String category) {
        return FILE_TYPE_MAPPING.getOrDefault(category, Collections.emptyList());
    }
}
