package com.codermy.myspringsecurityplus.admin.controller;

import com.codermy.myspringsecurityplus.admin.dto.MenuIndexDto;
import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.log.service.MyLogService;
import com.codermy.myspringsecurityplus.resource.dto.ArticleStatisticsDto;
import com.codermy.myspringsecurityplus.resource.dto.ResourceStatisticsDto;
import com.codermy.myspringsecurityplus.resource.service.ArticleService;
import com.codermy.myspringsecurityplus.resource.service.DownloadService;
import com.codermy.myspringsecurityplus.resource.service.ResourceService;
import com.codermy.myspringsecurityplus.security.dto.JwtUserDto;
import com.codermy.myspringsecurityplus.admin.service.MenuService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

/**
 * @author codermy
 * @createTime 2025/7/16
 */
@Controller
@RequestMapping("/api")
@Api(tags = "系统：菜单路由")
public class AdminController {
    @Autowired
    private MenuService menuService;

    @Autowired
    private MyLogService myLogService;

    @Autowired
    private ResourceService resourceService;

    @Autowired
    private ArticleService articleService;

    @Autowired
    private DownloadService downloadService;

    @GetMapping(value = "/index")
    @ResponseBody
    @ApiOperation(value = "通过用户id获取菜单")
    public List<MenuIndexDto> getMenu() {
        JwtUserDto jwtUserDto = (JwtUserDto)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Integer userId = jwtUserDto.getMyUser().getUserId();
        return menuService.getMenu(userId);
    }
    
    @GetMapping("/console")
    @ApiOperation(value = "后台首页")
    public String console(){
        return "console/console";
    }

    @GetMapping("/form/build")
    @ApiOperation(value = "后台首页")
    public String formBuild(){
        return "system/form/index";
    }

    @GetMapping("/403")
    @ApiOperation(value = "403页面")
    public String error403(){
        return "error/403";
    }

    @GetMapping("/404")
    @ApiOperation(value = "404页面")
    public String error404(){
        return "error/404";
    }

    @GetMapping("/500")
    @ApiOperation(value = "500页面")
    public String error500(){
        return "error/500";
    }

    /**
     * 获取仪表盘统计数据
     * @return 统计数据
     */
    @GetMapping("/dashboard/statistics")
    @ResponseBody
    @ApiOperation(value = "获取仪表盘统计数据")
    public Result getDashboardStatistics() {
        Map<String, Object> data = new HashMap<>();

        // 今日访问量
        Integer todayVisits = myLogService.countTodayVisits();
        data.put("todayVisits", todayVisits);

        // 资源统计
        ResourceStatisticsDto resourceStats = resourceService.getResourceStatistics();
        data.put("totalResources", resourceStats.getTotal());
        data.put("todayResources", resourceStats.getToday());

        // 文章统计
        ArticleStatisticsDto articleStats = articleService.getArticleStatistics();
        data.put("totalArticles", articleStats.getTotalArticles());
        data.put("todayArticles", articleStats.getTodayArticles());

        // 总下载量（从资源统计中获取）
        data.put("totalDownloads", resourceStats.getTotalDownloads());

        // 今日下载次数
        Integer todayDownloads = downloadService.countTodayDownloads();
        data.put("todayDownloads", todayDownloads);

        return Result.ok()
                .data(Collections.singletonList(data))
                .message("查询成功");
    }

    /**
     * 获取下载趋势数据（最近6个月）
     * @return 下载趋势数据
     */
    @GetMapping("/dashboard/download-trend")
    @ResponseBody
    @ApiOperation(value = "获取下载趋势数据")
    public Result getDownloadTrend() {
        List<Map<String, Object>> trendData = downloadService.getDownloadTrendLast6Months();

        // 提取月份和下载数量
        List<String> months = new ArrayList<>();
        List<Integer> counts = new ArrayList<>();

        for (Map<String, Object> item : trendData) {
            months.add((String) item.get("month"));
            counts.add(((Number) item.get("downloadCount")).intValue());
        }

        Map<String, Object> result = new HashMap<>();
        result.put("months", months);
        result.put("counts", counts);

        return Result.ok()
                .data(Collections.singletonList(result))
                .message("查询成功");
    }

}
