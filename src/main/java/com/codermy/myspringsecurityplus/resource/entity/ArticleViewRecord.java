package com.codermy.myspringsecurityplus.resource.entity;

import com.codermy.myspringsecurityplus.admin.entity.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 文章浏览记录实体
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class ArticleViewRecord extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Integer recordId;

    /** 文章ID */
    private Integer articleId;

    /** 浏览用户ID（NULL表示游客） */
    private Integer userId;

    /** 浏览时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date viewTime;

    /** 浏览IP */
    private String ipAddress;
}
