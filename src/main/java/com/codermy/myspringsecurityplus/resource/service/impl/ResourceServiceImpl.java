package com.codermy.myspringsecurityplus.resource.service.impl;

import com.codermy.myspringsecurityplus.resource.config.FileUploadConfig;
import com.codermy.myspringsecurityplus.resource.config.FileTypeConfig;
import com.codermy.myspringsecurityplus.resource.dao.ResourceDao;
import com.codermy.myspringsecurityplus.resource.dao.TagDao;
import com.codermy.myspringsecurityplus.resource.dao.DownloadDao;
import com.codermy.myspringsecurityplus.resource.dto.PlatformStatisticsDto;
import com.codermy.myspringsecurityplus.resource.dto.ResourceStatisticsDto;
import com.codermy.myspringsecurityplus.resource.entity.ResourceInfo;
import com.codermy.myspringsecurityplus.resource.entity.ResourceTag;
import com.codermy.myspringsecurityplus.resource.service.ResourceService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 资源服务实现类
 * @author codermy
 * @createTime 2025/2/8
 */
@Slf4j
@Service
public class ResourceServiceImpl implements ResourceService {

    @Autowired
    private ResourceDao resourceDao;

    @Autowired
    private TagDao tagDao;

    @Autowired
    private DownloadDao downloadDao;

    @Autowired
    private FileUploadConfig fileUploadConfig;

    @Autowired
    private FileTypeConfig fileTypeConfig;

    @Autowired
    private com.codermy.myspringsecurityplus.admin.dao.UserDao userDao;

    @Override
    public List<ResourceInfo> getResourcesByPage(Map<String, Object> params) {
        // 处理文件类型参数：将分类转换为扩展名列表
        String fileType = (String) params.get("fileType");
        if (fileType != null && !fileType.isEmpty()) {
            List<String> extensions = fileTypeConfig.getExtensionsByCategory(fileType);
            if (!extensions.isEmpty()) {
                params.put("fileTypeList", extensions);
            }
        }
        return resourceDao.getResourceByPage(params);
    }

    @Override
    public ResourceInfo getResourceById(Integer resourceId) {
        return resourceDao.getResourceById(resourceId);
    }

    @Override
    @Transactional
    public ResourceInfo upload(MultipartFile file, String title, Integer categoryId, String description, String tags, Integer userId, String userName) {
        // 1. 文件校验
        validateFile(file);

        // 2. 生成唯一文件名
        String originalName = file.getOriginalFilename();
        String extension = getFileExtension(originalName);
        String newFileName = UUID.randomUUID().toString().replace("-", "") + "." + extension;

        // 3. 按日期创建目录: /2024/02/
        String datePath = new SimpleDateFormat("yyyy/MM").format(new Date());
        String relativePath = datePath + "/" + newFileName;
        String fullPath = fileUploadConfig.getPath() + relativePath;

        // 4. 保存文件
        try {
            File destFile = new File(fullPath);
            if (!destFile.getParentFile().exists()) {
                destFile.getParentFile().mkdirs();
            }
            file.transferTo(destFile);
        } catch (Exception e) {
            log.error("文件上传失败", e);
            throw new RuntimeException("文件上传失败：" + e.getMessage());
        }

        // 5. 保存数据库
        ResourceInfo resource = new ResourceInfo();
        resource.setTitle(title);
        resource.setCategoryId(categoryId);
        resource.setDescription(description);
        resource.setFileName(originalName);
        resource.setFilePath(relativePath);
        resource.setFileSize(file.getSize());
        resource.setFileType(extension);
        resource.setUploaderId(userId);
        resource.setUploaderName(userName);
        resource.setStatus(1); // 直接发布，无需审核
        resource.setViewCount(0);
        resource.setDownloadCount(0);
        resource.setCollectCount(0);

        resourceDao.save(resource);

        // 6. 处理标签
        if (tags != null && !tags.trim().isEmpty()) {
            saveTags(resource.getResourceId(), tags);
        }

        log.info("资源上传成功：resourceId={}, title={}", resource.getResourceId(), title);
        return resource;
    }

