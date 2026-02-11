/*
 学享汇后台管理系统改造 SQL 脚本
 执行前请备份数据库！
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- 第一步：删除无用菜单
-- =====================================================

-- 1. 删除岗位管理菜单及子菜单
DELETE FROM my_menu WHERE menu_id IN (69, 75, 76, 77);

-- 2. 删除系统工具菜单（代码生成、表单构建、定时任务）
DELETE FROM my_menu WHERE parent_id = 70;
DELETE FROM my_menu WHERE menu_id = 70;

-- 3. 删除错误页面菜单（作为菜单不需要，但错误页面本身保留）
DELETE FROM my_menu WHERE parent_id = 10;
DELETE FROM my_menu WHERE menu_id = 10;

-- 4. 删除SQL监控（保留接口文档和日志）
DELETE FROM my_menu WHERE menu_id = 8;

-- =====================================================
-- 第二步：添加"学享汇管理"菜单
-- =====================================================

-- 1. 添加"学享汇管理"一级菜单
INSERT INTO my_menu (parent_id, menu_name, icon, url, permission, sort, type, create_time, update_time)
VALUES (0, '学享汇管理', 'layui-icon layui-icon-file', '', '', 4, 0, NOW(), NOW());

-- 获取刚插入的menu_id（根据现有数据，新插入的ID应该是100）
SET @xue_xiang_hui_menu_id = LAST_INSERT_ID();

-- 2. 添加资源管理子菜单
INSERT INTO my_menu (parent_id, menu_name, icon, url, permission, sort, type, create_time, update_time)
VALUES
(@xue_xiang_hui_menu_id, '资源列表', 'layui-icon layui-icon-file', '/admin/resource/list', 'resource:list', 1, 1, NOW(), NOW()),
(@xue_xiang_hui_menu_id, '资源分类', 'layui-icon layui-icon-app', '/admin/resource/category', 'resource:category:list', 2, 1, NOW(), NOW()),
(@xue_xiang_hui_menu_id, '资源标签', 'layui-icon layui-icon-note', '/admin/resource/tag', 'resource:tag:list', 3, 1, NOW(), NOW()),
(@xue_xiang_hui_menu_id, '下载记录', 'layui-icon layui-icon-download-circle', '/admin/resource/download', 'resource:download:list', 4, 1, NOW(), NOW());

-- 3. 添加文章管理子菜单
INSERT INTO my_menu (parent_id, menu_name, icon, url, permission, sort, type, create_time, update_time)
VALUES
(@xue_xiang_hui_menu_id, '文章列表', 'layui-icon layui-icon-read', '/admin/article/list', 'article:list', 5, 1, NOW(), NOW()),
(@xue_xiang_hui_menu_id, '文章分类', 'layui-icon layui-icon-app', '/admin/article/category', 'article:category:list', 6, 1, NOW(), NOW());

-- 4. 添加AI管理子菜单
INSERT INTO my_menu (parent_id, menu_name, icon, url, permission, sort, type, create_time, update_time)
VALUES
(@xue_xiang_hui_menu_id, 'AI对话历史', 'layui-icon layui-icon-dialogue', '/admin/ai/history', 'ai:history:list', 7, 1, NOW(), NOW()),
(@xue_xiang_hui_menu_id, 'Token统计', 'layui-icon layui-icon-chart', '/admin/ai/tokens', 'ai:token:list', 8, 1, NOW(), NOW());

-- 5. 添加数据统计子菜单
INSERT INTO my_menu (parent_id, menu_name, icon, url, permission, sort, type, create_time, update_time)
VALUES
(@xue_xiang_hui_menu_id, '数据概览', 'layui-icon layui-icon-chart-screen', '/admin/statistics/dashboard', 'statistics:view', 9, 1, NOW(), NOW()),
(@xue_xiang_hui_menu_id, '用户排行', 'layui-icon layui-icon-user', '/admin/statistics/user', 'statistics:user', 10, 1, NOW(), NOW());

-- =====================================================
-- 第三步：为管理员角色分配新菜单权限
-- =====================================================

-- 查询管理员角色的roleId（通常是1）
-- 然后将新菜单的权限分配给管理员角色

-- 假设管理员角色ID为1，分配所有学享汇管理菜单权限
INSERT INTO my_role_menu (role_id, menu_id)
SELECT 1, menu_id FROM my_menu WHERE parent_id = @xue_xiang_hui_menu_id OR parent_id IN (
    SELECT menu_id FROM my_menu WHERE parent_id = @xue_xiang_hui_menu_id
);

-- =====================================================
-- 验证SQL（可选）
-- =====================================================

-- 查看所有一级菜单
-- SELECT * FROM my_menu WHERE parent_id = 0 ORDER BY sort;

-- 查看学享汇管理下的所有菜单
-- SELECT * FROM my_menu WHERE parent_id = @xue_xiang_hui_menu_id OR parent_id IN (
--     SELECT menu_id FROM my_menu WHERE parent_id = @xue_xiang_hui_menu_id
-- ) ORDER BY sort;

SET FOREIGN_KEY_CHECKS = 1;

-- 执行完成提示
SELECT '后台管理菜单改造完成！' AS message;
