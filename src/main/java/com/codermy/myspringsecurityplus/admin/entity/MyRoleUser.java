package com.codermy.myspringsecurityplus.admin.entity;

import lombok.Data;

import java.io.Serializable;

/**
 * @author codermy
 * @createTime 2025/7/10
 */
@Data
public class MyRoleUser implements Serializable {

    private static final long serialVersionUID = 8545514045582235838L;

    private Integer userId;

    private Integer roleId;
}
