package com.codermy.myspringsecurityplus;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
/**
 * @author codermy
 * @createTime 2025/7/10
 */
@SpringBootApplication
@MapperScan({"com.codermy.myspringsecurityplus.admin.dao", "com.codermy.myspringsecurityplus.log.dao", "com.codermy.myspringsecurityplus.resource.dao"})
public class MySpringsecurityPlusApplication {

    public static void main(String[] args) {
        SpringApplication.run(MySpringsecurityPlusApplication.class, args);
    }

}
