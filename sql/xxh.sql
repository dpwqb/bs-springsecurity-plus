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
	(1, '开学第一课', '<h1 style="text-align: center;">开学第一课</h1><p style="text-indent: 2em;">初秋的晨光透过教室的玻璃窗，落在崭新的课桌上。当上课铃清脆地响起，黑板上被粉笔郑重写下五个字：“开学第一课”。没有公式，没有课文，只有老师温和而坚定的目光。那一刻我忽然明白，这并非某门学科的起点，而是一场成长的序章。</p><p style="text-indent: 2em;">开学第一课，从不急于翻开教材。它更像一面镜子，照见我们过去一年的跋涉，也映出未来的轮廓。老师问：“你们为什么而学？”有人答为梦想，有人答为前程，也有人低头沉默。其实，答案不必急于给出。真正的学习，始于对世界的好奇，成于面对挫折的韧性。那些解不出的难题、背不完的篇章、考砸后的叹息，都是课堂之外的必修课。这堂课提醒我们：分数不是终点，而是丈量脚步的刻度；失败不是句号，而是重新出发的逗号。</p><p style="text-indent: 2em;">这堂课，也把目光从书桌引向更广阔的天地。窗外的梧桐正抽出新芽，而世界的变化从未停歇。人工智能正重塑知识的获取方式，全球性议题呼唤青年的理性与担当，多元文化要求我们以开放之心倾听异见。开学第一课告诉我们：读书，不只是为了走出舒适区，更是为了理解他者；求知，不只为独善其身，更要兼济天下。当我们在实验室里严谨记录，在志愿服务中递出援手，在公共讨论中坚守底线，知识才真正有了温度与重量。</p><p style="text-indent: 2em;">黑板上的粉笔字渐渐干涸，但心中的种子已悄然生根。开学第一课的魔力，不在于它传授了多少新知，而在于它唤醒了多少沉睡的可能。新学期不必豪言壮语，只需每天早到十分钟预习，遇到瓶颈时多问一句“为什么”，在他人需要时伸出一只手。把宏大愿景拆解为微小坚持，把这堂课的精神写进每一页笔记、每一次晨读、每一场考试。</p><p style="text-indent: 2em;">铃声再次响起，合上笔记本，走出教室。阳光正好，微风不燥。开学第一课早已结束，但它的影响才刚刚开始。人生没有真正的“最后一课”，却永远需要“第一课”的清醒与热望。愿我们带着这堂课的馈赠，在岁月的长卷上，写下不负时代、不负自己的答案。</p>', '本项目的开发设计方案', 2, NULL, 39, 22, 1, '管理员', 1, '2026-02-15 17:20:59', '2026-02-20 23:57:16', NULL),
	(7, '在喧嚣中保持清醒', '<h1 style="text-align: center;">在喧嚣中保持清醒</h1><h1 style="text-align: right;">——给思想装上“过滤网”</h1><p style="text-indent: 2em;">算法编织的信息茧房、短视频里转瞬即逝的“健康秘方”、热搜榜单上非黑即白的立场对立……我们正身处一个前所未有的信息丰饶时代，却也前所未有地面临“认知过载”的困境。当碎片化观点如潮水般涌来，当情绪极易替代理性发声，我们比任何时候都更需要一种内在的定力——批判性思维。它并非一把用来挑刺的匕首，而是一张细密的过滤网，帮我们在喧嚣中打捞真知，在盲从前保持清醒。</p><p style="text-indent: 2em;">长久以来，批判性思维常被误读为“抬杠”或“全盘否定”。实则不然。真正的批判性思维，是对信息、观点与证据进行主动、理性、系统评估的认知过程。它不教人“该想什么”，而是教人“怎么想”。正如教育学者理查德·保罗所言，它是一种心智的纪律：敢于质疑隐含的前提，谨慎区分事实与观点，乐于在多元视角中校准自己的坐标。怀疑的终点从来不是虚无，而是构建更坚实的证据链。当我们学会在“专家说”“千万人转发”面前停顿三秒，追问一句“证据何在？样本几何？利益相关方是谁？”时，思维的锚点便已悄然落下。</p><p style="text-indent: 2em;">这种思维的价值，在现实场景中尤为锋利。面对“每天喝柠檬水可逆转糖尿病”的爆款视频，批判性思维会引导我们穿透情绪化标题，追溯原始文献、审视临床指南与个体差异；面对“哥伦布发现新大陆”的单一叙事，它会提醒我们拆解话语背后的立场，引入原住民史料，将“发现”还原为复杂的“接触与碰撞”；面对算法不断投喂的“同类信息”，它会主动打破信息茧房，强制订阅对立观点，用交叉验证抵御确认偏误。我们常无意识掉入逻辑的陷阱：用“诉诸权威”代替独立判断，用“滑坡谬误”制造无端恐慌，用“虚假两难”封堵讨论空间。而批判性思维，正是照见这些认知暗区的探照灯。</p><p style="text-indent: 2em;">然而，批判性思维并非天赋，而是一项可训练、可迭代的技艺。它始于觉察——记录那些让我们瞬间狂热或反感的观点，辨认情绪背后的触发词；成于工具——用逻辑图拆解论证链条，用证据矩阵权衡信息权重，在自我坚信的领域里主动寻找“反证”；终于输出——在公共讨论中坚守理性底线，在学术阅读中敢于提出异见，将宏大叙事拆解为具体追问。真正的思想开放，是允许自己的观点被更好的论证推翻。把每一次信息消费转化为一次微型思维实验，批判性思维便从书本概念，内化为呼吸般的认知习惯。</p><p style="text-indent: 2em;">信息洪流奔涌向前，技术迭代日新月异，但人类认知的底层逻辑从未改变：知识可以速成，判断力却需慢养。在教我们如何汲取的今天，更需教我们如何筛选。愿我们都能为思想装上这张名为“批判”的过滤网，不盲从、不轻信、不愤世，在纷繁世界中守住理性的微光。当喧嚣退去，留下的不是算法的回声，而是经过时间、逻辑与证据共同淬炼的真知。</p>', '给思想装上“过滤网”', 1, NULL, 12, 0, 1, '管理员', 1, '2026-02-19 13:37:30', '2026-02-21 21:20:53', NULL),
	(8, '“过滤网”的缝隙', '<h1 style="text-align: center;">“过滤网”的缝隙</h1><h1 style="text-align: right;">——当批判性思维遭遇现实重力</h1><p style="text-indent: 2em;">前文《在喧嚣中保持清醒》以“过滤网”为喻，呼吁在信息洪流中植入批判性思维，立意清晰，逻辑自洽。然而，若以批判性思维的反身性（reflexivity）审视该文本身，便会发现其精妙的修辞背后，隐藏着一组值得警惕的预设：将认知困境简化为个体心智的“技术升级”，将理性与情绪对立，将“证据”与“逻辑”视为天然中立的尺度。当批判性思维被包装成一套可个人化下载的“认知插件”时，我们是否忽略了思想在现实重力场中的摩擦与损耗？</p><p style="text-indent: 2em;">文章的核心隐喻是“给思想装上过滤网”，这暗示信息是被动产出的“原材料”，而个体只需提升“筛分精度”即可。但这一模型忽略了当代信息生态的结构性权力。算法并非中立管道，而是以“注意力变现”为目标的商业引擎；平台经济通过即时反馈回路，系统性削弱用户的长程专注力。要求普通人在通勤间隙、工作疲惫之余，持续执行“查证文献-审视样本-交叉验证”的认知操作，无异于要求行人在暴雨中自备抽水泵。批判性思维若脱离对信息生产机制、教育公平性与认知资源分配的审视，便会滑向一种隐性的“认知精英主义”——它默认了人人皆有闲暇、训练与心智带宽去“保持清醒”，却遮蔽了结构性不平等对思考能力的无形剥夺。</p><p style="text-indent: 2em;">文中将“情绪化反应”“非黑即白”与“理性”“证据链”置于对立两端，隐含了“情感是理性的干扰项”这一传统启蒙假设。然而，认知科学与道德心理学早已指出：情感并非理性的敌人，而是价值判断的底层操作系统。没有共情与道德直觉，纯粹的逻辑推演可能滑向冷漠的功利计算；没有对“他者处境”的情感共鸣，批判性思维极易异化为“智力优越感”的展演。当我们在公共讨论中仅以“证据不足”“逻辑谬误”否定他人时，若缺失了倾听的意愿与对话的善意，批判便不再是通向真理的桥梁，而成了话语权的壁垒。真正的思想清醒，不是剔除情绪，而是学会与情绪共处，让理性为其导航，而非将其放逐。</p><p style="text-indent: 2em;">文章列举的“验证路径”与“逻辑谬误”清单，呈现了一种高度理想化的知识图景：只要方法正确，真相即可显现。但“证据”从来不是真空中的客观物，而是被权力、文化与历史所塑造的产物。谁有资格定义“可靠信源”？哪些群体的经验被排除在“同行评议”之外？当批判性思维过度依赖形式逻辑与技术理性时，可能无意中边缘化了情境性智慧、整体性思维与地方性知识。更需警惕的是，批判性思维若缺乏伦理锚点，极易蜕变为“为怀疑而怀疑”的虚无主义，或被用作解构一切共识的武器。在真相碎片化、共识脆弱的语境下，比“如何证伪”更紧迫的命题或许是：“我们为何而信？”以及“批判之后，如何重建？”</p><p style="text-indent: 2em;">因此，批判性思维不应止步于个人心智的“防身术”，而需升维为一场集体性的“认知生态治理”。它要求我们：在个体层面，接纳认知的有限性，将“我不知道”视为思考的起点而非缺陷；在制度层面，推动算法透明、媒体问责与公共教育中的思维训练普惠化；在文化层面，将批判与共情、怀疑与建设、逻辑与伦理编织为一张更具韧性的意义之网。思想从来不是在真空中过滤杂质，而是在泥泞中跋涉前行。当我们不再幻想一张完美无缺的“过滤网”，而是学会在重力中调整姿态、在缝隙中辨认微光时，批判性思维才真正完成了从“技术”到“智慧”的跃迁。清醒，不是隔绝喧嚣，而是带着对复杂性的敬畏，依然选择理性地站立。</p>', '当批判性思维遭遇现实重力', 1, '/uploads/article/2026/02/18dd948b88d1427da69833c0655bfb98.jpg', 66, 1, 1, '管理员', 1, '2026-02-19 17:33:16', '2026-02-21 22:18:07', '2026-02-19 23:49:05'),
	(11, '批判的自反性陷阱', '<h1 style="text-align: center;">批判的自反性陷阱</h1><h1 style="text-align: right;">——当“清醒”成为另一种盲视</h1><p style="text-indent: 2em;">前文《“过滤网”的缝隙》以结构视角拆解了批判性思维的个体化迷思，指出其背后隐藏的认知精英主义、情感/理性二元对立以及证据的中立性幻觉，并呼吁将批判升维至“认知生态治理”与“伦理锚点”。这一反思已触及问题的肌理，但若以批判性思维的反身性（reflexivity）继续向下挖掘，便会发现：任何试图“修补”或“升维”批判的框架，本身仍在重复它所要警惕的逻辑。当我们用批判去批判批判时，极易滑入一场没有出口的认知套娃；而追求“更深刻的清醒”，反而可能成为遮蔽行动与责任的新型盲视。</p><p style="text-indent: 2em;">首先，元批判的无限倒退消解了思想落地的可能。前文指出“过滤网”隐喻忽略了结构性不平等，主张以制度透明与教育普惠替代个体心智训练。这一诊断固然准确，却默认了“只要我们看清结构，就能设计更公平的认知生态”。然而，结构本身并非静止的客体，而是由无数话语、实践与利益博弈动态编织的网络。要求算法透明、推动媒体问责、重塑教育范式，这些诉求本身就需要权力让渡与资源重组，而权力从来不会因“逻辑更严密”或“道德更自洽”就自动退场。将批判的终点指向“治理”与“重建”，无形中预设了一个能够超然于结构之外的“设计者视角”。可批判性思维若真要贯彻到底，就必须承认：我们皆是结构的产物，亦是结构的共谋；任何试图从外部“校准”系统的方案，都难免携带其自身的盲区与特权。</p><p style="text-indent: 2em;">其次，批判正日益沦为一种文化资本与话语表演。在学术圈、公共讨论乃至自媒体语境中，“指出逻辑谬误”“揭示权力叙事”“强调情境知识”已成为一套娴熟的修辞操演。前文对“认知精英主义”的警惕极为必要，却未充分意识到：当“批判”本身被制度化、术语化、圈子化时，它便从一种开放的思维方式，退化为划定边界的身份标识。谁能熟练调用“确认偏误”“信息茧房”“地方性知识”等概念，谁便掌握了话语的高地；而真正身处信息贫困、教育边缘或生存重压中的人群，往往连参与这场“清醒游戏”的入场券都未曾获得。批判若脱离对物质条件、时间分配与生存焦虑的体察，便极易沦为智力阶层的自我加冕。解构一切之后，留下的不是平等的对话空间，而是新的知识等级。</p><p style="text-indent: 2em;">更深层的困境在于：过度自反的批判，正在制造认知的瘫痪。前文呼吁接纳“我不知道”作为思考起点，警惕形式逻辑对多元智慧的边缘化，这本是极具洞见的认知谦逊。但当“所有证据皆被权力塑造”“所有逻辑皆含文化预设”“所有批判皆具自我指涉性”成为不容置疑的前提时，思想便容易陷入“知得越多，越不敢断言”的僵局。现实世界从不等待我们完成完美的认知校准：气候危机需要减排决策，公共政策需要资源分配，个体生命需要价值取舍。当批判性思维蜕变为“永远准备批判，却从不准备承诺”的悬置状态，它便从抵御盲从的盾牌，异化为逃避责任的避风港。没有临时性立场的批判，如同没有船锚的罗盘；它指向所有方向，却抵达不了任何地方。</p><p style="text-indent: 2em;">因此，批判性思维的出路，或许不在于寻找“更深刻”的框架，而在于接受其固有的不完整性，并将思想重新锚定于具身实践与风险承担。我们无需幻想一张无瑕的过滤网，也不必奢求一套能容纳所有视角的元理论；我们只需要在具体情境中做出“有风险的承诺”：承认自己的立场必带偏见，但仍选择为某一价值辩护；知道自己的证据必有限度，但仍愿意为其后果负责；理解他人的逻辑必有盲区，但仍尝试在差异中寻找可协作的底线。批判不是用来证明“我比你清醒”的武器，而是用来检验“我是否仍愿与世界发生真实关联”的试金石。</p><p style="text-indent: 2em;">思想的深度，从不体现在它能拆解多少幻觉，而在于它能否在拆解之后，依然敢于相信、敢于行动、敢于犯错。当批判性思维走出自反的镜像迷宫，放下对“绝对清醒”的执念，它才真正从一种认知技艺，回归为一种生命姿态：在不完美中前行，在不确定中抉择，在明知可能偏航时，依然保持对真相的敬畏与对同类的共情。清醒的终极形态，或许不是看透一切，而是带着已知的盲视，依然选择向前走去。</p>', '当“清醒”成为另一种盲视', 10, '/uploads/article/2026/02/62ea577a18db49dbbbf521b456eea07c.jpg', 1, 0, 1, '管理员', 1, '2026-02-21 22:57:57', '2026-02-21 22:57:58', NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.dept 的数据：~7 rows (大约)
INSERT INTO `dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `sort`, `status`, `create_time`, `update_time`) VALUES
	(1, 0, '0', '公司内部人员', 1, b'1', '2025-08-19 11:01:09', '2025-09-08 18:21:26'),
	(2, 1, '0,1', 'IT支持', 1, b'1', '2025-08-19 11:01:28', '2025-08-19 11:01:30'),
	(3, 1, '0,1', '审核人员', 2, b'1', '2025-08-19 11:01:47', '2025-08-19 11:01:48'),
	(4, 1, '0,1', '运维人员', 3, b'1', '2025-08-19 11:02:01', '2025-08-19 11:02:04'),
	(5, 0, '0', '受众用户', 2, b'1', '2025-08-19 11:07:36', '2025-08-27 14:18:48'),
	(6, 5, '0,5', 'VIP用户', 1, b'1', '2025-08-19 11:08:40', '2025-08-21 20:32:40'),
	(7, 5, '0,5', '测试人员', 2, b'1', '2025-08-19 11:08:56', '2025-09-08 18:03:56');


-- 导出  表 xue-xiang-hui.job 结构
CREATE TABLE IF NOT EXISTS `job` (
  `job_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `job_name` varchar(255) NOT NULL COMMENT '岗位名称',
  `status` tinyint(1) DEFAULT NULL COMMENT '岗位状态',
  `sort` int(5) DEFAULT NULL COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
	(90, 0, '学享汇管理', 'layui-icon layui-icon-file', '', '', 4, 0, '2026-02-08 22:54:50', '2026-02-08 22:54:50'),
	(91, 90, '资源列表', 'layui-icon layui-icon-file', '/api/admin/resource/list', 'resource:list', 1, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(92, 90, '资源分类', 'layui-icon layui-icon-app', '/api/admin/resource/category', 'resource:category:list', 2, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(93, 90, '标签管理', 'layui-icon layui-icon-note', '/api/admin/resource/tag', 'resource:tag:list', 3, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(94, 90, '下载记录', 'layui-icon layui-icon-download-circle', '/api/admin/resource/download', 'resource:download:list', 4, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(95, 90, '文章列表', 'layui-icon layui-icon-read', '/api/admin/article/list', 'article:list', 5, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35'),
	(96, 90, '文章分类', 'layui-icon layui-icon-app', '/api/admin/article/category', 'article:category:list', 6, 1, '2026-02-08 22:54:50', '2026-02-14 19:46:35');

-- 导出  表 xue-xiang-hui.role 结构
CREATE TABLE IF NOT EXISTS `role` (
  `role_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id值',
  `role_name` varchar(255) NOT NULL COMMENT '名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `data_scope` char(1) DEFAULT NULL COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- 正在导出表  xue-xiang-hui.role 的数据：~2 rows (大约)
INSERT INTO `role` (`role_id`, `role_name`, `description`, `create_time`, `update_time`, `data_scope`) VALUES
	(1, 'ADMIN', '超级管理员，拥有所有权限', '2025-07-10 09:40:35', '2025-11-07 14:47:39', '1'),
	(2, 'USER', '普通用户', '2025-07-10 09:40:56', '2025-11-07 14:47:52', '2');

-- 导出  表 xue-xiang-hui.role_dept 结构
CREATE TABLE IF NOT EXISTS `role_dept` (
  `role_id` int(32) NOT NULL COMMENT '角色id',
  `dept_id` int(32) NOT NULL COMMENT '部门id',
  PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
	(1, 90),
	(1, 91),
	(1, 92),
	(1, 93),
	(1, 94),
	(1, 95),
	(1, 96),
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
	(1, '学享汇资源共享平台', '学享汇资源共享平台的开发方案', 3, '学享汇开发方案.txt', '2026/02/523adc7cd5ca451eabc9e681043df7dc.txt', 33414, 'txt', NULL, 34, 6, 5, 1, '管理员', 1, '2026-02-14 21:37:53', '2026-02-21 14:41:01'),
	(2, '常用开发工具介绍', '知识分享', 1, '编程工具介绍.pptx', '2026/02/2aeed9a85a014301bf86a07405596fbd.pptx', 33174, 'pptx', NULL, 23, 12, 1, 1, '管理员', 1, '2026-02-19 15:14:47', '2026-02-21 17:58:30'),
	(3, '平台使用说明书', '使用说明', 6, '学享汇平台使用说明.pdf', '2026/02/71288acfbae84ce8b1b673e823a29f30.pdf', 5188, 'pdf', NULL, 0, 0, 0, 1, '管理员', 0, '2026-02-19 15:21:17', '2026-02-20 17:11:46'),
	(7, '美文美句分享', '学而时习之，必有其用之', 2, '美言美句.docx', '2026/02/4f84ea88ccd841e0b40ceece1eb09d76.docx', 16098, 'docx', NULL, 10, 4, 0, 2, '测试用户', 1, '2026-02-20 21:59:32', '2026-02-21 21:20:51'),
	(8, '编程工具', '编程工具的分享', 1, 'IDE.zip', '2026/02/a5962e0d530a44e2bc6b716a01b3f6e2.zip', 38015, 'zip', NULL, 1, 1, 0, 1, '管理员', 1, '2026-02-21 23:04:03', '2026-02-21 23:04:13');

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
