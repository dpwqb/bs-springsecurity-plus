package com.codermy.myspringsecurityplus.resource.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonGetter;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 文章详情响应DTO（完整字段）
 * @author codermy
 * @createTime 2025/2/19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ArticleResponseDto {

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

    /** 收藏次数 */
    private Integer collectCount;

    /** 评论次数 */
    private Integer commentCount;

    /** 作者用户ID */
    private Integer authorId;

    /** 作者姓名（冗余） */
    private String authorName;

    /** 关联的资源ID */
    private Integer relatedResourceId;

    /** 关联资源标题（冗余） */
    private String relatedResourceTitle;

    /** 状态：0草稿 1已发布 2已下架 */
    private Integer status;

    /** 是否置顶：0否 1是 */
    private Integer isTop;

    /** 是否推荐：0否 1是 */
    private Integer isRecommend;

    /** 是否原创：0转载 1原创 */
    private Integer isOriginal;

    /** 发布时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date publishTime;

    /**
     * 获取封面图片URL（自动添加/uploads/前缀）
     */
    @JsonGetter("coverImage")
    public String getCoverImageUrl() {
        if (coverImage == null || coverImage.trim().isEmpty()) {
            return null;
        }

        String trimmed = coverImage.trim();

        // 如果已经是完整URL，直接返回
        if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
            return trimmed;
        }

        // 如果已经有/uploads/前缀，直接返回
        if (trimmed.startsWith("/uploads/")) {
            return trimmed;
        }

        // 为相对路径添加/uploads/前缀
        return "/uploads/" + trimmed;
    }
}
