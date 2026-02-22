package com.codermy.myspringsecurityplus.admin.dto;

import lombok.Data;
import lombok.Getter;
import java.io.Serializable;

/**
 * @author codermy
 * @createTime 2025/7/12
 */
@Data
@Getter
public class MenuDto implements Serializable {

    private Integer id;

    private Integer parentId;

    private String checkArr = "0";

    private String title;

    public Integer getParentId() {
        return parentId;
    }
}
