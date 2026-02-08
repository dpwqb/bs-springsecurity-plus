package com.codermy.myspringsecurityplus.security.handler;

import com.alibaba.fastjson.JSON;
import com.codermy.myspringsecurityplus.security.dto.JwtUserDto;
import com.codermy.myspringsecurityplus.security.utils.JwtUtils;
import com.codermy.myspringsecurityplus.common.utils.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;

/**
 * @author codermy
 * @createTime 2025/8/1
 * 登录成功
 */
@Component
@Slf4j
public class MyAuthenticationSuccessHandler implements AuthenticationSuccessHandler {
    @Autowired
    private JwtUtils jwtUtils;
    @Value("${jwt.tokenHeader}")
    private String tokenHeader;
    @Value("${jwt.tokenHead}")
    private String tokenHead;
    @Override
    public void onAuthenticationSuccess(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication authentication) throws IOException, ServletException {

        JwtUserDto userDetails = (JwtUserDto) authentication.getPrincipal();
        String jwtToken = jwtUtils.generateToken(userDetails.getUsername());

        HttpSession session = httpServletRequest.getSession();
        //删除缓存里的验证码信息
        session.removeAttribute("captcha");

        // 构建响应数据，包含 token 和用户信息
        Result result = Result.ok()
                .jwt(jwtToken)
                .data(Collections.singletonList(userDetails))
                .message("登录成功");

        //修改编码格式
        httpServletResponse.setCharacterEncoding("utf-8");
        httpServletResponse.setContentType("application/json");
        //输出结果
        httpServletResponse.getWriter().write(JSON.toJSONString(result));

    }
}
