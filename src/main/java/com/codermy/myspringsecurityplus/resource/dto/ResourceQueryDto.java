package com.codermy.myspringsecurityplus.resource.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 资源查询条件DTO
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@ApiModel("资源查询条件")
public class ResourceQueryDto {

    @ApiModelProperty(value = "关键词（标题、描述模糊搜索）")
    private String keyword;

    @ApiModelProperty(value = "分类ID")
    private Integer categoryId;

    @ApiModelProperty(value = "文件类型（pdf/doc/docx/ppt/pptx/txt）")
    private String fileType;

    @ApiModelProperty(value = "状态（1已发布 0已下架）")
    private Integer status;

    @ApiModelProperty(value = "上传者ID")
    private Integer uploaderId;

    @ApiModelProperty(value = "排序字段（create_time/download_count/view_count）")
    private String sortBy = "create_time";

    @ApiModelProperty(value = "排序方向（asc/desc）")
    private String sortOrder = "desc";
}
