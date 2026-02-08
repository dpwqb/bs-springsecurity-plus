package com.codermy.myspringsecurityplus.resource.entity;

import com.codermy.myspringsecurityplus.admin.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * 资源标签关联实体
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class ResourceTagRelation extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 关联ID */
    private Integer id;

    /** 资源ID */
    private Integer resourceId;

    /** 标签ID */
    private Integer tagId;
}
