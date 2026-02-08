package com.codermy.myspringsecurityplus.resource.entity;

import com.codermy.myspringsecurityplus.admin.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * 文章标签关联实体
 * @author codermy
 * @createTime 2025/2/8
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class ArticleTagRelation extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 关联ID */
    private Integer id;

    /** 文章ID */
    private Integer articleId;

    /** 标签ID（复用resource_tag表） */
    private Integer tagId;
}
