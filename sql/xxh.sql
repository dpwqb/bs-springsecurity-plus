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
  `model_name` varchar(50) DEFAULT 'Unknown' COMMENT '使用的模型',
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

-- 导出  表 xue-xiang-hui.article 结构
CREATE TABLE IF NOT EXISTS `article` (
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

-- 正在导出表  xue-xiang-hui.article 的数据：~3 rows (大约)
INSERT INTO `article` (`article_id`, `title`, `content`, `summary`, `category_id`, `cover_image`, `view_count`, `like_count`, `author_id`, `author_name`, `status`, `create_time`, `update_time`, `publish_time`) VALUES
	(1, '第一篇文章的标题', '第一篇文章的内容', '本项目的开发设计方案', 2, NULL, 39, 22, 1, '管理员', 1, '2026-02-15 17:20:59', '2026-02-20 23:57:16', NULL),
	(7, '测试文章发布', '<h1><u><em><strong>这里是文章的正文</strong></em></u></h1>', '用于测试文章封面及文章标签', 1, NULL, 12, 0, 1, '管理员', 1, '2026-02-19 13:37:30', '2026-02-21 21:20:53', NULL),
	(8, '测试文章发布', '<h1>测试封面测试封面测试封面测试封面测试封面！</h1>', '用于测试文章封面及文章标签', 1, '/uploads/article/2026/02/18dd948b88d1427da69833c0655bfb98.jpg', 66, 1, 1, '管理员', 1, '2026-02-19 17:33:16', '2026-02-21 22:18:07', '2026-02-19 23:49:05'),
	(11, '回归测试', '<h1>回归测试回归测试回归测试回归测试</h1><p><br></p><ul><li>回归测试回归测试</li><li>回归测试回归测试</li><li>回归测试回归测试</li><li>回归测试回归测试</li></ul>', '测试文章创建', 10, '/uploads/article/2026/02/62ea577a18db49dbbbf521b456eea07c.jpg', 1, 0, 1, '管理员', 1, '2026-02-21 22:57:57', '2026-02-21 22:57:58', NULL);

-- 导出  表 xue-xiang-hui.dept 结构
CREATE TABLE IF NOT EXISTS `dept` (
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

-- 正在导出表  xue-xiang-hui.dept 的数据：~7 rows (大约)
INSERT INTO `dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `sort`, `status`, `create_time`, `update_time`) VALUES
	(1, 0, '0', '公司内部人员', 1, b'1', '2025-08-19 11:01:09', '2025-09-08 18:21:26'),
	(2, 1, '0,1', 'IT支持', 1, b'1', '2025-08-19 11:01:28', '2025-08-19 11:01:30'),
	(3, 1, '0,1', '审核人员', 2, b'1', '2025-08-19 11:01:47', '2025-08-19 11:01:48'),
	(4, 1, '0,1', '运维人员', 3, b'1', '2025-08-19 11:02:01', '2025-08-19 11:02:04'),
	(5, 0, '0', '受众用户', 2, b'1', '2025-08-19 11:07:36', '2025-08-27 14:18:48'),
	(6, 5, '0,5', 'VIP用户', 1, b'1', '2025-08-19 11:08:40', '2025-08-21 20:32:40'),
	(7, 5, '0,5', '测试人员', 2, b'1', '2025-08-19 11:08:56', '2025-09-08 18:03:56');

-- 导出  表 xue-xiang-hui.dict 结构
CREATE TABLE IF NOT EXISTS `dict` (
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

-- 正在导出表  xue-xiang-hui.dict 的数据：~0 rows (大约)
INSERT INTO `dict` (`dict_id`, `dict_name`, `description`, `sort`, `create_by`, `update_by`, `create_time`, `update_time`) VALUES
	(1, '性别', '性别字典', 1, 'admin', 'admin', '2025-11-07 15:06:18', '2025-11-07 15:06:20');

-- 导出  表 xue-xiang-hui.dict_detail 结构
CREATE TABLE IF NOT EXISTS `dict_detail` (
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

-- 正在导出表  xue-xiang-hui.dict_detail 的数据：~2 rows (大约)
INSERT INTO `dict_detail` (`id`, `dict_id`, `label`, `value`, `sort`, `create_by`, `update_by`, `create_time`, `update_time`) VALUES
	(1, 1, '男', '1', 1, NULL, NULL, NULL, NULL),
	(2, 1, '女', '2', 2, NULL, NULL, NULL, NULL);

-- 导出  表 xue-xiang-hui.job 结构
CREATE TABLE IF NOT EXISTS `job` (
  `job_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `job_name` varchar(255) NOT NULL COMMENT '岗位名称',
  `status` tinyint(1) DEFAULT NULL COMMENT '岗位状态',
  `sort` int(5) DEFAULT NULL COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.job 的数据：~3 rows (大约)
INSERT INTO `job` (`job_id`, `job_name`, `status`, `sort`, `create_time`, `update_time`) VALUES
	(1, '部门经理', 1, 1, '2025-08-19 11:14:55', '2025-08-19 11:14:57'),
	(2, '人事专员', 1, 2, '2025-08-19 11:15:30', '2025-08-19 11:15:33'),
	(3, '普通员工', 1, 3, '2025-08-19 11:16:19', '2025-09-02 10:48:34');

-- 导出  表 xue-xiang-hui.log 结构
CREATE TABLE IF NOT EXISTS `log` (
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

-- 导出  表 xue-xiang-hui.menu 结构
CREATE TABLE IF NOT EXISTS `menu` (
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

-- 正在导出表  xue-xiang-hui.menu 的数据：~41 rows (大约)
INSERT INTO `menu` (`menu_id`, `parent_id`, `menu_name`, `icon`, `url`, `permission`, `sort`, `type`, `create_time`, `update_time`) VALUES
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

-- 导出  表 xue-xiang-hui.role 结构
CREATE TABLE IF NOT EXISTS `role` (
  `role_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `role_name` varchar(255) NOT NULL COMMENT '名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `data_scope` char(1) DEFAULT NULL COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.role 的数据：~2 rows (大约)
INSERT INTO `role` (`role_id`, `role_name`, `description`, `create_time`, `update_time`, `data_scope`) VALUES
	(1, 'ADMIN', '超级管理员，拥有所有权限', '2025-07-10 09:40:35', '2025-11-07 14:47:39', '1'),
	(2, 'USER', '普通用户', '2025-07-10 09:40:56', '2025-11-07 14:47:52', '2');

-- 导出  表 xue-xiang-hui.role_dept 结构
CREATE TABLE IF NOT EXISTS `role_dept` (
  `role_id` int(32) NOT NULL COMMENT '角色id',
  `dept_id` int(32) NOT NULL COMMENT '部门id',
  PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.role_dept 的数据：~3 rows (大约)
INSERT INTO `role_dept` (`role_id`, `dept_id`) VALUES
	(2, 5),
	(2, 6),
	(2, 7);

-- 导出  表 xue-xiang-hui.role_menu 结构
CREATE TABLE IF NOT EXISTS `role_menu` (
  `role_id` int(32) NOT NULL COMMENT '角色id',
  `menu_id` int(32) NOT NULL COMMENT '菜单id',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.role_menu 的数据：~55 rows (大约)
INSERT INTO `role_menu` (`role_id`, `menu_id`) VALUES
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

-- 导出  表 xue-xiang-hui.role_user 结构
CREATE TABLE IF NOT EXISTS `role_user` (
  `user_id` int(32) NOT NULL COMMENT '用户id',
  `role_id` int(32) NOT NULL COMMENT '角色id',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.role_user 的数据：~8 rows (大约)
INSERT INTO `role_user` (`user_id`, `role_id`) VALUES
	(1, 1),
	(2, 2),
	(3, 2),
	(4, 2),
	(5, 2),
	(6, 2),
	(7, 2),
	(8, 2);

-- 导出  表 xue-xiang-hui.user 结构
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `dept_id` int(32) DEFAULT NULL COMMENT '部门id',
  `user_name` varchar(255) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `nick_name` varchar(255) NOT NULL COMMENT '用户昵称',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机号',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` tinyint(1) NOT NULL COMMENT '状态',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.user 的数据：~8 rows (大约)
INSERT INTO `user` (`user_id`, `dept_id`, `user_name`, `password`, `nick_name`, `phone`, `email`, `status`, `create_time`, `update_time`) VALUES
	(1, 1, 'admin', '$2a$10$pAuzCLIe6Sl7kXfX6FEQ1uzM79V2njg.KtL9qawg9JkW7e1f417k2', '管理员', '13556336255', '1454564646@qq.com', 1, '2025-07-10 09:42:03', '2025-08-23 16:24:34'),
	(2, 2, 'test', '$2a$10$pAuzCLIe6Sl7kXfX6FEQ1uzM79V2njg.KtL9qawg9JkW7e1f417k2', '测试用户', '13556336256', '1454564646@163.com', 1, '2025-07-10 09:42:09', '2025-07-13 17:49:49'),
	(3, 2, 'test1', '$2a$10$exOfpFK2TNHnAdG/aaVTFeCDLihkg8JfD1qGWKjCOBdicxcQJax5W', '普通用户2', '13556336257', '1454564646@qq.com', 1, '2025-07-10 09:42:14', '2025-07-10 09:42:16'),
	(4, 2, 'test2', '$2a$10$RR665iMnfCuYGY0Af344U.Fy3XmGcgjkURENW/Zea/oAEhuiLyjO.', '普通用户3', '13556336258', '1454564646@qq.com', 1, '2025-07-10 09:42:19', '2025-07-10 09:42:21'),
	(5, 3, 'test3', '$2a$10$o0lZgmzReca24TP5viy/nOrPQty4jga1W.BG5SvgdeK9eprm.NoMa', '普通用户4', '13556336259', '1454564646@qq.com', 1, '2025-07-10 09:42:23', '2025-07-10 09:42:25'),
	(6, 3, 'test4', '$2a$10$jNU1gXN.wAPhq5vUmLrCoeyDJbF3ReSnYQ2IulJA99drcMs1w1Som', '封禁用户', '13556336250', '1454564646@qq.com', 0, '2025-07-10 09:42:27', '2025-07-13 17:54:11'),
	(7, 3, 'test5', '$2a$10$ADEBRX13Z9vvNxzdu/HiROaB1F7rYd5DHpE9UWeXtNOSbeB1tcWie', '封禁用户2', '13556336211', '1454564646@qq.com', 0, '2025-07-10 09:42:32', '2025-07-10 09:42:34'),
	(8, 6, 'test6', '$2a$10$2aLbMBdNottSq13J.tfIF.5IFgTcDlWwOQI7btckzsq3vl2KtWOV6', '测试修改', '13556336253', '1454564646@qq.com', 1, '2025-07-10 09:42:36', '2025-10-01 14:24:19');

-- 导出  表 xue-xiang-hui.user_job 结构
CREATE TABLE IF NOT EXISTS `user_job` (
  `user_id` int(32) NOT NULL COMMENT '岗位id',
  `job_id` int(32) NOT NULL COMMENT '工作id',
  PRIMARY KEY (`user_id`,`job_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.user_job 的数据：~9 rows (大约)
INSERT INTO `user_job` (`user_id`, `job_id`) VALUES
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
