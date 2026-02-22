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


-- 导出 xue-xiang-hui 的数据库结构
CREATE DATABASE IF NOT EXISTS `xue-xiang-hui` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;
USE `xue-xiang-hui`;

-- 导出  表 xue-xiang-hui.ai_chat_history 结构
CREATE TABLE IF NOT EXISTS `ai_chat_history` (
  `chat_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '对话ID',
  `user_id` int(32) NOT NULL COMMENT '用户ID',
  `session_id` varchar(100) NOT NULL COMMENT '会话ID（UUID）',
  `question_text` text NOT NULL COMMENT '用户问题',
  `answer_text` text NOT NULL COMMENT 'AI回答内容',
  `model_name` varchar(50) DEFAULT 'gpt-3.5-turbo' COMMENT '使用的模型',
  `tokens_used` int(10) DEFAULT 0 COMMENT '消耗的token数',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '对话时间',
  PRIMARY KEY (`chat_id`),
  KEY `idx_user_session` (`user_id`,`session_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='AI对话记录表';

-- 导出  表 xue-xiang-hui.article_category 结构
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='文章分类表';

-- 正在导出表  xue-xiang-hui.article_category 的数据：~10 rows (大约)
INSERT INTO `article_category` (`parent_id`, `category_name`, `description`, `icon`, `sort_order`, `status`, `create_time`, `update_time`) VALUES
	(0, '技术教程', '技术教程类文章', 'layui-icon layui-icon-template', 1, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(0, '学习笔记', '学习心得和笔记', 'layui-icon layui-icon-note', 2, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(0, '问题解决', '问题排查和解决方案', 'layui-icon layui-icon-ok-circle', 3, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(0, '项目实战', '项目实战经验分享', 'layui-icon layui-icon-engine', 4, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(0, '职业发展', '职业规划和经验', 'layui-icon layui-icon-user', 5, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(1, 'Java教程', 'Java相关教程', NULL, 1, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(1, 'Python教程', 'Python相关教程', NULL, 2, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(1, '前端教程', '前端开发教程', NULL, 3, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(1, '数据库教程', '数据库相关教程', NULL, 4, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32'),
	(3, 'Bug解决', 'Bug排查和解决', NULL, 1, 1, '2026-02-08 16:55:32', '2026-02-08 16:55:32');

-- 导出  表 xue-xiang-hui.article_like_record 结构
CREATE TABLE IF NOT EXISTS `article_like_record` (
  `record_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `article_id` int(32) NOT NULL COMMENT '文章ID',
  `user_id` int(32) NOT NULL COMMENT '用户ID',
  `user_name` varchar(100) DEFAULT NULL COMMENT '用户姓名',
  `article_title` varchar(200) DEFAULT NULL COMMENT '文章标题',
  `is_cancelled` tinyint(1) DEFAULT 0 COMMENT '是否已取消：0未取消 1已取消',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '点赞时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
  PRIMARY KEY (`record_id`),
  UNIQUE KEY `uk_article_user` (`article_id`,`user_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='文章点赞记录表';

-- 正在导出表  xue-xiang-hui.article_like_record 的数据：~2 rows (大约)
INSERT INTO `article_like_record` (`record_id`, `article_id`, `user_id`, `user_name`, `article_title`, `is_cancelled`, `create_time`, `cancel_time`) VALUES
	(1, 8, 1, '管理员', '测试文章发布', 0, '2026-02-19 18:31:44', NULL),
	(6, 1, 1, '管理员', '第一篇文章的标题', 1, '2026-02-19 18:47:35', '2026-02-19 18:47:40');

-- 导出  表 xue-xiang-hui.article_tag_relation 结构
CREATE TABLE IF NOT EXISTS `article_tag_relation` (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `article_id` int(32) NOT NULL COMMENT '文章ID',
  `tag_id` int(32) NOT NULL COMMENT '标签ID',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_article_tag` (`article_id`,`tag_id`),
  KEY `idx_tag_id` (`tag_id`),
  KEY `idx_article_id` (`article_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='文章标签关联表';

-- 正在导出表  xue-xiang-hui.article_tag_relation 的数据：~22 rows (大约)
INSERT INTO `article_tag_relation` (`id`, `article_id`, `tag_id`, `create_time`) VALUES
	(1, 6, 2, '2026-02-19 13:37:25'),
	(2, 6, 9, '2026-02-19 13:37:25'),
	(3, 6, 8, '2026-02-19 13:37:25'),
	(4, 6, 7, '2026-02-19 13:37:25'),
	(5, 6, 6, '2026-02-19 13:37:25'),
	(6, 6, 5, '2026-02-19 13:37:25'),
	(7, 6, 4, '2026-02-19 13:37:25'),
	(8, 6, 3, '2026-02-19 13:37:25'),
	(9, 7, 2, '2026-02-19 13:37:30'),
	(10, 7, 9, '2026-02-19 13:37:30'),
	(11, 7, 8, '2026-02-19 13:37:30'),
	(12, 7, 7, '2026-02-19 13:37:30'),
	(13, 7, 6, '2026-02-19 13:37:30'),
	(14, 7, 5, '2026-02-19 13:37:30'),
	(15, 7, 4, '2026-02-19 13:37:30'),
	(16, 7, 3, '2026-02-19 13:37:30'),
	(17, 8, 2, '2026-02-19 23:35:00'),
	(18, 8, 4, '2026-02-19 23:35:00'),
	(19, 8, 6, '2026-02-19 23:35:00'),
	(20, 8, 3, '2026-02-19 23:35:00'),
	(21, 8, 5, '2026-02-19 23:35:00'),
	(22, 8, 7, '2026-02-19 23:35:00'),
	(23, 8, 9, '2026-02-19 23:35:00'),
	(24, 8, 8, '2026-02-19 23:35:00'),
	(25, 11, 1, '2026-02-21 22:57:57'),
	(26, 11, 2, '2026-02-21 22:57:57'),
	(27, 11, 6, '2026-02-21 22:57:57');

-- 导出  表 xue-xiang-hui.article_view_record 结构
CREATE TABLE IF NOT EXISTS `article_view_record` (
  `record_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `article_id` int(32) NOT NULL COMMENT '文章ID',
  `user_id` int(32) DEFAULT NULL COMMENT '浏览用户ID（NULL表示游客）',
  `view_time` datetime DEFAULT current_timestamp() COMMENT '浏览时间',
  `ip_address` varchar(50) DEFAULT NULL COMMENT '浏览IP',
  PRIMARY KEY (`record_id`),
  KEY `idx_article_id` (`article_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_view_time` (`view_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='文章浏览记录表';

-- 导出  表 xue-xiang-hui.download_record 结构
CREATE TABLE IF NOT EXISTS `download_record` (
  `record_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `resource_id` int(32) NOT NULL COMMENT '资源ID',
  `user_id` int(32) NOT NULL COMMENT '下载用户ID',
  `user_name` varchar(100) DEFAULT NULL COMMENT '用户姓名',
  `resource_title` varchar(200) DEFAULT NULL COMMENT '资源标题',
  `download_time` datetime DEFAULT current_timestamp() COMMENT '下载时间',
  `ip_address` varchar(50) DEFAULT NULL COMMENT '下载IP',
  PRIMARY KEY (`record_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_resource_id` (`resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='下载记录表';

-- 正在导出表  xue-xiang-hui.download_record 的数据：~14 rows (大约)
INSERT INTO `download_record` (`record_id`, `resource_id`, `user_id`, `user_name`, `resource_title`, `download_time`, `ip_address`) VALUES
	(1, 2, 1, '管理员', NULL, '2026-02-19 23:59:15', NULL),
	(2, 2, 1, '管理员', NULL, '2026-02-19 23:59:20', NULL),
	(3, 2, 1, '管理员', NULL, '2026-02-19 23:59:25', NULL),
	(4, 1, 1, '管理员', NULL, '2026-02-19 23:59:35', NULL),
	(6, 2, 2, '测试用户', NULL, '2026-02-20 21:40:54', NULL),
	(7, 2, 2, '测试用户', NULL, '2026-02-20 21:42:40', NULL),
	(8, 2, 2, '测试用户', NULL, '2026-02-20 21:47:17', NULL),
	(9, 2, 2, '测试用户', NULL, '2026-02-20 21:53:37', NULL),
	(10, 2, 2, '测试用户', NULL, '2026-02-20 21:55:44', NULL),
	(11, 2, 2, '测试用户', NULL, '2026-02-20 21:56:31', NULL),
	(12, 2, 2, '测试用户', NULL, '2026-02-20 21:57:03', NULL),
	(13, 1, 2, '测试用户', NULL, '2026-02-20 22:00:24', NULL),
	(14, 7, 1, '管理员', NULL, '2026-02-20 22:00:45', NULL),
	(15, 7, 1, '管理员', NULL, '2026-02-20 22:00:52', NULL),
	(16, 2, 1, '管理员', NULL, '2026-02-20 22:08:23', NULL),
	(17, 7, 1, '管理员', NULL, '2026-02-20 22:10:30', NULL),
	(18, 2, 1, '管理员', NULL, '2026-02-21 17:58:30', '192.168.1.141'),
	(19, 7, 1, '管理员', NULL, '2026-02-21 17:58:33', '192.168.1.141'),
	(20, 8, 1, '管理员', NULL, '2026-02-21 23:04:13', '192.168.1.141');

-- 导出  表 xue-xiang-hui.favorite_record 结构
CREATE TABLE IF NOT EXISTS `favorite_record` (
  `favorite_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` int(32) NOT NULL COMMENT '用户ID',
  `resource_id` int(32) NOT NULL COMMENT '资源ID',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '收藏时间',
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `uk_user_resource` (`user_id`,`resource_id`),
  KEY `idx_resource_id` (`resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='收藏记录表';

-- 正在导出表  xue-xiang-hui.favorite_record 的数据：~0 rows (大约)
INSERT INTO `favorite_record` (`favorite_id`, `user_id`, `resource_id`, `create_time`) VALUES
	(1, 2, 2, '2026-02-20 20:02:50');

-- 导出  表 xue-xiang-hui.my_article 结构
CREATE TABLE IF NOT EXISTS `my_article` (
  `article_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `title` varchar(200) NOT NULL COMMENT '文章标题',
  `content` mediumtext NOT NULL COMMENT '文章内容（富文本HTML）',
  `summary` varchar(500) DEFAULT NULL COMMENT '文章摘要',
  `category_id` int(32) DEFAULT NULL COMMENT '文章分类ID',
  `cover_image` varchar(500) DEFAULT NULL COMMENT '封面图片路径',
  `view_count` int(10) DEFAULT 0 COMMENT '浏览次数',
  `like_count` int(10) DEFAULT 0 COMMENT '点赞次数',
  `author_id` int(32) NOT NULL COMMENT '作者用户ID',
  `author_name` varchar(100) DEFAULT NULL COMMENT '作者姓名',
  `status` tinyint(1) DEFAULT 0 COMMENT '状态：0草稿 1已发布 2已下架',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  `update_time` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '更新时间',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`article_id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_author` (`author_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  FULLTEXT KEY `ft_title_summary` (`title`,`summary`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='文章主表';

-- 正在导出表  xue-xiang-hui.my_article 的数据：~3 rows (大约)
INSERT INTO `my_article` (`article_id`, `title`, `content`, `summary`, `category_id`, `cover_image`, `view_count`, `like_count`, `author_id`, `author_name`, `status`, `create_time`, `update_time`, `publish_time`) VALUES
	(1, '第一篇文章的标题', '<h1>学享汇资源共享平台 - 完整开发方案</h1><h2>项目概述</h2><h3>基本信息</h3><p>项目名称: 学享汇资源共享平台</p><p>项目性质: 计算机专业毕业设计</p><p>技术栈: SpringBoot 2.3.1 + SpringSecurity + MyBatis + LayUI + Vue3</p><p>开发周期: 13个工作日（约2-3周）</p><p>难度等级: ⭐⭐⭐（中等）</p><p>核心定位</p><p>将现有的 RBAC 权限管理系统改造为完全免费的文档资源共享平台，核心创新点是AI智能解读功能（用户选中文本即可向AI提问）。</p><p><br></p><h3>一、功能需求清单</h3><p>1.1 用户端功能（Vue3开发）</p><p>模块	功能	优先级</p><p>用户认证	注册/登录/找回密码	P0</p><p>资源浏览	卡片式展示资源列表	P0</p><p>资源搜索	关键词搜索、分类筛选、标签筛选	P0</p><p>资源详情	查看资源详细信息、预览	P0</p><p>资源下载	免费下载文档	P0</p><p>资源上传	上传PDF/Word/PPT等文档	P0</p><p>AI对话	选中文本→侧边栏AI对话	P0（创新点）</p><p>个人中心	我的资源、下载历史、收藏	P1</p><p>1.2 管理端功能（LayUI开发）</p><p>模块	功能	优先级</p><p>用户管理	查看/编辑/禁用用户	P1</p><p>资源管理	查看/删除资源	P1</p><p>分类管理	多级分类管理	P1</p><p>标签管理	标签增删改查	P2</p><p>系统监控	数据统计、日志查看	P2</p><p>1.3 核心特色</p><p>✅ 完全免费 - 无积分系统、无付费墙</p><p>✅ AI智能解读 - 选中网页文本即可向AI提问</p><p>✅ 即时发布 - 无需审核，上传后立即可见</p><p>✅ 简单实用 - 界面简洁、操作便捷</p><p><br></p><h3>二、数据库设计</h3><p>2.1 新增表结构（共6张表）</p><p>表1: 资源分类表 (resource_category)</p><p><br></p><p>DROP TABLE IF EXISTS `resource_category`;</p><p>CREATE TABLE `resource_category` (</p><p> &nbsp;`category_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT \'分类ID\',</p><p> &nbsp;`parent_id` INT(32) DEFAULT 0 COMMENT \'父分类ID，0表示顶级分类\',</p><p> &nbsp;`category_name` VARCHAR(100) NOT NULL COMMENT \'分类名称\',</p><p> &nbsp;`description` VARCHAR(500) DEFAULT NULL COMMENT \'分类描述\',</p><p> &nbsp;`icon` VARCHAR(100) DEFAULT NULL COMMENT \'分类图标\',</p><p> &nbsp;`sort_order` INT(5) DEFAULT 0 COMMENT \'排序序号\',</p><p> &nbsp;`status` TINYINT(1) DEFAULT 1 COMMENT \'状态：1启用 0禁用\',</p><p> &nbsp;`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',</p><p> &nbsp;`update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',</p><p> &nbsp;PRIMARY KEY (`category_id`),</p><p> &nbsp;INDEX `idx_parent_id` (`parent_id`)</p><p>) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'资源分类表\';</p><p><br></p><p>-- 初始化分类数据</p><p>INSERT INTO `resource_category` VALUES</p><p>(1, 0, \'计算机基础\', \'计算机基础知识\', \'layui-icon layui-icon-component\', 1, 1, NOW(), NOW()),</p><p>(2, 0, \'编程语言\', \'各类编程语言资料\', \'layui-icon layui-icon-code\', 2, 1, NOW(), NOW()),</p><p>(3, 0, \'框架技术\', \'主流开发框架\', \'layui-icon layui-icon-template\', 3, 1, NOW(), NOW()),</p><p>(4, 0, \'数据库\', \'数据库相关资料\', \'layui-icon layui-icon-table\', 4, 1, NOW(), NOW()),</p><p>(5, 0, \'人工智能\', \'AI、机器学习等\', \'layui-icon layui-icon-engine\', 5, 1, NOW(), NOW()),</p><p>(6, 2, \'Java\', \'Java编程语言\', NULL, 1, 1, NOW(), NOW()),</p><p>(7, 2, \'Python\', \'Python编程语言\', NULL, 2, 1, NOW(), NOW()),</p><p>(8, 2, \'JavaScript\', \'JavaScript前端\', NULL, 3, 1, NOW(), NOW()),</p><p>(9, 3, \'Spring\', \'Spring全家桶\', NULL, 1, 1, NOW(), NOW()),</p><p>(10, 3, \'Vue\', \'Vue前端框架\', NULL, 2, 1, NOW(), NOW());</p><p>表2: 资源标签表 (resource_tag)</p><p><br></p><p>DROP TABLE IF EXISTS `resource_tag`;</p><p>CREATE TABLE `resource_tag` (</p><p> &nbsp;`tag_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT \'标签ID\',</p><p> &nbsp;`tag_name` VARCHAR(50) NOT NULL COMMENT \'标签名称\',</p><p> &nbsp;`use_count` INT(10) DEFAULT 0 COMMENT \'使用次数\',</p><p> &nbsp;`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',</p><p> &nbsp;PRIMARY KEY (`tag_id`),</p><p> &nbsp;UNIQUE KEY `uk_tag_name` (`tag_name`)</p><p>) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'资源标签表\';</p><p><br></p><p>-- 初始化标签数据</p><p>INSERT INTO `resource_tag` VALUES</p><p>(1, \'SpringBoot\', 0, NOW()),</p><p>(2, \'毕业设计\', 0, NOW()),</p><p>(3, \'教程\', 0, NOW()),</p><p>(4, \'面试\', 0, NOW()),</p><p>(5, \'实战项目\', 0, NOW()),</p><p>(6, \'源码\', 0, NOW()),</p><p>(7, \'课件\', 0, NOW());</p><p>表3: 资源主表 (resource_info) - 核心表</p><p><br></p><p>DROP TABLE IF EXISTS `resource_info`;</p><p>CREATE TABLE `resource_info` (</p><p> &nbsp;`resource_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT \'资源ID\',</p><p> &nbsp;`title` VARCHAR(200) NOT NULL COMMENT \'资源标题\',</p><p> &nbsp;`description` TEXT COMMENT \'资源描述\',</p><p> &nbsp;`category_id` INT(32) NOT NULL COMMENT \'所属分类ID\',</p><p> &nbsp;`file_name` VARCHAR(255) NOT NULL COMMENT \'文件原始名称\',</p><p> &nbsp;`file_path` VARCHAR(500) NOT NULL COMMENT \'文件存储路径\',</p><p> &nbsp;`file_size` BIGINT(20) DEFAULT 0 COMMENT \'文件大小（字节）\',</p><p> &nbsp;`file_type` VARCHAR(20) NOT NULL COMMENT \'文件类型：pdf/doc/docx/ppt/pptx/txt\',</p><p> &nbsp;`cover_image` VARCHAR(500) DEFAULT NULL COMMENT \'封面图片路径\',</p><p><br></p><p> &nbsp;-- 统计信息</p><p> &nbsp;`view_count` INT(10) DEFAULT 0 COMMENT \'浏览次数\',</p><p> &nbsp;`download_count` INT(10) DEFAULT 0 COMMENT \'下载次数\',</p><p> &nbsp;`collect_count` INT(10) DEFAULT 0 COMMENT \'收藏次数\',</p><p><br></p><p> &nbsp;-- 用户信息</p><p> &nbsp;`uploader_id` INT(32) NOT NULL COMMENT \'上传者用户ID\',</p><p> &nbsp;`uploader_name` VARCHAR(100) DEFAULT NULL COMMENT \'上传者姓名（冗余）\',</p><p><br></p><p> &nbsp;-- 状态（无需审核，直接发布）</p><p> &nbsp;`status` TINYINT(1) DEFAULT 1 COMMENT \'状态：1已发布 0已下架\',</p><p><br></p><p> &nbsp;-- 时间字段</p><p> &nbsp;`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT \'上传时间\',</p><p> &nbsp;`update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',</p><p><br></p><p> &nbsp;PRIMARY KEY (`resource_id`),</p><p> &nbsp;INDEX `idx_category` (`category_id`),</p><p> &nbsp;INDEX `idx_uploader` (`uploader_id`),</p><p> &nbsp;INDEX `idx_status` (`status_id`),</p><p> &nbsp;INDEX `idx_create_time` (`create_time`),</p><p> &nbsp;FULLTEXT KEY `ft_title_desc` (`title`, `description`)</p><p>) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'资源信息表\';</p><p>表4: 资源标签关联表 (resource_tag_relation)</p><p><br></p><p>DROP TABLE IF EXISTS `resource_tag_relation`;</p><p>CREATE TABLE `resource_tag_relation` (</p><p> &nbsp;`id` INT(32) NOT NULL AUTO_INCREMENT,</p><p> &nbsp;`resource_id` INT(32) NOT NULL COMMENT \'资源ID\',</p><p> &nbsp;`tag_id` INT(32) NOT NULL COMMENT \'标签ID\',</p><p> &nbsp;`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',</p><p> &nbsp;PRIMARY KEY (`id`),</p><p> &nbsp;UNIQUE KEY `uk_resource_tag` (`resource_id`, `tag_id`),</p><p> &nbsp;INDEX `idx_tag_id` (`tag_id`)</p><p>) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'资源标签关联表\';</p><p>表5: 下载记录表 (download_record)</p><p><br></p><p>DROP TABLE IF EXISTS `download_record`;</p><p>CREATE TABLE `download_record` (</p><p> &nbsp;`record_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT \'记录ID\',</p><p> &nbsp;`resource_id` INT(32) NOT NULL COMMENT \'资源ID\',</p><p> &nbsp;`user_id` INT(32) NOT NULL COMMENT \'下载用户ID\',</p><p> &nbsp;`user_name` VARCHAR(100) DEFAULT NULL COMMENT \'用户姓名（冗余）\',</p><p> &nbsp;`resource_title` VARCHAR(200) DEFAULT NULL COMMENT \'资源标题（冗余）\',</p><p> &nbsp;`download_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT \'下载时间\',</p><p> &nbsp;`ip_address` VARCHAR(50) DEFAULT NULL COMMENT \'下载IP\',</p><p> &nbsp;PRIMARY KEY (`record_id`),</p><p> &nbsp;INDEX `idx_user_id` (`user_id`),</p><p> &nbsp;INDEX `idx_resource_id` (`resource_id`)</p><p>) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'下载记录表\';</p><p>表6: AI对话记录表 (ai_chat_history) - 创新功能</p><p><br></p><p>DROP TABLE IF EXISTS `ai_chat_history`;</p><p>CREATE TABLE `ai_chat_history` (</p><p> &nbsp;`chat_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT \'对话ID\',</p><p> &nbsp;`user_id` INT(32) NOT NULL COMMENT \'用户ID\',</p><p> &nbsp;`session_id` VARCHAR(100) NOT NULL COMMENT \'会话ID（UUID）\',</p><p> &nbsp;`question_text` TEXT NOT NULL COMMENT \'用户选中的问题文本\',</p><p> &nbsp;`question_context` TEXT DEFAULT NULL COMMENT \'问题上下文（网页内容片段）\',</p><p> &nbsp;`answer_text` TEXT NOT NULL COMMENT \'AI回答内容\',</p><p> &nbsp;`model_name` VARCHAR(50) DEFAULT \'gpt-3.5-turbo\' COMMENT \'使用的模型\',</p><p> &nbsp;`tokens_used` INT(10) DEFAULT 0 COMMENT \'消耗的token数\',</p><p> &nbsp;`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT \'对话时间\',</p><p> &nbsp;PRIMARY KEY (`chat_id`),</p><p> &nbsp;INDEX `idx_user_session` (`user_id`, `session_id`),</p><p> &nbsp;INDEX `idx_create_time` (`create_time`)</p><p>) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'AI对话记录表\';</p><p>表7: 收藏记录表 (favorite_record)</p><p><br></p><p>DROP TABLE IF EXISTS `favorite_record`;</p><p>CREATE TABLE `favorite_record` (</p><p> &nbsp;`favorite_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT \'收藏ID\',</p><p> &nbsp;`user_id` INT(32) NOT NULL COMMENT \'用户ID\',</p><p> &nbsp;`resource_id` INT(32) NOT NULL COMMENT \'资源ID\',</p><p> &nbsp;`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT \'收藏时间\',</p><p> &nbsp;PRIMARY KEY (`favorite_id`),</p><p> &nbsp;UNIQUE KEY `uk_user_resource` (`user_id`, `resource_id`),</p><p> &nbsp;INDEX `idx_resource_id` (`resource_id`)</p><p>) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'收藏记录表\';</p><p>2.2 扩展现有表（可选）</p><p><br></p><p>-- 扩展用户表，添加资源相关统计</p><p>ALTER TABLE `my_user`</p><p>ADD COLUMN `upload_count` INT(10) DEFAULT 0 COMMENT \'上传资源数\',</p><p>ADD COLUMN `download_count` INT(10) DEFAULT 0 COMMENT \'下载资源数\';</p><p>三、后端模块设计</p><p>3.1 目录结构</p><p><br></p><p>com.codermy.myspringsecurityplus.resource/</p><p>├── controller/</p><p>│ &nbsp; ├── ResourceController.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 资源管理API</p><p>│ &nbsp; ├── CategoryController.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 分类管理API</p><p>│ &nbsp; ├── TagController.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 标签管理API</p><p>│ &nbsp; ├── DownloadController.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 下载管理API</p><p>│ &nbsp; ├── FavoriteController.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 收藏管理API</p><p>│ &nbsp; └── AiChatController.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# AI对话API（创新点）</p><p>├── service/</p><p>│ &nbsp; ├── ResourceService.java</p><p>│ &nbsp; ├── CategoryService.java</p><p>│ &nbsp; ├── TagService.java</p><p>│ &nbsp; ├── DownloadService.java</p><p>│ &nbsp; ├── FavoriteService.java</p><p>│ &nbsp; ├── AiChatService.java</p><p>│ &nbsp; └── impl/</p><p>│ &nbsp; &nbsp; &nbsp; └── *ServiceImpl.java</p><p>├── dao/</p><p>│ &nbsp; ├── ResourceDao.java</p><p>│ &nbsp; ├── CategoryDao.java</p><p>│ &nbsp; ├── TagDao.java</p><p>│ &nbsp; ├── DownloadDao.java</p><p>│ &nbsp; ├── FavoriteDao.java</p><p>│ &nbsp; └── AiChatDao.java</p><p>├── entity/</p><p>│ &nbsp; ├── ResourceInfo.java</p><p>│ &nbsp; ├── ResourceCategory.java</p><p>│ &nbsp; ├── ResourceTag.java</p><p>│ &nbsp; ├── ResourceTagRelation.java</p><p>│ &nbsp; ├── DownloadRecord.java</p><p>│ &nbsp; ├── FavoriteRecord.java</p><p>│ &nbsp; └── AiChatHistory.java</p><p>├── dto/</p><p>│ &nbsp; ├── ResourceQueryDto.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 查询条件</p><p>│ &nbsp; ├── ResourceUploadDto.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 上传请求</p><p>│ &nbsp; └── AiChatRequestDto.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# AI对话请求</p><p>└── config/</p><p> &nbsp; &nbsp;├── FileUploadConfig.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 文件上传配置</p><p> &nbsp; &nbsp;└── AiServiceConfig.java &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # AI服务配置</p><p>3.2 核心API设计</p><p>ResourceController - 资源管理</p><p><br></p><p>@Controller</p><p>@RequestMapping("/api/resource")</p><p>@Api(tags = "资源管理")</p><p>public class ResourceController {</p><p><br></p><p> &nbsp; &nbsp;// 资源列表（分页、搜索）</p><p> &nbsp; &nbsp;@GetMapping</p><p> &nbsp; &nbsp;@ResponseBody</p><p> &nbsp; &nbsp;@ApiOperation("资源列表")</p><p> &nbsp; &nbsp;public Result&lt;ResourceInfo&gt; list(</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam(defaultValue = "1") Integer page,</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam(defaultValue = "12") Integer limit,</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam(required = false) String keyword,</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam(required = false) Integer categoryId,</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam(required = false) String fileType);</p><p><br></p><p> &nbsp; &nbsp;// 资源详情</p><p> &nbsp; &nbsp;@GetMapping("/{resourceId}")</p><p> &nbsp; &nbsp;@ResponseBody</p><p> &nbsp; &nbsp;public Result&lt;ResourceDto&gt; getDetail(@PathVariable Integer resourceId);</p><p><br></p><p> &nbsp; &nbsp;// 资源上传</p><p> &nbsp; &nbsp;@PostMapping("/upload")</p><p> &nbsp; &nbsp;@ResponseBody</p><p> &nbsp; &nbsp;@MyLog("上传资源")</p><p> &nbsp; &nbsp;public Result upload(</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam("file") MultipartFile file,</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam("title") String title,</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam("categoryId") Integer categoryId,</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam("description") String description,</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam("tags") String tags);</p><p><br></p><p> &nbsp; &nbsp;// 资源下载</p><p> &nbsp; &nbsp;@GetMapping("/download/{resourceId}")</p><p> &nbsp; &nbsp;@MyLog("下载资源")</p><p> &nbsp; &nbsp;public void download(</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@PathVariable Integer resourceId,</p><p> &nbsp; &nbsp; &nbsp; &nbsp;HttpServletResponse response);</p><p><br></p><p> &nbsp; &nbsp;// 删除资源</p><p> &nbsp; &nbsp;@DeleteMapping("/{resourceId}")</p><p> &nbsp; &nbsp;@PreAuthorize("hasAnyAuthority(\'resource:delete\')")</p><p> &nbsp; &nbsp;@MyLog("删除资源")</p><p> &nbsp; &nbsp;public Result delete(@PathVariable Integer resourceId);</p><p><br></p><p> &nbsp; &nbsp;// 我上传的资源</p><p> &nbsp; &nbsp;@GetMapping("/my")</p><p> &nbsp; &nbsp;@ResponseBody</p><p> &nbsp; &nbsp;public Result&lt;ResourceInfo&gt; getMyResources(</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam(defaultValue = "1") Integer page,</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@RequestParam(defaultValue = "10") Integer limit);</p><p>}</p><p>AiChatController - AI对话（创新点）</p><p><br></p><p>@Controller</p><p>@RequestMapping("/api/ai")</p><p>@Api(tags = "AI对话功能")</p><p>public class AiChatController {</p><p><br></p><p> &nbsp; &nbsp;@Autowired</p><p> &nbsp; &nbsp;private AiChatService aiChatService;</p><p><br></p><p> &nbsp; &nbsp;// 发送问题到AI</p><p> &nbsp; &nbsp;@PostMapping("/chat")</p><p> &nbsp; &nbsp;@ResponseBody</p><p> &nbsp; &nbsp;@ApiOperation("AI对话")</p><p> &nbsp; &nbsp;@MyLog("AI对话")</p><p> &nbsp; &nbsp;public Result&lt;AiChatResponse&gt; chat(@RequestBody AiChatRequestDto request);</p><p><br></p><p> &nbsp; &nbsp;// 获取对话历史</p><p> &nbsp; &nbsp;@GetMapping("/history/{sessionId}")</p><p> &nbsp; &nbsp;@ResponseBody</p><p> &nbsp; &nbsp;public Result&lt;List&lt;AiChatHistory&gt;&gt; getHistory(@PathVariable String sessionId);</p><p><br></p><p> &nbsp; &nbsp;// 清空对话历史</p><p> &nbsp; &nbsp;@DeleteMapping("/history/{sessionId}")</p><p> &nbsp; &nbsp;@ResponseBody</p><p> &nbsp; &nbsp;public Result clearHistory(@PathVariable String sessionId);</p><p>}</p><p>3.3 核心Service实现</p><p>ResourceServiceImpl - 文件上传</p><p><br></p><p>@Service</p><p>public class ResourceServiceImpl implements ResourceService {</p><p><br></p><p> &nbsp; &nbsp;@Value("${upload.path}")</p><p> &nbsp; &nbsp;private String uploadPath; // 如: D:/uploads/</p><p><br></p><p> &nbsp; &nbsp;@Value("${upload.max-size}")</p><p> &nbsp; &nbsp;private long maxSize; // 如: 52428800 (50MB)</p><p><br></p><p> &nbsp; &nbsp;@Override</p><p> &nbsp; &nbsp;@Transactional</p><p> &nbsp; &nbsp;public Result&lt;ResourceInfo&gt; upload(MultipartFile file, ResourceUploadDto dto, Integer userId) {</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 1. 文件校验</p><p> &nbsp; &nbsp; &nbsp; &nbsp;validateFile(file);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 2. 生成唯一文件名</p><p> &nbsp; &nbsp; &nbsp; &nbsp;String originalName = file.getOriginalFilename();</p><p> &nbsp; &nbsp; &nbsp; &nbsp;String extension = getFileExtension(originalName);</p><p> &nbsp; &nbsp; &nbsp; &nbsp;String newFileName = UUID.randomUUID() + "." + extension;</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 3. 按日期创建目录: /2024/01/</p><p> &nbsp; &nbsp; &nbsp; &nbsp;String datePath = DateUtil.format(new Date(), "yyyy/MM");</p><p> &nbsp; &nbsp; &nbsp; &nbsp;String relativePath = datePath + "/" + newFileName;</p><p> &nbsp; &nbsp; &nbsp; &nbsp;String fullPath = uploadPath + relativePath;</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 4. 保存文件</p><p> &nbsp; &nbsp; &nbsp; &nbsp;File destFile = new File(fullPath);</p><p> &nbsp; &nbsp; &nbsp; &nbsp;FileUtils.mkdirs(destFile.getParentFile());</p><p> &nbsp; &nbsp; &nbsp; &nbsp;file.transferTo(destFile);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 5. 保存数据库</p><p> &nbsp; &nbsp; &nbsp; &nbsp;ResourceInfo resource = new ResourceInfo();</p><p> &nbsp; &nbsp; &nbsp; &nbsp;resource.setTitle(dto.getTitle());</p><p> &nbsp; &nbsp; &nbsp; &nbsp;resource.setCategoryId(dto.getCategoryId());</p><p> &nbsp; &nbsp; &nbsp; &nbsp;resource.setDescription(dto.getDescription());</p><p> &nbsp; &nbsp; &nbsp; &nbsp;resource.setFileName(originalName);</p><p> &nbsp; &nbsp; &nbsp; &nbsp;resource.setFilePath(relativePath);</p><p> &nbsp; &nbsp; &nbsp; &nbsp;resource.setFileSize(file.getSize());</p><p> &nbsp; &nbsp; &nbsp; &nbsp;resource.setFileType(extension);</p><p> &nbsp; &nbsp; &nbsp; &nbsp;resource.setUploaderId(userId);</p><p> &nbsp; &nbsp; &nbsp; &nbsp;resource.setStatus(1); // 直接发布，无需审核</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;resourceDao.save(resource);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 6. 处理标签</p><p> &nbsp; &nbsp; &nbsp; &nbsp;saveTags(resource.getResourceId(), dto.getTags());</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;return Result.ok().message("上传成功！");</p><p> &nbsp; &nbsp;}</p><p><br></p><p> &nbsp; &nbsp;private void validateFile(MultipartFile file) {</p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 大小校验</p><p> &nbsp; &nbsp; &nbsp; &nbsp;if (file.getSize() &gt; maxSize) {</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;throw new MyException("文件大小超过50MB限制");</p><p> &nbsp; &nbsp; &nbsp; &nbsp;}</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 类型校验</p><p> &nbsp; &nbsp; &nbsp; &nbsp;String extension = getFileExtension(file.getOriginalFilename());</p><p> &nbsp; &nbsp; &nbsp; &nbsp;List&lt;String&gt; allowed = Arrays.asList("pdf", "doc", "docx", "ppt", "pptx", "txt");</p><p> &nbsp; &nbsp; &nbsp; &nbsp;if (!allowed.contains(extension.toLowerCase())) {</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;throw new MyException("不支持的文件类型");</p><p> &nbsp; &nbsp; &nbsp; &nbsp;}</p><p> &nbsp; &nbsp;}</p><p>}</p><p>AiChatServiceImpl - AI服务（创新点核心）</p><p><br></p><p>@Service</p><p>public class AiChatServiceImpl implements AiChatService {</p><p><br></p><p> &nbsp; &nbsp;@Value("${ai.api.base-url}")</p><p> &nbsp; &nbsp;private String baseUrl; // 用户可配置，如 https://api.openai.com</p><p><br></p><p> &nbsp; &nbsp;@Value("${ai.api.key}")</p><p> &nbsp; &nbsp;private String apiKey; // 用户配置的API Key</p><p><br></p><p> &nbsp; &nbsp;@Value("${ai.api.model}")</p><p> &nbsp; &nbsp;private String model; // 如 gpt-3.5-turbo</p><p><br></p><p> &nbsp; &nbsp;@Override</p><p> &nbsp; &nbsp;public AiChatResponse chat(AiChatRequestDto request, Integer userId) {</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 1. 构建请求体</p><p> &nbsp; &nbsp; &nbsp; &nbsp;Map&lt;String, Object&gt; requestBody = new HashMap&lt;&gt;();</p><p> &nbsp; &nbsp; &nbsp; &nbsp;requestBody.put("model", model);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 2. 构建消息列表</p><p> &nbsp; &nbsp; &nbsp; &nbsp;List&lt;Map&lt;String, String&gt;&gt; messages = buildMessages(request);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;requestBody.put("messages", messages);</p><p> &nbsp; &nbsp; &nbsp; &nbsp;requestBody.put("temperature", 0.7);</p><p> &nbsp; &nbsp; &nbsp; &nbsp;requestBody.put("max_tokens", 1000);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 3. 调用OpenAI兼容API</p><p> &nbsp; &nbsp; &nbsp; &nbsp;String response = HttpRequest.post(baseUrl + "/v1/chat/completions")</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.header("Content-Type", "application/json")</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.header("Authorization", "Bearer " + apiKey)</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.timeout(30000)</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.body(JSON.toJSONString(requestBody))</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.execute()</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.body();</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 4. 解析响应</p><p> &nbsp; &nbsp; &nbsp; &nbsp;String answer = parseResponse(response);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 5. 保存对话记录</p><p> &nbsp; &nbsp; &nbsp; &nbsp;AiChatHistory history = new AiChatHistory();</p><p> &nbsp; &nbsp; &nbsp; &nbsp;history.setUserId(userId);</p><p> &nbsp; &nbsp; &nbsp; &nbsp;history.setSessionId(request.getSessionId());</p><p> &nbsp; &nbsp; &nbsp; &nbsp;history.setQuestionText(request.getSelectedText());</p><p> &nbsp; &nbsp; &nbsp; &nbsp;history.setAnswerText(answer);</p><p> &nbsp; &nbsp; &nbsp; &nbsp;aiChatDao.save(history);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 6. 返回结果</p><p> &nbsp; &nbsp; &nbsp; &nbsp;return AiChatResponse.builder()</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.answer(answer)</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.chatId(history.getChatId())</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.build();</p><p> &nbsp; &nbsp;}</p><p><br></p><p> &nbsp; &nbsp;private List&lt;Map&lt;String, String&gt;&gt; buildMessages(AiChatRequestDto request) {</p><p> &nbsp; &nbsp; &nbsp; &nbsp;List&lt;Map&lt;String, String&gt;&gt; messages = new ArrayList&lt;&gt;();</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 系统提示词</p><p> &nbsp; &nbsp; &nbsp; &nbsp;Map&lt;String, String&gt; systemMsg = new HashMap&lt;&gt;();</p><p> &nbsp; &nbsp; &nbsp; &nbsp;systemMsg.put("role", "system");</p><p> &nbsp; &nbsp; &nbsp; &nbsp;systemMsg.put("content",</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;"你是一个专业的计算机学习助手。请用简洁易懂的语言解释专业概念。" +</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;"回答控制在200字以内，适当举例说明。");</p><p> &nbsp; &nbsp; &nbsp; &nbsp;messages.add(systemMsg);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;// 用户消息</p><p> &nbsp; &nbsp; &nbsp; &nbsp;Map&lt;String, String&gt; userMsg = new HashMap&lt;&gt;();</p><p> &nbsp; &nbsp; &nbsp; &nbsp;userMsg.put("role", "user");</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;StringBuilder prompt = new StringBuilder();</p><p> &nbsp; &nbsp; &nbsp; &nbsp;prompt.append("我选中了以下内容：\\n");</p><p> &nbsp; &nbsp; &nbsp; &nbsp;prompt.append(request.getSelectedText());</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;if (StringUtils.isNotBlank(request.getContext())) {</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;prompt.append("\\n\\n上下文：\\n");</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;prompt.append(request.getContext());</p><p> &nbsp; &nbsp; &nbsp; &nbsp;}</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;prompt.append("\\n\\n我的问题是：");</p><p> &nbsp; &nbsp; &nbsp; &nbsp;prompt.append(request.getQuestion());</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;userMsg.put("content", prompt.toString());</p><p> &nbsp; &nbsp; &nbsp; &nbsp;messages.add(userMsg);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;return messages;</p><p> &nbsp; &nbsp;}</p><p><br></p><p> &nbsp; &nbsp;private String parseResponse(String response) {</p><p> &nbsp; &nbsp; &nbsp; &nbsp;JSONObject json = JSON.parseObject(response);</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;if (json.containsKey("error")) {</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;throw new MyException("AI调用失败：" + json.getString("error"));</p><p> &nbsp; &nbsp; &nbsp; &nbsp;}</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;return json.getJSONArray("choices")</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.getJSONObject(0)</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.getJSONObject("message")</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.getString("content");</p><p> &nbsp; &nbsp;}</p><p>}</p><p>四、前端设计</p><p>4.1 技术选型</p><p>端	技术	说明</p><p>管理后台	LayUI + Pear Admin	保留现有技术，维护用户管理、分类管理等功能</p><p>用户资源中心	Vue3 + Element Plus	新开发，提供现代化的用户体验</p><p>AI对话组件	Vue3 组件	可在任意页面嵌入使用</p><p>4.2 用户端页面结构（Vue3）</p><p><br></p><p>frontend-vue/</p><p>├── src/</p><p>│ &nbsp; ├── views/</p><p>│ &nbsp; │ &nbsp; ├── Home.vue &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 首页（资源列表）</p><p>│ &nbsp; │ &nbsp; ├── ResourceDetail.vue &nbsp; &nbsp; &nbsp; &nbsp;# 资源详情</p><p>│ &nbsp; │ &nbsp; ├── ResourceUpload.vue &nbsp; &nbsp; &nbsp; &nbsp;# 资源上传</p><p>│ &nbsp; │ &nbsp; ├── Search.vue &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 搜索页</p><p>│ &nbsp; │ &nbsp; ├── MyResources.vue &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 我的资源</p><p>│ &nbsp; │ &nbsp; ├── MyDownloads.vue &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 下载历史</p><p>│ &nbsp; │ &nbsp; ├── MyFavorites.vue &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 我的收藏</p><p>│ &nbsp; │ &nbsp; ├── Login.vue &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 登录</p><p>│ &nbsp; │ &nbsp; └── Register.vue &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 注册</p><p>│ &nbsp; ├── components/</p><p>│ &nbsp; │ &nbsp; ├── ResourceCard.vue &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 资源卡片</p><p>│ &nbsp; │ &nbsp; ├── CategoryTree.vue &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 分类树</p><p>│ &nbsp; │ &nbsp; ├── TagCloud.vue &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 标签云</p><p>│ &nbsp; │ &nbsp; └── AiChatSidebar.vue &nbsp; &nbsp; &nbsp; &nbsp; # **AI对话侧边栏（创新点）**</p><p>│ &nbsp; ├── api/</p><p>│ &nbsp; │ &nbsp; ├── resource.js &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 资源API</p><p>│ &nbsp; │ &nbsp; ├── ai.js &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # AI API</p><p>│ &nbsp; │ &nbsp; └── user.js &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 用户API</p><p>│ &nbsp; └── router/</p><p>│ &nbsp; &nbsp; &nbsp; └── index.js &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 路由配置</p><p>4.3 AI对话组件实现（核心创新）</p><p>AiChatSidebar.vue</p><p><br></p><p>&lt;template&gt;</p><p> &nbsp;&lt;!-- AI对话侧边栏 --&gt;</p><p> &nbsp;&lt;el-drawer</p><p> &nbsp; &nbsp;v-model="visible"</p><p> &nbsp; &nbsp;title="AI学习助手"</p><p> &nbsp; &nbsp;direction="rtl"</p><p> &nbsp; &nbsp;size="400px"</p><p> &nbsp; &nbsp;:before-close="handleClose"&gt;</p><p><br></p><p> &nbsp; &nbsp;&lt;!-- 对话历史 --&gt;</p><p> &nbsp; &nbsp;&lt;div class="chat-history" ref="chatHistory"&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;div</p><p> &nbsp; &nbsp; &nbsp; &nbsp;v-for="(msg, index) in messages"</p><p> &nbsp; &nbsp; &nbsp; &nbsp;:key="index"</p><p> &nbsp; &nbsp; &nbsp; &nbsp;:class="[\'message\', msg.role]"&gt;</p><p><br></p><p> &nbsp; &nbsp; &nbsp; &nbsp;&lt;div class="message-content"&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;strong&gt;{{ msg.role === \'user\' ? \'我\' : \'AI助手\' }}：&lt;/strong&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;p&gt;{{ msg.content }}&lt;/p&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp;&lt;/div&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;/div&gt;</p><p><br></p><p> &nbsp; &nbsp; &nbsp;&lt;!-- 加载动画 --&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;div v-if="loading" class="message ai"&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp;&lt;div class="message-content"&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;p&gt;正在思考中...&lt;/p&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp;&lt;/div&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;/div&gt;</p><p> &nbsp; &nbsp;&lt;/div&gt;</p><p><br></p><p> &nbsp; &nbsp;&lt;!-- 输入区域 --&gt;</p><p> &nbsp; &nbsp;&lt;div class="chat-input"&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;el-input</p><p> &nbsp; &nbsp; &nbsp; &nbsp;v-model="question"</p><p> &nbsp; &nbsp; &nbsp; &nbsp;type="textarea"</p><p> &nbsp; &nbsp; &nbsp; &nbsp;:rows="3"</p><p> &nbsp; &nbsp; &nbsp; &nbsp;placeholder="输入你的问题..."</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@keydown.ctrl.enter="send" /&gt;</p><p><br></p><p> &nbsp; &nbsp; &nbsp;&lt;div class="input-actions"&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp;&lt;span class="hint"&gt;Ctrl + Enter 发送&lt;/span&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp;&lt;el-button</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;type="primary"</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;:loading="loading"</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;@click="send"&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;发送</p><p> &nbsp; &nbsp; &nbsp; &nbsp;&lt;/el-button&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;/div&gt;</p><p> &nbsp; &nbsp;&lt;/div&gt;</p><p> &nbsp;&lt;/el-drawer&gt;</p><p>&lt;/template&gt;</p><p><br></p><p>&lt;script setup&gt;</p><p>import { ref, nextTick } from \'vue\'</p><p>import { chatWithAi } from \'@/api/ai\'</p><p>import { ElMessage } from \'element-plus\'</p><p><br></p><p>const props = defineProps({</p><p> &nbsp;selectedText: String, &nbsp; &nbsp;// 用户选中的文本</p><p> &nbsp;context: String &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;// 上下文内容</p><p>})</p><p><br></p><p>const emit = defineEmits([\'close\'])</p><p><br></p><p>const visible = ref(true)</p><p>const loading = ref(false)</p><p>const question = ref(\'\')</p><p>const sessionId = ref(generateUUID())</p><p>const messages = ref([])</p><p>const chatHistory = ref(null)</p><p><br></p><p>// 自动填充选中的文本</p><p>if (props.selectedText) {</p><p> &nbsp;question.value = `请解释：${props.selectedText}`</p><p>}</p><p><br></p><p>// 发送消息</p><p>const send = async () =&gt; {</p><p> &nbsp;if (!question.value.trim()) {</p><p> &nbsp; &nbsp;ElMessage.warning(\'请输入问题\')</p><p> &nbsp; &nbsp;return</p><p> &nbsp;}</p><p><br></p><p> &nbsp;// 添加用户消息</p><p> &nbsp;messages.value.push({</p><p> &nbsp; &nbsp;role: \'user\',</p><p> &nbsp; &nbsp;content: question.value</p><p> &nbsp;})</p><p><br></p><p> &nbsp;const userQuestion = question.value</p><p> &nbsp;question.value = \'\'</p><p> &nbsp;scrollToBottom()</p><p><br></p><p> &nbsp;// 调用AI接口</p><p> &nbsp;loading.value = true</p><p> &nbsp;try {</p><p> &nbsp; &nbsp;const response = await chatWithAi({</p><p> &nbsp; &nbsp; &nbsp;sessionId: sessionId.value,</p><p> &nbsp; &nbsp; &nbsp;selectedText: props.selectedText,</p><p> &nbsp; &nbsp; &nbsp;question: userQuestion,</p><p> &nbsp; &nbsp; &nbsp;context: props.context</p><p> &nbsp; &nbsp;})</p><p><br></p><p> &nbsp; &nbsp;// 添加AI回复</p><p> &nbsp; &nbsp;messages.value.push({</p><p> &nbsp; &nbsp; &nbsp;role: \'ai\',</p><p> &nbsp; &nbsp; &nbsp;content: response.data.answer</p><p> &nbsp; &nbsp;})</p><p><br></p><p> &nbsp; &nbsp;scrollToBottom()</p><p> &nbsp;} catch (error) {</p><p> &nbsp; &nbsp;ElMessage.error(\'AI服务暂时不可用：\' + error.message)</p><p> &nbsp;} finally {</p><p> &nbsp; &nbsp;loading.value = false</p><p> &nbsp;}</p><p>}</p><p><br></p><p>// 滚动到底部</p><p>const scrollToBottom = () =&gt; {</p><p> &nbsp;nextTick(() =&gt; {</p><p> &nbsp; &nbsp;if (chatHistory.value) {</p><p> &nbsp; &nbsp; &nbsp;chatHistory.value.scrollTop = chatHistory.value.scrollHeight</p><p> &nbsp; &nbsp;}</p><p> &nbsp;})</p><p>}</p><p><br></p><p>// 生成UUID</p><p>const generateUUID = () =&gt; {</p><p> &nbsp;return \'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx\'.replace(/[xy]/g, (c) =&gt; {</p><p> &nbsp; &nbsp;const r = Math.random() * 16 | 0</p><p> &nbsp; &nbsp;const v = c === \'x\' ? r : (r & 0x3 | 0x8)</p><p> &nbsp; &nbsp;return v.toString(16)</p><p> &nbsp;})</p><p>}</p><p><br></p><p>const handleClose = () =&gt; {</p><p> &nbsp;emit(\'close\')</p><p>}</p><p>&lt;/script&gt;</p><p><br></p><p>&lt;style scoped&gt;</p><p>.chat-history {</p><p> &nbsp;height: calc(100vh - 200px);</p><p> &nbsp;overflow-y: auto;</p><p> &nbsp;padding: 10px;</p><p>}</p><p><br></p><p>.message {</p><p> &nbsp;margin-bottom: 15px;</p><p>}</p><p><br></p><p>.message.user .message-content {</p><p> &nbsp;background: #e6f7ff;</p><p> &nbsp;padding: 10px;</p><p> &nbsp;border-radius: 5px;</p><p> &nbsp;text-align: right;</p><p>}</p><p><br></p><p>.message.ai .message-content {</p><p> &nbsp;background: #f6f6f6;</p><p> &nbsp;padding: 10px;</p><p> &nbsp;border-radius: 5px;</p><p>}</p><p><br></p><p>.chat-input {</p><p> &nbsp;padding: 10px;</p><p> &nbsp;border-top: 1px solid #eee;</p><p>}</p><p>&lt;/style&gt;</p><p>页面中使用AI组件</p><p><br></p><p>&lt;template&gt;</p><p> &nbsp;&lt;div class="resource-detail" @mouseup="handleTextSelection"&gt;</p><p> &nbsp; &nbsp;&lt;!-- 资源内容 --&gt;</p><p> &nbsp; &nbsp;&lt;div class="content"&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;h1&gt;{{ resource.title }}&lt;/h1&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;div class="description"&gt;{{ resource.description }}&lt;/div&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;!-- ... --&gt;</p><p> &nbsp; &nbsp;&lt;/div&gt;</p><p><br></p><p> &nbsp; &nbsp;&lt;!-- AI提问按钮（选中文本后显示） --&gt;</p><p> &nbsp; &nbsp;&lt;transition name="fade"&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;el-button</p><p> &nbsp; &nbsp; &nbsp; &nbsp;v-if="selectedText"</p><p> &nbsp; &nbsp; &nbsp; &nbsp;class="ask-ai-btn"</p><p> &nbsp; &nbsp; &nbsp; &nbsp;type="warning"</p><p> &nbsp; &nbsp; &nbsp; &nbsp;circle</p><p> &nbsp; &nbsp; &nbsp; &nbsp;size="large"</p><p> &nbsp; &nbsp; &nbsp; &nbsp;@click="showAiChat = true"&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp;&lt;el-icon&gt;&lt;ChatDotRound /&gt;&lt;/el-icon&gt;</p><p> &nbsp; &nbsp; &nbsp; &nbsp;&lt;span&gt;问问AI&lt;/span&gt;</p><p> &nbsp; &nbsp; &nbsp;&lt;/el-button&gt;</p><p> &nbsp; &nbsp;&lt;/transition&gt;</p><p><br></p><p> &nbsp; &nbsp;&lt;!-- AI对话侧边栏 --&gt;</p><p> &nbsp; &nbsp;&lt;AiChatSidebar</p><p> &nbsp; &nbsp; &nbsp;v-model:visible="showAiChat"</p><p> &nbsp; &nbsp; &nbsp;:selected-text="selectedText"</p><p> &nbsp; &nbsp; &nbsp;:context="getContext()"</p><p> &nbsp; &nbsp; &nbsp;@close="showAiChat = false" /&gt;</p><p> &nbsp;&lt;/div&gt;</p><p>&lt;/template&gt;</p><p><br></p><p>&lt;script setup&gt;</p><p>import { ref } from \'vue\'</p><p>import AiChatSidebar from \'@/components/AiChatSidebar.vue\'</p><p><br></p><p>const showAiChat = ref(false)</p><p>const selectedText = ref(\'\')</p><p><br></p><p>// 监听文本选择</p><p>const handleTextSelection = () =&gt; {</p><p> &nbsp;const selection = window.getSelection()</p><p> &nbsp;const text = selection.toString().trim()</p><p><br></p><p> &nbsp;if (text.length &gt; 5) {</p><p> &nbsp; &nbsp;selectedText.value = text</p><p> &nbsp;} else {</p><p> &nbsp; &nbsp;selectedText.value = \'\'</p><p> &nbsp;}</p><p>}</p><p><br></p><p>// 获取上下文</p><p>const getContext = () =&gt; {</p><p> &nbsp;return document.body.textContent.substring(0, 500)</p><p>}</p><p>&lt;/script&gt;</p><p><br></p><p>&lt;style scoped&gt;</p><p>.ask-ai-btn {</p><p> &nbsp;position: fixed;</p><p> &nbsp;bottom: 100px;</p><p> &nbsp;right: 50px;</p><p> &nbsp;z-index: 1000;</p><p> &nbsp;animation: pulse 2s infinite;</p><p>}</p><p><br></p><p>@keyframes pulse {</p><p> &nbsp;0%, 100% { transform: scale(1); }</p><p> &nbsp;50% { transform: scale(1.05); }</p><p>}</p><p><br></p><p>.fade-enter-active, .fade-leave-active {</p><p> &nbsp;transition: opacity 0.3s;</p><p>}</p><p>.fade-enter-from, .fade-leave-to {</p><p> &nbsp;opacity: 0;</p><p>}</p><p>&lt;/style&gt;</p><p>五、配置文件扩展</p><p>5.1 application.yml 新增配置</p><p><br></p><p># 文件上传配置</p><p>upload:</p><p> &nbsp;path: D:/learn-share/uploads/ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;# 本地存储路径</p><p> &nbsp;max-size: 52428800 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 50MB</p><p> &nbsp;allowed-types: pdf,doc,docx,ppt,pptx,txt</p><p><br></p><p># AI服务配置（用户可配置任意兼容OpenAI的API）</p><p>ai:</p><p> &nbsp;api:</p><p> &nbsp; &nbsp;base-url: https://api.openai.com &nbsp; &nbsp; # 可改为 https://api.deepseek.com 等</p><p> &nbsp; &nbsp;key: your-api-key-here &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 用户自行配置</p><p> &nbsp; &nbsp;model: gpt-3.5-turbo &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 可改为 deepseek-chat 等</p><p> &nbsp; &nbsp;timeout: 30000 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 30秒超时</p><p> &nbsp; &nbsp;max-tokens: 1000 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # 最大token数</p><p><br></p><p># 静态资源映射（用于访问上传的文件）</p><p>spring:</p><p> &nbsp;web:</p><p> &nbsp; &nbsp;resources:</p><p> &nbsp; &nbsp; &nbsp;static-locations: file:${upload.path}</p><p> &nbsp;mvc:</p><p> &nbsp; &nbsp;static-path-pattern: /uploads/**</p><p>5.2 Maven依赖新增</p><p><br></p><p>&lt;!-- HTTP客户端（用于调用AI API） --&gt;</p><p>&lt;dependency&gt;</p><p> &nbsp; &nbsp;&lt;groupId&gt;cn.hutool&lt;/groupId&gt;</p><p> &nbsp; &nbsp;&lt;artifactId&gt;hutool-http&lt;/artifactId&gt;</p><p> &nbsp; &nbsp;&lt;version&gt;5.1.4&lt;/version&gt;</p><p>&lt;/dependency&gt;</p><p><br></p><p>&lt;!-- 文件上传工具 --&gt;</p><p>&lt;dependency&gt;</p><p> &nbsp; &nbsp;&lt;groupId&gt;commons-io&lt;/groupId&gt;</p><p> &nbsp; &nbsp;&lt;artifactId&gt;commons-io&lt;/artifactId&gt;</p><p> &nbsp; &nbsp;&lt;version&gt;2.8.0&lt;/version&gt;</p><p>&lt;/dependency&gt;</p><p>六、开发步骤与时间规划</p><p>阶段一：基础架构搭建（2天）</p><p> 创建数据库表并初始化数据</p><p> 搭建Vue3前端项目脚手架</p><p> 配置后端资源模块包结构</p><p> 实现文件上传功能</p><p> 测试文件存储和下载</p><p>阶段二：核心功能开发（4天）</p><p> 资源列表、搜索、筛选（Vue3）</p><p> 资源详情页</p><p> 资源上传页</p><p> 分类和标签管理（LayUI）</p><p> 我的资源、下载历史、收藏</p><p>阶段三：AI功能实现（3天）- 创新点</p><p> 后端AI服务集成</p><p> 前端文本选择监听</p><p> AI对话侧边栏组件</p><p> 对话历史记录</p><p> 多轮对话支持</p><p>阶段四：联调与优化（2天）</p><p> 前后端联调</p><p> 性能优化</p><p> 异常处理</p><p> 用户体验优化</p><p>阶段五：测试与文档（2天）</p><p> 功能测试</p><p> 编写使用手册</p><p> 准备答辩PPT</p><p> 撰写毕业论文</p><p>七、关键技术要点</p><p>7.1 文件上传安全</p><p><br></p><p>// 文件类型白名单</p><p>private static final List&lt;String&gt; ALLOWED_TYPES =</p><p> &nbsp; &nbsp;Arrays.asList("pdf", "doc", "docx", "ppt", "pptx", "txt");</p><p><br></p><p>// 文件大小限制</p><p>if (file.getSize() &gt; 50 * 1024 * 1024) {</p><p> &nbsp; &nbsp;throw new MyException("文件大小超过50MB");</p><p>}</p><p><br></p><p>// 文件名防重复</p><p>String newFileName = UUID.randomUUID() + "." + extension;</p><p><br></p><p>// 路径遍历攻击防护</p><p>if (file.getOriginalFilename().contains("..")) {</p><p> &nbsp; &nbsp;throw new MyException("非法文件名");</p><p>}</p><p>7.2 AI服务配置灵活性</p><p>支持任意兼容OpenAI API的服务（OpenAI、DeepSeek、通义千问等）</p><p>用户只需修改配置文件中的 base-url 和 api-key</p><p>支持多种模型切换（gpt-3.5-turbo、gpt-4、deepseek-chat等）</p><p>7.3 前后端集成方案</p><p>后端: 保留现有LayUI管理后台，端口8088</p><p>前端Vue: 新建独立项目，端口8080，通过Nginx反向代理</p><p>API认证: 继续使用JWT token，LocalStorage存储</p><p>八、项目亮点与创新点</p><p>8.1 核心创新点 ⭐⭐⭐⭐⭐</p><p>AI智能解读功能</p><p><br></p><p>用户在浏览资源时选中任意文本</p><p>点击浮动的"问问AI"按钮</p><p>右侧弹出AI对话侧边栏</p><p>AI解释选中的内容，支持多轮对话</p><p>模拟真人学习助手，适合教育场景</p><p>8.2 技术亮点</p><p>前后端混合架构 - 管理后台LayUI + 用户端Vue3</p><p>本地文件存储 - 简单可靠，适合毕业设计</p><p>无需审核机制 - 上传即发布，降低管理成本</p><p>AI服务灵活配置 - 支持多种OpenAI兼容API</p><p>完全免费共享 - 无积分系统，无付费墙</p><p>8.3 毕业设计优势</p><p>✅ 难度适中（不会太简单也不会太复杂）</p><p>✅ 有明显创新点（AI功能）</p><p>✅ 技术栈主流且实用</p><p>✅ 可演示性强</p><p>✅ 论文素材丰富</p><p>九、实施可行性分析</p><p>9.1 技术可行性</p><p>模块	难度	说明</p><p>文件上传下载	⭐	SpringBoot原生支持，简单</p><p>资源CRUD	⭐	标准业务逻辑</p><p>搜索筛选	⭐⭐	MyBatis动态SQL</p><p>Vue3前端	⭐⭐	Element Plus组件库完善</p><p>AI对话	⭐⭐⭐	HTTP调用API，有参考实现</p><p>9.2 时间可行性</p><p>总计13个工作日</p><p>每个阶段都有明确目标</p><p>预留2天缓冲时间</p><p>9.3 成本可行性</p><p>服务器：本地开发即可</p><p>AI API：用户自行配置，预估成本约$10-20（取决于使用量）</p><p>其他：完全免费</p><p>十、验证与测试</p><p>10.1 功能验收标准</p><p>✅ 用户可以注册、登录、上传资源</p><p>✅ 资源可以按分类、标签、关键词搜索</p><p>✅ 用户可以免费下载资源</p><p>✅ 选中文本后可点击"问问AI"按钮</p><p>✅ AI能够返回智能回复</p><p>✅ 管理员可以管理分类、标签、用户</p><p>✅ 系统稳定，无明显bug</p><p>10.2 性能指标</p><p>页面响应时间 &lt; 2秒</p><p>文件上传速度 &gt; 1MB/s</p><p>AI响应时间 &lt; 5秒</p><p>支持50并发用户</p><p>10.3 测试用例</p><p><br></p><p>// 1. 文件上传测试</p><p>@Test</p><p>public void testUploadPdf() {</p><p> &nbsp; &nbsp;File file = new File("test.pdf");</p><p> &nbsp; &nbsp;// 上传并验证文件存储成功</p><p>}</p><p><br></p><p>// 2. AI对话测试</p><p>@Test</p><p>public void testAiChat() {</p><p> &nbsp; &nbsp;AiChatRequestDto request = new AiChatRequestDto();</p><p> &nbsp; &nbsp;request.setSelectedText("Spring Boot是一个快速开发框架");</p><p> &nbsp; &nbsp;request.setQuestion("什么是Spring Boot？");</p><p> &nbsp; &nbsp;// 验证AI返回合理的回复</p><p>}</p><p><br></p><p>// 3. 搜索测试</p><p>@Test</p><p>public void testSearch() {</p><p> &nbsp; &nbsp;// 搜索"Spring Boot"</p><p> &nbsp; &nbsp;// 验证返回相关资源</p><p>}</p><p>十一、关键文件清单</p><p>需要创建的核心文件</p><p>后端（约20个文件）</p><p>ResourceController.java - 资源管理API</p><p>AiChatController.java - AI对话API</p><p>ResourceServiceImpl.java - 资源业务逻辑</p><p>AiChatServiceImpl.java - AI服务实现</p><p>ResourceInfo.java - 资源实体</p><p>AiChatHistory.java - AI对话实体</p><p>ResourceDao.java - 资源DAO</p><p>AiChatDao.java - AI对话DAO</p><p>ResourceMapper.xml - MyBatis映射</p><p>FileUploadConfig.java - 文件上传配置</p><p>AiServiceConfig.java - AI服务配置</p><p>前端Vue3（约15个文件）</p><p>Home.vue - 资源列表首页</p><p>ResourceDetail.vue - 资源详情</p><p>ResourceUpload.vue - 资源上传</p><p>AiChatSidebar.vue - AI对话侧边栏</p><p>ResourceCard.vue - 资源卡片组件</p><p>resource.js - 资源API封装</p><p>ai.js - AI API封装</p><p>router/index.js - 路由配置</p><p>数据库</p><p>learn-share.sql - 完整数据库脚本（包含所有表和初始数据）</p><p>十二、风险与应对</p><p>风险1：AI API调用失败</p><p>应对：</p><p><br></p><p>提供降级方案，显示友好错误提示</p><p>支持多个API配置，自动切换</p><p>风险2：文件存储空间不足</p><p>应对：</p><p><br></p><p>设置文件大小限制（50MB）</p><p>定期清理未使用的文件</p><p>风险3：开发时间不足</p><p>应对：</p><p><br></p><p>优先实现核心功能（资源CRUD + AI对话）</p><p>可选功能（收藏、评论）可放到后期</p><p>十三、总结</p><p>本方案提供了一个完整、可行、有创新点的毕业设计方案：</p><p><br></p><p>核心成果</p><p>6张数据表（完整DDL脚本）</p><p>1个AI创新功能（选中文本→AI对话）</p><p>前后端分离架构（LayUI管理 + Vue3用户）</p><p>13天开发计划（详细到每个阶段）</p><p>灵活的AI配置（支持任意OpenAI兼容API）</p><p>项目特色</p><p>✅ 技术主流：SpringBoot + Vue3</p><p>✅ 创新明显：AI智能解读功能</p><p>✅ 难度适中：不会太简单也不会太复杂</p><p>✅ 可演示强：功能直观、效果明显</p><p>✅ 论文素材丰富：有完整的技术栈和功能设计</p>', '本项目的开发设计方案', 2, NULL, 39, 22, 1, '管理员', 1, '2026-02-15 17:20:59', '2026-02-20 23:57:16', NULL),
	(7, '测试文章发布', '<h1><u><em><strong>这里是文章的正文</strong></em></u></h1>', '用于测试文章封面及文章标签', 1, NULL, 12, 0, 1, '管理员', 1, '2026-02-19 13:37:30', '2026-02-21 21:20:53', NULL),
	(8, '测试文章发布', '<h1>测试封面测试封面测试封面测试封面测试封面！</h1>', '用于测试文章封面及文章标签', 1, '/uploads/article/2026/02/18dd948b88d1427da69833c0655bfb98.jpg', 66, 1, 1, '管理员', 1, '2026-02-19 17:33:16', '2026-02-21 22:18:07', '2026-02-19 23:49:05'),
	(11, '回归测试', '<h1>回归测试回归测试回归测试回归测试</h1><p><br></p><ul><li>回归测试回归测试</li><li>回归测试回归测试</li><li>回归测试回归测试</li><li>回归测试回归测试</li></ul>', '测试文章创建', 10, '/uploads/article/2026/02/62ea577a18db49dbbbf521b456eea07c.jpg', 1, 0, 1, '管理员', 1, '2026-02-21 22:57:57', '2026-02-21 22:57:58', NULL);

-- 导出  表 xue-xiang-hui.my_dept 结构
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

-- 正在导出表  xue-xiang-hui.my_dept 的数据：~7 rows (大约)
INSERT INTO `my_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `sort`, `status`, `create_time`, `update_time`) VALUES
	(1, 0, '0', '南京总公司', 1, b'1', '2025-08-19 11:01:09', '2025-09-08 18:21:26'),
	(2, 1, '0,1', '研发部门', 1, b'1', '2025-08-19 11:01:28', '2025-08-19 11:01:30'),
	(3, 1, '0,1', '市场部门', 2, b'1', '2025-08-19 11:01:47', '2025-08-19 11:01:48'),
	(4, 1, '0,1', '运维部门', 3, b'1', '2025-08-19 11:02:01', '2025-08-19 11:02:04'),
	(5, 0, '0', '苏州分公司', 2, b'1', '2025-08-19 11:07:36', '2025-08-27 14:18:48'),
	(6, 5, '0,5', '营销部门', 1, b'1', '2025-08-19 11:08:40', '2025-08-21 20:32:40'),
	(7, 5, '0,5', '运维部门', 2, b'1', '2025-08-19 11:08:56', '2025-09-08 18:03:56');

-- 导出  表 xue-xiang-hui.my_dict 结构
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

-- 正在导出表  xue-xiang-hui.my_dict 的数据：~0 rows (大约)
INSERT INTO `my_dict` (`dict_id`, `dict_name`, `description`, `sort`, `create_by`, `update_by`, `create_time`, `update_time`) VALUES
	(1, '性别', '性别字典', 1, 'admin', 'admin', '2025-11-07 15:06:18', '2025-11-07 15:06:20');

-- 导出  表 xue-xiang-hui.my_dict_detail 结构
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

-- 正在导出表  xue-xiang-hui.my_dict_detail 的数据：~2 rows (大约)
INSERT INTO `my_dict_detail` (`id`, `dict_id`, `label`, `value`, `sort`, `create_by`, `update_by`, `create_time`, `update_time`) VALUES
	(1, 1, '男', '1', 1, NULL, NULL, NULL, NULL),
	(2, 1, '女', '2', 2, NULL, NULL, NULL, NULL);

-- 导出  表 xue-xiang-hui.my_job 结构
CREATE TABLE IF NOT EXISTS `my_job` (
  `job_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `job_name` varchar(255) NOT NULL COMMENT '岗位名称',
  `status` tinyint(1) DEFAULT NULL COMMENT '岗位状态',
  `sort` int(5) DEFAULT NULL COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.my_job 的数据：~3 rows (大约)
INSERT INTO `my_job` (`job_id`, `job_name`, `status`, `sort`, `create_time`, `update_time`) VALUES
	(1, '部门经理', 1, 1, '2025-08-19 11:14:55', '2025-08-19 11:14:57'),
	(2, '人事专员', 1, 2, '2025-08-19 11:15:30', '2025-08-19 11:15:33'),
	(3, '普通员工', 1, 3, '2025-08-19 11:16:19', '2025-09-02 10:48:34');

-- 导出  表 xue-xiang-hui.my_log 结构
CREATE TABLE IF NOT EXISTS `my_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `user_name` varchar(255) DEFAULT NULL COMMENT '用户名',
  `ip` varchar(64) DEFAULT NULL COMMENT '请求ip',
  `description` varchar(255) DEFAULT NULL COMMENT '操作描述',
  `params` text DEFAULT NULL COMMENT '参数值',
  `browser` varchar(255) DEFAULT NULL COMMENT '浏览器',
  `time` bigint(20) DEFAULT NULL COMMENT '执行时间',
  `type` varchar(255) DEFAULT NULL COMMENT '日志类型',
  `method` varchar(255) DEFAULT NULL COMMENT '执行方法',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `exception_detail` text DEFAULT NULL COMMENT '异常详细信息',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 导出  表 xue-xiang-hui.my_menu 结构
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

-- 正在导出表  xue-xiang-hui.my_menu 的数据：~41 rows (大约)
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
	(91, 90, '资源列表', 'layui-icon layui-icon-file', '/api/admin/resource/list', 'resource:list', 1, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(92, 90, '资源分类', 'layui-icon layui-icon-app', '/api/admin/resource/category', 'resource:category:list', 2, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(93, 90, '标签管理', 'layui-icon layui-icon-note', '/api/admin/resource/tag', 'resource:tag:list', 3, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(94, 90, '下载记录', 'layui-icon layui-icon-download-circle', '/api/admin/resource/download', 'resource:download:list', 4, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(95, 90, '文章列表', 'layui-icon layui-icon-read', '/api/admin/article/list', 'article:list', 5, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(96, 90, '文章分类', 'layui-icon layui-icon-app', '/api/admin/article/category', 'article:category:list', 6, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(97, 90, 'AI对话历史', 'layui-icon layui-icon-dialogue', '/admin/ai/history', 'ai:history:list', 7, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(98, 90, 'Token统计', 'layui-icon layui-icon-chart', '/admin/ai/tokens', 'ai:token:list', 8, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(99, 90, '数据概览', 'layui-icon layui-icon-chart-screen', '/admin/statistics/dashboard', 'statistics:view', 9, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(100, 90, '用户排行', 'layui-icon layui-icon-user', '/admin/statistics/user', 'statistics:user', 10, 1, '2026-02-08 22:54:50', '2026-02-08 22:54:50');

-- 导出  表 xue-xiang-hui.my_role 结构
CREATE TABLE IF NOT EXISTS `my_role` (
  `role_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `role_name` varchar(255) NOT NULL COMMENT '名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `data_scope` char(1) DEFAULT NULL COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.my_role 的数据：~2 rows (大约)
INSERT INTO `my_role` (`role_id`, `role_name`, `description`, `create_time`, `update_time`, `data_scope`) VALUES
	(1, 'ADMIN', '超级管理员，拥有所有权限', '2025-07-10 09:40:35', '2025-11-07 14:47:39', '1'),
	(2, 'USER', '普通用户', '2025-07-10 09:40:56', '2025-11-07 14:47:52', '2');

-- 导出  表 xue-xiang-hui.my_role_dept 结构
CREATE TABLE IF NOT EXISTS `my_role_dept` (
  `role_id` int(32) NOT NULL COMMENT '角色id',
  `dept_id` int(32) NOT NULL COMMENT '部门id',
  PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.my_role_dept 的数据：~3 rows (大约)
INSERT INTO `my_role_dept` (`role_id`, `dept_id`) VALUES
	(2, 5),
	(2, 6),
	(2, 7);

-- 导出  表 xue-xiang-hui.my_role_menu 结构
CREATE TABLE IF NOT EXISTS `my_role_menu` (
  `role_id` int(32) NOT NULL COMMENT '角色id',
  `menu_id` int(32) NOT NULL COMMENT '菜单id',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.my_role_menu 的数据：~55 rows (大约)
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

-- 导出  表 xue-xiang-hui.my_role_user 结构
CREATE TABLE IF NOT EXISTS `my_role_user` (
  `user_id` int(32) NOT NULL COMMENT '用户id',
  `role_id` int(32) NOT NULL COMMENT '角色id',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.my_role_user 的数据：~8 rows (大约)
INSERT INTO `my_role_user` (`user_id`, `role_id`) VALUES
	(1, 1),
	(2, 2),
	(3, 2),
	(4, 2),
	(5, 2),
	(6, 2),
	(7, 2),
	(8, 2);

-- 导出  表 xue-xiang-hui.my_user 结构
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

-- 正在导出表  xue-xiang-hui.my_user 的数据：~8 rows (大约)
INSERT INTO `my_user` (`user_id`, `dept_id`, `user_name`, `password`, `nick_name`, `phone`, `email`, `status`, `create_time`, `update_time`) VALUES
	(1, 1, 'admin', '$2a$10$pAuzCLIe6Sl7kXfX6FEQ1uzM79V2njg.KtL9qawg9JkW7e1f417k2', '管理员', '13556336255', '1454564646@qq.com', 1, '2025-07-10 09:42:03', '2025-08-23 16:24:34'),
	(2, 2, 'test', '$2a$10$pAuzCLIe6Sl7kXfX6FEQ1uzM79V2njg.KtL9qawg9JkW7e1f417k2', '测试用户', '13556336256', '1454564646@163.com', 1, '2025-07-10 09:42:09', '2025-07-13 17:49:49'),
	(3, 2, 'test1', '$2a$10$exOfpFK2TNHnAdG/aaVTFeCDLihkg8JfD1qGWKjCOBdicxcQJax5W', '普通用户2', '13556336257', '1454564646@qq.com', 1, '2025-07-10 09:42:14', '2025-07-10 09:42:16'),
	(4, 2, 'test2', '$2a$10$RR665iMnfCuYGY0Af344U.Fy3XmGcgjkURENW/Zea/oAEhuiLyjO.', '普通用户3', '13556336258', '1454564646@qq.com', 1, '2025-07-10 09:42:19', '2025-07-10 09:42:21'),
	(5, 3, 'test3', '$2a$10$o0lZgmzReca24TP5viy/nOrPQty4jga1W.BG5SvgdeK9eprm.NoMa', '普通用户4', '13556336259', '1454564646@qq.com', 1, '2025-07-10 09:42:23', '2025-07-10 09:42:25'),
	(6, 3, 'test4', '$2a$10$jNU1gXN.wAPhq5vUmLrCoeyDJbF3ReSnYQ2IulJA99drcMs1w1Som', '封禁用户', '13556336250', '1454564646@qq.com', 0, '2025-07-10 09:42:27', '2025-07-13 17:54:11'),
	(7, 3, 'test5', '$2a$10$ADEBRX13Z9vvNxzdu/HiROaB1F7rYd5DHpE9UWeXtNOSbeB1tcWie', '封禁用户2', '13556336211', '1454564646@qq.com', 0, '2025-07-10 09:42:32', '2025-07-10 09:42:34'),
	(8, 6, 'test6', '$2a$10$2aLbMBdNottSq13J.tfIF.5IFgTcDlWwOQI7btckzsq3vl2KtWOV6', '测试修改', '13556336253', '1454564646@qq.com', 1, '2025-07-10 09:42:36', '2025-10-01 14:24:19');

-- 导出  表 xue-xiang-hui.my_user_job 结构
CREATE TABLE IF NOT EXISTS `my_user_job` (
  `user_id` int(32) NOT NULL COMMENT '岗位id',
  `job_id` int(32) NOT NULL COMMENT '工作id',
  PRIMARY KEY (`user_id`,`job_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.my_user_job 的数据：~9 rows (大约)
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

-- 导出  表 xue-xiang-hui.resource_category 结构
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='资源分类表';

-- 正在导出表  xue-xiang-hui.resource_category 的数据：~10 rows (大约)
INSERT INTO `resource_category` (`parent_id`, `category_name`, `description`, `icon`, `sort_order`, `status`, `create_time`, `update_time`) VALUES
	(0, '计算机基础', '计算机基础知识', 'layui-icon layui-icon-component', 1, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(0, '编程语言', '各类编程语言资料', 'layui-icon layui-icon-code', 2, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(0, '框架技术', '主流开发框架', 'layui-icon layui-icon-template', 3, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(0, '数据库', '数据库相关资料', 'layui-icon layui-icon-table', 4, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(0, '人工智能', 'AI、机器学习等', 'layui-icon layui-icon-engine', 5, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(2, 'Java', 'Java编程语言', NULL, 1, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(2, 'Python', 'Python编程语言', NULL, 2, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(2, 'JavaScript', 'JavaScript前端', NULL, 3, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(3, 'Spring', 'Spring全家桶', NULL, 1, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31'),
	(3, 'Vue', 'Vue前端框架', NULL, 2, 1, '2026-02-08 16:55:31', '2026-02-08 16:55:31');

-- 导出  表 xue-xiang-hui.resource_info 结构
CREATE TABLE IF NOT EXISTS `resource_info` (
  `resource_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '资源ID',
  `title` varchar(200) NOT NULL COMMENT '资源标题',
  `description` text DEFAULT NULL COMMENT '资源描述',
  `category_id` int(32) NOT NULL COMMENT '所属分类ID',
  `file_name` varchar(255) NOT NULL COMMENT '文件原始名称',
  `file_path` varchar(500) NOT NULL COMMENT '文件存储路径',
  `file_size` bigint(20) DEFAULT 0 COMMENT '文件大小（字节）',
  `file_type` varchar(20) NOT NULL COMMENT '文件类型：pdf/doc/docx/ppt/pptx/zip',
  `cover_image` varchar(500) DEFAULT NULL COMMENT '封面图片路径',
  `view_count` int(10) DEFAULT 0 COMMENT '浏览次数',
  `download_count` int(10) DEFAULT 0 COMMENT '下载次数',
  `collect_count` int(10) DEFAULT 0 COMMENT '收藏次数',
  `uploader_id` int(32) NOT NULL COMMENT '上传者用户ID',
  `uploader_name` varchar(100) DEFAULT NULL COMMENT '上传者姓名',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：1已发布 0已下架',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '上传时间',
  `update_time` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '更新时间',
  PRIMARY KEY (`resource_id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_uploader` (`uploader_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  FULLTEXT KEY `ft_title_desc` (`title`,`description`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='资源信息表';

-- 正在导出表  xue-xiang-hui.resource_info 的数据：~4 rows (大约)
INSERT INTO `resource_info` (`resource_id`, `title`, `description`, `category_id`, `file_name`, `file_path`, `file_size`, `file_type`, `cover_image`, `view_count`, `download_count`, `collect_count`, `uploader_id`, `uploader_name`, `status`, `create_time`, `update_time`) VALUES
	(1, '学享汇资源共享平台', '这是一段资源描述内容', 3, '学享汇开发方案.txt', '2026/02/523adc7cd5ca451eabc9e681043df7dc.txt', 33414, 'txt', NULL, 34, 6, 5, 1, '管理员', 1, '2026-02-14 21:37:53', '2026-02-21 14:41:01'),
	(2, '文件上传测试', '测试测试测试测试测试', 1, '文件上传测试.pptx', '2026/02/2aeed9a85a014301bf86a07405596fbd.pptx', 33174, 'pptx', NULL, 23, 12, 1, 1, '管理员', 1, '2026-02-19 15:14:47', '2026-02-21 17:58:30'),
	(3, '文件上传测试', 'PDF上传测试，PDF上传测试。', 6, '文件上传测试.pdf', '2026/02/71288acfbae84ce8b1b673e823a29f30.pdf', 5188, 'pdf', NULL, 0, 0, 0, 1, '管理员', 0, '2026-02-19 15:21:17', '2026-02-20 17:11:46'),
	(7, '新建 Microsoft Word 文档', '这是一个新建的 Microsoft Word 文档', 2, '新建 Microsoft Word 文档.docx', '2026/02/4f84ea88ccd841e0b40ceece1eb09d76.docx', 16098, 'docx', NULL, 10, 4, 0, 2, '测试用户', 1, '2026-02-20 21:59:32', '2026-02-21 21:20:51'),
	(8, '文件上传测试', '资源上传の回归测试\r\n回归测试', 1, '文件上传测试.zip', '2026/02/a5962e0d530a44e2bc6b716a01b3f6e2.zip', 38015, 'zip', NULL, 1, 1, 0, 1, '管理员', 1, '2026-02-21 23:04:03', '2026-02-21 23:04:13');

-- 导出  表 xue-xiang-hui.resource_tag 结构
CREATE TABLE IF NOT EXISTS `resource_tag` (
  `tag_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `tag_name` varchar(50) NOT NULL COMMENT '标签名称',
  `use_count` int(10) DEFAULT 0 COMMENT '使用次数',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `uk_tag_name` (`tag_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='资源标签表';

-- 正在导出表  xue-xiang-hui.resource_tag 的数据：~9 rows (大约)
INSERT INTO `resource_tag` (`tag_id`, `tag_name`, `use_count`, `create_time`) VALUES
	(1, 'SpringBoot', 2, '2026-02-08 16:55:31'),
	(2, '毕业设计', 2, '2026-02-08 16:55:31'),
	(3, '教程', 1, '2026-02-08 16:55:31'),
	(4, '面试', 1, '2026-02-08 16:55:31'),
	(5, '实战项目', 1, '2026-02-08 16:55:31'),
	(6, '源码', 2, '2026-02-08 16:55:31'),
	(7, '课件', 1, '2026-02-08 16:55:31'),
	(8, '学习', 1, '2026-02-12 22:41:11'),
	(9, '论文', 0, '2026-02-12 22:50:32');

-- 导出  表 xue-xiang-hui.resource_tag_relation 结构
CREATE TABLE IF NOT EXISTS `resource_tag_relation` (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `resource_id` int(32) NOT NULL COMMENT '资源ID',
  `tag_id` int(32) NOT NULL COMMENT '标签ID',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resource_tag` (`resource_id`,`tag_id`),
  KEY `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='资源标签关联表';

-- 正在导出表  xue-xiang-hui.resource_tag_relation 的数据：~8 rows (大约)
INSERT INTO `resource_tag_relation` (`id`, `resource_id`, `tag_id`, `create_time`) VALUES
	(1, 1, 1, '2026-02-20 23:31:30'),
	(2, 1, 5, '2026-02-20 23:31:30'),
	(3, 2, 2, '2026-02-20 23:31:30'),
	(4, 2, 3, '2026-02-20 23:31:30'),
	(5, 3, 4, '2026-02-20 23:31:30'),
	(6, 3, 6, '2026-02-20 23:31:30'),
	(7, 7, 7, '2026-02-20 23:31:30'),
	(8, 7, 8, '2026-02-20 23:31:30');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
