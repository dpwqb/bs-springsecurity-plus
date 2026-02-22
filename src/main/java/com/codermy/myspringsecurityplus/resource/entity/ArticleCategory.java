package com.codermy.myspringsecurityplus.resource.entity;

import com.codermy.myspringsecurityplus.admin.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * 文章分类实体
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class ArticleCategory extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 分类ID */
    private Integer categoryId;

    /** 父分类ID，0表示顶级分类 */
    private Integer parentId;

    /** 分类名称 */
    private String categoryName;

    /** 分类描述 */
    private String description;

    /** 分类图标 */
    private String icon;

    /** 排序序号 */
    private Integer sortOrder;

    /** 状态：1启用 0禁用 */
    private Integer status;
}
