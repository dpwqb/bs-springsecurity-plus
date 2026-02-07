package com.codermy.myspringsecurityplus.admin.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * @author codermy
 * @createTime 2025/8/20
 */
@Data
public class JobQueryDto implements Serializable {
    private String queryName;

    private Integer queryStatus;
}
