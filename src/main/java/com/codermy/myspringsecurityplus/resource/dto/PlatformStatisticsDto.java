package com.codermy.myspringsecurityplus.resource.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 平台统计数据DTO（公开）
 * @author codermy
 * @createTime 2025/2/19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@ApiModel(description = "平台统计数据（公开）")
public class PlatformStatisticsDto {

    @ApiModelProperty(value = "总资源数")
    private Long totalResources;

    @ApiModelProperty(value = "总用户数")
    private Long totalUsers;

    @ApiModelProperty(value = "今日下载次数")
    private Integer todayDownloads;
}