    @Override
    @Transactional
    public int deleteResource(Integer resourceId) {
        // 1. 获取资源信息（在删除前需要文件路径）
        ResourceInfo resource = resourceDao.getResourceById(resourceId);
        if (resource == null) {
            return 0;
        }

        // 2. 将文件移动到回收站（而不是直接删除）
        moveToRecycleBin(resource.getFilePath(), resource.getResourceId());

        // 3. 删除资源标签关联
        tagDao.deleteResourceTagRelation(resourceId);

        // 4. 删除下载记录
        downloadDao.deleteByResourceId(resourceId);

        // 5. 删除数据库记录
        return resourceDao.delete(resourceId);
    }

    /**
     * 将文件移动到回收站
     * @param relativePath 原始相对路径
     * @param resourceId 资源ID（用于创建唯一文件名）
     */
    private void moveToRecycleBin(String relativePath, Integer resourceId) {
        try {
            String sourcePath = fileUploadConfig.getPath() + relativePath;
            File sourceFile = new File(sourcePath);

            if (!sourceFile.exists()) {
                log.warn("源文件不存在，跳过移动: {}", sourcePath);
                return;
            }

            // 创建回收站目录: /recycle/bin/
            String recycleDir = fileUploadConfig.getPath() + "recycle/bin/";
            File recycleDirFile = new File(recycleDir);
            if (!recycleDirFile.exists()) {
                recycleDirFile.mkdirs();
            }

            // 生成目标文件名：原文件名_资源ID_时间戳.扩展名
            String originalFileName = sourceFile.getName();
            String extension = originalFileName.contains(".")
                ? originalFileName.substring(originalFileName.lastIndexOf("."))
                : "";
            String baseName = originalFileName.contains(".")
                ? originalFileName.substring(0, originalFileName.lastIndexOf("."))
                : originalFileName;

            String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            String newFileName = baseName + "_" + resourceId + "_" + timestamp + extension;
            String targetPath = recycleDir + newFileName;

            // 移动文件
            File targetFile = new File(targetPath);

            // 如果目标文件已存在，添加序号
            int counter = 1;
            while (targetFile.exists()) {
                newFileName = baseName + "_" + resourceId + "_" + timestamp + "_" + counter + extension;
                targetPath = recycleDir + newFileName;
                targetFile = new File(targetPath);
                counter++;
            }

            boolean moved = sourceFile.renameTo(targetFile);
            if (moved) {
                log.info("文件已移动到回收站: {} -> {}", sourcePath, targetPath);
            } else {
                log.warn("文件移动到回收站失败: {}", sourcePath);
            }
        } catch (Exception e) {
            log.error("移动文件到回收站时发生错误: {}", relativePath, e);
            // 不抛出异常，避免影响数据库删除操作
        }
    }

    /**
     * 清理回收站中指定天数之前的文件
     * @param days 保留天数
     * @return 清理的文件数量
     */
    public int cleanRecycleBin(int days) {
        try {
            String recycleDir = fileUploadConfig.getPath() + "recycle/bin/";
            File recycleDirFile = new File(recycleDir);

            if (!recycleDirFile.exists() || !recycleDirFile.isDirectory()) {
                return 0;
            }

            long cutoffTime = System.currentTimeMillis() - (days * 24L * 60 * 60 * 1000);
            int cleanedCount = 0;

            File[] files = recycleDirFile.listFiles();
            if (files != null) {
                for (File file : files) {
                    if (file.lastModified() < cutoffTime) {
                        if (file.delete()) {
                            cleanedCount++;
                            log.info("清理回收站文件: {}", file.getName());
                        }
                    }
                }
            }

            return cleanedCount;
        } catch (Exception e) {
            log.error("清理回收站失败", e);
            return 0;
        }
    }

    @Override
    public void increaseViewCount(Integer resourceId) {
        resourceDao.increaseViewCount(resourceId);
    }

    @Override
    public void increaseDownloadCount(Integer resourceId) {
        resourceDao.increaseDownloadCount(resourceId);
    }

