package com.codermy.myspringsecurityplus.resource.service;

import com.codermy.myspringsecurityplus.resource.dto.ResourceStatisticsDto;
import com.codermy.myspringsecurityplus.resource.entity.ResourceInfo;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * 资源服务接口
 * @author codermy
 * @createTime 2025/2/8
 */
public interface ResourceService {

    /**
     * 分页查询资源列表
     * @param params 查询参数（keyword, categoryId, fileType, status等）
     * @return 资源列表
     */
    java.util.List<ResourceInfo> getResourcesByPage(Map<String, Object> params);

    /**
     * 根据ID查询资源详情
     * @param resourceId 资源ID
     * @return 资源详情
     */
    ResourceInfo getResourceById(Integer resourceId);

    /**
     * 上传资源
     * @param file 文件
     * @param title 标题
     * @param categoryId 分类ID
     * @param description 描述
     * @param tags 标签（逗号分隔）
     * @param userId 上传者ID
     * @param userName 上传者姓名
     * @return 资源信息
     */
    ResourceInfo upload(MultipartFile file, String title, Integer categoryId,
                        String description, String tags, Integer userId, String userName);

    /**
     * 删除资源
     * @param resourceId 资源ID
     * @return 影响行数
     */
    int deleteResource(Integer resourceId);

    /**
     * 增加浏览量
     * @param resourceId 资源ID
     */
    void increaseViewCount(Integer resourceId);

    /**
     * 增加下载量
     * @param resourceId 资源ID
     */
    void increaseDownloadCount(Integer resourceId);

    /**
     * 增加收藏量
     * @param resourceId 资源ID
     */
    void increaseCollectCount(Integer resourceId);

    /**
     * 查询用户的资源列表
     * @param uploaderId 上传者ID
     * @param params 查询参数
     * @return 资源列表
     */
    java.util.List<ResourceInfo> getResourcesByUploaderId(Integer uploaderId, Map<String, Object> params);

    /**
     * 管理员获取所有资源（包括所有状态）
     * @param params 查询参数
     * @return 资源列表
     */
    java.util.List<ResourceInfo> getAllResources(Map<String, Object> params);

    /**
     * 更新资源状态
     * @param resourceId 资源ID
     * @param status 状态（1已发布，0已下架）
     * @return 是否成功
     */
    boolean updateStatus(Integer resourceId, Integer status);

    /**
     * 批量更新状态
     * @param resourceIds 资源ID数组
     * @param status 状态
     * @return 是否成功
     */
    boolean batchUpdateStatus(Integer[] resourceIds, Integer status);

    /**
     * 获取资源统计
     * @return 统计数据DTO
     */
    ResourceStatisticsDto getResourceStatistics();
}
