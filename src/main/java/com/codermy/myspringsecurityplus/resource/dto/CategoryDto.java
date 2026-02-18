package com.codermy.myspringsecurityplus.resource.dto;

import lombok.Data;
import java.io.Serializable;

/**
 * 文章分类树形数据传输对象
 * 参考 MenuDto 实现，用于 dtree 组件
 * @author codermy
 * @createTime 2025/2/18
 */
@Data
public class CategoryDto implements Serializable {

    /** 分类ID */
    private Integer id;

    /** 父分类ID */
    private Integer parentId;

    /** 分类名称 */
    private String title;
}
