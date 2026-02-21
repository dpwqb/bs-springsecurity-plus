package com.codermy.myspringsecurityplus.resource.entity;

import com.codermy.myspringsecurityplus.admin.entity.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 文章实体
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class MyArticle extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 文章ID */
    private Integer articleId;

    /** 文章标题 */
    private String title;

    /** 文章内容（富文本HTML） */
    private String content;

    /** 文章摘要 */
    private String summary;

    /** 文章分类ID */
    private Integer categoryId;

    /** 封面图片路径 */
    private String coverImage;

    /** 浏览次数 */
    private Integer viewCount;

    /** 点赞次数 */
    private Integer likeCount;

    /** 作者用户ID */
    private Integer authorId;

    /** 作者姓名（冗余） */
    private String authorName;

    /** 状态：0草稿 1已发布 2已下架 */
    private Integer status;

    /** 发布时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date publishTime;
}
