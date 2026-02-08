package com.codermy.myspringsecurityplus.resource.entity;

import com.codermy.myspringsecurityplus.admin.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * 资源信息实体
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class ResourceInfo extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 资源ID */
    private Integer resourceId;

    /** 资源标题 */
    private String title;

    /** 资源描述 */
    private String description;

    /** 所属分类ID */
    private Integer categoryId;

    /** 文件原始名称 */
    private String fileName;

    /** 文件存储路径 */
    private String filePath;

    /** 文件大小（字节） */
    private Long fileSize;

    /** 文件类型：pdf/doc/docx/ppt/pptx/txt */
    private String fileType;

    /** 封面图片路径 */
    private String coverImage;

    /** 浏览次数 */
    private Integer viewCount;

    /** 下载次数 */
    private Integer downloadCount;

    /** 收藏次数 */
    private Integer collectCount;

    /** 上传者用户ID */
    private Integer uploaderId;

    /** 上传者姓名（冗余） */
    private String uploaderName;

    /** 状态：1已发布 0已下架 */
    private Integer status;
}
