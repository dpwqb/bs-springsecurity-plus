package com.codermy.myspringsecurityplus.resource.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 文章统计数据DTO
 * @author codermy
 * @createTime 2025/2/11
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@ApiModel(description = "文章统计数据")
public class ArticleStatisticsDto {

    @ApiModelProperty(value = "总文章数")
    private Long totalArticles;

    @ApiModelProperty(value = "今日新增")
    private Integer todayArticles;

    @ApiModelProperty(value = "总浏览量")
    private Long totalViews;

    @ApiModelProperty(value = "总点赞数")
    private Long totalLikes;
}
