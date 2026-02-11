package com.codermy.myspringsecurityplus.resource.dao;

import com.codermy.myspringsecurityplus.resource.entity.ResourceInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

/**
 * 资源数据访问层
 * @author codermy
 * @createTime 2025/2/8
 */
@Mapper
public interface ResourceDao {

    /**
     * 分页查询资源列表（支持多条件搜索）
     * @param params 查询参数
     * @return 资源列表
     */
    List<ResourceInfo> getResourceByPage(@Param("params") Map<String, Object> params);

    /**
     * 根据ID查询资源详情
     * @param resourceId 资源ID
     * @return 资源详情
     */
    @Select("SELECT * FROM resource_info WHERE resource_id = #{resourceId}")
    ResourceInfo getResourceById(Integer resourceId);

    /**
     * 保存资源
     * @param resource 资源信息
     * @return 影响行数
     */
    int save(ResourceInfo resource);

    /**
     * 更新资源
     * @param resource 资源信息
     * @return 影响行数
     */
    int update(ResourceInfo resource);

    /**
     * 删除资源
     * @param resourceId 资源ID
     * @return 影响行数
     */
    int delete(Integer resourceId);

    /**
     * 增加浏览量
     * @param resourceId 资源ID
     * @return 影响行数
     */
    int increaseViewCount(Integer resourceId);

    /**
     * 增加下载量
     * @param resourceId 资源ID
     * @return 影响行数
     */
    int increaseDownloadCount(Integer resourceId);

    /**
     * 增加收藏量
     * @param resourceId 资源ID
     * @return 影响行数
     */
    int increaseCollectCount(Integer resourceId);

    /**
     * 查询用户的资源列表
     * @param uploaderId 上传者ID
     * @param params 查询参数
     * @return 资源列表
     */
    List<ResourceInfo> getResourcesByUploaderId(@Param("uploaderId") Integer uploaderId, @Param("params") Map<String, Object> params);

    /**
     * 管理员获取所有资源（包括所有状态）
     * @param params 查询参数
     * @return 资源列表
     */
    List<ResourceInfo> getAllResourcesForAdmin(@Param("params") Map<String, Object> params);

    /**
     * 更新资源状态
     * @param resourceId 资源ID
     * @param status 状态
     * @return 影响行数
     */
    int updateStatus(@Param("resourceId") Integer resourceId, @Param("status") Integer status);

    /**
     * 批量更新资源状态
     * @param resourceIds 资源ID列表
     * @param status 状态
     * @return 影响行数
     */
    int batchUpdateStatus(@Param("resourceIds") List<Integer> resourceIds, @Param("status") Integer status);

    /**
     * 获取资源统计
     * @return 统计数据
     */
    Map<String, Object> getResourceStatistics();

    /**
     * 获取今日新增资源数
     * @return 今日新增数量
     */
    int getTodayResourceCount();
}
