package com.codermy.myspringsecurityplus.admin.controller;

import com.codermy.myspringsecurityplus.admin.dto.RegisterRequest;
import com.codermy.myspringsecurityplus.admin.service.UserService;
import com.codermy.myspringsecurityplus.common.utils.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

/**
 * 认证控制器 - 处理注册相关接口
 *
 * @author codermy
 * @createTime 2025-07-10
 */
@RestController
@RequestMapping("/api/auth")
@Api(tags = "认证：注册相关")
public class AuthController {

    @Autowired
    private UserService userService;

    /**
     * 用户注册
     *
     * @param request 注册请求
     * @param httpRequest HTTP请求
     * @return 注册结果
     */
    @PostMapping("/register")
    @ResponseBody
    @ApiOperation(value = "用户注册")
    public Result register(@RequestBody RegisterRequest request,
                           HttpServletRequest httpRequest) {
        // 参数校验
        if (request.getUsername() == null || request.getUsername().trim().isEmpty()) {
            return Result.error().message("用户名不能为空");
        }
        if (request.getEmail() == null || request.getEmail().trim().isEmpty()) {
            return Result.error().message("邮箱不能为空");
        }
        if (request.getPassword() == null || request.getPassword().trim().isEmpty()) {
            return Result.error().message("密码不能为空");
        }
        if (request.getCaptcha() == null || request.getCaptcha().trim().isEmpty()) {
            return Result.error().message("验证码不能为空");
        }

        // 验证码校验（从 session 中获取）
        String sessionCaptcha = (String) httpRequest.getSession().getAttribute("captcha");
        if (sessionCaptcha == null || !sessionCaptcha.equalsIgnoreCase(request.getCaptcha())) {
            return Result.error().message("验证码错误或已失效");
        }

        // 清除已使用的验证码
        httpRequest.getSession().removeAttribute("captcha");

        // 调用服务层注册
        return userService.registerUser(
                request.getUsername().trim(),
                request.getEmail().trim(),
                request.getPassword()
        );
    }
}
