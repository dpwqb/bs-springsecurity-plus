package com.codermy.myspringsecurityplus.admin.dto;

import lombok.Data;

/**
 * 注册请求DTO
 *
 * @author codermy
 * @createTime 2025-07-10
 */
@Data
public class RegisterRequest {

    /**
     * 用户名
     */
    private String username;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 密码
     */
    private String password;

    /**
     * 验证码
     */
    private String captcha;
}
