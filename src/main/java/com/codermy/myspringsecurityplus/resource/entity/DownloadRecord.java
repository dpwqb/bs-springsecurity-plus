package com.codermy.myspringsecurityplus.resource.entity;

import com.codermy.myspringsecurityplus.admin.entity.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 下载记录实体
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class DownloadRecord extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Integer recordId;

    /** 资源ID */
    private Integer resourceId;

    /** 下载用户ID */
    private Integer userId;

    /** 用户姓名（冗余） */
    private String userName;

    /** 资源标题（冗余） */
    private String resourceTitle;

    /** 下载时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date downloadTime;

    /** 下载IP */
    private String ipAddress;
}
