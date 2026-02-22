package com.codermy.myspringsecurityplus.resource.config;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.system.ApplicationHome;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.io.File;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;

/**
 * 文件上传配置类
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Data
@Configuration
@ConfigurationProperties(prefix = "upload")
public class FileUploadConfig {

    /**
     * 文件存储路径
     */
    private String path = "./uploads/";

    /**
     * 初始化文件上传路径
     * 在 Spring Bean 初始化后自动执行
     */
    @PostConstruct
    public void init() {
        // 保存原始配置路径用于日志记录
        String originalPath = this.path;

        // 检测并解析相对路径
        if (isRelativePath(this.path)) {
            this.path = resolveRelativePath(this.path);
            log.info("文件上传路径已解析：相对路径 '{}' -> 绝对路径 '{}'", originalPath, this.path);
        } else {
            log.info("文件上传路径（绝对路径）：{}", this.path);
        }

        // 确保上传目录存在
        File uploadDir = new File(this.path);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            if (created) {
                log.info("文件上传目录创建成功：{}", this.path);
            } else {
                log.error("文件上传目录创建失败：{}", this.path);
            }
        } else {
            log.info("文件上传目录已存在：{}", this.path);
        }

        // 验证目录是否可写
        if (!uploadDir.canWrite()) {
            log.error("警告：文件上传目录不可写！路径：{}", this.path);
        } else {
            log.info("文件上传目录可正常读写");
        }
    }

    /**
     * 最大文件大小（字节）
     */
    private Long maxSize = 52428800L; // 50MB

    /**
     * 允许的文件类型
     */
    private String allowedTypes = "pdf,doc,docx,ppt,pptx,txt,zip,7z,rar";

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

    /**
     * 判断是否为相对路径
     * 支持格式：./uploads/, .\\uploads/, ~/
     */
    private boolean isRelativePath(String path) {
        if (path == null || path.trim().isEmpty()) {
            return false;
        }
        String trimmed = path.trim();
        return trimmed.startsWith("./") ||
               trimmed.startsWith(".\\") ||
               trimmed.startsWith("~/") ||
               trimmed.equals(".") ||
               trimmed.equals("~");
    }

    /**
     * 解析相对路径为绝对路径
     * 开发环境：查找项目根目录（包含 pom.xml 的目录）
     * 生产环境：使用 JAR 文件所在目录
     */
    private String resolveRelativePath(String relativePath) {
        File workingDir = new File(System.getProperty("user.dir"));
        Path baseDir;

        // 1. 先检查是否在 IDE 开发环境（查找项目根目录）
        File projectRoot = findProjectRoot(workingDir);
        if (projectRoot != null) {
            baseDir = projectRoot.toPath();
            log.info("检测到开发环境，使用项目根目录作为基准：{}", projectRoot.getAbsolutePath());
        } else {
            // 2. 生产环境：使用 JAR 文件所在目录
            ApplicationHome home = new ApplicationHome(getClass());
            File jarDir = home.getSource() != null ? home.getSource().getParentFile() : null;
            if (jarDir != null && jarDir.exists()) {
                baseDir = jarDir.toPath();
                log.info("检测到生产环境，使用 JAR 文件所在目录作为基准：{}", jarDir.getAbsolutePath());
            } else {
                baseDir = workingDir.toPath();
                log.info("使用当前工作目录作为基准：{}", workingDir.getAbsolutePath());
            }
        }

        // 解析相对路径部分（移除 ./ 或 ~ 前缀）
        String relativePart = relativePath
            .replaceFirst("^\\./", "")
            .replaceFirst("^\\.\\\\", "")
            .replaceFirst("^~/", "");

        // 确保路径以分隔符结尾
        if (!relativePart.endsWith("/") && !relativePart.endsWith("\\")) {
            relativePart = relativePart + File.separator;
        }

        // 构建绝对路径
        Path absolutePath = baseDir.resolve(relativePart);
        String resolvedPath = absolutePath.normalize().toAbsolutePath().toString();

        // 确保路径以分隔符结尾
        if (!resolvedPath.endsWith("/") && !resolvedPath.endsWith("\\")) {
            resolvedPath = resolvedPath + File.separator;
        }

        return resolvedPath;
    }

    /**
     * 查找项目根目录
     * 通过向上遍历，找到包含 pom.xml 或 src 目录的父目录
     */
    private File findProjectRoot(File startDir) {
        File current = startDir;
        int maxIterations = 10; // 防止无限循环
        int iterations = 0;

        while (current != null && iterations < maxIterations) {
            // 检查是否包含 Maven/Gradle 项目标识文件
            File pomFile = new File(current, "pom.xml");
            File gradleFile = new File(current, "build.gradle");
            File srcDir = new File(current, "src");

            if (pomFile.exists() || gradleFile.exists() || srcDir.exists()) {
                return current;
            }

            current = current.getParentFile();
            iterations++;
        }

        return null;
    }
}
