package com.codermy.myspringsecurityplus.resource.entity;

import com.codermy.myspringsecurityplus.admin.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * 收藏记录实体
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class FavoriteRecord extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 收藏ID */
    private Integer favoriteId;

    /** 用户ID */
    private Integer userId;

    /** 资源ID */
    private Integer resourceId;
}
