package com.codermy.myspringsecurityplus.resource.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

/**
 * 文章发布请求DTO
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@ApiModel("文章发布请求")
public class ArticlePublishDto {

    @ApiModelProperty(value = "文章标题", required = true)
    private String title;

    @ApiModelProperty(value = "文章内容（富文本HTML）", required = true)
    private String content;

    @ApiModelProperty(value = "文章摘要")
    private String summary;

    @ApiModelProperty(value = "分类ID")
    private Integer categoryId;

    @ApiModelProperty(value = "封面图片URL")
    private String coverImage;

    @ApiModelProperty(value = "标签ID列表")
    private List<Integer> tags;

    @ApiModelProperty(value = "关联资源ID")
    private Integer relatedResourceId;

    @ApiModelProperty(value = "是否原创（0转载 1原创）")
    private Integer isOriginal = 1;

    @ApiModelProperty(value = "状态（0草稿 1已发布）")
    private Integer status = 1;

    @ApiModelProperty(value = "文章ID（编辑时必传）")
    private Integer articleId;
}
