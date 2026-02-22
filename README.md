<div align="center">
  <h1 align="center">
    学享汇资源共享平台
  </h1>
  <p align="center">
    <a href="https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html">
      <img src="https://img.shields.io/badge/jdk-1.8-yellowgreen" alt="jdk">
    </a>
    <a href="https://www.mit-license.org/">
          <img src="https://img.shields.io/badge/License-MIT-brightgreen" alt="License">
        </a>
  </p>
</div>

### 前言
基于SpringBoot+Vue开发的资源共享平台。
### 系统功能
- 用户管理：提供用户的相关配置
- 角色管理：对权限与菜单进行分配
- 菜单管理：已实现菜单动态路由
- 系统日志：记录用户操作日志与异常日志
- SQL监控：采用druid 监控数据库访问性能
- 接口管理：方便统一查看管理接口
- 部门管理：配置系统用户所属部门组织
- 岗位管理：配置系统用户所属担任职务
- 字典管理：配置维护系统中较为固定的数据

### 技术选型
1、SpringBoot
2、MyBatis
3、SpringSecurity
4、MySql
5、Druid
6、Swagger
8、Redis
9、JWT
10、[Pear Admin Layui](https://gitee.com/pear-admin/Pear-Admin-Layui)
### 快速使用
- 下载项目
- 导入idea
- 导入docs文件夹下sql文件到数据库
- 修改数据库配置文件的路径，用户名等信息
- 在settings--plugins中搜索并安装lombok插件(Lombok 是一个编译时库，在Idea上有支持的插件，可用来帮助开发人员消除冗长的Java代码，例如实体中的setters和getters),否则编译不过。
- 运行（启动后端接口及管理后台）端口：8088
- 进入xue-xiang-hui目录
- 执行命令：`npm install`安装依赖
- 执行命令：`npm run dev`启动Vue前端，端口：3000

### 项目中初始用户和密码

- **后台登录：** 用户：admin和test，密码：123456。其余的，若用户名是test1(2)，则密码是六个1(2)，依次类推
- **Druid：** 用户：admin，密码：admin

### 项目部署
- 先进入xue-xiang-hui目录
- 执行命令：`npm run build`编译前端至`src/main/resources/static`目录
- 进入项目根目录，执行命令：`mvn clean package -DskipTests`编译后端
- 运行项目，执行命令：`java -jar target/xue-xiang-hui-0.0.1-SNAPSHOT.jar`
