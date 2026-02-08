package com.codermy.myspringsecurityplus.resource.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 资源上传请求DTO
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@ApiModel("资源上传请求")
public class ResourceUploadDto {

    @ApiModelProperty(value = "资源标题", required = true)
    private String title;

    @ApiModelProperty(value = "分类ID", required = true)
    private Integer categoryId;

    @ApiModelProperty(value = "资源描述")
    private String description;

    @ApiModelProperty(value = "标签（逗号分隔，如：SpringBoot,教程）")
    private String tags;
}
