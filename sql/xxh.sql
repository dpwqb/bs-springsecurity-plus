-- --------------------------------------------------------
-- 主机:                           localhost
-- 服务器版本:                        11.7.2-MariaDB - mariadb.org binary distribution
-- 服务器操作系统:                      Win64
-- HeidiSQL 版本:                  12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- 导出 my-springsecurity-plus 的数据库结构
CREATE DATABASE IF NOT EXISTS `my-springsecurity-plus` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;
USE `my-springsecurity-plus`;

-- 导出  表 my-springsecurity-plus.ai_chat_history 结构
CREATE TABLE IF NOT EXISTS `ai_chat_history` (
  `chat_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '对话ID',
  `user_id` int(32) NOT NULL COMMENT '用户ID',
  `session_id` varchar(100) NOT NULL COMMENT '会话ID（UUID）',
  `question_text` text NOT NULL COMMENT '用户选中的问题文本',
  `question_context` text DEFAULT NULL COMMENT '问题上下文（网页内容片段）',
  `answer_text` text NOT NULL COMMENT 'AI回答内容',
  `model_name` varchar(50) DEFAULT 'gpt-3.5-turbo' COMMENT '使用的模型',
  `tokens_used` int(10) DEFAULT 0 COMMENT '消耗的token数',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '对话时间',
  PRIMARY KEY (`chat_id`),
  KEY `idx_user_session` (`user_id`,`session_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='AI对话记录表';

-- 正在导出表  my-springsecurity-plus.ai_chat_history 的数据：~0 rows (大约)
INSERT INTO `ai_chat_history` (`chat_id`, `user_id`, `session_id`, `question_text`, `question_context`, `answer_text`, `model_name`, `tokens_used`, `create_time`) VALUES
	(1, 1, 'string', 'string', 'string', '当你提到 "string" 时，你通常是在谈论编程或计算机科学中的某种数据类型或结构。在某些编程语言和库中，"string" 是指一个表示文本的变量或对象。\n\n例如，在Java中，String 类是一个类，用于存储文本信息，并允许你在程序中多次引用相同的字符串内容。当你定义一个新的 String 对象时，你可以给它赋值：\n\n```java\nString hello = "Hello, world!";\n```\n\n在这个例子中，"hello" 是一个 String 对象的名称，代表了包含字符串“Hello, 世界!”的内容。你可以使用这个对象来执行各种操作，比如打印到控制台或进行比较。\n\n在其他语言如Python中，"string" 可能是指类似 "Hello, world!" 这样的文本数据。它是一种简单的序列类型，可以像数组一样使用，并且是可变的。因此，你可以在同一个字符串上连续添加字符：\n\n```python\ns = "Hello"\ns += \' \'\ns += "world!"\nprint(s)  # 输出: Hello world!\n```\n\n总结来说，在不同的情境下，“string” 可能指代的是文本数据、编程语言中的字符串类型、或是一组可以像数组一样操作的字符序列。', 'qwen2.5:1.5b', 324, '2026-02-08 18:38:11');

-- 导出  表 my-springsecurity-plus.article_category 结构
CREATE TABLE IF NOT EXISTS `article_category` (
  `category_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `parent_id` int(32) DEFAULT 0 COMMENT '父分类ID，0表示顶级分类',
  `category_name` varchar(100) NOT NULL COMMENT '分类名称',
  `description` varchar(500) DEFAULT NULL COMMENT '分类描述',
  `icon` varchar(100) DEFAULT NULL COMMENT '分类图标',
  `sort_order` int(5) DEFAULT 0 COMMENT '排序序号',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：1启用 0禁用',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  `update_time` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '更新时间',
  PRIMARY KEY (`category_id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='文章分类表';

-- 正在导出表  my-springsecurity-plus.article_category 的数据：~10 rows (大约)
INSERT INTO `article_category` (`category_id`, `parent_id`, `category_name`, `description`, `icon`, `sort_order`, `status`, `create_time`, `update_time`) VALUES
	(1, 0, '技术教程', '技术教程类文章', 'layui-icon layui-icon-template', 1, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(2, 0, '学习笔记', '学习心得和笔记', 'layui-icon layui-icon-note', 2, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(3, 0, '问题解决', '问题排查和解决方案', 'layui-icon layui-icon-ok-circle', 3, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(4, 0, '项目实战', '项目实战经验分享', 'layui-icon layui-icon-engine', 4, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(5, 0, '职业发展', '职业规划和经验', 'layui-icon layui-icon-user', 5, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(6, 1, 'Java教程', 'Java相关教程', NULL, 1, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(7, 1, 'Python教程', 'Python相关教程', NULL, 2, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(8, 1, '前端教程', '前端开发教程', NULL, 3, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(9, 1, '数据库教程', '数据库相关教程', NULL, 4, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(10, 3, 'Bug解决', 'Bug排查和解决', NULL, 1, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32');

-- 导出  表 my-springsecurity-plus.article_tag_relation 结构
CREATE TABLE IF NOT EXISTS `article_tag_relation` (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `article_id` int(32) NOT NULL COMMENT '文章ID',
  `tag_id` int(32) NOT NULL COMMENT '标签ID（复用resource_tag表）',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_article_tag` (`article_id`,`tag_id`),
  KEY `idx_tag_id` (`tag_id`),
  KEY `idx_article_id` (`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='文章标签关联表';

-- 正在导出表  my-springsecurity-plus.article_tag_relation 的数据：~0 rows (大约)

-- 导出  表 my-springsecurity-plus.article_view_record 结构
CREATE TABLE IF NOT EXISTS `article_view_record` (
  `record_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `article_id` int(32) NOT NULL COMMENT '文章ID',
  `user_id` int(32) DEFAULT NULL COMMENT '浏览用户ID（NULL表示游客）',
  `user_name` varchar(100) DEFAULT NULL COMMENT '用户姓名（冗余）',
  `article_title` varchar(200) DEFAULT NULL COMMENT '文章标题（冗余）',
  `view_time` datetime DEFAULT current_timestamp() COMMENT '浏览时间',
  `ip_address` varchar(50) DEFAULT NULL COMMENT '浏览IP',
  `duration` int(10) DEFAULT NULL COMMENT '阅读时长（秒）',
  PRIMARY KEY (`record_id`),
  KEY `idx_article_id` (`article_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_view_time` (`view_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='文章浏览记录表';

-- 正在导出表  my-springsecurity-plus.article_view_record 的数据：~0 rows (大约)

-- 导出  表 my-springsecurity-plus.download_record 结构
CREATE TABLE IF NOT EXISTS `download_record` (
  `record_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `resource_id` int(32) NOT NULL COMMENT '资源ID',
  `user_id` int(32) NOT NULL COMMENT '下载用户ID',
  `user_name` varchar(100) DEFAULT NULL COMMENT '用户姓名（冗余）',
  `resource_title` varchar(200) DEFAULT NULL COMMENT '资源标题（冗余）',
  `download_time` datetime DEFAULT current_timestamp() COMMENT '下载时间',
  `ip_address` varchar(50) DEFAULT NULL COMMENT '下载IP',
  PRIMARY KEY (`record_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='下载记录表';

-- 正在导出表  my-springsecurity-plus.download_record 的数据：~0 rows (大约)

-- 导出  表 my-springsecurity-plus.favorite_record 结构
CREATE TABLE IF NOT EXISTS `favorite_record` (
  `favorite_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` int(32) NOT NULL COMMENT '用户ID',
  `resource_id` int(32) NOT NULL COMMENT '资源ID',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '收藏时间',
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `uk_user_resource` (`user_id`,`resource_id`),
  KEY `idx_resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='收藏记录表';

-- 正在导出表  my-springsecurity-plus.favorite_record 的数据：~0 rows (大约)

-- 导出  表 my-springsecurity-plus.my_article 结构
CREATE TABLE IF NOT EXISTS `my_article` (
  `article_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `title` varchar(200) NOT NULL COMMENT '文章标题',
  `content` mediumtext NOT NULL COMMENT '文章内容（富文本HTML）',
  `summary` varchar(500) DEFAULT NULL COMMENT '文章摘要',
  `category_id` int(32) DEFAULT NULL COMMENT '文章分类ID',
  `cover_image` varchar(500) DEFAULT NULL COMMENT '封面图片路径',
  `view_count` int(10) DEFAULT 0 COMMENT '浏览次数',
  `like_count` int(10) DEFAULT 0 COMMENT '点赞次数',
  `collect_count` int(10) DEFAULT 0 COMMENT '收藏次数',
  `comment_count` int(10) DEFAULT 0 COMMENT '评论次数',
  `author_id` int(32) NOT NULL COMMENT '作者用户ID',
  `author_name` varchar(100) DEFAULT NULL COMMENT '作者姓名（冗余）',
  `related_resource_id` int(32) DEFAULT NULL COMMENT '关联的资源ID',
  `related_resource_title` varchar(200) DEFAULT NULL COMMENT '关联资源标题（冗余）',
  `status` tinyint(1) DEFAULT 0 COMMENT '状态：0草稿 1已发布 2已下架',
  `is_top` tinyint(1) DEFAULT 0 COMMENT '是否置顶：0否 1是',
  `is_recommend` tinyint(1) DEFAULT 0 COMMENT '是否推荐：0否 1是',
  `is_original` tinyint(1) DEFAULT 1 COMMENT '是否原创：0转载 1原创',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  `update_time` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '更新时间',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`article_id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_author` (`author_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_is_top` (`is_top`),
  KEY `idx_is_recommend` (`is_recommend`),
  KEY `idx_related_resource` (`related_resource_id`),
  FULLTEXT KEY `ft_title_summary` (`title`,`summary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='文章主表';

-- 正在导出表  my-springsecurity-plus.my_article 的数据：~0 rows (大约)

-- 导出  表 my-springsecurity-plus.my_dept 结构
CREATE TABLE IF NOT EXISTS `my_dept` (
  `dept_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `parent_id` int(32) DEFAULT NULL COMMENT '上级部门',
  `ancestors` varchar(50) DEFAULT NULL COMMENT '祖级列表',
  `dept_name` varchar(255) DEFAULT NULL COMMENT '名称',
  `sort` int(5) DEFAULT NULL COMMENT '排序',
  `status` bit(1) NOT NULL COMMENT '状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_dept 的数据：~7 rows (大约)
INSERT INTO `my_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `sort`, `status`, `create_time`, `update_time`) VALUES
	(1, 0, '0', '南京总公司', 1, b'1', '2025-08-19 11:01:09', '2025-09-08 18:21:26'),
	(2, 1, '0,1', '研发部门', 1, b'1', '2025-08-19 11:01:28', '2025-08-19 11:01:30'),
	(3, 1, '0,1', '市场部门', 2, b'1', '2025-08-19 11:01:47', '2025-08-19 11:01:48'),
	(4, 1, '0,1', '运维部门', 3, b'1', '2025-08-19 11:02:01', '2025-08-19 11:02:04'),
	(5, 0, '0', '苏州分公司', 2, b'1', '2025-08-19 11:07:36', '2025-08-27 14:18:48'),
	(6, 5, '0,5', '营销部门', 1, b'1', '2025-08-19 11:08:40', '2025-08-21 20:32:40'),
	(7, 5, '0,5', '运维部门', 2, b'1', '2025-08-19 11:08:56', '2025-09-08 18:03:56');

-- 导出  表 my-springsecurity-plus.my_dict 结构
CREATE TABLE IF NOT EXISTS `my_dict` (
  `dict_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `dict_name` varchar(255) DEFAULT NULL COMMENT '字典名称',
  `description` varchar(255) DEFAULT NULL COMMENT '字典描述',
  `sort` int(32) DEFAULT NULL COMMENT '字典排序',
  `create_by` varchar(255) DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(255) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dict_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_dict 的数据：~0 rows (大约)
INSERT INTO `my_dict` (`dict_id`, `dict_name`, `description`, `sort`, `create_by`, `update_by`, `create_time`, `update_time`) VALUES
	(1, '性别', '性别字典', 1, 'admin', 'admin', '2025-11-07 15:06:18', '2025-11-07 15:06:20');

-- 导出  表 my-springsecurity-plus.my_dict_detail 结构
CREATE TABLE IF NOT EXISTS `my_dict_detail` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `dict_id` int(32) DEFAULT NULL COMMENT '字典id',
  `label` varchar(255) DEFAULT NULL COMMENT '字典标签',
  `value` varchar(255) DEFAULT NULL COMMENT '字典值',
  `sort` int(32) DEFAULT NULL COMMENT '字典详情排序',
  `create_by` varchar(255) DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(255) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_dict_detail 的数据：~2 rows (大约)
INSERT INTO `my_dict_detail` (`id`, `dict_id`, `label`, `value`, `sort`, `create_by`, `update_by`, `create_time`, `update_time`) VALUES
	(1, 1, '男', '1', 1, NULL, NULL, NULL, NULL),
	(2, 1, '女', '2', 2, NULL, NULL, NULL, NULL);

-- 导出  表 my-springsecurity-plus.my_job 结构
CREATE TABLE IF NOT EXISTS `my_job` (
  `job_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `job_name` varchar(255) NOT NULL COMMENT '岗位名称',
  `status` tinyint(1) DEFAULT NULL COMMENT '岗位状态',
  `sort` int(5) DEFAULT NULL COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_job 的数据：~3 rows (大约)
INSERT INTO `my_job` (`job_id`, `job_name`, `status`, `sort`, `create_time`, `update_time`) VALUES
	(1, '部门经理', 1, 1, '2025-08-19 11:14:55', '2025-08-19 11:14:57'),
	(2, '人事专员', 1, 2, '2025-08-19 11:15:30', '2025-08-19 11:15:33'),
	(3, '普通员工', 1, 3, '2025-08-19 11:16:19', '2025-09-02 10:48:34');

-- 导出  表 my-springsecurity-plus.my_log 结构
CREATE TABLE IF NOT EXISTS `my_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `user_name` varchar(255) DEFAULT NULL COMMENT '用户名',
  `ip` varchar(64) DEFAULT NULL COMMENT '请求ip',
  `description` varchar(255) DEFAULT NULL COMMENT '操作描述',
  `params` varchar(255) DEFAULT NULL COMMENT '参数值',
  `browser` varchar(255) DEFAULT NULL COMMENT '浏览器',
  `time` bigint(20) DEFAULT NULL COMMENT '执行时间',
  `type` varchar(255) DEFAULT NULL COMMENT '日志类型',
  `method` varchar(255) DEFAULT NULL COMMENT '执行方法',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `exception_detail` text DEFAULT NULL COMMENT '异常详细信息',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2784 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_log 的数据：~82 rows (大约)
INSERT INTO `my_log` (`log_id`, `user_name`, `ip`, `description`, `params`, `browser`, `time`, `type`, `method`, `create_time`, `exception_detail`) VALUES
	(2629, 'admin', '192.168.31.61', '查询岗位', '{ pageTableRequest: PageTableRequest(page=null, limit=null, offset=0) jobQueryDto: JobQueryDto(queryName=null, queryStatus=null) }', 'Chrome 8', 1, 'ERROR', 'com.codermy.myspringsecurityplus.admin.controller.JobController.getJobAll()', '2025-10-31 11:21:05', 'java.lang.NullPointerException\r\n	at com.codermy.myspringsecurityplus.admin.service.impl.JobServiceImpl.getJobAll(JobServiceImpl.java:35)\r\n	at com.codermy.myspringsecurityplus.admin.controller.JobController.getJobAll(JobController.java:44)\r\n	at com.codermy.myspringsecurityplus.admin.controller.JobController$$FastClassBySpringCGLIB$$fc005977.invoke(<generated>)\r\n	at org.springframework.cglib.proxy.MethodProxy.invoke(MethodProxy.java:218)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.invokeJoinpoint(CglibAopProxy.java:771)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.aspectj.AspectJAfterThrowingAdvice.invoke(AspectJAfterThrowingAdvice.java:62)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:175)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.aspectj.MethodInvocationProceedingJoinPoint.proceed(MethodInvocationProceedingJoinPoint.java:88)\r\n	at com.codermy.myspringsecurityplus.log.aspect.LogAspect.saveSysLog(LogAspect.java:46)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.springframework.aop.aspectj.AbstractAspectJAdvice.invokeAdviceMethodWithGivenArgs(AbstractAspectJAdvice.java:644)\r\n	at org.springframework.aop.aspectj.AbstractAspectJAdvice.invokeAdviceMethod(AbstractAspectJAdvice.java:633)\r\n	at org.springframework.aop.aspectj.AspectJAroundAdvice.invoke(AspectJAroundAdvice.java:70)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:175)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.security.access.intercept.aopalliance.MethodSecurityInterceptor.invoke(MethodSecurityInterceptor.java:69)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:95)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.framework.CglibAopProxy$DynamicAdvisedInterceptor.intercept(CglibAopProxy.java:691)\r\n	at com.codermy.myspringsecurityplus.admin.controller.JobController$$EnhancerBySpringCGLIB$$d9741499.getJobAll(<generated>)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:190)\r\n	at org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:138)\r\n	at org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:105)\r\n	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:879)\r\n	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:793)\r\n	at org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:87)\r\n	at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:1040)\r\n	at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:943)\r\n	at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:1006)\r\n	at org.springframework.web.servlet.FrameworkServlet.doGet(FrameworkServlet.java:898)\r\n	at javax.servlet.http.HttpServlet.service(HttpServlet.java:634)\r\n	at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:883)\r\n	at javax.servlet.http.HttpServlet.service(HttpServlet.java:741)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:231)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:113)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at com.codermy.myspringsecurityplus.security.filter.JwtAuthenticationTokenFilter.doFilterInternal(JwtAuthenticationTokenFilter.java:60)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:320)\r\n	at org.springframework.security.web.access.intercept.FilterSecurityInterceptor.invoke(FilterSecurityInterceptor.java:126)\r\n	at org.springframework.security.web.access.intercept.FilterSecurityInterceptor.doFilter(FilterSecurityInterceptor.java:90)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.access.ExceptionTranslationFilter.doFilter(ExceptionTranslationFilter.java:118)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.session.SessionManagementFilter.doFilter(SessionManagementFilter.java:137)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.AnonymousAuthenticationFilter.doFilter(AnonymousAuthenticationFilter.java:111)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.rememberme.RememberMeAuthenticationFilter.doFilter(RememberMeAuthenticationFilter.java:158)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestFilter.doFilter(SecurityContextHolderAwareRequestFilter.java:158)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.savedrequest.RequestCacheAwareFilter.doFilter(RequestCacheAwareFilter.java:63)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.www.BasicAuthenticationFilter.doFilterInternal(BasicAuthenticationFilter.java:155)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter.doFilter(AbstractAuthenticationProcessingFilter.java:200)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at com.codermy.myspringsecurityplus.security.filter.VerifyCodeFilter.doFilterInternal(VerifyCodeFilter.java:51)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.logout.LogoutFilter.doFilter(LogoutFilter.java:116)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.header.HeaderWriterFilter.doHeadersAfter(HeaderWriterFilter.java:92)\r\n	at org.springframework.security.web.header.HeaderWriterFilter.doFilterInternal(HeaderWriterFilter.java:77)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.context.SecurityContextPersistenceFilter.doFilter(SecurityContextPersistenceFilter.java:105)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.context.request.async.WebAsyncManagerIntegrationFilter.doFilterInternal(WebAsyncManagerIntegrationFilter.java:56)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.FilterChainProxy.doFilterInternal(FilterChainProxy.java:215)\r\n	at org.springframework.security.web.FilterChainProxy.doFilter(FilterChainProxy.java:178)\r\n	at org.springframework.web.filter.DelegatingFilterProxy.invokeDelegate(DelegatingFilterProxy.java:358)\r\n	at org.springframework.web.filter.DelegatingFilterProxy.doFilter(DelegatingFilterProxy.java:271)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.RequestContextFilter.doFilterInternal(RequestContextFilter.java:100)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.FormContentFilter.doFilterInternal(FormContentFilter.java:93)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:201)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:202)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:96)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:541)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:139)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:74)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:343)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:373)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:65)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:868)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1590)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)\r\n	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)\r\n	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)\r\n	at java.lang.Thread.run(Thread.java:748)\r\n'),
	(2703, 'admin', '192.168.31.244', '删除所有INFO日志', '{ }', 'Chrome 8', 5, 'INFO', 'com.codermy.myspringsecurityplus.log.controller.LogController.delAllByInfo()', '2025-11-07 16:12:51', NULL),
	(2704, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 28, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:17:01', NULL),
	(2705, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 5, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:17:41', NULL),
	(2706, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:19:15', NULL),
	(2707, 'admin', '192.168.31.244', '查询岗位', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) jobQueryDto: JobQueryDto(queryName=null, queryStatus=null) }', 'Chrome 8', 8, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.JobController.getJobAll()', '2025-11-07 16:19:22', NULL),
	(2708, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 5, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:19:23', NULL),
	(2709, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:22:10', NULL),
	(2710, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 5, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:23:27', NULL),
	(2711, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 30, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:25:14', NULL),
	(2712, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 32, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:27:31', NULL),
	(2713, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 30, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:29:17', NULL),
	(2714, 'admin', '192.168.31.244', '查询岗位', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) jobQueryDto: JobQueryDto(queryName=null, queryStatus=null) }', 'Chrome 8', 13, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.JobController.getJobAll()', '2025-11-07 16:31:43', NULL),
	(2715, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 22, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:34:26', NULL),
	(2716, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 23, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:39:06', NULL),
	(2717, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 24, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:40:41', NULL),
	(2718, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 4, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:40:43', NULL),
	(2719, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:48:19', NULL),
	(2720, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 159, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:53:09', NULL),
	(2721, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:54:49', NULL),
	(2722, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 28, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:55:43', NULL),
	(2723, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:56:42', NULL),
	(2724, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 16:57:42', NULL),
	(2725, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 17:01:03', NULL),
	(2726, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 17:04:29', NULL),
	(2727, 'admin', '192.168.31.244', '查询岗位', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) jobQueryDto: JobQueryDto(queryName=null, queryStatus=null) }', 'Chrome 8', 21, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.JobController.getJobAll()', '2025-11-07 17:06:24', NULL),
	(2728, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 17:10:10', NULL),
	(2729, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 31, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 17:22:00', NULL),
	(2730, 'admin', '192.168.31.244', '添加字典', '{ myDict: MyDict(dictId=null, dictName=测试, description=描述测试, sort=2, createBy=null, updateBy=null) }', 'Chrome 8', 8, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.saveJob()', '2025-11-07 17:22:12', NULL),
	(2731, 'admin', '192.168.31.244', '添加字典', '{ myDict: MyDict(dictId=null, dictName=测试2, description=描述测试, sort=2, createBy=null, updateBy=null) }', 'Chrome 8', 94, 'ERROR', 'com.codermy.myspringsecurityplus.admin.controller.DictController.saveJob()', '2025-11-07 17:22:15', 'org.springframework.dao.DataIntegrityViolationException: \r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'dict_id\' cannot be null\r\n### The error may exist in com/codermy/myspringsecurityplus/admin/dao/DictDao.java (best guess)\r\n### The error may involve com.codermy.myspringsecurityplus.admin.dao.DictDao.insertDict-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO my_dict(dict_id,dict_name,description, sort,create_time, update_time)values(?,?,?,?, now(), now())\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'dict_id\' cannot be null\n; Column \'dict_id\' cannot be null; nested exception is java.sql.SQLIntegrityConstraintViolationException: Column \'dict_id\' cannot be null\r\n	at org.springframework.jdbc.support.SQLExceptionSubclassTranslator.doTranslate(SQLExceptionSubclassTranslator.java:87)\r\n	at org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:72)\r\n	at org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:81)\r\n	at org.mybatis.spring.MyBatisExceptionTranslator.translateExceptionIfPossible(MyBatisExceptionTranslator.java:88)\r\n	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:440)\r\n	at com.sun.proxy.$Proxy99.insert(Unknown Source)\r\n	at org.mybatis.spring.SqlSessionTemplate.insert(SqlSessionTemplate.java:271)\r\n	at org.apache.ibatis.binding.MapperMethod.execute(MapperMethod.java:62)\r\n	at org.apache.ibatis.binding.MapperProxy$PlainMethodInvoker.invoke(MapperProxy.java:144)\r\n	at org.apache.ibatis.binding.MapperProxy.invoke(MapperProxy.java:85)\r\n	at com.sun.proxy.$Proxy115.insertDict(Unknown Source)\r\n	at com.codermy.myspringsecurityplus.admin.service.impl.DictServiceImpl.insertDict(DictServiceImpl.java:46)\r\n	at com.codermy.myspringsecurityplus.admin.controller.DictController.saveJob(DictController.java:63)\r\n	at com.codermy.myspringsecurityplus.admin.controller.DictController$$FastClassBySpringCGLIB$$1.invoke(<generated>)\r\n	at org.springframework.cglib.proxy.MethodProxy.invoke(MethodProxy.java:218)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.invokeJoinpoint(CglibAopProxy.java:771)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.aspectj.AspectJAfterThrowingAdvice.invoke(AspectJAfterThrowingAdvice.java:62)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:175)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.aspectj.MethodInvocationProceedingJoinPoint.proceed(MethodInvocationProceedingJoinPoint.java:88)\r\n	at com.codermy.myspringsecurityplus.log.aspect.LogAspect.saveSysLog(LogAspect.java:46)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.springframework.aop.aspectj.AbstractAspectJAdvice.invokeAdviceMethodWithGivenArgs(AbstractAspectJAdvice.java:644)\r\n	at org.springframework.aop.aspectj.AbstractAspectJAdvice.invokeAdviceMethod(AbstractAspectJAdvice.java:633)\r\n	at org.springframework.aop.aspectj.AspectJAroundAdvice.invoke(AspectJAroundAdvice.java:70)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:175)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.security.access.intercept.aopalliance.MethodSecurityInterceptor.invoke(MethodSecurityInterceptor.java:69)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:95)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.framework.CglibAopProxy$DynamicAdvisedInterceptor.intercept(CglibAopProxy.java:691)\r\n	at com.codermy.myspringsecurityplus.admin.controller.DictController$$EnhancerBySpringCGLIB$$1.saveJob(<generated>)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:190)\r\n	at org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:138)\r\n	at org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:105)\r\n	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:879)\r\n	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:793)\r\n	at org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:87)\r\n	at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:1040)\r\n	at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:943)\r\n	at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:1006)\r\n	at org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:909)\r\n	at javax.servlet.http.HttpServlet.service(HttpServlet.java:660)\r\n	at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:883)\r\n	at javax.servlet.http.HttpServlet.service(HttpServlet.java:741)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:231)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:113)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at com.codermy.myspringsecurityplus.security.filter.JwtAuthenticationTokenFilter.doFilterInternal(JwtAuthenticationTokenFilter.java:60)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:320)\r\n	at org.springframework.security.web.access.intercept.FilterSecurityInterceptor.invoke(FilterSecurityInterceptor.java:126)\r\n	at org.springframework.security.web.access.intercept.FilterSecurityInterceptor.doFilter(FilterSecurityInterceptor.java:90)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.access.ExceptionTranslationFilter.doFilter(ExceptionTranslationFilter.java:118)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.session.SessionManagementFilter.doFilter(SessionManagementFilter.java:137)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.AnonymousAuthenticationFilter.doFilter(AnonymousAuthenticationFilter.java:111)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.rememberme.RememberMeAuthenticationFilter.doFilter(RememberMeAuthenticationFilter.java:158)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestFilter.doFilter(SecurityContextHolderAwareRequestFilter.java:158)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.savedrequest.RequestCacheAwareFilter.doFilter(RequestCacheAwareFilter.java:63)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.www.BasicAuthenticationFilter.doFilterInternal(BasicAuthenticationFilter.java:155)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter.doFilter(AbstractAuthenticationProcessingFilter.java:200)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at com.codermy.myspringsecurityplus.security.filter.VerifyCodeFilter.doFilterInternal(VerifyCodeFilter.java:51)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.logout.LogoutFilter.doFilter(LogoutFilter.java:116)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.header.HeaderWriterFilter.doHeadersAfter(HeaderWriterFilter.java:92)\r\n	at org.springframework.security.web.header.HeaderWriterFilter.doFilterInternal(HeaderWriterFilter.java:77)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.context.SecurityContextPersistenceFilter.doFilter(SecurityContextPersistenceFilter.java:105)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.context.request.async.WebAsyncManagerIntegrationFilter.doFilterInternal(WebAsyncManagerIntegrationFilter.java:56)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.FilterChainProxy.doFilterInternal(FilterChainProxy.java:215)\r\n	at org.springframework.security.web.FilterChainProxy.doFilter(FilterChainProxy.java:178)\r\n	at org.springframework.web.filter.DelegatingFilterProxy.invokeDelegate(DelegatingFilterProxy.java:358)\r\n	at org.springframework.web.filter.DelegatingFilterProxy.doFilter(DelegatingFilterProxy.java:271)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.RequestContextFilter.doFilterInternal(RequestContextFilter.java:100)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.FormContentFilter.doFilterInternal(FormContentFilter.java:93)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:201)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:202)\r\n	at org.apache.catalina.core.StandardContextValve.__invoke(StandardContextValve.java:96)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:41002)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:541)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:139)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:74)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:343)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:373)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:65)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:868)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1590)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)\r\n	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)\r\n	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)\r\n	at java.lang.Thread.run(Thread.java:748)\r\nCaused by: java.sql.SQLIntegrityConstraintViolationException: Column \'dict_id\' cannot be null\r\n	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:117)\r\n	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:97)\r\n	at com.mysql.cj.jdbc.exceptions.SQLExceptionsMapping.translateException(SQLExceptionsMapping.java:122)\r\n	at com.mysql.cj.jdbc.ClientPreparedStatement.executeInternal(ClientPreparedStatement.java:953)\r\n	at com.mysql.cj.jdbc.ClientPreparedStatement.execute(ClientPreparedStatement.java:370)\r\n	at com.alibaba.druid.filter.FilterChainImpl.preparedStatement_execute(FilterChainImpl.java:3461)\r\n	at com.alibaba.druid.filter.FilterEventAdapter.preparedStatement_execute(FilterEventAdapter.java:440)\r\n	at com.alibaba.druid.filter.FilterChainImpl.preparedStatement_execute(FilterChainImpl.java:3459)\r\n	at com.alibaba.druid.proxy.jdbc.PreparedStatementProxyImpl.execute(PreparedStatementProxyImpl.java:167)\r\n	at com.alibaba.druid.pool.DruidPooledPreparedStatement.execute(DruidPooledPreparedStatement.java:497)\r\n	at org.apache.ibatis.executor.statement.PreparedStatementHandler.update(PreparedStatementHandler.java:47)\r\n	at org.apache.ibatis.executor.statement.RoutingStatementHandler.update(RoutingStatementHandler.java:74)\r\n	at org.apache.ibatis.executor.SimpleExecutor.doUpdate(SimpleExecutor.java:50)\r\n	at org.apache.ibatis.executor.BaseExecutor.update(BaseExecutor.java:117)\r\n	at org.apache.ibatis.executor.CachingExecutor.update(CachingExecutor.java:76)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.apache.ibatis.plugin.Plugin.invoke(Plugin.java:63)\r\n	at com.sun.proxy.$Proxy153.update(Unknown Source)\r\n	at org.apache.ibatis.session.defaults.DefaultSqlSession.update(DefaultSqlSession.java:197)\r\n	at org.apache.ibatis.session.defaults.DefaultSqlSession.insert(DefaultSqlSession.java:184)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:426)\r\n	... 134 more\r\n'),
	(2732, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 17:56:44', NULL),
	(2733, 'admin', '192.168.31.244', '添加字典', '{ myDict: MyDict(dictId=null, dictName=测试, description=1, sort=1, createBy=null, updateBy=null) }', 'Chrome 8', 4, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.saveJob()', '2025-11-07 17:56:54', NULL),
	(2734, 'admin', '192.168.31.244', '添加字典', '{ myDict: MyDict(dictId=null, dictName=测试1, description=1, sort=1, createBy=null, updateBy=null) }', 'Chrome 8', 73, 'ERROR', 'com.codermy.myspringsecurityplus.admin.controller.DictController.saveJob()', '2025-11-07 17:57:10', 'org.springframework.dao.DataIntegrityViolationException: \r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'dict_id\' cannot be null\r\n### The error may exist in com/codermy/myspringsecurityplus/admin/dao/DictDao.java (best guess)\r\n### The error may involve com.codermy.myspringsecurityplus.admin.dao.DictDao.insertDict-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO my_dict(dict_id,dict_name,description, sort,create_time, update_time)values(?,?,?,?, now(), now())\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'dict_id\' cannot be null\n; Column \'dict_id\' cannot be null; nested exception is java.sql.SQLIntegrityConstraintViolationException: Column \'dict_id\' cannot be null\r\n	at org.springframework.jdbc.support.SQLExceptionSubclassTranslator.doTranslate(SQLExceptionSubclassTranslator.java:87)\r\n	at org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:72)\r\n	at org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:81)\r\n	at org.mybatis.spring.MyBatisExceptionTranslator.translateExceptionIfPossible(MyBatisExceptionTranslator.java:88)\r\n	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:440)\r\n	at com.sun.proxy.$Proxy99.insert(Unknown Source)\r\n	at org.mybatis.spring.SqlSessionTemplate.insert(SqlSessionTemplate.java:271)\r\n	at org.apache.ibatis.binding.MapperMethod.execute(MapperMethod.java:62)\r\n	at org.apache.ibatis.binding.MapperProxy$PlainMethodInvoker.invoke(MapperProxy.java:144)\r\n	at org.apache.ibatis.binding.MapperProxy.invoke(MapperProxy.java:85)\r\n	at com.sun.proxy.$Proxy115.insertDict(Unknown Source)\r\n	at com.codermy.myspringsecurityplus.admin.service.impl.DictServiceImpl.insertDict(DictServiceImpl.java:46)\r\n	at com.codermy.myspringsecurityplus.admin.controller.DictController.saveJob(DictController.java:63)\r\n	at com.codermy.myspringsecurityplus.admin.controller.DictController$$FastClassBySpringCGLIB$$1.invoke(<generated>)\r\n	at org.springframework.cglib.proxy.MethodProxy.invoke(MethodProxy.java:218)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.invokeJoinpoint(CglibAopProxy.java:771)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.aspectj.AspectJAfterThrowingAdvice.invoke(AspectJAfterThrowingAdvice.java:62)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:175)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.aspectj.MethodInvocationProceedingJoinPoint.proceed(MethodInvocationProceedingJoinPoint.java:88)\r\n	at com.codermy.myspringsecurityplus.log.aspect.LogAspect.saveSysLog(LogAspect.java:46)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.springframework.aop.aspectj.AbstractAspectJAdvice.invokeAdviceMethodWithGivenArgs(AbstractAspectJAdvice.java:644)\r\n	at org.springframework.aop.aspectj.AbstractAspectJAdvice.invokeAdviceMethod(AbstractAspectJAdvice.java:633)\r\n	at org.springframework.aop.aspectj.AspectJAroundAdvice.invoke(AspectJAroundAdvice.java:70)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:175)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.security.access.intercept.aopalliance.MethodSecurityInterceptor.invoke(MethodSecurityInterceptor.java:69)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:95)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.framework.CglibAopProxy$DynamicAdvisedInterceptor.intercept(CglibAopProxy.java:691)\r\n	at com.codermy.myspringsecurityplus.admin.controller.DictController$$EnhancerBySpringCGLIB$$1.saveJob(<generated>)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:190)\r\n	at org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:138)\r\n	at org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:105)\r\n	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:879)\r\n	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:793)\r\n	at org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:87)\r\n	at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:1040)\r\n	at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:943)\r\n	at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:1006)\r\n	at org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:909)\r\n	at javax.servlet.http.HttpServlet.service(HttpServlet.java:660)\r\n	at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:883)\r\n	at javax.servlet.http.HttpServlet.service(HttpServlet.java:741)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:231)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:113)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at com.codermy.myspringsecurityplus.security.filter.JwtAuthenticationTokenFilter.doFilterInternal(JwtAuthenticationTokenFilter.java:60)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:320)\r\n	at org.springframework.security.web.access.intercept.FilterSecurityInterceptor.invoke(FilterSecurityInterceptor.java:126)\r\n	at org.springframework.security.web.access.intercept.FilterSecurityInterceptor.doFilter(FilterSecurityInterceptor.java:90)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.access.ExceptionTranslationFilter.doFilter(ExceptionTranslationFilter.java:118)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.session.SessionManagementFilter.doFilter(SessionManagementFilter.java:137)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.AnonymousAuthenticationFilter.doFilter(AnonymousAuthenticationFilter.java:111)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.rememberme.RememberMeAuthenticationFilter.doFilter(RememberMeAuthenticationFilter.java:158)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestFilter.doFilter(SecurityContextHolderAwareRequestFilter.java:158)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.savedrequest.RequestCacheAwareFilter.doFilter(RequestCacheAwareFilter.java:63)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.www.BasicAuthenticationFilter.doFilterInternal(BasicAuthenticationFilter.java:155)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter.doFilter(AbstractAuthenticationProcessingFilter.java:200)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at com.codermy.myspringsecurityplus.security.filter.VerifyCodeFilter.doFilterInternal(VerifyCodeFilter.java:51)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.logout.LogoutFilter.doFilter(LogoutFilter.java:116)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.header.HeaderWriterFilter.doHeadersAfter(HeaderWriterFilter.java:92)\r\n	at org.springframework.security.web.header.HeaderWriterFilter.doFilterInternal(HeaderWriterFilter.java:77)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.context.SecurityContextPersistenceFilter.doFilter(SecurityContextPersistenceFilter.java:105)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.context.request.async.WebAsyncManagerIntegrationFilter.doFilterInternal(WebAsyncManagerIntegrationFilter.java:56)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.FilterChainProxy.doFilterInternal(FilterChainProxy.java:215)\r\n	at org.springframework.security.web.FilterChainProxy.doFilter(FilterChainProxy.java:178)\r\n	at org.springframework.web.filter.DelegatingFilterProxy.invokeDelegate(DelegatingFilterProxy.java:358)\r\n	at org.springframework.web.filter.DelegatingFilterProxy.doFilter(DelegatingFilterProxy.java:271)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.RequestContextFilter.doFilterInternal(RequestContextFilter.java:100)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.FormContentFilter.doFilterInternal(FormContentFilter.java:93)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:201)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:202)\r\n	at org.apache.catalina.core.StandardContextValve.__invoke(StandardContextValve.java:96)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:41002)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:541)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:139)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:74)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:343)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:373)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:65)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:868)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1590)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)\r\n	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)\r\n	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)\r\n	at java.lang.Thread.run(Thread.java:748)\r\nCaused by: java.sql.SQLIntegrityConstraintViolationException: Column \'dict_id\' cannot be null\r\n	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:117)\r\n	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:97)\r\n	at com.mysql.cj.jdbc.exceptions.SQLExceptionsMapping.translateException(SQLExceptionsMapping.java:122)\r\n	at com.mysql.cj.jdbc.ClientPreparedStatement.executeInternal(ClientPreparedStatement.java:953)\r\n	at com.mysql.cj.jdbc.ClientPreparedStatement.execute(ClientPreparedStatement.java:370)\r\n	at com.alibaba.druid.filter.FilterChainImpl.preparedStatement_execute(FilterChainImpl.java:3461)\r\n	at com.alibaba.druid.filter.FilterEventAdapter.preparedStatement_execute(FilterEventAdapter.java:440)\r\n	at com.alibaba.druid.filter.FilterChainImpl.preparedStatement_execute(FilterChainImpl.java:3459)\r\n	at com.alibaba.druid.proxy.jdbc.PreparedStatementProxyImpl.execute(PreparedStatementProxyImpl.java:167)\r\n	at com.alibaba.druid.pool.DruidPooledPreparedStatement.execute(DruidPooledPreparedStatement.java:497)\r\n	at org.apache.ibatis.executor.statement.PreparedStatementHandler.update(PreparedStatementHandler.java:47)\r\n	at org.apache.ibatis.executor.statement.RoutingStatementHandler.update(RoutingStatementHandler.java:74)\r\n	at org.apache.ibatis.executor.SimpleExecutor.doUpdate(SimpleExecutor.java:50)\r\n	at org.apache.ibatis.executor.BaseExecutor.update(BaseExecutor.java:117)\r\n	at org.apache.ibatis.executor.CachingExecutor.update(CachingExecutor.java:76)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.apache.ibatis.plugin.Plugin.invoke(Plugin.java:63)\r\n	at com.sun.proxy.$Proxy153.update(Unknown Source)\r\n	at org.apache.ibatis.session.defaults.DefaultSqlSession.update(DefaultSqlSession.java:197)\r\n	at org.apache.ibatis.session.defaults.DefaultSqlSession.insert(DefaultSqlSession.java:184)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:426)\r\n	... 134 more\r\n'),
	(2735, 'admin', '192.168.31.244', '添加字典', '{ myDict: MyDict(dictId=null, dictName=测试1, description=1, sort=1, createBy=null, updateBy=null) }', 'Chrome 8', 5, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.saveJob()', '2025-11-07 17:57:29', NULL),
	(2736, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 7, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getJobAll()', '2025-11-07 17:57:33', NULL),
	(2737, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 18:44:01', NULL),
	(2738, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 30, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 18:44:59', NULL),
	(2739, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 18:46:27', NULL),
	(2740, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 159, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 18:47:37', NULL),
	(2741, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 30, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 18:50:16', NULL),
	(2742, 'admin', '192.168.31.244', '添加字典', '{ myDict: MyDict(dictId=null, dictName=测试1, description=2, sort=1, createBy=null, updateBy=null) }', 'Chrome 8', 5, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.saveDict()', '2025-11-07 18:50:22', NULL),
	(2743, 'admin', '192.168.31.244', '添加字典', '{ myDict: MyDict(dictId=null, dictName=测试2, description=1, sort=1, createBy=null, updateBy=null) }', 'Chrome 8', 5, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.saveDict()', '2025-11-07 18:50:52', NULL),
	(2744, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 8, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 18:50:54', NULL),
	(2745, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 28, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 18:51:53', NULL),
	(2746, 'admin', '192.168.31.244', '查询角色', '{ request: PageTableRequest(page=1, limit=10, offset=0) myRole: MyRole(roleId=null, roleName=null, dataScope=null, description=null) }', 'Chrome 8', 18, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.RoleController.roleList()', '2025-11-07 18:52:09', NULL),
	(2747, 'admin', '192.168.31.244', '通过id绘制菜单树', '{ roleId: 1 }', 'Chrome 8', 17, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.MenuController.buildMenuAllByRoleId()', '2025-11-07 18:52:12', NULL),
	(2748, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 18:58:44', NULL),
	(2749, 'admin', '192.168.31.244', '查询岗位', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) jobQueryDto: JobQueryDto(queryName=null, queryStatus=null) }', 'Chrome 8', 7, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.JobController.getJobAll()', '2025-11-07 18:59:40', NULL),
	(2750, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 162, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 19:05:32', NULL),
	(2751, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 6, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 19:05:40', NULL),
	(2752, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 5, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 19:05:43', NULL),
	(2753, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 32, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 19:46:50', NULL),
	(2754, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 29, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 19:57:43', NULL),
	(2755, 'admin', '192.168.31.244', '添加字典详情', '{ myDictDetail: MyDictDetail(Id=null, dictId=1, label=中性别, value=0, sort=3, createBy=null, updateBy=null) }', 'Chrome 8', 61, 'ERROR', 'com.codermy.myspringsecurityplus.admin.controller.DictDetailController.saveDictDetail()', '2025-11-07 19:58:25', 'org.springframework.dao.DataIntegrityViolationException: \r\n### Error updating database.  Cause: java.sql.SQLException: Field \'id\' doesn\'t have a default value\r\n### The error may exist in com/codermy/myspringsecurityplus/admin/dao/DictDetailDao.java (best guess)\r\n### The error may involve com.codermy.myspringsecurityplus.admin.dao.DictDetailDao.insertDictDetail-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO my_dict_detail(dict_id,label,value, sort,create_time, update_time)values(?,?,?,?, now(), now())\r\n### Cause: java.sql.SQLException: Field \'id\' doesn\'t have a default value\n; Field \'id\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'id\' doesn\'t have a default value\r\n	at org.springframework.jdbc.support.SQLErrorCodeSQLExceptionTranslator.doTranslate(SQLErrorCodeSQLExceptionTranslator.java:247)\r\n	at org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:72)\r\n	at org.mybatis.spring.MyBatisExceptionTranslator.translateExceptionIfPossible(MyBatisExceptionTranslator.java:88)\r\n	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:440)\r\n	at com.sun.proxy.$Proxy99.insert(Unknown Source)\r\n	at org.mybatis.spring.SqlSessionTemplate.insert(SqlSessionTemplate.java:271)\r\n	at org.apache.ibatis.binding.MapperMethod.execute(MapperMethod.java:62)\r\n	at org.apache.ibatis.binding.MapperProxy$PlainMethodInvoker.invoke(MapperProxy.java:144)\r\n	at org.apache.ibatis.binding.MapperProxy.invoke(MapperProxy.java:85)\r\n	at com.sun.proxy.$Proxy116.insertDictDetail(Unknown Source)\r\n	at com.codermy.myspringsecurityplus.admin.service.impl.DictDetailServiceImpl.insertDictDetail(DictDetailServiceImpl.java:42)\r\n	at com.codermy.myspringsecurityplus.admin.controller.DictDetailController.saveDictDetail(DictDetailController.java:52)\r\n	at com.codermy.myspringsecurityplus.admin.controller.DictDetailController$$FastClassBySpringCGLIB$$1.invoke(<generated>)\r\n	at org.springframework.cglib.proxy.MethodProxy.invoke(MethodProxy.java:218)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.invokeJoinpoint(CglibAopProxy.java:771)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.aspectj.AspectJAfterThrowingAdvice.invoke(AspectJAfterThrowingAdvice.java:62)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:175)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.aspectj.MethodInvocationProceedingJoinPoint.proceed(MethodInvocationProceedingJoinPoint.java:88)\r\n	at com.codermy.myspringsecurityplus.log.aspect.LogAspect.saveSysLog(LogAspect.java:46)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.springframework.aop.aspectj.AbstractAspectJAdvice.invokeAdviceMethodWithGivenArgs(AbstractAspectJAdvice.java:644)\r\n	at org.springframework.aop.aspectj.AbstractAspectJAdvice.invokeAdviceMethod(AbstractAspectJAdvice.java:633)\r\n	at org.springframework.aop.aspectj.AspectJAroundAdvice.invoke(AspectJAroundAdvice.java:70)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:175)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.security.access.intercept.aopalliance.MethodSecurityInterceptor.invoke(MethodSecurityInterceptor.java:69)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:95)\r\n	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)\r\n	at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:749)\r\n	at org.springframework.aop.framework.CglibAopProxy$DynamicAdvisedInterceptor.intercept(CglibAopProxy.java:691)\r\n	at com.codermy.myspringsecurityplus.admin.controller.DictDetailController$$EnhancerBySpringCGLIB$$1.saveDictDetail(<generated>)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:190)\r\n	at org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:138)\r\n	at org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:105)\r\n	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:879)\r\n	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:793)\r\n	at org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:87)\r\n	at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:1040)\r\n	at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:943)\r\n	at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:1006)\r\n	at org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:909)\r\n	at javax.servlet.http.HttpServlet.service(HttpServlet.java:660)\r\n	at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:883)\r\n	at javax.servlet.http.HttpServlet.service(HttpServlet.java:741)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:231)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:113)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at com.codermy.myspringsecurityplus.security.filter.JwtAuthenticationTokenFilter.doFilterInternal(JwtAuthenticationTokenFilter.java:60)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:320)\r\n	at org.springframework.security.web.access.intercept.FilterSecurityInterceptor.invoke(FilterSecurityInterceptor.java:126)\r\n	at org.springframework.security.web.access.intercept.FilterSecurityInterceptor.doFilter(FilterSecurityInterceptor.java:90)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.access.ExceptionTranslationFilter.doFilter(ExceptionTranslationFilter.java:118)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.session.SessionManagementFilter.doFilter(SessionManagementFilter.java:137)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.AnonymousAuthenticationFilter.doFilter(AnonymousAuthenticationFilter.java:111)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.rememberme.RememberMeAuthenticationFilter.doFilter(RememberMeAuthenticationFilter.java:158)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestFilter.doFilter(SecurityContextHolderAwareRequestFilter.java:158)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.savedrequest.RequestCacheAwareFilter.doFilter(RequestCacheAwareFilter.java:63)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.www.BasicAuthenticationFilter.doFilterInternal(BasicAuthenticationFilter.java:155)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter.doFilter(AbstractAuthenticationProcessingFilter.java:200)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at com.codermy.myspringsecurityplus.security.filter.VerifyCodeFilter.doFilterInternal(VerifyCodeFilter.java:51)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.authentication.logout.LogoutFilter.doFilter(LogoutFilter.java:116)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.header.HeaderWriterFilter.doHeadersAfter(HeaderWriterFilter.java:92)\r\n	at org.springframework.security.web.header.HeaderWriterFilter.doFilterInternal(HeaderWriterFilter.java:77)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.context.SecurityContextPersistenceFilter.doFilter(SecurityContextPersistenceFilter.java:105)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.context.request.async.WebAsyncManagerIntegrationFilter.doFilterInternal(WebAsyncManagerIntegrationFilter.java:56)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\r\n	at org.springframework.security.web.FilterChainProxy.doFilterInternal(FilterChainProxy.java:215)\r\n	at org.springframework.security.web.FilterChainProxy.doFilter(FilterChainProxy.java:178)\r\n	at org.springframework.web.filter.DelegatingFilterProxy.invokeDelegate(DelegatingFilterProxy.java:358)\r\n	at org.springframework.web.filter.DelegatingFilterProxy.doFilter(DelegatingFilterProxy.java:271)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.RequestContextFilter.doFilterInternal(RequestContextFilter.java:100)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.FormContentFilter.doFilterInternal(FormContentFilter.java:93)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:201)\r\n	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:202)\r\n	at org.apache.catalina.core.StandardContextValve.__invoke(StandardContextValve.java:96)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:41002)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:541)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:139)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:74)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:343)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:373)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:65)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:868)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1590)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)\r\n	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)\r\n	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)\r\n	at java.lang.Thread.run(Thread.java:748)\r\nCaused by: java.sql.SQLException: Field \'id\' doesn\'t have a default value\r\n	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:129)\r\n	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:97)\r\n	at com.mysql.cj.jdbc.exceptions.SQLExceptionsMapping.translateException(SQLExceptionsMapping.java:122)\r\n	at com.mysql.cj.jdbc.ClientPreparedStatement.executeInternal(ClientPreparedStatement.java:953)\r\n	at com.mysql.cj.jdbc.ClientPreparedStatement.execute(ClientPreparedStatement.java:370)\r\n	at com.alibaba.druid.filter.FilterChainImpl.preparedStatement_execute(FilterChainImpl.java:3461)\r\n	at com.alibaba.druid.filter.FilterEventAdapter.preparedStatement_execute(FilterEventAdapter.java:440)\r\n	at com.alibaba.druid.filter.FilterChainImpl.preparedStatement_execute(FilterChainImpl.java:3459)\r\n	at com.alibaba.druid.proxy.jdbc.PreparedStatementProxyImpl.execute(PreparedStatementProxyImpl.java:167)\r\n	at com.alibaba.druid.pool.DruidPooledPreparedStatement.execute(DruidPooledPreparedStatement.java:497)\r\n	at org.apache.ibatis.executor.statement.PreparedStatementHandler.update(PreparedStatementHandler.java:47)\r\n	at org.apache.ibatis.executor.statement.RoutingStatementHandler.update(RoutingStatementHandler.java:74)\r\n	at org.apache.ibatis.executor.SimpleExecutor.doUpdate(SimpleExecutor.java:50)\r\n	at org.apache.ibatis.executor.BaseExecutor.update(BaseExecutor.java:117)\r\n	at org.apache.ibatis.executor.CachingExecutor.update(CachingExecutor.java:76)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.apache.ibatis.plugin.Plugin.invoke(Plugin.java:63)\r\n	at com.sun.proxy.$Proxy153.update(Unknown Source)\r\n	at org.apache.ibatis.session.defaults.DefaultSqlSession.update(DefaultSqlSession.java:197)\r\n	at org.apache.ibatis.session.defaults.DefaultSqlSession.insert(DefaultSqlSession.java:184)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n	at java.lang.reflect.Method.invoke(Method.java:498)\r\n	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:426)\r\n	... 134 more\r\n'),
	(2756, 'admin', '192.168.31.244', '添加字典详情', '{ myDictDetail: MyDictDetail(Id=null, dictId=1, label=中性别, value=0, sort=3, createBy=null, updateBy=null) }', 'Chrome 8', 3, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictDetailController.saveDictDetail()', '2025-11-07 19:58:37', NULL),
	(2757, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 33, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 20:04:22', NULL),
	(2758, 'admin', '192.168.31.244', '查询岗位', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) jobQueryDto: JobQueryDto(queryName=null, queryStatus=null) }', 'Chrome 8', 6, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.JobController.getJobAll()', '2025-11-07 20:05:06', NULL),
	(2759, 'admin', '192.168.31.244', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 8', 4, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2025-11-07 20:05:08', NULL),
	(2760, 'admin', '4.2.2.2', '查询角色', '{ request: PageTableRequest(page=1, limit=10, offset=0) myRole: MyRole(roleId=null, roleName=null, dataScope=null, description=null) }', 'Chrome 14', 75, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.RoleController.roleList()', '2026-02-07 23:35:48', NULL),
	(2761, 'admin', '4.2.2.2', '查询用户', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myUser: MyUser(userId=null, deptId=null, userName=null, password=null, nickName=null, phone=null, email=null, status=null, roleId=null, jobIds=null) }', 'Chrome 14', 14, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.UserController.userList()', '2026-02-07 23:35:50', NULL),
	(2762, 'admin', '4.2.2.2', '绘制部门树', '{ deptDto: DeptDto(id=null, parentId=null, checkArr=0, title=null) }', 'Chrome 14', 21, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DeptController.buildDeptAll()', '2026-02-07 23:35:50', NULL),
	(2763, 'admin', '4.2.2.2', '查询菜单', '{ queryName: null queryType: null }', 'Chrome 14', 13, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.MenuController.getMenuAll()', '2026-02-07 23:35:51', NULL),
	(2764, 'admin', '4.2.2.2', 'AI对话', '{ request: AiChatRequestDto(sessionId=string, selectedText=string, question=string, context=string) }', 'Chrome 14', 16243, 'INFO', 'com.codermy.myspringsecurityplus.resource.controller.AiChatController.chat()', '2026-02-08 18:38:11', NULL),
	(2765, 'admin', '4.2.2.2', '绘制部门树', '{ deptDto: DeptDto(id=null, parentId=null, checkArr=0, title=null) }', 'Chrome 14', 17, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DeptController.buildDeptAll()', '2026-02-08 20:31:52', NULL),
	(2766, 'admin', '4.2.2.2', '查询用户', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myUser: MyUser(userId=null, deptId=null, userName=null, password=null, nickName=null, phone=null, email=null, status=null, roleId=null, jobIds=null) }', 'Chrome 14', 102, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.UserController.userList()', '2026-02-08 20:31:52', NULL),
	(2767, 'admin', '4.2.2.2', '查询角色', '{ request: PageTableRequest(page=1, limit=10, offset=0) myRole: MyRole(roleId=null, roleName=null, dataScope=null, description=null) }', 'Chrome 14', 27, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.RoleController.roleList()', '2026-02-08 20:32:14', NULL),
	(2768, 'admin', '4.2.2.2', '查询菜单', '{ queryName: null queryType: null }', 'Chrome 14', 11, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.MenuController.getMenuAll()', '2026-02-08 20:32:14', NULL),
	(2769, 'admin', '4.2.2.2', '查询角色', '{ request: PageTableRequest(page=1, limit=10, offset=0) myRole: MyRole(roleId=null, roleName=null, dataScope=null, description=null) }', 'Chrome 14', 59, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.RoleController.roleList()', '2026-02-08 21:50:52', NULL),
	(2770, 'admin', '4.2.2.2', '绘制部门树', '{ deptDto: DeptDto(id=null, parentId=null, checkArr=0, title=null) }', 'Chrome 14', 14, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DeptController.buildDeptAll()', '2026-02-08 21:50:54', NULL),
	(2771, 'admin', '4.2.2.2', '查询用户', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myUser: MyUser(userId=null, deptId=null, userName=null, password=null, nickName=null, phone=null, email=null, status=null, roleId=null, jobIds=null) }', 'Chrome 14', 11, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.UserController.userList()', '2026-02-08 21:50:54', NULL),
	(2772, 'admin', '4.2.2.2', '查询角色', '{ request: PageTableRequest(page=1, limit=10, offset=0) myRole: MyRole(roleId=null, roleName=null, dataScope=null, description=null) }', 'Chrome 14', 62, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.RoleController.roleList()', '2026-02-09 00:04:36', NULL),
	(2773, 'admin', '4.2.2.2', '绘制部门树', '{ deptDto: DeptDto(id=null, parentId=null, checkArr=0, title=null) }', 'Chrome 14', 12, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DeptController.buildDeptAll()', '2026-02-09 00:04:37', NULL),
	(2774, 'admin', '4.2.2.2', '查询用户', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myUser: MyUser(userId=null, deptId=null, userName=null, password=null, nickName=null, phone=null, email=null, status=null, roleId=null, jobIds=null) }', 'Chrome 14', 9, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.UserController.userList()', '2026-02-09 00:04:37', NULL),
	(2775, 'admin', '4.2.2.2', '查询菜单', '{ queryName: null queryType: null }', 'Chrome 14', 4, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.MenuController.getMenuAll()', '2026-02-09 00:04:39', NULL),
	(2776, 'admin', '4.2.2.2', '查询部门', '{ myDept: MyDept(deptId=null, parentId=null, ancestors=null, deptName=null, sort=null, status=null) }', 'Chrome 14', 4, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DeptController.getDeptAll()', '2026-02-09 00:04:40', NULL),
	(2777, 'admin', '4.2.2.2', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 14', 8, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2026-02-09 00:04:41', NULL),
	(2778, 'admin', '4.2.2.2', '查询角色', '{ request: PageTableRequest(page=1, limit=10, offset=0) myRole: MyRole(roleId=null, roleName=null, dataScope=null, description=null) }', 'Chrome 14', 68, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.RoleController.roleList()', '2026-02-09 00:10:42', NULL),
	(2779, 'admin', '4.2.2.2', '绘制部门树', '{ deptDto: DeptDto(id=null, parentId=null, checkArr=0, title=null) }', 'Chrome 14', 17, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DeptController.buildDeptAll()', '2026-02-09 00:10:43', NULL),
	(2780, 'admin', '4.2.2.2', '查询用户', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myUser: MyUser(userId=null, deptId=null, userName=null, password=null, nickName=null, phone=null, email=null, status=null, roleId=null, jobIds=null) }', 'Chrome 14', 11, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.UserController.userList()', '2026-02-09 00:10:43', NULL),
	(2781, 'admin', '4.2.2.2', '查询菜单', '{ queryName: null queryType: null }', 'Chrome 14', 3, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.MenuController.getMenuAll()', '2026-02-11 20:17:13', NULL),
	(2782, 'admin', '4.2.2.2', '查询部门', '{ myDept: MyDept(deptId=null, parentId=null, ancestors=null, deptName=null, sort=null, status=null) }', 'Chrome 14', 11, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DeptController.getDeptAll()', '2026-02-11 20:17:14', NULL),
	(2783, 'admin', '4.2.2.2', '查询字典列表', '{ pageTableRequest: PageTableRequest(page=1, limit=10, offset=0) myDict: MyDict(dictId=null, dictName=null, description=null, sort=null, createBy=null, updateBy=null) }', 'Chrome 14', 60, 'INFO', 'com.codermy.myspringsecurityplus.admin.controller.DictController.getDictAll()', '2026-02-11 20:17:15', NULL);

-- 导出  表 my-springsecurity-plus.my_menu 结构
CREATE TABLE IF NOT EXISTS `my_menu` (
  `menu_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `parent_id` int(32) NOT NULL COMMENT '父级菜单id',
  `menu_name` varchar(255) NOT NULL COMMENT '菜单名称',
  `icon` varchar(255) DEFAULT NULL COMMENT '菜单图标',
  `url` varchar(255) DEFAULT NULL COMMENT 'url',
  `permission` varchar(255) DEFAULT NULL COMMENT '权限',
  `sort` int(12) DEFAULT NULL COMMENT '排序',
  `type` tinyint(1) NOT NULL COMMENT '类型',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_menu 的数据：~41 rows (大约)
INSERT INTO `my_menu` (`menu_id`, `parent_id`, `menu_name`, `icon`, `url`, `permission`, `sort`, `type`, `create_time`, `update_time`) VALUES
	(1, 0, '工作空间', 'layui-icon layui-icon-console', '', '', 1, 0, '2025-07-13 20:14:26', '2025-07-14 14:38:28'),
	(2, 1, '控制后台', 'layui-icon layui-icon-console', '/api/console', '', 2, 1, '2025-07-13 20:19:02', '2025-07-13 20:19:08'),
	(3, 0, '系统管理', 'layui-icon layui-icon-set-fill', '', '', 3, 0, '2025-07-10 09:33:00', '2025-07-12 21:03:22'),
	(4, 3, '用户管理', 'layui-icon layui-icon-username', '/api/user/index', 'user:list', 4, 1, '2025-07-10 09:33:33', '2025-07-13 09:30:12'),
	(5, 3, '角色管理', 'layui-icon layui-icon-user', '/api/role/index', 'role:list', 5, 1, '2025-07-10 09:34:17', '2025-07-10 09:34:20'),
	(6, 3, '菜单管理', 'layui-icon layui-icon-vercode', '/api/menu/index', 'menu:list', 6, 1, '2025-07-10 09:34:50', '2025-07-10 09:34:53'),
	(7, 0, '系统监控', 'layui-icon layui-icon-console', '', '', 7, 0, '2025-07-10 09:35:20', '2025-07-12 20:58:31'),
	(9, 7, '接口文档', 'layui-icon layui-icon-chart', '/swagger-ui.html', NULL, 9, 1, '2025-07-10 09:36:11', '2025-07-12 20:04:57'),
	(14, 4, '用户新增', NULL, NULL, 'user:add', 4, 2, '2025-07-10 09:36:41', '2025-07-10 09:36:44'),
	(15, 4, '用户编辑', NULL, NULL, 'user:edit', 4, 2, '2025-07-10 09:37:16', '2025-07-10 09:37:18'),
	(16, 4, '用户删除', NULL, NULL, 'user:del', 4, 2, '2025-07-10 09:37:38', '2025-07-10 09:37:40'),
	(17, 5, '角色新增', NULL, NULL, 'role:add', 5, 2, '2025-07-10 09:38:02', '2025-07-10 09:38:05'),
	(18, 5, '角色编辑', NULL, NULL, 'role:edit', 5, 2, '2025-07-10 09:38:30', '2025-07-10 09:38:32'),
	(19, 5, '角色删除', NULL, NULL, 'role:del', 5, 2, '2025-07-10 09:38:51', '2025-07-10 09:38:54'),
	(20, 6, '菜单新增', NULL, NULL, 'menu:add', 6, 2, '2025-07-10 09:39:16', '2025-07-10 09:39:21'),
	(21, 6, '菜单修改', NULL, NULL, 'menu:edit', 6, 2, '2025-07-10 09:39:46', '2025-07-10 09:39:48'),
	(22, 6, '菜单删除', NULL, NULL, 'menu:del', 6, 2, '2025-07-10 09:40:08', '2025-07-10 09:40:10'),
	(35, 7, '操作日志', 'layui-icon-group', '/api/log/index', 'log:list', 7, 1, '2025-08-04 11:38:45', '2025-08-04 11:38:58'),
	(36, 7, '异常日志', 'layui-icon-face-cry', '/api/log/error/index', 'errorLog:list', 7, 1, '2025-08-04 11:42:22', '2025-08-04 11:42:22'),
	(66, 35, '日志删除', 'layui-icon ', '', 'log:del', 7, 2, '2025-08-09 15:16:03', '2025-08-09 15:16:03'),
	(67, 36, '异常日志删除', 'layui-icon layui-icon layui-icon ', '', 'errorLog:del', 7, 2, '2025-08-09 15:16:30', '2025-08-09 15:16:59'),
	(68, 3, '部门管理', 'layui-icon layui-icon layui-icon layui-icon-group', '/api/dept/index', 'dept:list', 7, 1, '2025-08-19 15:03:27', '2025-08-23 16:34:51'),
	(78, 68, '部门新增', 'layui-icon ', '', 'dept:add', 8, 2, '2025-08-23 16:34:39', '2025-08-23 16:34:39'),
	(79, 68, '部门修改', 'layui-icon ', '', 'dept:edit', 9, 2, '2025-08-23 16:35:18', '2025-08-23 16:35:18'),
	(80, 68, '部门删除', 'layui-icon ', '', 'dept:del', 10, 2, '2025-08-23 16:35:41', '2025-08-23 16:35:41'),
	(81, 7, '在线用户', 'layui-icon layui-icon layui-icon layui-icon-username', '/api/online/index', '', 7, 1, '2025-08-26 14:34:16', '2025-08-26 14:38:16'),
	(86, 3, '字典管理', 'layui-icon layui-icon-form', '/api/dict/index', 'dict:list', 9, 1, '2025-11-07 14:44:36', '2025-11-07 14:45:33'),
	(87, 86, '字典新增', 'layui-icon ', '', 'dict:add', 11, 2, '2025-11-07 14:46:21', '2025-11-07 14:46:21'),
	(88, 86, '字典修改', 'layui-icon ', '', 'dict:edit', 12, 2, '2025-11-07 14:46:52', '2025-11-07 14:46:52'),
	(89, 86, '字典删除', 'layui-icon ', '', 'dict:del', 13, 2, '2025-11-07 14:47:15', '2025-11-07 14:47:15'),
	(90, 0, '学享汇管理', 'layui-icon layui-icon-file', '', '', 4, 0, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(91, 90, '资源列表', 'layui-icon layui-icon-file', '/admin/resource/list', 'resource:list', 1, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(92, 90, '资源分类', 'layui-icon layui-icon-app', '/admin/resource/category', 'resource:category:list', 2, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(93, 90, '资源标签', 'layui-icon layui-icon-note', '/admin/resource/tag', 'resource:tag:list', 3, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(94, 90, '下载记录', 'layui-icon layui-icon-download-circle', '/admin/resource/download', 'resource:download:list', 4, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(95, 90, '文章列表', 'layui-icon layui-icon-read', '/admin/article/list', 'article:list', 5, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(96, 90, '文章分类', 'layui-icon layui-icon-app', '/admin/article/category', 'article:category:list', 6, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(97, 90, 'AI对话历史', 'layui-icon layui-icon-dialogue', '/admin/ai/history', 'ai:history:list', 7, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(98, 90, 'Token统计', 'layui-icon layui-icon-chart', '/admin/ai/tokens', 'ai:token:list', 8, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(99, 90, '数据概览', 'layui-icon layui-icon-chart-screen', '/admin/statistics/dashboard', 'statistics:view', 9, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(100, 90, '用户排行', 'layui-icon layui-icon-user', '/admin/statistics/user', 'statistics:user', 10, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50');

-- 导出  表 my-springsecurity-plus.my_role 结构
CREATE TABLE IF NOT EXISTS `my_role` (
  `role_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `role_name` varchar(255) NOT NULL COMMENT '名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `data_scope` char(1) DEFAULT NULL COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_role 的数据：~2 rows (大约)
INSERT INTO `my_role` (`role_id`, `role_name`, `description`, `create_time`, `update_time`, `data_scope`) VALUES
	(1, 'ADMIN', '超级管理员，拥有所有权限', '2025-07-10 09:40:35', '2025-11-07 14:47:39', '1'),
	(2, 'USER', '普通用户', '2025-07-10 09:40:56', '2025-11-07 14:47:52', '2');

-- 导出  表 my-springsecurity-plus.my_role_dept 结构
CREATE TABLE IF NOT EXISTS `my_role_dept` (
  `role_id` int(32) NOT NULL COMMENT '角色id',
  `dept_id` int(32) NOT NULL COMMENT '部门id',
  PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_role_dept 的数据：~3 rows (大约)
INSERT INTO `my_role_dept` (`role_id`, `dept_id`) VALUES
	(2, 5),
	(2, 6),
	(2, 7);

-- 导出  表 my-springsecurity-plus.my_role_menu 结构
CREATE TABLE IF NOT EXISTS `my_role_menu` (
  `role_id` int(32) NOT NULL COMMENT '角色id',
  `menu_id` int(32) NOT NULL COMMENT '菜单id',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_role_menu 的数据：~55 rows (大约)
INSERT INTO `my_role_menu` (`role_id`, `menu_id`) VALUES
	(1, 1),
	(1, 2),
	(1, 3),
	(1, 4),
	(1, 5),
	(1, 6),
	(1, 7),
	(1, 9),
	(1, 14),
	(1, 15),
	(1, 16),
	(1, 17),
	(1, 18),
	(1, 19),
	(1, 20),
	(1, 21),
	(1, 22),
	(1, 35),
	(1, 36),
	(1, 66),
	(1, 67),
	(1, 68),
	(1, 78),
	(1, 79),
	(1, 80),
	(1, 81),
	(1, 86),
	(1, 87),
	(1, 88),
	(1, 89),
	(1, 90),
	(1, 91),
	(1, 92),
	(1, 93),
	(1, 94),
	(1, 95),
	(1, 96),
	(1, 97),
	(1, 98),
	(1, 99),
	(1, 100),
	(2, 1),
	(2, 2),
	(2, 3),
	(2, 4),
	(2, 5),
	(2, 6),
	(2, 14),
	(2, 15),
	(2, 16),
	(2, 68),
	(2, 78),
	(2, 79),
	(2, 80),
	(2, 86);

-- 导出  表 my-springsecurity-plus.my_role_user 结构
CREATE TABLE IF NOT EXISTS `my_role_user` (
  `user_id` int(32) NOT NULL COMMENT '用户id',
  `role_id` int(32) NOT NULL COMMENT '角色id',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_role_user 的数据：~8 rows (大约)
INSERT INTO `my_role_user` (`user_id`, `role_id`) VALUES
	(1, 1),
	(2, 2),
	(3, 2),
	(4, 2),
	(5, 2),
	(6, 2),
	(7, 2),
	(8, 2);

-- 导出  表 my-springsecurity-plus.my_user 结构
CREATE TABLE IF NOT EXISTS `my_user` (
  `user_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `dept_id` int(32) DEFAULT NULL COMMENT '部门id',
  `user_name` varchar(255) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `nick_name` varchar(255) NOT NULL COMMENT '用户昵称',
  `phone` varchar(11) NOT NULL COMMENT '手机号',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` tinyint(1) NOT NULL COMMENT '状态',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_user 的数据：~8 rows (大约)
INSERT INTO `my_user` (`user_id`, `dept_id`, `user_name`, `password`, `nick_name`, `phone`, `email`, `status`, `create_time`, `update_time`) VALUES
	(1, 1, 'admin', '$2a$10$pAuzCLIe6Sl7kXfX6FEQ1uzM79V2njg.KtL9qawg9JkW7e1f417k2', '管理员', '13556336255', '1454564646@qq.com', 1, '2025-07-10 09:42:03', '2025-08-23 16:24:34'),
	(2, 2, 'test', '$2a$10$pAuzCLIe6Sl7kXfX6FEQ1uzM79V2njg.KtL9qawg9JkW7e1f417k2', '测试用户', '13556336256', '1454564646@163.com', 1, '2025-07-10 09:42:09', '2025-07-13 17:49:49'),
	(3, 2, 'test1', '$2a$10$exOfpFK2TNHnAdG/aaVTFeCDLihkg8JfD1qGWKjCOBdicxcQJax5W', '普通用户2', '13556336257', '1454564646@qq.com', 1, '2025-07-10 09:42:14', '2025-07-10 09:42:16'),
	(4, 2, 'test2', '$2a$10$RR665iMnfCuYGY0Af344U.Fy3XmGcgjkURENW/Zea/oAEhuiLyjO.', '普通用户3', '13556336258', '1454564646@qq.com', 1, '2025-07-10 09:42:19', '2025-07-10 09:42:21'),
	(5, 3, 'test3', '$2a$10$o0lZgmzReca24TP5viy/nOrPQty4jga1W.BG5SvgdeK9eprm.NoMa', '普通用户4', '13556336259', '1454564646@qq.com', 1, '2025-07-10 09:42:23', '2025-07-10 09:42:25'),
	(6, 3, 'test4', '$2a$10$jNU1gXN.wAPhq5vUmLrCoeyDJbF3ReSnYQ2IulJA99drcMs1w1Som', '封禁用户', '13556336250', '1454564646@qq.com', 0, '2025-07-10 09:42:27', '2025-07-13 17:54:11'),
	(7, 3, 'test5', '$2a$10$ADEBRX13Z9vvNxzdu/HiROaB1F7rYd5DHpE9UWeXtNOSbeB1tcWie', '封禁用户2', '13556336211', '1454564646@qq.com', 0, '2025-07-10 09:42:32', '2025-07-10 09:42:34'),
	(8, 6, 'test6', '$2a$10$2aLbMBdNottSq13J.tfIF.5IFgTcDlWwOQI7btckzsq3vl2KtWOV6', '测试修改', '13556336253', '1454564646@qq.com', 1, '2025-07-10 09:42:36', '2025-10-01 14:24:19');

-- 导出  表 my-springsecurity-plus.my_user_job 结构
CREATE TABLE IF NOT EXISTS `my_user_job` (
  `user_id` int(32) NOT NULL COMMENT '岗位id',
  `job_id` int(32) NOT NULL COMMENT '工作id',
  PRIMARY KEY (`user_id`,`job_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  my-springsecurity-plus.my_user_job 的数据：~9 rows (大约)
INSERT INTO `my_user_job` (`user_id`, `job_id`) VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 2),
	(5, 1),
	(6, 2),
	(7, 3),
	(8, 2),
	(8, 3);

-- 导出  表 my-springsecurity-plus.resource_category 结构
CREATE TABLE IF NOT EXISTS `resource_category` (
  `category_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `parent_id` int(32) DEFAULT 0 COMMENT '父分类ID，0表示顶级分类',
  `category_name` varchar(100) NOT NULL COMMENT '分类名称',
  `description` varchar(500) DEFAULT NULL COMMENT '分类描述',
  `icon` varchar(100) DEFAULT NULL COMMENT '分类图标',
  `sort_order` int(5) DEFAULT 0 COMMENT '排序序号',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：1启用 0禁用',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  `update_time` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '更新时间',
  PRIMARY KEY (`category_id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='资源分类表';

-- 正在导出表  my-springsecurity-plus.resource_category 的数据：~10 rows (大约)
INSERT INTO `resource_category` (`category_id`, `parent_id`, `category_name`, `description`, `icon`, `sort_order`, `status`, `create_time`, `update_time`) VALUES
	(1, 0, '计算机基础', '计算机基础知识', 'layui-icon layui-icon-component', 1, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(2, 0, '编程语言', '各类编程语言资料', 'layui-icon layui-icon-code', 2, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(3, 0, '框架技术', '主流开发框架', 'layui-icon layui-icon-template', 3, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(4, 0, '数据库', '数据库相关资料', 'layui-icon layui-icon-table', 4, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(5, 0, '人工智能', 'AI、机器学习等', 'layui-icon layui-icon-engine', 5, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(6, 2, 'Java', 'Java编程语言', NULL, 1, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(7, 2, 'Python', 'Python编程语言', NULL, 2, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(8, 2, 'JavaScript', 'JavaScript前端', NULL, 3, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(9, 3, 'Spring', 'Spring全家桶', NULL, 1, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(10, 3, 'Vue', 'Vue前端框架', NULL, 2, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31');

-- 导出  表 my-springsecurity-plus.resource_info 结构
CREATE TABLE IF NOT EXISTS `resource_info` (
  `resource_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '资源ID',
  `title` varchar(200) NOT NULL COMMENT '资源标题',
  `description` text DEFAULT NULL COMMENT '资源描述',
  `category_id` int(32) NOT NULL COMMENT '所属分类ID',
  `file_name` varchar(255) NOT NULL COMMENT '文件原始名称',
  `file_path` varchar(500) NOT NULL COMMENT '文件存储路径',
  `file_size` bigint(20) DEFAULT 0 COMMENT '文件大小（字节）',
  `file_type` varchar(20) NOT NULL COMMENT '文件类型：pdf/doc/docx/ppt/pptx/txt',
  `cover_image` varchar(500) DEFAULT NULL COMMENT '封面图片路径',
  `view_count` int(10) DEFAULT 0 COMMENT '浏览次数',
  `download_count` int(10) DEFAULT 0 COMMENT '下载次数',
  `collect_count` int(10) DEFAULT 0 COMMENT '收藏次数',
  `uploader_id` int(32) NOT NULL COMMENT '上传者用户ID',
  `uploader_name` varchar(100) DEFAULT NULL COMMENT '上传者姓名（冗余）',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：1已发布 0已下架',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '上传时间',
  `update_time` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '更新时间',
  PRIMARY KEY (`resource_id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_uploader` (`uploader_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  FULLTEXT KEY `ft_title_desc` (`title`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='资源信息表';

-- 正在导出表  my-springsecurity-plus.resource_info 的数据：~0 rows (大约)

-- 导出  表 my-springsecurity-plus.resource_tag 结构
CREATE TABLE IF NOT EXISTS `resource_tag` (
  `tag_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `tag_name` varchar(50) NOT NULL COMMENT '标签名称',
  `use_count` int(10) DEFAULT 0 COMMENT '使用次数',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `uk_tag_name` (`tag_name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='资源标签表';

-- 正在导出表  my-springsecurity-plus.resource_tag 的数据：~7 rows (大约)
INSERT INTO `resource_tag` (`tag_id`, `tag_name`, `use_count`, `create_time`) VALUES
	(1, 'SpringBoot', 0, '2026-02-08 16:55:31'),
	(2, '毕业设计', 0, '2026-02-08 16:55:31'),
	(3, '教程', 0, '2026-02-08 16:55:31'),
	(4, '面试', 0, '2026-02-08 16:55:31'),
	(5, '实战项目', 0, '2026-02-08 16:55:31'),
	(6, '源码', 0, '2026-02-08 16:55:31'),
	(7, '课件', 0, '2026-02-08 16:55:31');

-- 导出  表 my-springsecurity-plus.resource_tag_relation 结构
CREATE TABLE IF NOT EXISTS `resource_tag_relation` (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `resource_id` int(32) NOT NULL COMMENT '资源ID',
  `tag_id` int(32) NOT NULL COMMENT '标签ID',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resource_tag` (`resource_id`,`tag_id`),
  KEY `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='资源标签关联表';

-- 正在导出表  my-springsecurity-plus.resource_tag_relation 的数据：~0 rows (大约)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
