package com.codermy.myspringsecurityplus.resource.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.Date;

/**
 * 下载记录查询条件DTO
 * @author codermy
 * @createTime 2025/2/22
 */
@Data
@ApiModel("下载记录查询条件")
public class DownloadQueryDto {

    @ApiModelProperty(value = "用户名（模糊搜索）")
    private String userName;

    @ApiModelProperty(value = "资源标题（模糊搜索）")
    private String resourceTitle;

    @ApiModelProperty(value = "开始时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    @ApiModelProperty(value = "结束时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    @ApiModelProperty(value = "IP地址")
    private String ipAddress;
}