    @Override
    public void increaseCollectCount(Integer resourceId) {
        resourceDao.increaseCollectCount(resourceId);
    }

    @Override
    public List<ResourceInfo> getResourcesByUploaderId(Integer uploaderId, Map<String, Object> params) {
        return resourceDao.getResourcesByUploaderId(uploaderId, params);
    }

    @Override
    public List<ResourceInfo> getAllResources(Map<String, Object> params) {
        return resourceDao.getAllResourcesForAdmin(params);
    }

    @Override
    @Transactional
    public boolean updateStatus(Integer resourceId, Integer status) {
        return resourceDao.updateStatus(resourceId, status) > 0;
    }

    @Override
    @Transactional
    public boolean batchUpdateStatus(Integer[] resourceIds, Integer status) {
        if (resourceIds == null || resourceIds.length == 0) {
            return false;
        }
        List<Integer> resourceIdList = Arrays.asList(resourceIds);
        return resourceDao.batchUpdateStatus(resourceIdList, status) > 0;
    }

    @Override
    public ResourceStatisticsDto getResourceStatistics() {
        Map<String, Object> stats = resourceDao.getResourceStatistics();
        Integer todayCount = resourceDao.getTodayResourceCount();

        ResourceStatisticsDto dto = new ResourceStatisticsDto();
        dto.setTotal(((Number) stats.getOrDefault("total", 0)).longValue());
        dto.setToday(todayCount);
        dto.setTotalDownloads(((Number) stats.getOrDefault("totalDownloads", 0)).longValue());
        dto.setTotalViews(((Number) stats.getOrDefault("totalViews", 0)).longValue());

        return dto;
    }

    @Override
    public PlatformStatisticsDto getPlatformStatistics() {
        PlatformStatisticsDto dto = new PlatformStatisticsDto();

        // 获取资源总数（使用现有查询）
        Map<String, Object> resourceStats = resourceDao.getResourceStatistics();
        dto.setTotalResources(((Number) resourceStats.getOrDefault("total", 0)).longValue());

        // 获取用户总数
        dto.setTotalUsers(userDao.countAllUser());

        // 获取今日下载次数
        dto.setTodayDownloads(downloadDao.countTodayDownloads());

        return dto;
    }

    /**
     * 文件校验
     */
    private void validateFile(MultipartFile file) {
        if (file == null) {
            throw new RuntimeException("请选择要上传的文件");
        }

        if (file.isEmpty()) {
            throw new RuntimeException("文件不能为空");
        }

        // 大小校验
        if (file.getSize() > fileUploadConfig.getMaxSize()) {
            throw new RuntimeException("文件大小超过" + (fileUploadConfig.getMaxSize() / 1024 / 1024) + "MB限制");
        }

        // 类型校验
        String extension = getFileExtension(file.getOriginalFilename());
        if (!fileUploadConfig.isAllowedType(extension)) {
            throw new RuntimeException("不支持的文件类型，仅支持：" + fileUploadConfig.getAllowedTypes());
        }

        // 文件名校验
        String fileName = file.getOriginalFilename();
        if (fileName.contains("..")) {
            throw new RuntimeException("非法文件名");
        }
    }

    /**
     * 获取文件扩展名
     */
    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        int lastDotIndex = fileName.lastIndexOf(".");
        if (lastDotIndex == -1) {
            return "";
        }
        return fileName.substring(lastDotIndex + 1);
    }

    /**
     * 保存标签
     */
    private void saveTags(Integer resourceId, String tags) {
        String[] tagArray = tags.split(",");
        for (String tagName : tagArray) {
            tagName = tagName.trim();
            if (tagName.isEmpty()) {
                continue;
            }

            // 查询或创建标签
            ResourceTag tag = tagDao.getTagByName(tagName);
            if (tag == null) {
                tag = new ResourceTag();
                tag.setTagName(tagName);
                tag.setUseCount(0);
                tagDao.save(tag);
            }

            // 保存关联关系
            tagDao.saveResourceTagRelation(resourceId, tag.getTagId());
            tagDao.increaseUseCount(tag.getTagId());
        }
    }
}
