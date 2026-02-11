package com.codermy.myspringsecurityplus.resource.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 资源统计数据DTO
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@ApiModel(description = "资源统计数据")
public class ResourceStatisticsDto {

    @ApiModelProperty(value = "总资源数")
    private Long total;

    @ApiModelProperty(value = "今日新增")
    private Integer today;

    @ApiModelProperty(value = "总下载量")
    private Long totalDownloads;

    @ApiModelProperty(value = "总浏览量")
    private Long totalViews;
}
