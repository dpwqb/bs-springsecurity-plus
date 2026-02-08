package com.codermy.myspringsecurityplus.resource.entity;

import com.codermy.myspringsecurityplus.admin.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * 资源标签实体
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class ResourceTag extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 标签ID */
    private Integer tagId;

    /** 标签名称 */
    private String tagName;

    /** 使用次数 */
    private Integer useCount;
}
