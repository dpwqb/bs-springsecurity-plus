package com.codermy.myspringsecurityplus.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 首页路由控制器
 * 负责处理前端Vue应用和管理后台的路由转发
 *
 * @author codermy
 * @createTime 2025/2/22
 */
@Controller
public class IndexController {

    /**
     * Vue前端入口 - 访问根路径时直接返回Vue应用
     */
    @GetMapping("/")
    public String index() {
        return "forward:/index.html";
    }

    /**
     * 管理后台主页面 - 返回PearAdmin框架页面
     * 注意：此路径需要认证，未登录用户会被Spring Security重定向到 /login.html
     */
    @GetMapping("/admin")
    public String admin() {
        return "index";
    }

    /**
     * Vue前端路由支持（SPA路由fallback）
     * 当访问Vue应用的其他路径时，返回index.html由Vue Router处理
     * Vue Router使用history模式，需要服务器端支持
     */
    @GetMapping({
        "/resources",
        "/articles",
        "/upload",
        "/my-resources",
        "/my-favorites",
        "/my-downloads",
        "/my-articles"
    })
    public String forwardToVue() {
        return "forward:/index.html";
    }
}
