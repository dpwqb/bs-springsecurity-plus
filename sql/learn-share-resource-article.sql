-- =====================================================
-- 学享汇资源共享平台 - 数据库初始化脚本
-- 包含：资源模块（6张表）+ 文章模块（4张表）+ AI模块（1张表）
-- =====================================================

-- =====================================================
-- 第一部分：资源模块表（6张表）
-- =====================================================

-- 表1: 资源分类表 (resource_category)
DROP TABLE IF EXISTS `resource_category`;
CREATE TABLE `resource_category` (
  `category_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `parent_id` INT(32) DEFAULT 0 COMMENT '父分类ID，0表示顶级分类',
  `category_name` VARCHAR(100) NOT NULL COMMENT '分类名称',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '分类描述',
  `icon` VARCHAR(100) DEFAULT NULL COMMENT '分类图标',
  `sort_order` INT(5) DEFAULT 0 COMMENT '排序序号',
  `status` TINYINT(1) DEFAULT 1 COMMENT '状态：1启用 0禁用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`category_id`),
  INDEX `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资源分类表';

-- 初始化分类数据
INSERT INTO `resource_category` VALUES
(1, 0, '计算机基础', '计算机基础知识', 'layui-icon layui-icon-component', 1, 1, NOW(), NOW()),
(2, 0, '编程语言', '各类编程语言资料', 'layui-icon layui-icon-code', 2, 1, NOW(), NOW()),
(3, 0, '框架技术', '主流开发框架', 'layui-icon layui-icon-template', 3, 1, NOW(), NOW()),
(4, 0, '数据库', '数据库相关资料', 'layui-icon layui-icon-table', 4, 1, NOW(), NOW()),
(5, 0, '人工智能', 'AI、机器学习等', 'layui-icon layui-icon-engine', 5, 1, NOW(), NOW()),
(6, 2, 'Java', 'Java编程语言', NULL, 1, 1, NOW(), NOW()),
(7, 2, 'Python', 'Python编程语言', NULL, 2, 1, NOW(), NOW()),
(8, 2, 'JavaScript', 'JavaScript前端', NULL, 3, 1, NOW(), NOW()),
(9, 3, 'Spring', 'Spring全家桶', NULL, 1, 1, NOW(), NOW()),
(10, 3, 'Vue', 'Vue前端框架', NULL, 2, 1, NOW(), NOW());

-- 表2: 资源标签表 (resource_tag)
DROP TABLE IF EXISTS `resource_tag`;
CREATE TABLE `resource_tag` (
  `tag_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `tag_name` VARCHAR(50) NOT NULL COMMENT '标签名称',
  `use_count` INT(10) DEFAULT 0 COMMENT '使用次数',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `uk_tag_name` (`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资源标签表';

-- 初始化标签数据
INSERT INTO `resource_tag` VALUES
(1, 'SpringBoot', 0, NOW()),
(2, '毕业设计', 0, NOW()),
(3, '教程', 0, NOW()),
(4, '面试', 0, NOW()),
(5, '实战项目', 0, NOW()),
(6, '源码', 0, NOW()),
(7, '课件', 0, NOW());

-- 表3: 资源主表 (resource_info) - 核心表
DROP TABLE IF EXISTS `resource_info`;
CREATE TABLE `resource_info` (
  `resource_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT '资源ID',
  `title` VARCHAR(200) NOT NULL COMMENT '资源标题',
  `description` TEXT COMMENT '资源描述',
  `category_id` INT(32) NOT NULL COMMENT '所属分类ID',
  `file_name` VARCHAR(255) NOT NULL COMMENT '文件原始名称',
  `file_path` VARCHAR(500) NOT NULL COMMENT '文件存储路径',
  `file_size` BIGINT(20) DEFAULT 0 COMMENT '文件大小（字节）',
  `file_type` VARCHAR(20) NOT NULL COMMENT '文件类型：pdf/doc/docx/ppt/pptx/txt',
  `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图片路径',

  -- 统计信息
  `view_count` INT(10) DEFAULT 0 COMMENT '浏览次数',
  `download_count` INT(10) DEFAULT 0 COMMENT '下载次数',
  `collect_count` INT(10) DEFAULT 0 COMMENT '收藏次数',

  -- 用户信息
  `uploader_id` INT(32) NOT NULL COMMENT '上传者用户ID',
  `uploader_name` VARCHAR(100) DEFAULT NULL COMMENT '上传者姓名（冗余）',

  -- 状态（无需审核，直接发布）
  `status` TINYINT(1) DEFAULT 1 COMMENT '状态：1已发布 0已下架',

  -- 时间字段
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  PRIMARY KEY (`resource_id`),
  INDEX `idx_category` (`category_id`),
  INDEX `idx_uploader` (`uploader_id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_create_time` (`create_time`),
  FULLTEXT KEY `ft_title_desc` (`title`, `description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资源信息表';

-- 表4: 资源标签关联表 (resource_tag_relation)
DROP TABLE IF EXISTS `resource_tag_relation`;
CREATE TABLE `resource_tag_relation` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `resource_id` INT(32) NOT NULL COMMENT '资源ID',
  `tag_id` INT(32) NOT NULL COMMENT '标签ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resource_tag` (`resource_id`, `tag_id`),
  INDEX `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资源标签关联表';

-- 表5: 下载记录表 (download_record)
DROP TABLE IF EXISTS `download_record`;
CREATE TABLE `download_record` (
  `record_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `resource_id` INT(32) NOT NULL COMMENT '资源ID',
  `user_id` INT(32) NOT NULL COMMENT '下载用户ID',
  `user_name` VARCHAR(100) DEFAULT NULL COMMENT '用户姓名（冗余）',
  `resource_title` VARCHAR(200) DEFAULT NULL COMMENT '资源标题（冗余）',
  `download_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '下载时间',
  `ip_address` VARCHAR(50) DEFAULT NULL COMMENT '下载IP',
  PRIMARY KEY (`record_id`),
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='下载记录表';

-- 表6: 收藏记录表 (favorite_record)
DROP TABLE IF EXISTS `favorite_record`;
CREATE TABLE `favorite_record` (
  `favorite_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` INT(32) NOT NULL COMMENT '用户ID',
  `resource_id` INT(32) NOT NULL COMMENT '资源ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `uk_user_resource` (`user_id`, `resource_id`),
  INDEX `idx_resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏记录表';

-- =====================================================
-- 第二部分：文章模块表（4张表）
-- =====================================================

-- 表7: 文章分类表 (article_category)
DROP TABLE IF EXISTS `article_category`;
CREATE TABLE `article_category` (
  `category_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `parent_id` INT(32) DEFAULT 0 COMMENT '父分类ID，0表示顶级分类',
  `category_name` VARCHAR(100) NOT NULL COMMENT '分类名称',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '分类描述',
  `icon` VARCHAR(100) DEFAULT NULL COMMENT '分类图标',
  `sort_order` INT(5) DEFAULT 0 COMMENT '排序序号',
  `status` TINYINT(1) DEFAULT 1 COMMENT '状态：1启用 0禁用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`category_id`),
  INDEX `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章分类表';

-- 初始化文章分类数据
INSERT INTO `article_category` VALUES
(1, 0, '技术教程', '技术教程类文章', 'layui-icon layui-icon-template', 1, 1, NOW(), NOW()),
(2, 0, '学习笔记', '学习心得和笔记', 'layui-icon layui-icon-note', 2, 1, NOW(), NOW()),
(3, 0, '问题解决', '问题排查和解决方案', 'layui-icon layui-icon-ok-circle', 3, 1, NOW(), NOW()),
(4, 0, '项目实战', '项目实战经验分享', 'layui-icon layui-icon-engine', 4, 1, NOW(), NOW()),
(5, 0, '职业发展', '职业规划和经验', 'layui-icon layui-icon-user', 5, 1, NOW(), NOW()),
(6, 1, 'Java教程', 'Java相关教程', NULL, 1, 1, NOW(), NOW()),
(7, 1, 'Python教程', 'Python相关教程', NULL, 2, 1, NOW(), NOW()),
(8, 1, '前端教程', '前端开发教程', NULL, 3, 1, NOW(), NOW()),
(9, 1, '数据库教程', '数据库相关教程', NULL, 4, 1, NOW(), NOW()),
(10, 3, 'Bug解决', 'Bug排查和解决', NULL, 1, 1, NOW(), NOW());

-- 表8: 文章主表 (my_article) - 核心表
DROP TABLE IF EXISTS `my_article`;
CREATE TABLE `my_article` (
  `article_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `title` VARCHAR(200) NOT NULL COMMENT '文章标题',
  `content` MEDIUMTEXT NOT NULL COMMENT '文章内容（富文本HTML）',
  `summary` VARCHAR(500) DEFAULT NULL COMMENT '文章摘要',
  `category_id` INT(32) DEFAULT NULL COMMENT '文章分类ID',

  -- 封面图片
  `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图片路径',

  -- 统计信息
  `view_count` INT(10) DEFAULT 0 COMMENT '浏览次数',
  `like_count` INT(10) DEFAULT 0 COMMENT '点赞次数',
  `collect_count` INT(10) DEFAULT 0 COMMENT '收藏次数',
  `comment_count` INT(10) DEFAULT 0 COMMENT '评论次数',

  -- 作者信息
  `author_id` INT(32) NOT NULL COMMENT '作者用户ID',
  `author_name` VARCHAR(100) DEFAULT NULL COMMENT '作者姓名（冗余）',

  -- 关联资源（可选）
  `related_resource_id` INT(32) DEFAULT NULL COMMENT '关联的资源ID',
  `related_resource_title` VARCHAR(200) DEFAULT NULL COMMENT '关联资源标题（冗余）',

  -- 状态和属性
  `status` TINYINT(1) DEFAULT 0 COMMENT '状态：0草稿 1已发布 2已下架',
  `is_top` TINYINT(1) DEFAULT 0 COMMENT '是否置顶：0否 1是',
  `is_recommend` TINYINT(1) DEFAULT 0 COMMENT '是否推荐：0否 1是',
  `is_original` TINYINT(1) DEFAULT 1 COMMENT '是否原创：0转载 1原创',

  -- 时间字段
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `publish_time` DATETIME DEFAULT NULL COMMENT '发布时间',

  PRIMARY KEY (`article_id`),
  INDEX `idx_category` (`category_id`),
  INDEX `idx_author` (`author_id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_create_time` (`create_time`),
  INDEX `idx_is_top` (`is_top`),
  INDEX `idx_is_recommend` (`is_recommend`),
  INDEX `idx_related_resource` (`related_resource_id`),
  FULLTEXT KEY `ft_title_summary` (`title`, `summary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章主表';

-- 表9: 文章标签关联表 (article_tag_relation)
DROP TABLE IF EXISTS `article_tag_relation`;
CREATE TABLE `article_tag_relation` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `article_id` INT(32) NOT NULL COMMENT '文章ID',
  `tag_id` INT(32) NOT NULL COMMENT '标签ID（复用resource_tag表）',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_article_tag` (`article_id`, `tag_id`),
  INDEX `idx_tag_id` (`tag_id`),
  INDEX `idx_article_id` (`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章标签关联表';

-- 表10: 文章浏览记录表 (article_view_record)
DROP TABLE IF EXISTS `article_view_record`;
CREATE TABLE `article_view_record` (
  `record_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `article_id` INT(32) NOT NULL COMMENT '文章ID',
  `user_id` INT(32) DEFAULT NULL COMMENT '浏览用户ID（NULL表示游客）',
  `user_name` VARCHAR(100) DEFAULT NULL COMMENT '用户姓名（冗余）',
  `article_title` VARCHAR(200) DEFAULT NULL COMMENT '文章标题（冗余）',
  `view_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '浏览时间',
  `ip_address` VARCHAR(50) DEFAULT NULL COMMENT '浏览IP',
  `duration` INT(10) DEFAULT NULL COMMENT '阅读时长（秒）',
  PRIMARY KEY (`record_id`),
  INDEX `idx_article_id` (`article_id`),
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_view_time` (`view_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章浏览记录表';

-- =====================================================
-- 第三部分：AI模块表（1张表）
-- =====================================================

-- 表11: AI对话记录表 (ai_chat_history) - 创新功能
DROP TABLE IF EXISTS `ai_chat_history`;
CREATE TABLE `ai_chat_history` (
  `chat_id` INT(32) NOT NULL AUTO_INCREMENT COMMENT '对话ID',
  `user_id` INT(32) NOT NULL COMMENT '用户ID',
  `session_id` VARCHAR(100) NOT NULL COMMENT '会话ID（UUID）',
  `question_text` TEXT NOT NULL COMMENT '用户选中的问题文本',
  `question_context` TEXT DEFAULT NULL COMMENT '问题上下文（网页内容片段）',
  `answer_text` TEXT NOT NULL COMMENT 'AI回答内容',
  `model_name` VARCHAR(50) DEFAULT 'gpt-3.5-turbo' COMMENT '使用的模型',
  `tokens_used` INT(10) DEFAULT 0 COMMENT '消耗的token数',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '对话时间',
  PRIMARY KEY (`chat_id`),
  INDEX `idx_user_session` (`user_id`, `session_id`),
  INDEX `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI对话记录表';

-- =====================================================
-- 可选：扩展用户表（如果需要）
-- =====================================================

-- 扩展用户表，添加资源相关统计
-- ALTER TABLE `my_user`
-- ADD COLUMN `upload_count` INT(10) DEFAULT 0 COMMENT '上传资源数',
-- ADD COLUMN `download_count` INT(10) DEFAULT 0 COMMENT '下载资源数';

-- =====================================================
-- 数据库表创建完成
-- =====================================================
