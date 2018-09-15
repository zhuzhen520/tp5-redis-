-- phpMyAdmin SQL Dump
-- version 4.8.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 15, 2018 at 02:24 PM
-- Server version: 10.0.32-MariaDB
-- PHP Version: 7.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tic_zengliangke`
--

-- --------------------------------------------------------

--
-- Table structure for table `think_admin`
--

CREATE TABLE `think_admin` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` char(32) NOT NULL DEFAULT '',
  `entry` char(32) NOT NULL DEFAULT '',
  `nickname` varchar(50) NOT NULL DEFAULT '',
  `login_num` int(11) NOT NULL DEFAULT '0',
  `login_ip` varchar(30) NOT NULL DEFAULT '',
  `login_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_admin`
--

INSERT INTO `think_admin` (`id`, `username`, `password`, `entry`, `nickname`, `login_num`, `login_ip`, `login_time`) VALUES
(1, 'admin', 'd0c89ab83eee5e24d179526dc8b6eb02', 'memeda', '超级管理员', 99, '113.246.155.103', 1536988674);

-- --------------------------------------------------------

--
-- Table structure for table `think_adminmoney`
--

CREATE TABLE `think_adminmoney` (
  `name` varchar(10) NOT NULL,
  `money` decimal(12,4) NOT NULL DEFAULT '0.0000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_adminmoney`
--

INSERT INTO `think_adminmoney` (`name`, `money`) VALUES
('admin', '2043.2000');

-- --------------------------------------------------------

--
-- Table structure for table `think_adminmoney_log`
--

CREATE TABLE `think_adminmoney_log` (
  `id` int(11) NOT NULL COMMENT 'id',
  `username` varchar(25) NOT NULL COMMENT '用户名',
  `uid` int(11) NOT NULL COMMENT '扣除手续费用户ID',
  `product_id` int(11) NOT NULL COMMENT '资产包ID',
  `num` decimal(10,4) NOT NULL COMMENT '金额',
  `create_time` int(11) NOT NULL COMMENT '添加时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_adminmoney_log`
--

INSERT INTO `think_adminmoney_log` (`id`, `username`, `uid`, `product_id`, `num`, `create_time`) VALUES
(1, '18163626560', 100000, 2, '20.0000', 1536586924),
(2, '18516067713', 100013, 2, '0.2000', 1536645817),
(3, '18516067713', 100013, 2, '0.4000', 1536645840),
(4, '18516067713', 100013, 2, '0.4000', 1536645911),
(5, '18516067713', 100013, 2, '0.4000', 1536645947),
(6, '18516067713', 100013, 2, '0.2000', 1536645993),
(7, '18516067713', 100013, 2, '0.2000', 1536645998),
(8, '18516067713', 100013, 2, '0.4000', 1536646179),
(9, '18516067713', 100013, 2, '0.2000', 1536646240),
(10, '18516067713', 100013, 2, '0.2000', 1536647392),
(11, '18516067713', 100013, 2, '0.2000', 1536647977),
(12, '18516067713', 100013, 2, '0.2000', 1536648006),
(13, '18516067713', 100013, 2, '0.2000', 1536649733),
(14, '15387528217', 100024, 2, '2000.0000', 1536723798),
(15, '13677337935', 100019, 2, '20.0000', 1536897662);

-- --------------------------------------------------------

--
-- Table structure for table `think_attribute`
--

CREATE TABLE `think_attribute` (
  `attr_id` smallint(5) UNSIGNED NOT NULL,
  `attr_name` varchar(50) NOT NULL DEFAULT '',
  `parent_id` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `sort` int(11) NOT NULL DEFAULT '0',
  `is_show` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_attribute`
--

INSERT INTO `think_attribute` (`attr_id`, `attr_name`, `parent_id`, `sort`, `is_show`) VALUES
(1, '测试sh是', 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `think_auth_group`
--

CREATE TABLE `think_auth_group` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `title` char(100) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `rules` char(200) NOT NULL DEFAULT '',
  `note` varchar(200) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_auth_group`
--

INSERT INTO `think_auth_group` (`id`, `title`, `status`, `rules`, `note`) VALUES
(1, '超级管理员', 1, '18,19,50,59,55,61,25,69,70,36,75,76,26,38,39,57,35,71,72,65,20,21,24,22,23,15,73,74,27,53,64,28,1,2,6,14,3,13,5,4,11,8,7,9,47,48,62,66,68,67,10,41,42', '最高权限');

-- --------------------------------------------------------

--
-- Table structure for table `think_auth_group_access`
--

CREATE TABLE `think_auth_group_access` (
  `uid` mediumint(8) UNSIGNED NOT NULL,
  `group_id` mediumint(8) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_auth_group_access`
--

INSERT INTO `think_auth_group_access` (`uid`, `group_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `think_auth_rule`
--

CREATE TABLE `think_auth_rule` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `name` char(80) NOT NULL DEFAULT '',
  `title` char(20) NOT NULL DEFAULT '',
  `type` tinyint(1) NOT NULL DEFAULT '1',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `condition` char(100) NOT NULL DEFAULT '',
  `parent_id` mediumint(8) UNSIGNED NOT NULL DEFAULT '0',
  `sort` int(11) NOT NULL DEFAULT '0',
  `param` varchar(100) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_auth_rule`
--

INSERT INTO `think_auth_rule` (`id`, `name`, `title`, `type`, `status`, `condition`, `parent_id`, `sort`, `param`) VALUES
(1, '权限管理', '权限管理', 1, 1, '', 0, 40, ''),
(2, 'admin/auth/role', '角色管理', 1, 1, '', 1, 0, ''),
(3, 'admin/auth/rule', '后台菜单', 1, 1, '', 1, 0, ''),
(4, 'Admin/auth/admin', '管理员列表', 1, 1, '', 1, 0, ''),
(5, 'Admin/auth/rule_add', '添加/修改', 1, 1, '', 3, 0, ''),
(6, 'Admin/Auth/role_add', '添加/修改', 1, 1, '', 2, 0, ''),
(7, 'Admin/Auth/admin_add', '添加/修改', 1, 1, '', 4, 0, ''),
(8, 'Admin/Auth/repeat', '账号唯一', 1, 1, '', 4, 0, ''),
(9, '系统管理', '系统管理', 1, 1, '', 0, 50, ''),
(10, 'Admin/System/config', '系统设置', 1, 1, '', 9, 1, ''),
(11, 'Admin/Auth/admin_del', '删除', 1, 1, '', 4, 0, ''),
(13, 'Admin/Auth/rule_del', '删除', 1, 1, '', 3, 0, ''),
(14, 'Admin/Auth/role_del', '删除', 1, 1, '', 2, 0, ''),
(15, '产品中心', '应用中心', 1, 1, '', 0, 30, ''),
(16, 'Admin/Product/category', '产品分类', 1, 1, '', 15, 1, ''),
(17, 'Admin/Product/category_add', '添加/修改', 1, 1, '', 16, 0, ''),
(18, '会员管理', '会员管理', 1, 1, '', 0, 0, ''),
(19, 'Admin/Member/member_list', '会员列表', 1, 1, '', 18, 1, ''),
(20, '资讯管理', '资讯管理', 1, 1, '', 0, 20, ''),
(21, 'Admin/News/category', '资讯分类', 1, 1, '', 20, 0, ''),
(22, 'Admin/News/news_list', '资讯列表', 1, 1, '', 20, 0, ''),
(23, 'Admin/News/news_add', '添加/修改', 1, 1, '', 22, 0, ''),
(24, 'Admin/News/category_add', '添加/修改', 1, 1, '', 21, 0, ''),
(25, 'Admin/Member/member_add', '添加/修改', 1, 1, '', 19, 8, ''),
(26, '交易中心', '交易中心', 1, 1, '', 0, 10, ''),
(27, 'Admin/Product/product_list', '应用列表', 1, 1, '', 15, 0, ''),
(28, 'Admin/Product/product_add', '添加/修改', 1, 1, '', 27, 0, ''),
(29, 'Admin/Product/attribute', '属性管理', 1, 1, '', 15, 0, ''),
(30, 'Admin/Product/attribute_add', '添加/修改', 1, 1, '', 29, 0, ''),
(31, '奖励管理', '奖励管理', 1, 1, '', 0, 9, ''),
(32, 'Admin/Reward/integral', '会员动态积分', 1, 1, '', 31, 1, ''),
(33, 'Admin/reward/money', '会员资产', 1, 1, '', 31, 2, ''),
(35, 'Admin/Trade/trade_list', '交易列表', 1, 1, '', 26, 0, ''),
(36, 'Admin/Member/gold_rid', '释放订单', 1, 1, '', 18, 9, ''),
(38, 'Admin/Trade/price_trend', '价格走势', 1, 1, '', 26, 0, ''),
(39, 'Admin/Trade/add_order_trend', '添加', 1, 1, '', 38, 0, ''),
(75, 'Admin/Member/member_zjmoney', '管理增扣明细', 1, 1, '', 18, 10, ''),
(41, 'Admin/System/banner', '轮播图', 1, 1, '', 9, 2, ''),
(42, 'Admin/System/banner_add', '添加', 1, 1, '', 41, 0, ''),
(44, 'Admin/System/static_config', '奖励规则', 1, 1, '', 9, 3, ''),
(45, 'Admin/system/static_config_add', '添加', 1, 1, '', 44, 0, ''),
(74, 'Admin/Trade/handmoney', '应用手续费列表', 1, 1, '', 15, 0, ''),
(47, 'Admin/System/message', '留言管理', 1, 1, '', 9, 0, ''),
(48, 'Admin/System/message_add', '回复留言', 1, 1, '', 47, 0, ''),
(49, 'Admin/System/message_count', '留言提醒', 1, 1, '', 47, 0, ''),
(50, 'Admin/Member/member_info', '安全中心', 1, 1, '', 19, 4, ''),
(51, 'Admin/Member/put_integral', '资产提现', 1, 1, '', 18, 10, ''),
(52, 'Admin/Member/put_integral_add', '操作提现', 1, 1, '', 51, 11, ''),
(53, 'Admin/Product/comment_list', '产品评价', 1, 1, '', 27, 0, ''),
(54, 'Admin/System/info', '发现', 1, 1, '', 9, 0, ''),
(55, 'Admin/Member/member_tree', '会员结构', 1, 1, '', 19, 6, ''),
(56, 'Admin/System/message_del', '留言删除', 1, 1, '', 47, 0, ''),
(57, 'Admin/trade/chart', '走势图', 1, 1, '', 38, 0, ''),
(58, 'Admin/member/gold_static_gold', '复投订单', 1, 1, '', 18, 12, ''),
(59, 'Admin/member/member_money', '线下入金', 1, 1, '', 19, 5, ''),
(60, 'admin/reward/put_integral_log', '可提现积分', 1, 1, '', 31, 0, ''),
(61, 'admin/member/member_gold_static', '拨币', 1, 1, '', 19, 7, ''),
(62, 'Admin/System/databackup', '数据库备份', 1, 1, '', 9, 0, ''),
(64, 'Admin/Product/banner_add', '资产包banner图', 1, 1, '', 27, 0, ''),
(65, 'Admin/trade/tic_order', 'Tic交易记录', 1, 1, '', 26, 0, ''),
(66, 'Admin/System/kefu', '客服中心', 1, 1, '', 9, 0, ''),
(67, 'Admin/System/kefu_add', '添加客服', 1, 1, '', 66, 0, ''),
(68, 'Admin/System/kefu_del', '删除客服', 1, 1, '', 66, 0, ''),
(69, 'Admin/Member/member_kcsource', '收益明细', 1, 1, '', 18, 2, ''),
(70, 'Admin/Member/member_class', '会员层级', 1, 1, '', 18, 3, ''),
(71, 'Admin/trade/tic_duichong', '拨币兑冲订单', 1, 1, '', 26, 0, ''),
(72, 'Admin/trade/duichong_pass', '兑冲后台拨币', 1, 1, '', 71, 0, ''),
(73, 'Admin/Trade/product_order', '应用交易列表', 1, 1, '', 15, 0, ''),
(76, 'Admin/Member/member_jiedian', '节点算力明细', 1, 1, '', 18, 11, '');

-- --------------------------------------------------------

--
-- Table structure for table `think_banner`
--

CREATE TABLE `think_banner` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` int(11) NOT NULL DEFAULT '0',
  `image_path` varchar(300) NOT NULL DEFAULT '',
  `type` char(25) NOT NULL DEFAULT '0',
  `add_time` varchar(50) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_banner`
--

INSERT INTO `think_banner` (`id`, `title`, `image_path`, `type`, `add_time`) VALUES
(71, 0, '20180915/2f6a709dea0dff7ead6a2455cf23a81d.jpg', 'app', '1536976593'),
(72, 0, '20180915/7c47c787c91bad5c3801ecd108b492db.jpg', 'app', '1536976594'),
(73, 0, '20180915/0c1fe874828564e85621022196fdef86.jpg', 'index', '1536976608'),
(74, 0, '20180915/678659205db9f376a097d8e741b770b1.jpg', 'index', '1536976608');

-- --------------------------------------------------------

--
-- Table structure for table `think_cart`
--

CREATE TABLE `think_cart` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `ip` varchar(30) NOT NULL DEFAULT '',
  `pro_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `pro_name` varchar(200) NOT NULL DEFAULT '',
  `pro_thumb` varchar(200) NOT NULL DEFAULT '',
  `pro_attr` varchar(100) NOT NULL DEFAULT '',
  `attr_id` varchar(100) NOT NULL DEFAULT '',
  `attr_price` decimal(5,2) NOT NULL DEFAULT '0.00',
  `buy_number` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `price` decimal(7,2) NOT NULL DEFAULT '0.00',
  `market_price` decimal(7,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(8,2) NOT NULL DEFAULT '0.00',
  `add_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_comment`
--

CREATE TABLE `think_comment` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `pro_id` int(11) NOT NULL DEFAULT '0',
  `order_id` int(11) NOT NULL DEFAULT '0',
  `score` tinyint(4) NOT NULL DEFAULT '0',
  `content` varchar(300) NOT NULL DEFAULT '',
  `add_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_config`
--

CREATE TABLE `think_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `value` varchar(600) NOT NULL DEFAULT '',
  `type` char(10) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_config`
--

INSERT INTO `think_config` (`id`, `name`, `value`, `type`) VALUES
(1, 'website', '增量科技', 'base'),
(2, 'notice', '增量链DAPP2.0版全新上线，梦想启航！', 'base'),
(3, 'apk', 'https://fir.im/m5rf', 'base'),
(4, 'address', '3', 'base'),
(5, 'order', '5', 'base'),
(6, 'integral_up', '1', 'base'),
(7, 'integral_lt', '100', 'base'),
(8, 'gold_static_gold', '2', 'base'),
(9, 'first', '10', 'reward'),
(10, 'new_orderA', '2', 'reward'),
(11, 'new_orderB', '3', 'reward'),
(12, 'new_order_count', '10', 'reward'),
(13, 'static_gold_rid', '30', 'reward'),
(14, 'put_integral_0', '', 'base'),
(15, 'put_integral_1', '', 'base'),
(16, 'put_integral_2', '', 'base'),
(17, 'put_integral_3', '', 'base'),
(18, 'put_integral_4', '', 'base'),
(19, 'put_integral_5', '', 'base'),
(20, 'team_role0', '8', 'reward'),
(21, 'team_role1', '8', 'reward'),
(22, 'team_role2', '8', 'reward'),
(23, 'team_role3', '8', 'reward'),
(24, 'team_role4', '8', 'reward'),
(25, 'team_role5', '8', 'reward'),
(26, 'msgname', '增量科技', 'message'),
(27, 'code', 'SMS_136260043', 'message'),
(31, 'mineral', '3', 'rate'),
(30, 'candy', '100', 'rate'),
(33, 'usdt', '6.87', 'rate'),
(32, 'mineraltic', '3', 'rate'),
(34, 'money_address', '0xd2593c7528e99ca07be6bcb010a33870e2fc419b', 'base'),
(35, 'apk1', 'https://fir.im/m5rf', 'base'),
(36, 'version', '1.0', 'base');

-- --------------------------------------------------------

--
-- Table structure for table `think_eth_log`
--

CREATE TABLE `think_eth_log` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL COMMENT '用户uid',
  `address` varchar(100) NOT NULL COMMENT 'eth、btc地址',
  `currency` int(1) NOT NULL COMMENT '1表示消耗tic兑换  2表示矿石兑换',
  `dh_num` decimal(10,5) NOT NULL COMMENT '兑换eth、btc数量',
  `rmbnum` decimal(10,5) NOT NULL COMMENT '单个eth、btc人民币单价',
  `type` varchar(15) NOT NULL COMMENT '类型：eth、btc',
  `tic` decimal(10,5) NOT NULL COMMENT '消耗tic数目',
  `status` int(1) NOT NULL COMMENT '状态 0提交待审核 1通过 2驳回 ',
  `time` int(11) NOT NULL COMMENT '提交时间戳'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_eth_log`
--

INSERT INTO `think_eth_log` (`id`, `uid`, `address`, `currency`, `dh_num`, `rmbnum`, `type`, `tic`, `status`, `time`) VALUES
(4, 100019, '1', 1, '1.00000', '34.00000', 'EOS', '6.80000', 1, 1536652306),
(5, 100019, 'https://fir.im/kxs7', 1, '2.00000', '1318.11200', 'ETH', '527.24480', 2, 1536654763),
(6, 100024, '0xd2593c7528e99ca07be6bcb010a33870e2fc419b', 1, '1.00000', '1199.99600', 'ETH', '239.99920', 1, 1536724048),
(7, 100024, '0xd2593c7528e99ca07be6bcb010a33870e2fc419b', 1, '10.00000', '1186.32800', 'ETH', '2372.65600', 1, 1536724142),
(8, 100024, '0xd2593c7528e99ca07be6bcb010a33870e2fc419b', 1, '3.00000', '1203.00570', 'ETH', '721.80342', 0, 1536724318),
(9, 100013, '0xd2593c7528e99ca07be6bcb010a33870e2fc419b', 1, '1.00000', '1308.39150', 'ETH', '654.19575', 0, 1536801618),
(10, 100015, '123456', 1, '1.00000', '1295.54460', 'ETH', '647.77230', 0, 1536819575),
(11, 100015, '123456', 1, '1.00000', '1292.65920', 'ETH', '646.32960', 0, 1536820251);

-- --------------------------------------------------------

--
-- Table structure for table `think_exchange`
--

CREATE TABLE `think_exchange` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `type` int(1) NOT NULL COMMENT '1糖果 2钻石',
  `kind` char(10) NOT NULL COMMENT '兑换币种',
  `num` decimal(10,4) NOT NULL COMMENT '兑换tic eth 数量',
  `dh_num` decimal(10,4) NOT NULL COMMENT '糖果或钻石消耗数量',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_exchange`
--

INSERT INTO `think_exchange` (`id`, `uid`, `type`, `kind`, `num`, `dh_num`, `time`) VALUES
(1, 100013, 1, 'TIC', '10.0000', '1000.0000', '2018-09-10 06:01:18'),
(2, 100013, 2, 'TIC', '1197.0000', '3591.0000', '2018-09-10 06:01:27'),
(3, 100013, 2, 'TIC', '5.0000', '0.0000', '2018-09-10 03:32:14'),
(4, 100013, 1, '', '2.0000', '0.0000', '2018-09-09 09:46:00'),
(5, 100019, 1, '', '1.0000', '0.0000', '2018-09-10 02:25:53'),
(6, 100019, 2, '', '166.0000', '0.0000', '2018-09-10 02:27:53'),
(7, 100000, 1, '', '1.0000', '0.0000', '2018-09-10 06:15:59'),
(8, 100000, 1, '', '2.0000', '0.0000', '2018-09-10 06:30:09'),
(9, 100000, 1, '', '1.0000', '100.0000', '2018-09-10 06:31:55'),
(10, 100000, 2, 'TIC', '50.0000', '150.0000', '2018-09-11 02:51:46'),
(11, 100019, 1, '', '1.0000', '100.0000', '2018-09-10 10:04:07'),
(12, 100019, 1, '', '1.0000', '100.0000', '2018-09-11 00:07:32'),
(13, 100013, 2, '', '50.0000', '100.0000', '2018-09-11 01:12:51'),
(14, 100019, 2, '', '400.0000', '2000.0000', '2018-09-11 09:54:32'),
(15, 100019, 2, '', '23.0000', '115.0000', '2018-09-11 12:09:03'),
(16, 100019, 2, '', '20.0000', '100.0000', '2018-09-11 12:12:47'),
(17, 100019, 2, '', '5.0000', '25.0000', '2018-09-11 12:17:32'),
(18, 100019, 2, '', '43.0000', '215.0000', '2018-09-11 12:19:13'),
(19, 100019, 1, '', '1.0000', '100.0000', '2018-09-11 12:21:03'),
(20, 100019, 2, '', '25.0000', '125.0000', '2018-09-11 12:22:27'),
(21, 100019, 1, '', '10.0000', '1000.0000', '2018-09-11 12:22:36'),
(22, 100019, 2, '', '12.0000', '240.0000', '2018-09-11 12:26:33'),
(23, 100019, 2, '', '6.0000', '120.0000', '2018-09-11 12:26:46'),
(24, 100013, 1, '', '4.0000', '400.0000', '2018-09-12 02:32:20'),
(25, 100017, 1, '', '1.0000', '100.0000', '2018-09-12 07:38:53'),
(26, 100019, 1, '', '2.0000', '200.0000', '2018-09-12 08:12:35'),
(27, 100019, 2, '', '5.0000', '100.0000', '2018-09-12 08:12:47'),
(28, 100013, 2, '', '213.0000', '4260.0000', '2018-09-12 08:15:27'),
(29, 100025, 1, '', '1.0000', '100.0000', '2018-09-13 01:20:50'),
(30, 100015, 2, '', '20.0000', '400.0000', '2018-09-13 01:56:24'),
(31, 100031, 1, '', '1.0000', '100.0000', '2018-09-13 09:36:09'),
(32, 100013, 1, '', '2.0000', '200.0000', '2018-09-13 09:46:52'),
(33, 100013, 1, '', '3000.0000', '300000.0000', '2018-09-13 09:50:53'),
(34, 100013, 1, '', '90.0000', '9000.0000', '2018-09-13 09:54:21'),
(35, 100028, 2, '', '2.0000', '40.0000', '2018-09-13 09:55:50'),
(36, 100013, 1, '', '10.0000', '1000.0000', '2018-09-13 09:58:58'),
(37, 100015, 1, '', '11.0000', '1100.0000', '2018-09-13 10:01:12'),
(38, 100013, 1, '', '10.0000', '1000.0000', '2018-09-13 10:07:15'),
(39, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:08:00'),
(40, 100013, 1, '', '1.0000', '100.0000', '2018-09-13 10:08:39'),
(41, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:08:58'),
(42, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:10:31'),
(43, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:12:14'),
(44, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:14:02'),
(45, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:15:04'),
(46, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:17:47'),
(47, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:21:24'),
(48, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:22:05'),
(49, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:22:45'),
(50, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:24:49'),
(51, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:25:23'),
(52, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:25:44'),
(53, 100015, 1, '', '1.0000', '100.0000', '2018-09-13 10:26:11'),
(54, 100015, 2, '', '50.0000', '1000.0000', '2018-09-13 11:20:49'),
(55, 100015, 1, '', '10.0000', '1000.0000', '2018-09-13 11:20:58'),
(56, 100025, 1, '', '4.0000', '400.0000', '2018-09-13 14:34:05'),
(57, 100017, 1, '', '2.0000', '200.0000', '2018-09-14 05:41:41'),
(58, 100015, 1, '', '1.0000', '100.0000', '2018-09-14 08:30:50'),
(59, 100015, 1, '', '1.0000', '200.0000', '2018-09-14 09:09:20'),
(60, 100015, 1, '', '0.0000', '200.0000', '2018-09-14 09:10:09'),
(61, 100015, 1, '', '-2.0000', '200.0000', '2018-09-14 09:10:21'),
(62, 100015, 1, '', '-4.0000', '200.0000', '2018-09-14 09:10:35'),
(63, 100015, 1, '', '-6.0000', '1000.0000', '2018-09-14 09:10:46'),
(64, 100015, 1, '', '1.0000', '100.0000', '2018-09-14 09:12:42'),
(65, 100015, 2, '', '5.0000', '20.0000', '2018-09-14 09:34:44'),
(66, 100015, 2, '', '4.0000', '20.0000', '2018-09-14 09:35:02'),
(67, 100015, 2, '', '3.0000', '20.0000', '2018-09-14 09:35:05'),
(68, 100015, 1, '', '2.0000', '100.0000', '2018-09-15 01:06:26'),
(69, 100015, 1, '', '1.0000', '100.0000', '2018-09-15 01:06:37'),
(70, 100015, 2, '', '2.0000', '20.0000', '2018-09-15 01:06:58'),
(71, 100015, 2, '', '1.0000', '20.0000', '2018-09-15 01:07:26'),
(72, 100013, 2, '', '36.0000', '20.0000', '2018-09-15 01:39:54'),
(73, 100039, 1, '', '1.0000', '100.0000', '2018-09-15 03:01:11'),
(74, 100017, 1, '', '21.0000', '500.0000', '2018-09-15 03:33:44'),
(75, 100025, 2, '', '57.0000', '1140.0000', '2018-09-15 04:37:23'),
(76, 100017, 2, '', '106.0000', '20.0000', '2018-09-15 05:21:57'),
(77, 100042, 1, '', '10.0000', '900.0000', '2018-09-15 06:00:02'),
(78, 100042, 1, '', '1.0000', '100.0000', '2018-09-15 06:01:20'),
(79, 100042, 2, '', '333.0000', '900.0000', '2018-09-15 06:01:33'),
(80, 100042, 2, '', '33.0000', '99.0000', '2018-09-15 06:01:40'),
(81, 100017, 1, '', '17.0000', '1000.0000', '2018-09-15 06:10:17');

-- --------------------------------------------------------

--
-- Table structure for table `think_gold_log`
--

CREATE TABLE `think_gold_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL COMMENT '账号id',
  `username` char(50) NOT NULL COMMENT '账号',
  `action` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '变动金额',
  `money_end` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '余额',
  `info` varchar(300) NOT NULL DEFAULT '' COMMENT '备注',
  `order_sn` varchar(200) NOT NULL DEFAULT '' COMMENT '订单号',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型/0支出/1',
  `action_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1普通来源/2交易/3兑换/4静态释放/5动态转静态',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '操作时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_gold_static_gold`
--

CREATE TABLE `think_gold_static_gold` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL DEFAULT '0',
  `username` char(50) NOT NULL COMMENT '账号',
  `action` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '转入数量',
  `money_end` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '余额',
  `total` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '总',
  `gold_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '当时金币价',
  `add_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_gold_static_log`
--

CREATE TABLE `think_gold_static_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL COMMENT '账号id',
  `username` char(50) NOT NULL COMMENT '账号',
  `action` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '变动金额',
  `money_end` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '余额',
  `info` varchar(300) NOT NULL DEFAULT '' COMMENT '备注',
  `order_sn` varchar(200) NOT NULL DEFAULT '' COMMENT '订单号',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型/0支出/1',
  `action_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1普通来源/2交易/3兑换/4静态释放/5动态转静态',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '操作时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_integral_log`
--

CREATE TABLE `think_integral_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL COMMENT '账号id',
  `username` char(50) NOT NULL COMMENT '账号',
  `action` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '变动金额',
  `money_end` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '余额',
  `info` varchar(300) NOT NULL DEFAULT '' COMMENT '备注',
  `order_sn` varchar(200) NOT NULL DEFAULT '' COMMENT '订单号',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型/0支出/1收入',
  `action_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1静态奖励/2首推奖/3团队管理/4新增业绩奖/5新增业同级绩奖/6兑换金币/7提现',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '操作时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_kefu`
--

CREATE TABLE `think_kefu` (
  `id` int(10) NOT NULL,
  `title` varchar(50) NOT NULL,
  `thumb` varchar(255) NOT NULL,
  `type` tinyint(1) NOT NULL COMMENT '1微信客服 2qq客服 3微信群客服 4qq群客服',
  `add_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_kefu`
--

INSERT INTO `think_kefu` (`id`, `title`, `thumb`, `type`, `add_time`) VALUES
(12, 'tichain01', '/uploads/20180911/ec8c0de76f6c7bf39ae5662e66f0181e.png', 1, 1536631296),
(13, ' 1433931825', '/uploads/20180911/f697a6c9940029226eea3d523b376f0f.png', 2, 1536631780),
(14, '微信公众号', '/uploads/20180911/44eca8b1cf4005dcf966cb91084ed92c.png', 1, 1536637082),
(16, '123', '/uploads/20180913/63f7d812a3c93873b98f874682ac9376.png', 1, 1536811241),
(17, '第三方充值客服', '/uploads/20180914/b1468054bd6c04e7fe837949fb4d1ca7.png', 5, 1536919756);

-- --------------------------------------------------------

--
-- Table structure for table `think_member`
--

CREATE TABLE `think_member` (
  `id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '上级id',
  `level` smallint(6) NOT NULL DEFAULT '0' COMMENT '级别',
  `username` char(50) NOT NULL COMMENT '账号',
  `nickname` varchar(60) NOT NULL DEFAULT '' COMMENT '昵称',
  `mobile` varchar(30) NOT NULL COMMENT '电话',
  `password` char(32) NOT NULL DEFAULT '',
  `Paytoken` char(32) NOT NULL DEFAULT '' COMMENT '支付密码',
  `entry` char(6) NOT NULL DEFAULT '',
  `wallet_address` char(50) NOT NULL COMMENT '钱包地址',
  `avatar` varchar(300) NOT NULL DEFAULT '' COMMENT '头像',
  `money` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '余额',
  `candy` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '糖果',
  `mineral` decimal(11,5) NOT NULL DEFAULT '0.00000' COMMENT '矿石',
  `power` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT '算力',
  `gold_static` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '静态金币',
  `gold` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '金币',
  `integral` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '积分',
  `parent_mobile` varchar(30) NOT NULL DEFAULT '' COMMENT '上级手机号码',
  `sex` tinyint(4) NOT NULL DEFAULT '0',
  `reg_time` int(11) NOT NULL DEFAULT '0' COMMENT '注册时间',
  `rid_speed` decimal(5,4) NOT NULL DEFAULT '0.0200' COMMENT '释放速度',
  `is_trade` tinyint(4) NOT NULL DEFAULT '0' COMMENT '交易限制',
  `is_admin` tinyint(4) NOT NULL DEFAULT '0' COMMENT '管理员',
  `is_login` tinyint(4) NOT NULL DEFAULT '0' COMMENT '登陆限制',
  `login_time` int(11) NOT NULL DEFAULT '0' COMMENT '登陆时间',
  `gold_static_price` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '静态金币价',
  `put_integral` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '可提现额度'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_member`
--

INSERT INTO `think_member` (`id`, `parent_id`, `level`, `username`, `nickname`, `mobile`, `password`, `Paytoken`, `entry`, `wallet_address`, `avatar`, `money`, `candy`, `mineral`, `power`, `gold_static`, `gold`, `integral`, `parent_mobile`, `sex`, `reg_time`, `rid_speed`, `is_trade`, `is_admin`, `is_login`, `login_time`, `gold_static_price`, `put_integral`) VALUES
(100000, 0, 3, '18163626560', '小猪猪', '18163626560', '9fabef74eafffd68b56c4e8b11131943', 'b5e6878180e45ed99de9160be4447271', 'aKF5vI', '1d51dc2b723063d0470a992d0aa6c2538dbe2b108', '', '0.000', '366.00', '445.50000', '0.0030', '0.000', '0.000', '0.000', '18163626560', 0, 1535083090, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100011, 100000, 1, '15211322811', '', '15211322811', '8d66db0a285916af27420bf503fa1745', 'b5e6878180e45ed99de9160be4447271', 'W$#hsM', '17019c247cddc85ac9ddf6efec0324de3cc524395', '', '0.000', '100.00', '0.01716', '0.0030', '0.000', '0.000', '0.000', '18163626560', 0, 1535512842, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100012, 100011, 0, '15211322888', '', '15211322888', '006f7fef95709a46208bcd67b4d976eb', 'b5e6878180e45ed99de9160be4447271', '37sKF$', '1635dfaa11826f8e6d08fc69fccc78344fb19d7bd', '', '0.000', '100000.00', '100000.00000', '0.0020', '0.000', '0.000', '0.000', '18163626560', 0, 1535512877, '0.0200', 0, 0, 0, 1535521392, '0.000', '0.000'),
(100013, 100012, 2, '18516067713', '', '18516067713', '5b6968dabe1cb73365c3b745c8f2acd2', 'e10adc3949ba59abbe56e057f20f883e', 'G6m7PF', '141342d959767ca20e86488accf2e7cc7380db9ce', '', '10001.000', '103.00', '706.79325', '0.0020', '0.000', '0.000', '0.000', '18163626560', 0, 1535593709, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100014, 100013, 0, '17673055071', '', '17673055071', '364bf2a87f33b5ccbb6208a5c353640e', 'e10adc3949ba59abbe56e057f20f883e', '2aMREH', '1d61481a63d04a52f12174bd35d6a2ce9d9c59512', '', '0.000', '200.00', '0.00000', '0.0020', '0.000', '0.000', '0.000', '18516067713', 0, 1535602383, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100015, 100014, 0, '15897381680', '111', '15897381680', '10b96d32d328f4fc8e8bb03047fdde25', 'e10adc3949ba59abbe56e057f20f883e', 'bdr@uf', '1184a3ccf03cec7ef68d3655f06a3827f51591972', '', '0.000', '15.50', '5.02859', '0.0020', '0.000', '0.000', '0.000', '18516067713', 0, 1535619374, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100016, 100015, 2, '18890608054', '', '18890608054', '117464b65cddf6cb392dcd58f8dd50d4', 'e10adc3949ba59abbe56e057f20f883e', 'RdZJzy', '1d631490dff3a21e9d68838c58e01d046d6eed21b', '', '0.000', '245.00', '0.09034', '0.0020', '0.000', '0.000', '0.000', '18516067713', 0, 1535622133, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100017, 100016, 2, '15367894550', '', '15367894550', '62b2405949c8da399119bb3db80e8354', 'e10adc3949ba59abbe56e057f20f883e', 'IyDYQ0', '1be93ad496057f2d6f502bb1ec801ab5506a26b8e', '', '0.000', '736.00', '2106.05490', '0.0030', '0.000', '0.000', '0.000', '18516067713', 0, 1535954326, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100018, 100017, 0, '18273154511', 'TIC', '18273154511', 'dd9e478aeb6b1c2885551a0c6388a48a', 'e10adc3949ba59abbe56e057f20f883e', 'C@rRuv', '17573877b0e3ebc51eb48867671537adaab5404e2', '', '0.000', '0.00', '0.00000', '0.0020', '0.000', '0.000', '0.000', '18516067713', 0, 1536290806, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100019, 100013, 0, '13677337935', 'TIC', '13677337935', '783a88ad2e3bae536c1e60e118fd492f', '6035d7a170ff97458068c79e64310a38', 'd2mgK%', '1b3407d73605a7b320a101153d26d8dac5eb4a594', '', '9000.000', '260.00', '131.04468', '0.0020', '800.000', '0.000', '0.000', '18163626560', 0, 1536313572, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100020, 100000, 0, '13347255699', 'TIC', '13347255699', '4f1f7f85d0c7d61b781f426779ba4537', '96e79218965eb72c92a549dd5a330112', '%OVe2z', '1510acb5900c6d17cdd5fb1cc9184bc0ccdd3b8d6', '', '0.000', '97.00', '0.03312', '0.0020', '0.000', '0.000', '0.000', '18516067713', 0, 1536313998, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100021, 100015, 2, '18163626562', 'TIC', '18163626562', '94fb47ccff2f02f1b4ee393f7da270c0', 'e10adc3949ba59abbe56e057f20f883e', 'fVRISU', '1d51dc2b723063d0470a992d0aa6c2538dbe2b110', '', '0.000', '0.00', '0.00000', '0.0030', '0.000', '0.000', '0.000', '15897381680', 0, 1536547601, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100022, 100019, 1, '15274912795', 'TIC', '15274912795', 'ea958c9be1f6a2641b882670699016f7', 'e10adc3949ba59abbe56e057f20f883e', 'Cnp5F4', '1c0332e291647ebf3c94c7419b20afabe73098cf2', '', '0.000', '0.00', '1000.00000', '0.0030', '0.000', '0.000', '0.000', '13677337935', 0, 1536631772, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100024, 100019, 3, '15387528217', 'TIC', '15387528217', 'ae46b0562ac82388cfa8fba744cbf02a', '6035d7a170ff97458068c79e64310a38', 'YE9Ip2', '0x5c6059947634aea124e8b00c36ed11c8f6516d74', '', '0.000', '60068.00', '5000.00000', '0.0030', '0.000', '0.000', '0.000', '13677337935', 0, 1536721027, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100025, 100019, 1, '13720223000', 'TIC', '13720223000', '55f87ac8fab5a2171a475a3a0410f20a', 'e10adc3949ba59abbe56e057f20f883e', 'Iq9Fci', '0x352005e40577e457ed5c4d576286bd69c7af632e', '', '0.000', '282.00', '7.04991', '0.0030', '0.000', '0.000', '0.000', '13677337935', 0, 1536734755, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100026, 100019, 0, '13873173233', 'TIC', '13873173233', '5e09aa178d27c4fbd21373426094ce49', '0ebfb7d7828cc60aad56b72705ab92ed', '2fW9Ku', '0xf85f85e9b5942e40dc08b2b5f73b63f80207335d', '', '0.000', '91.00', '0.01600', '0.0020', '0.000', '0.000', '0.000', '13677337935', 0, 1536735921, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100027, 100019, 0, '18175166776', 'TIC', '18175166776', '218e36d9c067de3271b60852a87b19ad', 'cec3393cd80135dfa4716466be0b7cad', 'lEWu5L', '0xd2c8006c8ac08c8b14a831e7878a286477e1b107', '', '0.000', '0.00', '0.00000', '0.0020', '0.000', '0.000', '0.000', '13677337935', 0, 1536742966, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100028, 100000, 1, '13487583399', 'TIC', '13487583399', '687134df5c0fd776e19ce97a4af6cad4', '3010a4ccfdbcad8238c8e7de844b15fb', 'C97MGb', '0x80d3d2f915580a522793866849c78c712af030f4', '', '0.000', '121.00', '139.00000', '0.0030', '0.000', '0.000', '0.000', '18163626560', 0, 1536746917, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100029, 100025, 0, '13667384550', 'TIC', '13667384550', 'c1b125f2c405cf549ccd5e553a49cffb', 'db6ad7cbe970e12b00cf917c8d6515cf', 'I1yF$U', '0xc57ab4b36ff6c4e417d579bc277599d909360629', '', '0.000', '0.00', '0.00000', '0.0020', '0.000', '0.000', '0.000', '13720223000', 0, 1536802242, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100030, 100025, 0, '13871355965', 'TIC', '13871355965', 'd5ca7a345e0fe5217f54ba4f7ec98a49', '333b91ffdb663784430dcf50d290ae88', 'zqvLEK', '0x21cb467ad45791ee630cc8c3ebecbc5cf0a9d92b', '', '0.000', '51.00', '0.03763', '0.0020', '0.000', '0.000', '0.000', '13720223000', 0, 1536831127, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100031, 100025, 0, '18569077407', 'TIC', '18569077407', '92179f7c48c96b123e90f12b1f6ab2db', '860c6d6d6c82a25147a6bb7312fbd3a7', 'CfUjOc', '0xca283abab7aea7880628dda195cf82b1d2003268', '', '0.000', '79.00', '0.03444', '0.0020', '0.000', '0.000', '0.000', '13720223000', 0, 1536831148, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100032, 100025, 0, '13975188161', 'TIC', '13975188161', 'ca0e8c90c88ebca972e8b98e88c9fafc', 'af8f9dffa5d420fbc249141645b962ee', 'LZS5ov', '0xc743196ef8e597b589327ff32711580d7771a008', '', '0.000', '31.00', '0.02486', '0.0020', '0.000', '0.000', '0.000', '13720223000', 0, 1536833644, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100033, 100025, 0, '13720378288', 'TIC', '13720378288', 'd01a89a186accfb5f2f941afa31371ad', '8cac0b17f5dbf99022e2faff21008788', '4INwm$', '0x2d7d4445d12f2f17bb30d328784491e679284f8e', '', '0.000', '0.00', '0.00000', '0.0020', '0.000', '0.000', '0.000', '13720223000', 0, 1536846574, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100034, 100019, 0, '18932428889', 'TIC', '18932428889', '6207500e028060ffdff594ed85ecb589', '0ebfb7d7828cc60aad56b72705ab92ed', 'kIlOx4', '0x28cc933bfece8301dcf95c9a7ace7b23da9f0163', '', '0.000', '0.00', '0.00000', '0.0020', '0.000', '0.000', '0.000', '13677337935', 0, 1536887567, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100035, 100017, 0, '17802719797', 'TIC', '17802719797', '59e0d54f2fc985a5b61589febeadb6ca', '3e6d4fbd9494ed8c8e2f9a4f2b20d1a0', '5@ksFu', '0x483ed626455041b68b6a4be6cc3bee1cd49fd263', '', '0.000', '0.00', '0.00000', '0.0020', '0.000', '0.000', '0.000', '15367894550', 0, 1536908401, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100036, 100019, 0, '13925028090', 'TIC', '13925028090', '9f7941550e0d7c66f29e24088d60a762', '81b25a80a3d3302bb94f61bd4520af8e', '4q5BFY', '0x79a1b74697a88d3016f10a3a6382182ba08d0b09', '', '0.000', '13.00', '0.01220', '0.0020', '0.000', '0.000', '0.000', '13677337935', 0, 1536921174, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100037, 100017, 0, '13608174064', 'TIC', '13608174064', 'a7f2461fec33daf48b2a72554419882b', 'e10adc3949ba59abbe56e057f20f883e', 'pAaT3b', '0x4f357c2a6314d21335300877b97d2ca154f920bc', '', '0.000', '0.00', '0.00000', '0.0020', '0.000', '0.000', '0.000', '15367894550', 0, 1536926902, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100038, 100028, 0, '15200920305', 'TIC', '15200920305', '80c17e99f14ad6b2b5510f58c3318037', 'e10adc3949ba59abbe56e057f20f883e', '#$EcSx', '0x3b331a08c3c424b9a7778e52f643034bd21635cb', '', '0.000', '0.00', '0.00000', '0.0000', '0.000', '0.000', '0.000', '13487583399', 0, 1536979961, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100039, 100025, 0, '15074016316', 'TIC', '15074016316', '486e413092b94230364509e047e395bc', 'dc483e80a7a0bd9ef71d8cf973673924', 'Xcdwyu', '0x239e9f009813032d02554bc20c2cf62793f91fa7', '', '0.000', '16.00', '0.00000', '0.0000', '0.000', '0.000', '0.000', '13720223000', 0, 1536980231, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100040, 100019, 0, '13341315559', 'TIC', '13341315559', 'e4022e5c4eaf2851e71af02626f94021', 'd5945ee3c4803966f5c08ba21bd45218', '%i1WXy', '0xa16fa22e267516fc6dcc0ce44f6332c53c7ac8c8', '', '0.000', '0.00', '0.00000', '0.0000', '0.000', '0.000', '0.000', '13677337935', 0, 1536981172, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100041, 100019, 0, '15973118906', 'TIC', '15973118906', '091d6e4c7b433e93e4ad14487a72160e', '2edd606a117f9264d03cf059b62888be', 'D2qmJz', '0x3022fd991cf5a5a1764bb9932601f6dc11ee7eb8', '', '0.000', '0.00', '0.00000', '0.0000', '0.000', '0.000', '0.000', '13677337935', 0, 1536981230, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100042, 100025, 1, '13606165222', 'TIC', '13606165222', '500935b5eebd28fd58204de907707856', '0c0829e8571a8297d905b228897323e2', '47og5Y', '0x8444f03378ab6c32a630151208e7a31c4a17bb0b', '', '0.000', '1.00', '3.00000', '0.0000', '0.000', '0.000', '0.000', '13720223000', 0, 1536990821, '0.0200', 0, 0, 0, 0, '0.000', '0.000'),
(100043, 100025, 0, '15973159933', 'TIC', '15973159933', 'b31e2457bb3b484d12b7c27939f0dd3f', 'e10adc3949ba59abbe56e057f20f883e', 'aXG28s', '0xee35c179a8b5bbe745d6143d502cc2875de7bbcb', '', '0.000', '60.00', '0.00000', '0.0000', '0.000', '0.000', '0.000', '13720223000', 0, 1536991264, '0.0200', 0, 0, 0, 0, '0.000', '0.000');

-- --------------------------------------------------------

--
-- Table structure for table `think_member_address`
--

CREATE TABLE `think_member_address` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `province` int(11) NOT NULL DEFAULT '0',
  `city` int(11) NOT NULL DEFAULT '0',
  `area` int(11) NOT NULL DEFAULT '0',
  `address` varchar(200) NOT NULL DEFAULT '',
  `zipcode` char(6) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '',
  `mobile` varchar(30) NOT NULL DEFAULT '',
  `is_default` tinyint(4) NOT NULL DEFAULT '0',
  `add_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_member_card`
--

CREATE TABLE `think_member_card` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL COMMENT '账号id',
  `username` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '姓名',
  `card` varchar(100) NOT NULL DEFAULT '' COMMENT '银行卡',
  `khh` varchar(200) NOT NULL DEFAULT '' COMMENT '开户行',
  `khzh` varchar(200) NOT NULL DEFAULT '' COMMENT '开支户行'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_member_card`
--

INSERT INTO `think_member_card` (`id`, `uid`, `username`, `name`, `card`, `khh`, `khzh`) VALUES
(6, 100013, '18516067713', '孟楠', '4656', '565', '686');

-- --------------------------------------------------------

--
-- Table structure for table `think_member_fandian`
--

CREATE TABLE `think_member_fandian` (
  `id` int(11) NOT NULL COMMENT 'id',
  `uid` int(11) NOT NULL COMMENT '获利ID',
  `cid` int(11) NOT NULL COMMENT '返点id',
  `sid` int(11) NOT NULL COMMENT '根入单用户id',
  `num` decimal(10,4) NOT NULL COMMENT '返点数量',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '返点时间',
  `type` tinyint(1) NOT NULL COMMENT '1挖矿算力 2贡献算力'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_member_fandian`
--

INSERT INTO `think_member_fandian` (`id`, `uid`, `cid`, `sid`, `num`, `add_time`, `create_time`, `type`) VALUES
(1, 100013, 100014, 0, '700.0000', 1536239600, '2018-09-07 06:36:30', 1),
(2, 100000, 100012, 0, '1600.0000', 1536239600, '2018-09-07 06:36:35', 1),
(3, 100013, 100014, 0, '700.0000', 1536301411, '2018-09-07 06:23:31', 1),
(4, 100000, 100012, 0, '1600.0000', 1536301411, '2018-09-07 06:23:31', 1),
(5, 100013, 100014, 0, '700.0000', 1536301461, '2018-09-07 06:24:21', 1),
(6, 100000, 100012, 0, '1600.0000', 1536301461, '2018-09-07 06:24:21', 1),
(7, 100013, 100014, 0, '700.0000', 1536301532, '2018-09-07 06:25:32', 1),
(8, 100000, 100012, 0, '1600.0000', 1536301532, '2018-09-07 06:25:32', 1),
(9, 100013, 100016, 0, '700.0000', 1536304077, '2018-09-07 07:07:57', 1),
(10, 100000, 100012, 0, '1600.0000', 1536304077, '2018-09-07 07:07:57', 1),
(11, 100013, 100015, 0, '700.0000', 1536304087, '2018-09-07 07:08:07', 1),
(12, 100000, 100012, 0, '1600.0000', 1536304087, '2018-09-07 07:08:07', 1),
(13, 100013, 100014, 0, '700.0000', 1536304098, '2018-09-07 07:08:18', 1),
(14, 100000, 100012, 0, '1600.0000', 1536304098, '2018-09-07 07:08:18', 1),
(15, 100013, 100015, 0, '350.0000', 1536305851, '2018-09-07 07:37:31', 1),
(16, 100000, 100012, 0, '800.0000', 1536305851, '2018-09-07 07:37:31', 1),
(17, 100013, 100014, 0, '700.0000', 1536306627, '2018-09-07 07:50:27', 1),
(18, 100000, 100011, 0, '1600.0000', 1536306627, '2018-09-07 07:50:27', 1),
(19, 100013, 100014, 0, '700.0000', 1536306708, '2018-09-07 07:51:48', 1),
(20, 100000, 100011, 0, '1600.0000', 1536306708, '2018-09-07 07:51:48', 1),
(21, 100013, 100014, 0, '700.0000', 1536306808, '2018-09-07 07:53:28', 1),
(22, 100011, 100012, 0, '1600.0000', 1536306808, '2018-09-07 07:53:28', 1),
(23, 100000, 100011, 0, '300.0000', 1536306808, '2018-09-07 07:53:28', 1),
(24, 100013, 100014, 0, '700.0000', 1536307000, '2018-09-07 07:56:40', 1),
(25, 100011, 100012, 0, '900.0000', 1536307000, '2018-09-07 07:56:40', 1),
(26, 100000, 100011, 0, '1000.0000', 1536307000, '2018-09-07 07:56:40', 1),
(27, 100013, 100014, 0, '1600.0000', 1536307097, '2018-09-07 07:58:17', 1),
(28, 100012, 100013, 0, '200.0000', 1536307097, '2018-09-07 07:58:17', 2),
(29, 100011, 100012, 0, '1000.0000', 1536307097, '2018-09-07 07:58:17', 1),
(30, 100017, 100018, 0, '700.0000', 1536307283, '2018-09-07 08:01:23', 1),
(31, 100016, 100017, 0, '900.0000', 1536307283, '2018-09-07 08:01:23', 1),
(32, 100011, 100012, 0, '1000.0000', 1536307283, '2018-09-07 08:01:23', 1),
(33, 100000, 100011, 0, '200.0000', 1536307283, '2018-09-07 08:01:23', 2),
(34, 100000, 100019, 0, '780.0000', 1536461711, '2018-09-09 02:55:11', 1),
(35, 100017, 100018, 0, '70.0000', 1536471822, '2018-09-09 05:43:42', 1),
(36, 100016, 100017, 0, '90.0000', 1536471822, '2018-09-09 05:43:42', 1),
(37, 100011, 100012, 0, '100.0000', 1536471822, '2018-09-09 05:43:42', 1),
(38, 100000, 100011, 0, '20.0000', 1536471822, '2018-09-09 05:43:42', 2),
(39, 100000, 100011, 0, '20.0000', 1536471862, '2018-09-09 05:44:22', 2),
(40, 100000, 100011, 0, '260.0000', 1536471862, '2018-09-09 05:44:22', 1),
(41, 100000, 100019, 0, '999999.9999', 1536718039, '2018-09-12 02:07:19', 1),
(42, 100000, 100019, 0, '260.0000', 1536718819, '2018-09-12 02:20:19', 1),
(43, 100000, 100019, 0, '2600.0000', 1536718936, '2018-09-12 02:22:16', 1),
(44, 100000, 100019, 0, '0.0200', 1536719242, '2018-09-12 02:27:22', 2),
(45, 100000, 100019, 0, '0.2600', 1536719242, '2018-09-12 02:27:22', 1),
(46, 100000, 100011, 0, '26.0000', 1536720632, '2018-09-12 02:50:32', 1),
(47, 100019, 100023, 0, '42.0000', 1536720862, '2018-09-12 02:54:22', 2),
(48, 100019, 100023, 0, '546.0000', 1536720862, '2018-09-12 02:54:22', 1),
(49, 100019, 100023, 0, '650.0000', 1536720941, '2018-09-12 02:55:41', 1),
(50, 100000, 100019, 0, '50.0000', 1536720941, '2018-09-12 02:55:41', 2),
(51, 100019, 100022, 0, '50.0000', 1536721040, '2018-09-12 02:57:20', 2),
(52, 100019, 100022, 0, '650.0000', 1536721040, '2018-09-12 02:57:20', 1),
(53, 100019, 100024, 0, '546.0000', 1536721416, '2018-09-12 03:03:36', 1),
(54, 100000, 100019, 0, '42.0000', 1536721416, '2018-09-12 03:03:36', 2),
(55, 100019, 100024, 0, '54600.0000', 1536721447, '2018-09-12 03:04:07', 1),
(56, 100000, 100019, 0, '4200.0000', 1536721447, '2018-09-12 03:04:07', 2),
(57, 100019, 100024, 0, '24000.0000', 1536721479, '2018-09-12 03:04:39', 2),
(58, 100019, 100024, 0, '312000.0000', 1536721479, '2018-09-12 03:04:39', 1),
(59, 100015, 100021, 0, '14700.0000', 1536721514, '2018-09-12 03:05:14', 1),
(60, 100013, 100014, 0, '18900.0000', 1536721514, '2018-09-12 03:05:14', 1),
(61, 100000, 100011, 0, '21000.0000', 1536721514, '2018-09-12 03:05:14', 1),
(62, 100019, 100024, 0, '40.0000', 1536731090, '2018-09-12 05:44:50', 2),
(63, 100019, 100024, 0, '520.0000', 1536731090, '2018-09-12 05:44:50', 1),
(64, 100019, 100022, 0, '650.0000', 1536731525, '2018-09-12 05:52:05', 1),
(65, 100000, 100019, 0, '50.0000', 1536731525, '2018-09-12 05:52:05', 2),
(66, 100000, 100028, 0, '2600.0000', 1536747800, '2018-09-12 10:23:20', 1),
(67, 100013, 100019, 0, '520.0000', 1536802676, '2018-09-13 11:01:32', 1),
(68, 100016, 100017, 100017, '160.0000', 1536913082, '2018-09-14 08:18:02', 1),
(69, 100000, 100011, 100017, '100.0000', 1536913082, '2018-09-14 08:18:02', 1),
(70, 100013, 100019, 100025, '8000.0000', 1536916526, '2018-09-14 09:15:26', 1),
(71, 100000, 100011, 100025, '5000.0000', 1536916526, '2018-09-14 09:15:26', 1),
(72, 100016, 100017, 100017, '7679.8400', 1536917269, '2018-09-14 09:27:49', 1),
(73, 100000, 100011, 100017, '4799.9000', 1536917269, '2018-09-14 09:27:49', 1),
(74, 100016, 100017, 100017, '3000.0000', 1536918451, '2018-09-14 09:47:31', 2),
(75, 100016, 100017, 100017, '24000.0000', 1536918451, '2018-09-14 09:47:31', 1),
(76, 100000, 100011, 100017, '15000.0000', 1536918451, '2018-09-14 09:47:31', 1),
(77, 100016, 100017, 100017, '0.0800', 1536987431, '2018-09-15 04:57:11', 2),
(78, 100016, 100017, 100017, '0.6400', 1536987431, '2018-09-15 04:57:11', 1),
(79, 100000, 100011, 100017, '0.4000', 1536987431, '2018-09-15 04:57:11', 1),
(80, 100025, 100042, 100042, '700.0000', 1536990867, '2018-09-15 05:54:27', 1),
(81, 100013, 100019, 100042, '900.0000', 1536990867, '2018-09-15 05:54:27', 1),
(82, 100000, 100011, 100042, '1000.0000', 1536990867, '2018-09-15 05:54:27', 1),
(83, 100016, 100017, 100017, '2.0000', 1536991071, '2018-09-15 05:57:51', 2),
(84, 100016, 100017, 100017, '16.0000', 1536991071, '2018-09-15 05:57:51', 1),
(85, 100000, 100011, 100017, '10.0000', 1536991071, '2018-09-15 05:57:51', 1);

-- --------------------------------------------------------

--
-- Table structure for table `think_member_getnum`
--

CREATE TABLE `think_member_getnum` (
  `uid` int(11) NOT NULL,
  `getnum` int(11) NOT NULL DEFAULT '0' COMMENT '直接下线会员数量',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_member_getnum`
--

INSERT INTO `think_member_getnum` (`uid`, `getnum`, `update_time`) VALUES
(100000, 5, '2018-09-12 10:08:37'),
(100013, 6, '2018-09-07 09:53:18'),
(100015, 1, '2018-09-10 02:46:41'),
(100017, 2, '2018-09-14 12:08:22'),
(100019, 10, '2018-09-15 03:13:50'),
(100025, 8, '2018-09-15 06:01:04'),
(100028, 1, '2018-09-15 02:52:41');

-- --------------------------------------------------------

--
-- Table structure for table `think_member_info`
--

CREATE TABLE `think_member_info` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL COMMENT '账号id',
  `username` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '姓名',
  `card_no` char(50) NOT NULL DEFAULT '' COMMENT '身份证号码',
  `WeChat` varchar(100) NOT NULL DEFAULT '' COMMENT '微信',
  `alipay` varchar(50) NOT NULL DEFAULT '' COMMENT '支付宝'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_member_info`
--

INSERT INTO `think_member_info` (`id`, `uid`, `username`, `name`, `card_no`, `WeChat`, `alipay`) VALUES
(1, 100019, '13677337935', '刘昊', '430121198709101057', '', ''),
(2, 100025, '13720223000', '余泓川', '430682198309040013', '', ''),
(3, 100000, '18163626560', '朱桢', '430725199301262511', '773780273', ''),
(4, 100016, '18890608054', '', '', '76', '1334444'),
(5, 100031, '18569077407', '陈涛涛', '42242919780925191X', '', ''),
(6, 100028, '13487583399', '阮开领', '430521198301114278', '', ''),
(7, 100017, '15367894550', '李阳洋', '510723199301021352', '', ''),
(8, 100015, '15897381680', '邹鹏飞', '432524199411204413', '', ''),
(9, 100039, '15074016316', '李钊', '430682198501035716', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `think_member_randmoney`
--

CREATE TABLE `think_member_randmoney` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `type` tinyint(1) NOT NULL COMMENT '类型 1 糖果 2 矿石 3算力币',
  `num` decimal(10,5) NOT NULL COMMENT '生成数量',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 未收取 2 已收取',
  `getway` tinyint(1) NOT NULL COMMENT '1算力  2签到 3分享  4推荐 5实名 6 激活 7注册',
  `pass_time` int(11) NOT NULL COMMENT '过期时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '生成时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_member_randmoney`
--

INSERT INTO `think_member_randmoney` (`id`, `uid`, `type`, `num`, `status`, `getway`, `pass_time`, `create_time`) VALUES
(1, 100000, 1, '103.00000', 1, 1, 1536149848, '2018-09-05 09:52:59'),
(2, 100011, 2, '142.00000', 1, 1, 1536149848, '2018-09-05 09:52:59'),
(3, 100012, 2, '18.00000', 1, 1, 1536149848, '2018-09-05 09:52:59'),
(4, 100013, 2, '132.00000', 1, 1, 1536149848, '2018-09-12 09:23:43'),
(5, 100014, 2, '0.01774', 1, 1, 1536149848, '2018-09-05 09:52:59'),
(6, 100015, 2, '0.01276', 1, 1, 1536149848, '2018-09-05 09:52:59'),
(7, 100016, 2, '0.01114', 1, 1, 1536149848, '2018-09-05 09:52:59'),
(8, 100017, 2, '0.01469', 1, 1, 1536149848, '2018-09-05 09:52:59'),
(9, 100000, 2, '147.00000', 1, 1, 1536163201, '2018-09-05 09:52:59'),
(10, 100011, 2, '113.00000', 1, 1, 1536163201, '2018-09-05 09:52:59'),
(11, 100012, 2, '7.00000', 1, 1, 1536163201, '2018-09-05 09:52:59'),
(12, 100013, 2, '106.00000', 1, 1, 1536163201, '2018-09-05 03:22:51'),
(13, 100014, 2, '0.01241', 1, 1, 1536163201, '2018-09-05 09:52:59'),
(14, 100015, 2, '0.01388', 1, 1, 1536163201, '2018-09-05 09:52:59'),
(15, 100016, 2, '0.01051', 1, 1, 1536163201, '2018-09-05 09:52:59'),
(16, 100017, 2, '0.01059', 1, 1, 1536163201, '2018-09-05 09:52:59'),
(19, 100012, 2, '7.00000', 1, 1, 1536202522, '2018-09-05 09:52:59'),
(20, 100013, 2, '124.00000', 1, 1, 1536202522, '2018-09-05 03:22:55'),
(21, 100013, 2, '0.01332', 1, 1, 1536214159, '2018-09-06 03:24:06'),
(22, 100015, 2, '0.01888', 1, 1, 1536202522, '2018-09-05 09:52:59'),
(23, 100013, 2, '0.01488', 1, 1, 1536214159, '2018-09-12 09:23:51'),
(24, 100013, 2, '0.01971', 1, 1, 1536214159, '2018-09-12 09:23:54'),
(31, 100013, 2, '48.00000', 1, 1, 1536214159, '2018-09-12 09:23:59'),
(32, 100000, 2, '103.00000', 1, 1, 1536249601, '2018-09-05 09:52:59'),
(33, 100011, 2, '126.00000', 1, 1, 1536249601, '2018-09-05 09:52:59'),
(34, 100012, 2, '22.00000', 1, 1, 1536249601, '2018-09-05 09:52:59'),
(35, 100013, 2, '113.00000', 1, 1, 1536249601, '2018-09-11 11:22:19'),
(36, 100014, 2, '0.01699', 1, 1, 1536249601, '2018-09-05 09:52:59'),
(37, 100013, 2, '0.01961', 1, 1, 1536377440, '2018-09-11 11:22:17'),
(38, 100013, 2, '0.01633', 1, 1, 1536377440, '2018-09-11 11:22:08'),
(39, 100013, 2, '0.01575', 1, 1, 1536377440, '2018-09-11 11:22:05'),
(40, 100013, 2, '135.00000', 2, 1, 1536830367, '2018-09-12 10:12:06'),
(41, 100013, 2, '103.00000', 2, 1, 1536830367, '2018-09-13 07:50:47'),
(42, 100013, 2, '17.00000', 2, 1, 1536830367, '2018-09-12 09:48:09'),
(43, 100013, 2, '116.00000', 2, 1, 1536830367, '2018-09-13 07:50:50'),
(44, 100013, 2, '142.00000', 2, 1, 1536830367, '2018-09-12 09:38:22'),
(45, 100013, 2, '0.01636', 2, 1, 1536830367, '2018-09-12 09:39:03'),
(48, 100013, 1, '64.00000', 1, 2, 1536377440, '2018-09-12 09:23:06'),
(49, 100013, 1, '36.00000', 1, 2, 1536377440, '2018-09-12 09:23:06'),
(50, 100000, 2, '101.00000', 1, 1, 1536422401, '2018-09-06 16:00:01'),
(51, 100011, 2, '119.00000', 1, 1, 1536422401, '2018-09-06 16:00:01'),
(52, 100012, 2, '28.00000', 1, 1, 1536422401, '2018-09-06 16:00:01'),
(53, 100013, 2, '119.00000', 2, 1, 1536830367, '2018-09-13 03:55:59'),
(54, 100014, 2, '147.00000', 1, 1, 1536422401, '2018-09-06 16:00:02'),
(55, 100015, 2, '0.01254', 2, 1, 1536422401, '2018-09-07 09:27:53'),
(56, 100016, 2, '0.01810', 2, 1, 1536422401, '2018-09-07 02:50:11'),
(57, 100017, 2, '0.01747', 1, 1, 1536422401, '2018-09-06 16:00:02'),
(58, 100016, 1, '44.00000', 2, 2, 1536461297, '2018-09-07 02:49:27'),
(59, 100013, 1, '75.00000', 1, 2, 1536461606, '2018-09-12 09:23:06'),
(60, 100013, 1, '50.00000', 1, 4, 1536463606, '2018-09-12 09:23:06'),
(61, 100015, 1, '40.00000', 2, 2, 1536485269, '2018-09-07 09:33:37'),
(62, 100000, 1, '50.00000', 1, 4, 1536486372, '2018-09-07 09:46:12'),
(63, 100019, 1, '48.00000', 2, 2, 1536486387, '2018-09-07 09:46:50'),
(64, 100013, 1, '50.00000', 1, 4, 1536486798, '2018-09-12 09:23:06'),
(65, 100020, 1, '97.00000', 2, 2, 1536486817, '2018-09-07 09:53:53'),
(66, 100019, 1, '52.00000', 1, 2, 1536569818, '2018-09-10 10:16:00'),
(67, 100019, 1, '27.00000', 2, 2, 1536634043, '2018-09-09 02:47:42'),
(68, 100013, 1, '96.00000', 1, 2, 1536658591, '2018-09-12 09:23:06'),
(69, 100019, 1, '100.00000', 2, 2, 1536716363, '2018-09-10 10:17:27'),
(70, 100013, 1, '40.00000', 1, 2, 1536716474, '2018-09-12 09:23:06'),
(71, 100015, 2, '50.00000', 2, 4, 1536720401, '2018-09-11 02:32:37'),
(72, 100015, 2, '24.00000', 2, 2, 1536725747, '2018-09-11 01:31:43'),
(73, 100015, 2, '24.00000', 2, 2, 1536725747, '2018-09-11 01:30:04'),
(74, 100015, 1, '24.00000', 2, 2, 1536725747, '2018-09-11 01:30:01'),
(75, 100015, 1, '24.00000', 2, 2, 1536725747, '2018-09-11 01:30:56'),
(76, 100015, 1, '24.00000', 2, 2, 1536725747, '2018-09-11 01:31:47'),
(77, 100013, 1, '24.00000', 1, 2, 1536725747, '2018-09-12 09:23:06'),
(78, 100013, 1, '42.00000', 1, 2, 1536733775, '2018-09-12 09:23:06'),
(79, 100019, 1, '7.00000', 2, 2, 1536797215, '2018-09-11 00:07:13'),
(80, 100019, 1, '50.00000', 2, 4, 1536804572, '2018-09-11 02:57:48'),
(81, 100000, 2, '89.00000', 2, 1, 1536828402, '2018-09-12 10:12:43'),
(82, 100011, 2, '34.00000', 1, 1, 1536828402, '2018-09-11 08:46:42'),
(83, 100012, 2, '0.01357', 1, 1, 1536828402, '2018-09-11 08:46:42'),
(84, 100013, 2, '35.00000', 2, 1, 1536828402, '2018-09-12 09:37:58'),
(85, 100014, 2, '0.01789', 1, 1, 1536828402, '2018-09-11 08:46:42'),
(86, 100015, 2, '0.01298', 2, 1, 1536828402, '2018-09-11 11:00:41'),
(87, 100016, 2, '0.01631', 2, 1, 1536828402, '2018-09-11 09:35:35'),
(88, 100017, 2, '0.01140', 2, 1, 1536828402, '2018-09-12 07:09:51'),
(89, 100018, 2, '0.01705', 1, 1, 1536828402, '2018-09-11 08:46:42'),
(90, 100019, 2, '115.00000', 2, 1, 1536828402, '2018-09-11 10:13:08'),
(91, 100020, 2, '0.01497', 2, 1, 1536828402, '2018-09-12 09:12:35'),
(92, 100021, 2, '0.01300', 1, 1, 1536828402, '2018-09-11 08:46:42'),
(93, 100022, 2, '0.01597', 1, 1, 1536828402, '2018-09-11 08:46:42'),
(94, 100013, 1, '62.00000', 2, 2, 1536830367, '2018-09-12 09:38:09'),
(95, 100016, 1, '2.00000', 2, 2, 1536831304, '2018-09-11 09:35:23'),
(96, 100019, 1, '50.00000', 2, 5, 1536839912, '2018-09-11 12:16:58'),
(97, 100019, 1, '50.00000', 2, 4, 1536842514, '2018-09-11 15:02:59'),
(98, 100000, 2, '79.00000', 2, 1, 1536855001, '2018-09-12 10:12:59'),
(99, 100011, 2, '33.00000', 1, 1, 1536855001, '2018-09-11 16:10:01'),
(100, 100019, 2, '111.00000', 2, 1, 1536855001, '2018-09-12 02:02:05'),
(101, 100020, 2, '0.01815', 2, 1, 1536855001, '2018-09-12 09:12:36'),
(102, 100012, 2, '0.01567', 1, 1, 1536855001, '2018-09-11 16:10:01'),
(103, 100013, 2, '41.00000', 2, 1, 1536855001, '2018-09-12 09:38:19'),
(104, 100014, 2, '0.01994', 1, 1, 1536855001, '2018-09-11 16:10:01'),
(105, 100015, 2, '0.01889', 2, 1, 1536855001, '2018-09-12 03:02:10'),
(106, 100016, 2, '0.01068', 2, 1, 1536855001, '2018-09-12 11:55:06'),
(107, 100021, 2, '0.01756', 1, 1, 1536855001, '2018-09-11 16:10:01'),
(108, 100017, 2, '0.01197', 2, 1, 1536855001, '2018-09-12 07:09:53'),
(109, 100018, 2, '0.01187', 1, 1, 1536855001, '2018-09-11 16:10:01'),
(110, 100022, 2, '0.01674', 1, 1, 1536855001, '2018-09-11 16:10:01'),
(111, 100023, 2, '0.01554', 1, 1, 1536855001, '2018-09-11 16:10:01'),
(112, 100013, 1, '86.00000', 2, 2, 1536892212, '2018-09-12 09:41:49'),
(113, 100019, 1, '50.00000', 2, 4, 1536893827, '2018-09-12 05:34:50'),
(114, 100024, 1, '68.00000', 2, 2, 1536893845, '2018-09-12 04:05:30'),
(115, 100019, 1, '50.00000', 2, 4, 1536907555, '2018-09-12 08:00:16'),
(116, 100025, 1, '13.00000', 2, 2, 1536907579, '2018-09-12 06:47:10'),
(117, 100025, 1, '50.00000', 2, 5, 1536908139, '2018-09-12 06:58:56'),
(118, 100019, 1, '50.00000', 2, 4, 1536908721, '2018-09-12 08:00:18'),
(119, 100017, 1, '67.00000', 2, 2, 1536909310, '2018-09-12 07:15:50'),
(120, 100019, 1, '50.00000', 2, 4, 1536915766, '2018-09-12 09:10:11'),
(121, 100000, 1, '50.00000', 2, 4, 1536919717, '2018-09-12 10:12:47'),
(122, 100028, 1, '17.00000', 2, 2, 1536919787, '2018-09-12 10:10:38'),
(123, 100000, 1, '66.00000', 2, 2, 1536919801, '2018-09-12 10:10:28'),
(124, 100000, 1, '50.00000', 2, 5, 1536919944, '2018-09-12 10:12:38'),
(125, 100020, 1, '76.00000', 1, 2, 1536923598, '2018-09-12 11:13:18'),
(126, 100016, 1, '50.00000', 2, 5, 1536923662, '2018-09-12 11:52:59'),
(127, 100016, 1, '13.00000', 2, 2, 1536926826, '2018-09-12 12:21:45'),
(128, 100026, 1, '91.00000', 2, 2, 1536934765, '2018-09-13 03:13:47'),
(129, 100000, 2, '61.00000', 2, 1, 1536941401, '2018-09-14 09:55:15'),
(130, 100011, 2, '31.00000', 1, 1, 1536941401, '2018-09-12 16:10:01'),
(131, 100019, 2, '118.00000', 2, 1, 1536941401, '2018-09-13 01:14:11'),
(132, 100020, 2, '0.01898', 1, 1, 1536941401, '2018-09-12 16:10:01'),
(133, 100028, 2, '56.00000', 2, 1, 1536941401, '2018-09-13 09:53:26'),
(134, 100012, 2, '0.01012', 1, 1, 1536941401, '2018-09-12 16:10:01'),
(135, 100013, 2, '0.01004', 2, 1, 1536941401, '2018-09-13 09:00:46'),
(136, 100014, 2, '0.01112', 1, 1, 1536941401, '2018-09-12 16:10:01'),
(137, 100015, 2, '0.01984', 2, 1, 1536941401, '2018-09-13 07:51:22'),
(138, 100016, 2, '0.01687', 2, 1, 1536941401, '2018-09-13 07:28:05'),
(139, 100021, 2, '123.00000', 1, 1, 1536941401, '2018-09-12 16:10:01'),
(140, 100017, 2, '0.01664', 2, 1, 1536941401, '2018-09-13 00:55:05'),
(141, 100018, 2, '0.01478', 1, 1, 1536941401, '2018-09-12 16:10:01'),
(142, 100022, 2, '26.00000', 1, 1, 1536941401, '2018-09-12 16:10:01'),
(143, 100024, 2, '100.00000', 1, 1, 1536941401, '2018-09-12 16:10:01'),
(144, 100025, 2, '0.01889', 2, 1, 1536941401, '2018-09-13 01:17:16'),
(145, 100026, 2, '0.01600', 2, 1, 1536941401, '2018-09-13 03:13:48'),
(146, 100027, 2, '0.01616', 1, 1, 1536941401, '2018-09-12 16:10:01'),
(147, 100017, 1, '27.00000', 2, 2, 1536972926, '2018-09-13 11:28:44'),
(148, 100025, 1, '74.00000', 2, 2, 1536974226, '2018-09-13 08:51:31'),
(149, 100013, 1, '39.00000', 2, 2, 1536974265, '2018-09-13 10:57:10'),
(150, 100025, 1, '50.00000', 2, 4, 1536975042, '2018-09-13 08:51:26'),
(151, 100026, 1, '79.00000', 1, 2, 1536981225, '2018-09-13 03:13:45'),
(152, 100015, 1, '82.00000', 2, 2, 1536996193, '2018-09-13 08:19:31'),
(153, 100016, 1, '12.00000', 2, 2, 1536996493, '2018-09-14 08:50:07'),
(154, 100013, 2, '0.01004', 2, 1, 1536941401, '2018-09-13 09:00:53'),
(155, 100013, 2, '0.01004', 2, 1, 1536941401, '2018-09-13 09:00:41'),
(156, 100025, 1, '50.00000', 2, 4, 1537003927, '2018-09-13 09:36:01'),
(157, 100025, 1, '50.00000', 2, 4, 1537003948, '2018-09-13 09:36:14'),
(158, 100031, 1, '56.00000', 2, 2, 1537003993, '2018-09-13 09:34:15'),
(159, 100030, 1, '9.00000', 2, 2, 1537004020, '2018-09-13 10:03:43'),
(160, 100031, 1, '50.00000', 2, 5, 1537004044, '2018-09-13 09:34:13'),
(161, 100019, 1, '12.00000', 2, 2, 1537006081, '2018-09-13 10:08:13'),
(162, 100025, 1, '50.00000', 2, 4, 1537006444, '2018-09-13 10:14:50'),
(163, 100032, 1, '31.00000', 2, 2, 1537006478, '2018-09-13 10:20:14'),
(164, 100028, 1, '50.00000', 2, 5, 1537009198, '2018-09-14 00:15:37'),
(165, 100025, 1, '50.00000', 2, 4, 1537019374, '2018-09-13 13:57:40'),
(166, 100033, 1, '88.00000', 1, 2, 1537019416, '2018-09-13 13:50:16'),
(167, 100000, 2, '71.00000', 2, 1, 1537027801, '2018-09-14 09:55:21'),
(168, 100011, 2, '47.00000', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(169, 100020, 2, '0.01130', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(170, 100028, 2, '50.00000', 2, 1, 1537027801, '2018-09-14 00:15:44'),
(171, 100012, 2, '0.01091', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(172, 100013, 2, '0.01404', 2, 1, 1537027801, '2018-09-15 02:38:32'),
(173, 100014, 2, '0.01918', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(174, 100019, 2, '0.01362', 2, 1, 1537027801, '2018-09-14 03:56:25'),
(175, 100015, 2, '0.01011', 2, 1, 1537027801, '2018-09-14 02:47:49'),
(176, 100016, 2, '0.01477', 2, 1, 1537027801, '2018-09-14 01:15:33'),
(177, 100021, 2, '142.00000', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(178, 100017, 2, '0.01489', 2, 1, 1537027801, '2018-09-13 23:51:47'),
(179, 100018, 2, '0.01667', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(180, 100022, 2, '22.00000', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(181, 100024, 2, '108.00000', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(182, 100025, 2, '0.01717', 2, 1, 1537027801, '2018-09-13 17:15:04'),
(183, 100026, 2, '0.01930', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(184, 100027, 2, '0.01573', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(185, 100029, 2, '0.01296', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(186, 100030, 2, '0.01465', 2, 1, 1537027801, '2018-09-14 03:47:07'),
(187, 100031, 2, '0.01129', 2, 1, 1537027801, '2018-09-15 00:49:26'),
(188, 100032, 2, '0.01156', 2, 1, 1537027801, '2018-09-14 09:17:48'),
(189, 100033, 2, '0.01807', 1, 1, 1537027801, '2018-09-13 16:10:01'),
(190, 100025, 1, '75.00000', 2, 2, 1537031665, '2018-09-13 17:15:16'),
(191, 100017, 1, '94.00000', 2, 2, 1537055510, '2018-09-13 23:52:12'),
(192, 100028, 1, '4.00000', 2, 2, 1537057050, '2018-09-14 06:42:25'),
(193, 100019, 1, '50.00000', 2, 4, 1537060367, '2018-09-14 03:56:19'),
(194, 100015, 1, '99.00000', 2, 2, 1537060694, '2018-09-14 02:42:38'),
(195, 100000, 1, '72.00000', 1, 2, 1537063426, '2018-09-14 02:03:46'),
(196, 100017, 1, '50.00000', 2, 5, 1537068847, '2018-09-14 05:21:13'),
(197, 100030, 1, '29.00000', 2, 2, 1537069622, '2018-09-14 08:44:25'),
(198, 100019, 1, '64.00000', 2, 2, 1537070188, '2018-09-14 03:56:40'),
(199, 100017, 1, '50.00000', 2, 4, 1537081201, '2018-09-14 07:47:21'),
(200, 100015, 1, '50.00000', 2, 5, 1537082579, '2018-09-14 08:06:27'),
(201, 100000, 2, '6.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(202, 100000, 2, '6.50000', 2, 1, 1537089064, '2018-09-14 09:55:24'),
(203, 100000, 2, '6.50000', 2, 1, 1537089064, '2018-09-14 09:55:21'),
(204, 100000, 2, '6.50000', 2, 1, 1537089064, '2018-09-14 09:55:15'),
(205, 100000, 2, '6.50000', 2, 1, 1537089064, '2018-09-14 09:55:18'),
(206, 100000, 2, '6.50000', 2, 1, 1537089064, '2018-09-14 09:55:16'),
(207, 100000, 2, '6.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(208, 100000, 2, '6.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(211, 100011, 2, '3.70000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(212, 100011, 2, '3.70000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(213, 100011, 2, '3.70000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(214, 100011, 2, '3.70000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(215, 100011, 2, '3.70000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(216, 100011, 2, '3.70000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(217, 100011, 2, '3.70000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(218, 100011, 2, '3.70000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(219, 100011, 2, '3.70000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(220, 100011, 2, '3.70000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(221, 100020, 2, '0.01009', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(222, 100028, 2, '3.00000', 2, 1, 1537089064, '2018-09-14 10:45:17'),
(223, 100028, 2, '3.00000', 2, 1, 1537089064, '2018-09-14 10:44:57'),
(224, 100028, 2, '3.00000', 2, 1, 1537089064, '2018-09-14 10:45:14'),
(225, 100028, 2, '3.00000', 2, 1, 1537089064, '2018-09-14 10:45:12'),
(226, 100028, 2, '3.00000', 2, 1, 1537089064, '2018-09-14 10:44:54'),
(227, 100028, 2, '3.00000', 2, 1, 1537089064, '2018-09-14 10:45:20'),
(228, 100028, 2, '3.00000', 2, 1, 1537089064, '2018-09-14 10:45:01'),
(229, 100028, 2, '3.00000', 2, 1, 1537089064, '2018-09-14 10:44:51'),
(230, 100028, 2, '3.00000', 2, 1, 1537089064, '2018-09-14 10:44:56'),
(231, 100028, 2, '3.00000', 2, 1, 1537089064, '2018-09-14 10:45:08'),
(232, 100012, 2, '0.01889', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(233, 100013, 2, '0.01547', 2, 1, 1537089064, '2018-09-15 03:51:22'),
(234, 100014, 2, '0.01054', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(235, 100019, 2, '0.01634', 2, 1, 1537089064, '2018-09-15 02:45:58'),
(236, 100015, 2, '0.01026', 2, 1, 1537089064, '2018-09-15 02:15:30'),
(237, 100016, 2, '0.01423', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(238, 100021, 2, '14.60000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(239, 100021, 2, '14.60000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(240, 100021, 2, '14.60000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(241, 100021, 2, '14.60000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(242, 100021, 2, '14.60000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(243, 100021, 2, '14.60000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(244, 100021, 2, '14.60000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(245, 100021, 2, '14.60000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(246, 100021, 2, '14.60000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(247, 100021, 2, '14.60000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(248, 100017, 2, '1.80000', 2, 1, 1537089064, '2018-09-14 09:14:13'),
(249, 100017, 2, '1.80000', 2, 1, 1537089064, '2018-09-14 09:14:18'),
(250, 100017, 2, '1.80000', 2, 1, 1537089064, '2018-09-14 09:14:08'),
(251, 100017, 2, '1.80000', 2, 1, 1537089064, '2018-09-14 09:14:11'),
(252, 100017, 2, '1.80000', 2, 1, 1537089064, '2018-09-14 09:14:15'),
(253, 100017, 2, '1.80000', 2, 1, 1537089064, '2018-09-14 09:14:08'),
(254, 100017, 2, '1.80000', 2, 1, 1537089064, '2018-09-14 09:14:14'),
(255, 100017, 2, '1.80000', 2, 1, 1537089064, '2018-09-14 09:14:08'),
(256, 100017, 2, '1.80000', 2, 1, 1537089064, '2018-09-14 09:14:08'),
(257, 100017, 2, '1.80000', 2, 1, 1537089064, '2018-09-14 09:14:08'),
(258, 100018, 2, '0.01313', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(259, 100035, 2, '0.01162', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(260, 100022, 2, '2.40000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(261, 100022, 2, '2.40000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(262, 100022, 2, '2.40000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(263, 100022, 2, '2.40000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(264, 100022, 2, '2.40000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(265, 100022, 2, '2.40000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(266, 100022, 2, '2.40000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(267, 100022, 2, '2.40000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(268, 100022, 2, '2.40000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(269, 100022, 2, '2.40000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(270, 100024, 2, '12.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(271, 100024, 2, '12.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(272, 100024, 2, '12.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(273, 100024, 2, '12.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(274, 100024, 2, '12.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(275, 100024, 2, '12.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(276, 100024, 2, '12.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(277, 100024, 2, '12.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(278, 100024, 2, '12.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(279, 100024, 2, '12.50000', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(280, 100025, 2, '0.01385', 2, 1, 1537089064, '2018-09-14 09:17:41'),
(281, 100026, 2, '0.01395', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(282, 100027, 2, '0.01355', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(283, 100034, 2, '0.01727', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(284, 100029, 2, '0.01648', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(285, 100030, 2, '0.01161', 2, 1, 1537089064, '2018-09-14 10:53:50'),
(286, 100031, 2, '0.01219', 2, 1, 1537089064, '2018-09-15 00:49:25'),
(287, 100032, 2, '0.01330', 2, 1, 1537089064, '2018-09-14 09:17:51'),
(288, 100033, 2, '0.01276', 1, 1, 1537089064, '2018-09-14 09:11:04'),
(289, 100019, 1, '50.00000', 2, 4, 1537093974, '2018-09-15 02:45:56'),
(290, 100036, 1, '13.00000', 2, 2, 1537094016, '2018-09-14 23:47:16'),
(291, 100034, 1, '30.00000', 1, 2, 1537094083, '2018-09-14 10:34:43'),
(292, 100017, 1, '50.00000', 2, 4, 1537099702, '2018-09-14 12:34:50'),
(293, 100000, 2, '7.20000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(294, 100000, 2, '7.20000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(295, 100000, 2, '7.20000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(296, 100000, 2, '7.20000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(297, 100000, 2, '7.20000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(298, 100000, 2, '7.20000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(299, 100000, 2, '7.20000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(300, 100000, 2, '7.20000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(301, 100000, 2, '7.20000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(302, 100000, 2, '7.20000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(303, 100011, 2, '4.30000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(304, 100011, 2, '4.30000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(305, 100011, 2, '4.30000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(306, 100011, 2, '4.30000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(307, 100011, 2, '4.30000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(308, 100011, 2, '4.30000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(309, 100011, 2, '4.30000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(310, 100011, 2, '4.30000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(311, 100011, 2, '4.30000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(312, 100011, 2, '4.30000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(313, 100020, 2, '0.01450', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(314, 100028, 2, '4.30000', 2, 1, 1537114201, '2018-09-15 02:45:42'),
(315, 100028, 2, '4.30000', 2, 1, 1537114201, '2018-09-15 02:45:53'),
(316, 100028, 2, '4.30000', 2, 1, 1537114201, '2018-09-15 02:45:50'),
(317, 100028, 2, '4.30000', 2, 1, 1537114201, '2018-09-15 02:45:39'),
(318, 100028, 2, '4.30000', 2, 1, 1537114201, '2018-09-15 02:45:45'),
(319, 100028, 2, '4.30000', 2, 1, 1537114201, '2018-09-15 02:45:51'),
(320, 100028, 2, '4.30000', 2, 1, 1537114201, '2018-09-15 02:45:48'),
(321, 100028, 2, '4.30000', 2, 1, 1537114201, '2018-09-15 02:45:43'),
(322, 100028, 2, '4.30000', 2, 1, 1537114201, '2018-09-15 02:45:37'),
(323, 100028, 2, '4.30000', 2, 1, 1537114201, '2018-09-15 02:45:32'),
(324, 100012, 2, '0.01392', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(325, 100013, 2, '0.01686', 2, 1, 1537114201, '2018-09-15 03:51:20'),
(326, 100014, 2, '0.01298', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(327, 100019, 2, '0.01472', 2, 1, 1537114201, '2018-09-15 02:45:54'),
(328, 100015, 2, '0.01833', 2, 1, 1537114201, '2018-09-15 02:15:34'),
(329, 100016, 2, '0.01361', 2, 1, 1537114201, '2018-09-15 05:33:41'),
(330, 100021, 2, '11.90000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(331, 100021, 2, '11.90000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(332, 100021, 2, '11.90000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(333, 100021, 2, '11.90000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(334, 100021, 2, '11.90000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(335, 100021, 2, '11.90000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(336, 100021, 2, '11.90000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(337, 100021, 2, '11.90000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(338, 100021, 2, '11.90000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(339, 100021, 2, '11.90000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(340, 100017, 2, '10.80000', 2, 1, 1537114201, '2018-09-15 03:36:22'),
(341, 100017, 2, '10.80000', 2, 1, 1537114201, '2018-09-15 03:36:21'),
(342, 100017, 2, '10.80000', 2, 1, 1537114201, '2018-09-15 03:36:19'),
(343, 100017, 2, '10.80000', 2, 1, 1537114201, '2018-09-15 03:36:20'),
(344, 100017, 2, '10.80000', 2, 1, 1537114201, '2018-09-15 03:36:24'),
(345, 100017, 2, '10.80000', 2, 1, 1537114201, '2018-09-15 03:36:20'),
(346, 100017, 2, '10.80000', 2, 1, 1537114201, '2018-09-15 03:36:20'),
(347, 100017, 2, '10.80000', 2, 1, 1537114201, '2018-09-15 03:36:21'),
(348, 100017, 2, '10.80000', 2, 1, 1537114201, '2018-09-15 03:36:22'),
(349, 100017, 2, '10.80000', 2, 1, 1537114201, '2018-09-15 03:36:23'),
(350, 100018, 2, '0.01984', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(351, 100035, 2, '0.01093', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(352, 100037, 2, '0.01572', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(353, 100022, 2, '0.60000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(354, 100022, 2, '0.60000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(355, 100022, 2, '0.60000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(356, 100022, 2, '0.60000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(357, 100022, 2, '0.60000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(358, 100022, 2, '0.60000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(359, 100022, 2, '0.60000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(360, 100022, 2, '0.60000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(361, 100022, 2, '0.60000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(362, 100022, 2, '0.60000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(363, 100024, 2, '11.50000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(364, 100024, 2, '11.50000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(365, 100024, 2, '11.50000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(366, 100024, 2, '11.50000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(367, 100024, 2, '11.50000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(368, 100024, 2, '11.50000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(369, 100024, 2, '11.50000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(370, 100024, 2, '11.50000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(371, 100024, 2, '11.50000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(372, 100024, 2, '11.50000', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(373, 100025, 2, '14.70000', 2, 1, 1537114201, '2018-09-14 17:32:13'),
(374, 100025, 2, '14.70000', 2, 1, 1537114201, '2018-09-14 17:32:03'),
(375, 100025, 2, '14.70000', 2, 1, 1537114201, '2018-09-14 17:32:09'),
(376, 100025, 2, '14.70000', 2, 1, 1537114201, '2018-09-14 17:32:15'),
(377, 100025, 2, '14.70000', 2, 1, 1537114201, '2018-09-14 17:32:01'),
(378, 100025, 2, '14.70000', 2, 1, 1537114201, '2018-09-14 17:31:51'),
(379, 100025, 2, '14.70000', 2, 1, 1537114201, '2018-09-14 17:32:11'),
(380, 100025, 2, '14.70000', 2, 1, 1537114201, '2018-09-14 17:31:57'),
(381, 100025, 2, '14.70000', 2, 1, 1537114201, '2018-09-14 17:32:04'),
(382, 100025, 2, '14.70000', 2, 1, 1537114201, '2018-09-14 17:32:17'),
(383, 100026, 2, '0.01250', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(384, 100027, 2, '0.01096', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(385, 100034, 2, '0.01338', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(386, 100036, 2, '0.01220', 2, 1, 1537114201, '2018-09-14 23:47:17'),
(387, 100029, 2, '0.01063', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(388, 100030, 2, '0.01137', 2, 1, 1537114201, '2018-09-14 17:09:46'),
(389, 100031, 2, '0.01096', 2, 1, 1537114201, '2018-09-15 00:49:25'),
(390, 100032, 2, '0.01306', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(391, 100033, 2, '0.01263', 1, 1, 1537114201, '2018-09-14 16:10:01'),
(392, 100030, 1, '13.00000', 2, 2, 1537118378, '2018-09-14 17:20:54'),
(393, 100025, 1, '96.00000', 2, 2, 1537119090, '2018-09-14 17:32:22'),
(394, 100017, 1, '98.00000', 2, 2, 1537140110, '2018-09-15 03:36:26'),
(395, 100031, 1, '73.00000', 2, 2, 1537145371, '2018-09-15 05:05:51'),
(396, 100015, 1, '78.00000', 1, 2, 1537150537, '2018-09-15 02:15:37'),
(397, 100013, 1, '64.00000', 2, 2, 1537151920, '2018-09-15 03:51:19'),
(398, 100028, 1, '50.00000', 2, 4, 1537152761, '2018-09-15 02:53:50'),
(399, 100025, 1, '50.00000', 2, 4, 1537153031, '2018-09-15 05:33:03'),
(400, 100039, 1, '66.00000', 2, 2, 1537153102, '2018-09-15 02:58:37'),
(401, 100039, 1, '50.00000', 2, 5, 1537153218, '2018-09-15 03:00:36'),
(402, 100019, 1, '50.00000', 1, 4, 1537153972, '2018-09-15 03:12:52'),
(403, 100019, 1, '52.00000', 1, 2, 1537154016, '2018-09-15 03:13:36'),
(404, 100019, 1, '50.00000', 1, 4, 1537154030, '2018-09-15 03:13:50'),
(405, 100041, 1, '51.00000', 1, 2, 1537154435, '2018-09-15 03:20:35'),
(406, 100016, 1, '64.00000', 1, 2, 1537162589, '2018-09-15 05:36:29'),
(407, 100025, 1, '50.00000', 2, 4, 1537163621, '2018-09-15 05:58:45'),
(408, 100025, 1, '50.00000', 1, 4, 1537164064, '2018-09-15 06:01:04'),
(409, 100043, 1, '60.00000', 2, 2, 1537164114, '2018-09-15 06:02:03'),
(410, 100042, 1, '98.00000', 1, 2, 1537164357, '2018-09-15 06:05:57');

-- --------------------------------------------------------

--
-- Table structure for table `think_member_tic`
--

CREATE TABLE `think_member_tic` (
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `storagetic` decimal(16,4) NOT NULL COMMENT '储存TIC',
  `circulatetic` decimal(16,4) NOT NULL COMMENT '流通TIC',
  `usetic` decimal(16,4) NOT NULL COMMENT '应用TIC',
  `update_time` datetime NOT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_member_tic`
--

INSERT INTO `think_member_tic` (`uid`, `storagetic`, `circulatetic`, `usetic`, `update_time`) VALUES
(100000, '21001.0000', '100063948.5799', '520.0000', '2018-08-29 00:00:00'),
(100011, '13100.0000', '0.0000', '0.0000', '2018-08-29 11:20:42'),
(100012, '1000.0000', '0.0000', '0.0000', '2018-08-29 11:21:17'),
(100013, '195.0000', '30598.6043', '13.8000', '2018-08-30 09:48:29'),
(100014, '1000.0000', '0.0000', '0.0000', '2018-08-30 12:13:03'),
(100015, '1000.0000', '204.8981', '0.0000', '2018-08-30 16:56:14'),
(100016, '1000.0000', '34858.5600', '0.0000', '2018-08-30 17:42:13'),
(100017, '201204.0000', '45044.0000', '4000.0000', '2018-09-03 13:58:46'),
(100018, '1000.0000', '0.0000', '0.0000', '2018-09-07 11:26:46'),
(100019, '1500.0000', '580.0000', '121520.0000', '2018-09-07 17:46:12'),
(100020, '1000.0000', '0.0000', '0.0000', '2018-09-07 17:53:18'),
(100021, '210000.0000', '0.0000', '0.0000', '2018-09-10 10:46:41'),
(100022, '2500.0000', '0.0000', '0.0000', '2018-09-11 10:09:32'),
(100024, '1414100.0000', '54665.5414', '12000.0000', '2018-09-12 10:57:07'),
(100025, '50001.0000', '5761.0000', '0.0000', '2018-09-12 14:45:55'),
(100026, '0.0000', '0.0000', '0.0000', '2018-09-12 15:05:21'),
(100027, '0.0000', '0.0000', '0.0000', '2018-09-12 17:02:46'),
(100028, '10200.0000', '802.0000', '0.0000', '2018-09-12 18:08:37'),
(100029, '0.0000', '0.0000', '0.0000', '2018-09-13 09:30:42'),
(100030, '0.0000', '0.0000', '0.0000', '2018-09-13 17:32:07'),
(100031, '0.0000', '1.0000', '0.0000', '2018-09-13 17:32:28'),
(100032, '0.0000', '0.0000', '0.0000', '2018-09-13 18:14:04'),
(100033, '0.0000', '0.0000', '0.0000', '2018-09-13 21:49:34'),
(100034, '0.0000', '0.0000', '0.0000', '2018-09-14 09:12:47'),
(100035, '0.0000', '0.0000', '0.0000', '2018-09-14 15:00:01'),
(100036, '0.0000', '0.0000', '0.0000', '2018-09-14 18:32:54'),
(100037, '0.0000', '0.0000', '0.0000', '2018-09-14 20:08:22'),
(100038, '0.0000', '0.0000', '0.0000', '2018-09-15 10:52:41'),
(100039, '0.0000', '1.0000', '0.0000', '2018-09-15 10:57:11'),
(100040, '0.0000', '0.0000', '0.0000', '2018-09-15 11:12:52'),
(100041, '0.0000', '0.0000', '0.0000', '2018-09-15 11:13:50'),
(100042, '10000.0000', '1327.0000', '0.0000', '2018-09-15 13:53:41'),
(100043, '0.0000', '0.0000', '0.0000', '2018-09-15 14:01:04');

-- --------------------------------------------------------

--
-- Table structure for table `think_message`
--

CREATE TABLE `think_message` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL DEFAULT '0',
  `username` char(50) NOT NULL COMMENT '账号',
  `admin_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(200) NOT NULL DEFAULT '',
  `email` varchar(200) NOT NULL DEFAULT '',
  `phone` varchar(200) NOT NULL DEFAULT '',
  `content` varchar(600) NOT NULL DEFAULT '',
  `content_admin` varchar(600) NOT NULL DEFAULT '' COMMENT '回复内容',
  `add_time` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0未阅读,1已回复'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_message`
--

INSERT INTO `think_message` (`id`, `uid`, `username`, `admin_id`, `name`, `email`, `phone`, `content`, `content_admin`, `add_time`, `state`) VALUES
(100000, 100017, '15367894550', 1, '', '', '', 'sfghjklh', '??\r\n', 1535966940, 1),
(100001, 100017, '15367894550', 1, '', '', '', 'jkdjfkdh', '的', 1535967032, 1);

-- --------------------------------------------------------

--
-- Table structure for table `think_money_log`
--

CREATE TABLE `think_money_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL COMMENT '账号id',
  `status` tinyint(1) NOT NULL COMMENT '1增加 2 减少',
  `ristatus` tinyint(1) NOT NULL COMMENT '类型id 1糖果 2 矿石 3 tic',
  `username` char(50) NOT NULL COMMENT '账号',
  `action` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '变动金额',
  `num` varchar(50) NOT NULL COMMENT '增减数量',
  `info` varchar(300) NOT NULL DEFAULT '' COMMENT '备注',
  `type` varchar(50) NOT NULL DEFAULT '0' COMMENT '类型',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '操作时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_money_log`
--

INSERT INTO `think_money_log` (`id`, `uid`, `status`, `ristatus`, `username`, `action`, `num`, `info`, `type`, `add_time`) VALUES
(1, 100000, 1, 3, '18163626560', '1000.000', '+1000', '哈哈哈[zengliangkeji]操作', '增加流通TIC', 1536664989),
(2, 100000, 2, 3, '18163626560', '1000.000', '-1000', '11[zengliangkeji]操作', '减少流通TIC', 1536665007),
(3, 100019, 1, 2, '13677337935', '100.000', '+100', '[zengliangkeji]操作', '增加矿石', 1536667945),
(4, 100019, 1, 2, '13677337935', '25.000', '+25', '[zengliangkeji]操作', '增加矿石', 1536668244),
(5, 100024, 1, 1, '15387528217', '60000.000', '+60000', '[zengliangkeji]操作', '增加糖果', 1536723600),
(6, 100024, 1, 2, '15387528217', '5000.000', '+5000', '[zengliangkeji]操作', '增加矿石', 1536723616),
(7, 100024, 1, 3, '15387528217', '70000.000', '+70000', '[zengliangkeji]操作', '增加流通TIC', 1536723631),
(8, 100000, 1, 1, '18163626560', '100.000', '+100', '333[zengliangkeji]操作', '增加糖果', 1536914870),
(9, 100025, 1, 3, '13720223000', '5000.000', '+5000', '[zengliangkeji]操作', '增加流通TIC', 1536916599),
(10, 100025, 1, 2, '13720223000', '1000.000', '+1000', '[zengliangkeji]操作', '增加矿石', 1536916637),
(11, 100017, 1, 3, '15367894550', '50000.000', '+50000', '[zengliangkeji]操作', '增加流通TIC', 1536917287),
(12, 100017, 1, 2, '15367894550', '2000.000', '+2000', '[zengliangkeji]操作', '增加矿石', 1536917307),
(13, 100017, 1, 1, '15367894550', '2000.000', '+2000', '[zengliangkeji]操作', '增加糖果', 1536917327),
(14, 100042, 1, 3, '13606165222', '1000.000', '+1000', '[zengliangkeji]操作', '增加流通TIC', 1536990881),
(15, 100042, 1, 1, '13606165222', '1000.000', '+1000', '[zengliangkeji]操作', '增加糖果', 1536990892),
(16, 100042, 1, 2, '13606165222', '1000.000', '+1000', '[zengliangkeji]操作', '增加矿石', 1536990901),
(17, 100042, 1, 1, '13606165222', '1.000', '+1', '[zengliangkeji]操作', '增加糖果', 1536991272),
(18, 100042, 1, 2, '13606165222', '2.000', '+2', '[zengliangkeji]操作', '增加矿石', 1536991320);

-- --------------------------------------------------------

--
-- Table structure for table `think_news`
--

CREATE TABLE `think_news` (
  `id` int(10) UNSIGNED NOT NULL,
  `cat_id` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `title` varchar(300) NOT NULL DEFAULT '',
  `title_tmp` varchar(200) NOT NULL DEFAULT '',
  `description` varchar(500) NOT NULL DEFAULT '',
  `thumb` varchar(200) NOT NULL DEFAULT '',
  `src` varchar(200) NOT NULL DEFAULT '',
  `publish_time` int(11) NOT NULL DEFAULT '0',
  `add_time` int(11) NOT NULL DEFAULT '0',
  `keywords` varchar(300) NOT NULL DEFAULT '',
  `resource` varchar(300) NOT NULL DEFAULT '',
  `img_resource` varchar(300) NOT NULL DEFAULT '',
  `author` varchar(200) NOT NULL DEFAULT '',
  `content` text,
  `is_recommend` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_news`
--

INSERT INTO `think_news` (`id`, `cat_id`, `title`, `title_tmp`, `description`, `thumb`, `src`, `publish_time`, `add_time`, `keywords`, `resource`, `img_resource`, `author`, `content`, `is_recommend`) VALUES
(12, 1, '软银中国携手增量科技共创未来', '', '软银中国携手增量科技共创未来', '/uploads/20180913/c80e68b9274b93586fa7f3ae856a45d3.png', '', 1531843200, 0, '软银中国 携手 增量科技  共创未来', '', '', '', '<p>&nbsp; &nbsp;&nbsp; 2018年7月16日下午，“增量科技”携手“软银中国”高端访谈会在增量科技总部路演大厅成功举行。会场大咖云集，掌声雷动，气氛爆棚。</p><p style=\"text-align: center;\">&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;<img title=\"1536803227744844.png\" alt=\"1536803149(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536803227744844.png\"/><br/></p><p>&nbsp; &nbsp; &nbsp; &nbsp; 梁总说：“只有把握住未来，只有跟大的趋势相融合，你才能成功，你才能得到你应有的价值。”他认为企业存在的价值在于解决社会痛点，解决的痛点越大，企业的价值就越大，他非常看好区块链领域，他讲区块链技术的特点天生就是为金融领域而生，区块链本身就带有信任特性，而金融的本质就是信任之间的互换，正好解决这一问题，增量区块链的理念及技术必将巅峰传统金融模式。</p><p>楚总从技术的角度重点介绍了区块链作为互联网革命性技术对未来生活产生的影响。最后，他对“增量科技”与“软银中国”本周末的签约携手表达了自己的良好祝愿。<br/></p><p>&nbsp; &nbsp; &nbsp;&nbsp; 吴总分享到：2000年的互联网可能代表了过去，移动互联网代表着现在，但区块链则代表了未来，未来已来，软银作为在互联网时代，移动互联网时代最为成功的投资机构之一，软银不可能对区块链视而不见。</p><p>&nbsp; &nbsp; &nbsp; 胡总分享了增量科技的发展前景、初衷和使命。他认为，从数据和技术的角度，区块链技术能够实现金融不良资产信息共享，能充分利用“区块链+金融”的模式，找到痛点并解决痛点，在这个过程中进行市场资源共建，在这种模式下，会逐步形成分领域、多维度，有创新模式及业态的区块链数字资产格局，然后这些链互通和共享，达成数字资产的乐园，笃信增量科技必将走在时代的前沿，在激烈的市场环境中位列前茅。<br/></p>', 1),
(14, 1, '增量科技第二轮员工考核圆满完成', '', '增量科技第二轮员工考核圆满完成', '/uploads/20180913/175a498c0c26a022d30a42c480851f2c.png', '', 1532880000, 0, '增量科技   第二轮员工  考核  圆满完成', '', '', '', '<p>7月30日12点30分，增量科技第二轮员工考核在公司路演大厅准时开始。本次考核是针对新来的公司员工以及大学生实习生安排的，其目的是为了全面提高员工对公司及其相关业务的了解，让员工更好的融入公司这个大集体。</p><p style=\"text-align: center;\"><img title=\"1536808862766971.png\" alt=\"1536808934(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536808862766971.png\"/></p><p>本次考核由综合部总监文华老师监考，与上次全员考试不一样的是，这次考试采取提问的方式对员工及大学生进行考核。提问者为上次已考核通过的员工。本次考核通过全员举手表决的方式，对被考核者的最终成绩进行评定，认为通过考核的评委，则举手示意表示通过，认为不行的，则不举手。最终不及格的被考核者，仍要受到辞退的严重处罚。<br/>对于本次考试，全体员工高度重视，以饱满的精神和严肃的态度认真回答问题。此次考核圆满完成。</p>', 1),
(15, 3, '投资 | 不良资产，站在银行肩膀上赚钱的行业', '', '不良资产，站在银行肩膀上赚钱的行业', '/uploads/20180913/bb4cb2bc184d4b4c7d921641ca5346bd.jpg', '', 1536768000, 0, '投资  不良资产 站在 银行肩膀  赚钱的行业', '', '', '', '<p style=\"text-align: center;\"><img title=\"1536819972855541.jpg\" alt=\"不良资产.jpg\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536819972855541.jpg\"/></p><p>金融圈曾有这样一句话很流行，保险公司跑着挣钱，证券公司坐着挣钱，银行躺着挣钱。</p><p>然而如今看来，最赚钱的金融行业既不是银行，也不是证券和保险，而是经营不良资产的坏账银行。</p><p>中国华融和中国信达公布的2016年业绩报告显示，净利润都有着双位数的增长，反观银行业，普华永道发布的2016年中国银行业回顾与展望报告显示，27家A股和港股上市银行的平均净利润同比增速仅有3.20%。</p><p>■ 站在银行肩膀上赚钱</p><p>中国华融资产管理股份有限公司2016年的年报显示，其总资产突破了1.4万亿元，较2015年年末增长62.9%。实现净利润超过 230 亿元，同比增长36.3%。</p><p>2016年，中国华融不良资产经营业务资产总额达人民币 6,287.1 亿元，较上年增长 71.8%，实现收入总额人民币507.0亿元，占比53.2%；不良债权资产经营业务新增投放人民币 3,480.2 亿元，较上年增长 55.1%。</p><p>事实上，中国华融的成长远比上述数据更加惊人。</p><p>2012年，中国华融的总资产只有3150.34亿元，到2016年这一数字增长了近3倍。即便是银行的黄金发展期，也没能达到如此速度。</p><p>尽管银行不良资产增速出现放缓迹象，但预计未来不良资产规模还将有所上升，我国的不良资产市场空间很大。</p><p>然而，随着近年来经济环境趋市场化，国家开放AMC牌照和监管准入门槛放开，不良资产处置这门垄断行业再次火热。</p><p>据业内测算，目前四大AMC资本总额约为3600亿元，按照12.5%资本充足率要求，最多可承接不良资产为3万亿元左右。</p><p>这样的承载能力，显然不足以消化不断增大的不良资产，估计仍有逾万亿级的市场空间提供给各类地方性资产管理机构以及民间机构。</p><p>故而，一眼望去，大有蓝海初现、资本竞逐之势，这场价值万亿特殊资产盛宴已然开席。</p><p>■ 民营AMC公司的快速扩张</p><p>据不完全统计，截至2017年10月底，全国已有近50家地方AMC正式成立，其中有14个省级行政区域至少已拥有两家地方AMC，浙江、广东、山东、福建4省更是拥有3家地方AMC。</p><p>据业内人士分析，2016年随着不良资产包价格上涨，配资业务成为部分AMC（包括民间机构）的重要利润来源，配资利率可高达8%至12%。</p><p>经济大环境决定了不良资产行业的兴起，行业兴起及政策鼓励，决定了不良资产处置二级市场的活跃。</p><p>商业银行、投资银行、证券公司、私募基金等金融机构，通过设立资产管理业务部或成立资产管理附属公司，参与不良资产二级市场业务，各地民营资管公司如雨后春笋般生长起来。</p><p>可以说，在新一轮不良资产的处置中，民营资产管理公司将扮演不可或缺的角色，相比于银行这类传统处置机构，其自身优势，尤其在终端处置环节的管理和退出上。</p><p>比如尽职调查、发现债务人财产、向债务人施压、资产盘活等，各家都有自己的独门绝技。</p><p>而这些民营的资产处理公司成了最先吃螃蟹，尝到AMC市场急速跑马圈地扩张甜头的公司。</p><p>■ 个人投资者的机会在哪里？</p><p>通常，不良资产会被设计成为信托或契约型基金的类固定收益产品。</p><p>作为个人投资者，投资以不良资产作为标的的类固定收益产品，最大优势在于该类产品的安全性和收益性有保障。</p><p>对现在的资管公司而言，它们都已经是老手，不管接收后结果是什么，前期会保证100%有抵押物以及50%的安全垫，高安全垫大大降低了损失的可能性，一张图可以清晰地明：</p><p style=\"text-align: center;\"><img title=\"1536820055290027.jpg\" alt=\"333333.jpg\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536820055290027.jpg\"/></p><p>同时，资金又全程托管给银行，施行封闭式监管，资金划转指令必须由托管行审核通过后方能对外支付，资金收付均按照基金合同执行。</p><p>此外，基金发起人通常会联手专业的资产管理机构。专业管理机构不仅在不良资产处置方面有专业优势和独家资源，还可以为基金提供流动性补充，保障基金还本付息。</p><p>而且，为规避单一资产收购的结构性缺陷，基金会投资多个资产包，从而获取稳健投资收益。另外，部分基金还会设计超额清收收益，让投资者获取高于基本收益的浮动收益。</p><p>目前来看，这两年是不良资产介入最有利的时期，因为这是企业最困难的阶段，也是可以以最廉价的价格买到不良资产包的时期。</p><p>高于普通类固收产品的年化收益率，以及较短的封闭期，灵活的投资方式，对于想要稳中求胜的投资者而言是个不错的配置选择。</p><p>不良资产处置产业链较长，众多机构都想参与到这场盛宴，通过私募基金方式对不良资产进行处置，需要整合银行、资产管理公司、服务商、专业评估机构、政府部门、国有企业、上市公司等多方面资源，投资团队要具备专业的尽职调查能力、精准的估价、定价能力，以及实现资产变现的跨行业整合能力。</p><p>处置团队需要的不仅仅是经验，还有法律关系的梳理、司法制度的推动、转让和定价能力、债务人的谈判能力、寻找潜在客户的资源推广能力等。这些综合素质直接导向是实现资金的快速有效退出，从而达到高额收益。</p><p><br/></p>', 1),
(16, 3, '央行数字货币研究所的两个大动作', '', '央行数字货币研究所的两个大动作\r\n', '/uploads/20180913/02e987f64bd9bdd0a5a9723070e90f76.png', '', 1536768000, 0, '央行数字 货币研究所  两个大动作', '', '', '', '<p style=\"text-align: center;\"><img title=\"1536820620754014.png\" alt=\"1536820666(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536820620754014.png\"/></p><p>核心观点：经济日报-中国经济网专栏作者盘和林认为，目前，我国对于区块链技术的研发和应用还处于起始阶段，即便是央行，也还在小心翼翼地探索。在这一阶段，不仅需要合理有序地开展区块链技术的研发应用，更需要监管机构制定完善的监管条例。区块链技术如果能够正确地应用，必将在未来引领金融创新，更好地驱动经济发展。</p><p>据报道，中国人民银行数字货币研究所近日已经在深圳成立了“深圳金融科技有限公司”。据悉，该公司还参与了贸易金融区块链等项目的开发。<br/>根据当前可以从网上获得的信息，“深圳金融科技有限公司”的注册时间为2018年6月15日，注册资本为200万元人民币。其经营范围为“金融科技相关技术开发、技术咨询、技术转让、技术服务；金融科技相关系统建设与运行维护”。<br/>事实上，央行在区块链领域的布局还不仅于此。9月4日，“湾区贸易金融区块链平台”在深圳上线进入试运行阶段；位于南京的金融科技研究创新中心于8月28日正式揭牌；而更早些的时候，央行数字货币研究所与上海票据交易所共同推动的“数字票据交易平台实验性生产系统”也在今年年初上线试运行。</p><p>从央行在区块链技术上开始布局的举动就可以看出，区块链技术被商业银行全面运用也只是时间上的问题。<br/>那么，红极一时的区块链到底是什么呢？狭义上来说，区块链是一种技术，即按照时间顺序将数据区块相连以形成链式数据结构，并辅以密码学的原理使其变为不可篡改和伪造的分布式账本；而从广义上来说，区块链技术只是一种基础，以这种基础结合现有的分布式账本、加密算法、P2P等技术之后形成新的数据库技术。简单说来，区块链是利用自身分布的数据节点实现网络数据的存储、验证、传递以及交流。</p><p>区块链技术是伴随着2009年比特币的横空出世而出现的。在比特币价格波动大、确认时间长和交易费用高等一系列弊端展现出来之后，作为比特币底层技术的区块链近年来逐渐独立于比特币，越来越多地单独出现在人们的视野中。<br/>区块链技术之所以受到金融机构以及互联网公司的青睐，还是源于其本身最重要的两个特点：<br/>第一，去中心化。这个词近年来被反复引用，只要是从业者都不会陌生。作为独立的技术，区块链不受中心管制，也不依赖于第三方机构，节省了维护成本。<br/>第二，安全性。区块链上的交易信息都是公开透明的，但各方信息都通过算法进行加密，实现了匿名，而想要篡改数据，必须至少控制全网51%及以上的数据节点。<br/>在互联网的普及应用下，诸如“人工智能”“大数据”等多项技术陆续出现。然而，商业银行系统对这些方面技术的应用有限，仍然是高度依赖于纸质文件、现有系统以及各种中介机构。</p><p>区块链技术的出现，为商业银行目前所存在的诸多问题提供了潜在解决方案。基于区块链技术的特点，商业银行若是能够成熟掌握运用该技术，很可能会带来颠覆性的改变。<br/>首先，区块链技术能够改变银行传统的业务模式，优化流程、降低成本，以往需要大量人力物力成本的经营模式将得到精简，整个系统将更加智能化。<br/>其次，区块链技术的安全性确保了交易的可靠性，分布式的数据结构令单点的破坏不会出现，在算法加密的加持下，安全性进一步提升，降低了银行包括流动性风险、信用风险在内的各项风险。<br/>再次，区块链技术使银行能够尽早摆脱对各种中介机构的依赖，这也将直接导致各种结算支付系统的变革。<br/>最后，随着“互联网+”的快速发展，便捷高效的服务已经成为客户的重要需求，对于银行业来说，传统的柜台业务已经不能满足客户的需要，灵活多变的服务场景才是客户的最终诉求，而区块链为这样的场景在未来成为可能提供了技术上的支持。</p><p>目前，我国对于区块链技术的研发和应用还处于起始阶段，即便是央行，对于区块链技术也还在小心翼翼地探索。在这一阶段，不仅需要合理有序地开展区块链技术的研发应用，更需要监管机构制定完善的监管条例，避免区块链技术被不当使用。区块链技术一直以来都被视为很可能颠覆金融领域现有格局的重要技术，如果能够正确地应用，必将在未来引领金融创新，更好地驱动经济发展。<br/>有人说，央行成立的数字货币研究所一直是“犹抱琵琶半遮面”的感觉，而最近研究所的两个动作也引来业界目光。</p><p>南京市金融发展办公室官网，2018年8月28日下午，由南京市人民政府、南京大学、江苏银行、中国人民银行南京分行、中国人民银行数字货币研究所(以下简称央行数字货币研究所)五方合作共建的“南京金融科技研究创新中心”暨“中国人民银行数字货币研究所(南京)应用示范基地”揭牌仪式在江北新区举行。</p><p>南京金融科技研究创新中心依托南京大学在区块链、数字加密、大数据、人工智能等方面的技术和人才优势，结合江苏银行、中国人民银行南京分行、央行数字货币研究所在金融科技方面的政策与需求，以移动互联网、区块链、大数据、人工智能等新型技术为支撑，重点研发数字货币加密算法和区块链底层核心技术，完成央行数字货币研究所布置的数字货币关键技术研究。同时，广泛开展金融科技课题研究、人员培训、场景应用试点，争取打造成为国内乃至全球金融科技研发及应用推广平台。</p><p>此外，从国家企业信用信息公示系统中看到，中国人民银行数字货币研究所还出资设立了“深圳金融科技有限公司”，其经营范围为“金融科技相关技术开发、技术咨询、技术转让、技术服务;金融科技相关系统建设与运行维护“，成立日期为2018年6月15日。</p><p>“支持金融机构加强对区块链、数字货币等新兴技术的研究探索。”曾写入“深圳市金融业发展‘十三五’规划”中。</p><p>今年两会期间的新闻发布会上，时任央行行长周小川曾介绍，央行比较早就动手关注金融科技方面的新技术，并组织了研讨会，成立了研究所，在这方面付出了力量，同时进行了多方案的研究，这首先表明央行对科技的总体态度。</p><p>同时，央行方面也很关注像区块链和分布式记账技术的应用。但与此同时，有关方面认为这些研发应该比较慎重，像比特币和其他一些分叉产品的东西出的太快，不够慎重，如果迅速扩大或者蔓延的话，有可能给消费者带来很大的负面的影响。同时，也许会对金融稳定、货币政策传导，都会产生一些不可预测的作用。</p><p>（中国财政科学研究院应用经济学博士后、经济日报-中国经济网专栏作者 盘和林）</p><p><br/></p>', 1),
(17, 1, '青春不散场|增量科技大学实习生表彰会', '', '增量科技大学实习生表彰会', '/uploads/20180913/ff35f5a465b24d1612d48044f6484a37.png', '', 1533830400, 0, '青春不散场 增量科技 大学实习生 表彰会', '', '', '', '<p style=\"text-align: center;\"><img title=\"1536821772292637.png\" alt=\"1536821696(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536821772292637.png\"/></p><p style=\"text-align: justify;\">2018年8月9日上午，来自湖南工程职业技术学院，湖南信息学院，湖南农业大学等多所高校的大学实习生，实习考核表彰大会在增量科技路演大厅举行，由CEO胡添翼先生亲自主持并为优秀大学实习生颁奖。<br/></p><p style=\"text-align: justify;\">表彰大会上，胡总表示：“增量科技永远是你们的家！”并希望大学生们返校后，对自己的人生提前做好规划，制定目标，一步一脚印。同时胡总用发生在身边的案列告诉大家，冷静地对待事物，客观的评估自己，热情的面对生活。我们要做的，是满怀信心，迎接挑战。路漫漫其修远兮，满怀斗志，充满信心，勇往直前！</p><p style=\"text-align: center;\"><img title=\"1536821714545812.png\" alt=\"1536821644(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536821714545812.png\"/></p><p style=\"text-align: center;\">胡总为优秀实习生颁奖<br/></p><p style=\"text-align: left;\">感谢这群活泼的大学生这一个多月来对公司的付出，同时，我也相信，他们在这里所学到的技能、认识的伙伴和领悟的道理，会构成这一生难以忘记的一段回忆，愿你们每个人都前程似锦。</p>', 1),
(18, 2, '增量链TIChain：用区块链技术重构下一代金融服务体系', '', '增量链TIChain：用区块链技术重构下一代金融服务体系', '/uploads/20180913/068233c9ef1d84705034600c05b948e2.jpg', '', 1536768000, 0, '增量链TIChain  区块链技术 重构  下一代   金融服务体系', '', '', '', '<p>金融服务产业是全球经济发展的动力，也是中心化程度最高的产业之一。金融市场中交易双方的信息不对称导致无法建立有效的信用机制，产业链条中存在大量中心化的信用中介和信息中介，减缓了系统运转效率，增加了资金往来成本。<br/>区块链技术去中心化、点对点、不可篡改、数据可溯源等机制的属性，为去中心化的信任机制提供了可能，具备改变金融基础架构的潜力，各类金融资产，如股权、债券、票据、仓单、基金份额等均可以被整合进区块链账本中，成为链上的数字资产，在区块链上进行存储、转移、交易，使区块链技术在金融领域的应用前景广阔。</p><p style=\"text-align: center;\"><img title=\"1536822276900858.jpg\" alt=\"5555555.jpg\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536822276900858.jpg\"/></p><p>如何在区块链时代持续创新，赋予金融服务产业新的发展和未来，增量链被寄予厚望。<br/><strong>01<br/>增量链TIChain是什么？</strong><br/>The Incremental Chain（简称增量链：TIC）是全球首个基于区块链技术驱动的专注金融资产数字化的社区平台，用于整合未来金融机构，致力于打造成全球金融领域第一链，用区块链技术重构下一代金融服务体系。<br/>该生态平台将使用新创建的加密数字货币TIC，其创建目的是用于将生态内企业的资产数字化，与生态内企业资产置换、生态联盟企业商业场景使用，打通多方的金融权益资产流通，使多方的金融权益资产能够通过资产数字化达到共赢。<br/>增量链TIChain由增量链全球基金在海外发起，该基金会将作为社区金融资产数字化的执行机构，遵循去中心化、点对点、不可篡改、数据可溯源等机制，使用基金会节点票选机制向社区公布账本，TIChain 将成为这一领域的领先社区。 <br/><strong>02<br/>增量链TIChain的价值？</strong><br/>作为专注于全球金融资产数字化社区，将依据公开、诚信、透明的原则，通过不断的寻求更多共识者参与，持续注入优质资产作为类股权的流量凭证，将各自金融权益资产的一部分Token化，金融权益资产本身具投资备价值，且注入的优质权益资产均可产生收益，TIC持有者共享收益分红权，金融资产数字化带来的高流通性与共融性，使生态价值得到不断提升。据统计，目前注入增量链TIChain的金融权益资产规模约5个亿，为每一个TIC持有者共享。<br/>当前，在TIChain生态当中已包含软银中国、国家发改委旗下瞭望九州集团、湖南联合产权交易所、浙江和运投资、祥鑫资产管理集团、共青城志诚核工业基金管理、中国银行、工商银行、建设银行、交通银行、农业银行、民生银行、华融湘江银行、招商银行、光大银行、上海浦东发展银行等。<br/><strong>综上所述</strong><br/>增量链TIChain很可能成为2018年区块链领域内横空出世的一匹黑马，打造的“区块链+金融”这一生态模式获得软银中国资本青睐，一个用区块链技术重构的下一代金融服务体系社区指日可待。</p><p><br/></p>', 1),
(19, 2, '当音乐产业遇上区块链', '', '当音乐产业遇上区块链', '/uploads/20180913/31b0b42f8f6e149ba0bdaa82a0a5e92f.jpg', '', 1533139200, 0, '音乐产业 遇上 区块链', '', '', '', '<p>传统的音乐产业链分为三种，分别为唱片音乐链，音乐版权链以及音乐演出链。前两者为音乐产业链的核心，但在中国，盗版音乐直接摧毁了前两条核心的链。毫不夸张的说，盗版音乐毁了整个中国音乐市场。</p><p style=\"text-align: center;\"><img title=\"1536822706990915.jpg\" alt=\"3333333333.jpg\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536822706990915.jpg\"/></p><p>治理中国音乐产业，无外乎从法律和技术两方面着手，那么，区块链技术能对中国音乐产业带来什么变化呢？</p><p><strong>盗版音乐问题</strong></p><p>首先，区块链上的所有数据都有以下几个特点:唯一性，不可篡改，可被连贯追溯，永久有效，存在即不可抹杀，且可将资产数字化，形成某一种代币。就是说，也许在不远的将来，一首歌就是一个代币。</p><p>那么区块链如何来防盗版音乐呢？首先，音乐的原创者，可以将音乐上传到元界区块链系统中。然后在这个系统中会有一个能给该音乐文件进行采点或采样的智能合约，包括音乐元素的采集，音乐密度的采集等。</p><p>采集过来就把这些极简但是极重要的数据存在区块链上面。如果接下来再有音乐上传的话，智能合约会自动和之前上传过的音乐进行对比，如果检测出上传的内容涉及到侵犯音乐版权的话，这段视频或音频就不会被审批成功，在各大音乐平台就无法上架供用户使用。</p><p>&nbsp;也就是说，登记到区块链上的音乐形成了独有的版权，且这些版权永久存在，不可被篡改，独立且唯一。且这样一种音乐版权，经过登记将成为一种独一无二的数字资产，可以视其为一枚代币，类似于比特币的代币。这一种代币在市场上也有自己独有的价格可以进行流通。</p><p style=\"text-align: center;\"><img title=\"1536822721498911.jpg\" alt=\"3333333333.jpg\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536822721498911.jpg\"/></p><p><strong>音乐版权的授权和管理</strong></p><p>JAAK公司给出的解决方案为KORD——一套运行在区块链之上的公有数据网络。其允许用户将自己的权利信息添加到数据库当中，由网络规则检测其中的冲突信息。音乐行业对此表示高度关注，而McKenzie-Landell也因此被《福布斯》评选为今年的“30岁以下三十大杰出人物”，旨在表彰其给整个经济体系带来的颠覆性变革。</p><p>McKenzie-Landell指出，“我们正尝试解决一个基于软件的基础设施问题，即利用这套基础设施为用户提供全球性的版权归属视野。其能够实现的功能其实并不复杂，总结起来就是以极具可扩展性的方式实现全球授权。”</p><p><strong>简化版税支付链条</strong></p><p>作为稳定的P2P平台网络，区块链能够在音乐人和消费者群体之间构建起直接联系，从而保证音乐人能够非常及时便捷地收取消费者支付的版税酬劳，同时也避免了中间环节的克扣。</p><p>用户只要在区块链平台上提出请求，智能合约立马会将所请求的音乐作品权限开放给用户，同时将用户所支付的钱款直接汇入作品版权所有者的加密钱包中。这也是为什么Imogen Heap认为其Mycelia平台“正努力将整个音乐行业内的权力下放给音乐人，或至少将权力的天平倾向于音乐人，以帮助他们塑造更好的未来。”</p><p>除了移除支付链条上的中间环节之外，区块链技术的透明度和智能合约能够帮助音乐人的作品得到更加合理公平的使用，也能够允许消费者通过分类账证明其对某个音乐作品的合法使用权利。<br/>区块链的应用当然不仅仅局限于音乐产业上，在未来，它可以改变我生活的方方面面，让我们拭目以待！</p><p><br/></p>', 1),
(20, 1, '增量科技圆满完成首次全员考试工作', '', '增量科技完成首次全员考试', '/uploads/20180913/d07b738b46f545d685d82760c1db9f4f.png', '', 1531584000, 0, '增量科技 圆满完成 首次 全员考试工作', '', '', '', '<p style=\"text-align: center;\"><img title=\"1536823909836977.png\" alt=\"1536823984(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536823909836977.png\"/></p><p>为了全面提高员工对公司及其相关业务的了解，近日，公司对员工组织了一系列相关培训。7月13日下午一点，我司圆满完成了全员考试工作。</p><p>本次考试内容覆盖了公司基本信息、区块链相关知识以及一些主观问题。考试不及格者，则会受到辞退的严重惩罚，相反，第一名则会有600元的现金奖励。</p><p>对于本次考试，全体员工高度重视，以饱满的精神和严肃的态度认真应对本次考试，考试现场严肃安静。</p><p><br/></p>', 1),
(21, 1, '合作共赢   共创未来', '热烈欢迎瞭望九州集团领导莅临我司考察', '瞭望九州集团领导莅临我司考察', '/uploads/20180913/c8f55ed7972556952eb506a744a2149e.png', '', 1531324800, 0, '合作共赢 共创未来 热烈欢迎 瞭望九州集团 领导 莅临 增量科技 考察', '', '', '', '<p>&nbsp; &nbsp; &nbsp;&nbsp; 瞭望九州集团有限公司成立于2011年10月，注册地址为北京市西城区广安门内大街315号信息大厦，是由国家发改委中国经济导报社管理的一家集互联网文化传媒、管理咨询、电子商务、投资控股、金融理财、生活服务等综合型企业人集团。<br/></p><p>&nbsp; &nbsp; &nbsp;&nbsp; 7月5日，瞭望九州集团领导莅临我司进行为期三天的参观考察。增量科技董事长胡添翼、李副总、车总对瞭望集团领导的到来表示热烈欢迎，此次参观考察旨在全面考察增量科技的整体实力以及核心竞争力，双方就战略合作进行洽谈与展望。</p><p style=\"text-align: center;\"><img title=\"1536824392938049.png\" alt=\"1536824233(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536824392938049.png\"/></p><p style=\"text-align: center;\">与瞭望九州集团副总裁刘总、范总一行进行项目合作洽谈</p><p style=\"text-align: center;\"><img title=\"1536824418990842.png\" alt=\"1536824308(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536824418990842.png\"/></p><p style=\"text-align: center;\">实地考察增量投资默默吾声餐饮公司与员工合影<br/></p><p style=\"text-align: justify;\">&nbsp; &nbsp; 通过对增量科技与餐饮公司的参观考察，瞭望集团对增量科技的文化理念与核心技术及运营团队予以充分肯定及赞许。增量董事长向瞭望集团副总裁介绍公司的发展历程以及未来的战略规划，并强调增量科技将继续以互联网为战略核心，围绕移动互联网、区块链领域做全方位快速的布局。瞭望集团代表表示认同胡总的理论对公司定位准确，并达成后续沟通配合，全力以赴创建一个新的业务合作模式。</p>', 1),
(22, 1, '热烈欢迎武汉市场领导团队刘总一行莅临我司考察', '', '武汉市场领导人莅临我司考察', '/uploads/20180913/a22c18134d9c333661d63d82e83c1332.png', '', 1531238400, 0, '热烈欢迎 武汉市场领导 团队 刘总一行 莅临 我司考察', '', '', '', '<p style=\"text-align: center;\"><img title=\"1536825182993582.png\" alt=\"1536824920(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536825182993582.png\"/></p><p style=\"text-align: center;\">现场交流</p><p style=\"text-align: center;\"><img title=\"1536825261344702.png\" alt=\"1536825413(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536825261344702.png\"/></p><p style=\"text-align: center;\">商业运营模式</p><p>2018年7月9日上午，湖北.武汉市场团队领导刘总一行莅临增量科技参观交流，在总经理胡添翼先生等公司高管陪同下，刘总一行先后参观增量企业文化、近期落地项目、增量公司项目投资的“默默吾声”饮餐公司以及增量在2018年第三季度的工作部署，并听取了项目负责人实体落地项目的发展情况及未来的远景规划。<br/>考察期间湖北.武汉市场团队一行对公司的发展及规划表示高度认同，并通过沟通与交流达成战略合作关系。<br/></p>', 1),
(23, 1, '软银中国集团华东负责人吴总一行莅临我司考察指导', '', '软银中国吴总一行莅临我司考察指导', '/uploads/20180913/642975c8b318a663b1a618f3cb3edd18.png', '', 1531152000, 0, '软银中国集团 华东负责人 吴总一行 莅临 我司 考察指导', '', '', '', '<p>软银中国全称软银中国资本(SBCVC)。软银中国资本成立于2000年，是一家领先的风险投资和私募股权基金管理公司，致力于在大中华地区投资优秀的高成长、高科技企业。<br/>曾成功投资了阿里巴巴、淘宝网、分众传媒、万国数据、神雾、普丽盛、迪安诊断、理邦仪器等一系列优秀企业。如今软银中国资本同时管理着多支美元和人民币基金，投资领域包括信息技术、清洁技术、医疗健康、消费零售和高端制造等行业，投资阶段涵盖早期、成长期和中后期各个阶段。<br/>软银中国资本的运营总部位于上海，在北京、天津、苏州、重庆、成都、西安、杭州、宁波、深圳及台湾等地设有办事机构。<br/>7月8日软银中国华东负责人吴总莅临我司参观考察，总经理胡添翼先生、副总经理张龙兵先生及达摩院车德先生等高层一行陪同参观与会谈，达摩院车德先生、张总等高层领导为软银中国华东负责人吴总介绍增量科技的发展历程以及未来的战略规划。</p><p style=\"text-align: center;\"><img title=\"1536825942710831.png\" alt=\"1536825988(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536825942710831.png\"/></p><p style=\"text-align: center;\">达摩院车德先生为软银中国华东负责人吴总介绍增量科技</p><p style=\"text-align: center;\"><img title=\"1536825972408541.png\" alt=\"1536826064(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536825972408541.png\"/></p><p style=\"text-align: center;\">与软银集团华东负责人吴总合影留念<br/></p><p>通过对增量科技的参观与考察，软银中国华东负责人吴总对增量科技的文化理念与核心技术及运营团队给予高度赞扬及肯定。软银中国华东负责人吴总与达摩院车德先生为代表的高层领导会谈达成后续沟通配合，携手合作，双赢共创未来。</p>', 1),
(24, 3, '数字资产再次得到公认，中国市场马上要爆发？', '', '中国数字资产市场马上要爆发', '/uploads/20180913/4b0fd6c7e082af22109898c6979c00c3.jpg', '', 1536768000, 0, '数字资产 中国市场 爆发  区块链', '', '', '', '<p>在经济全球化和金融一体化的背景下，互联网金融已经是一个主导趋势。<br/>互联网金融最伟大之处在于，它让市场参与者更加大众化，更加惠及普通百姓。每一个人都可以借助互联网金融平台，展示，支援和分享自己喜欢的创意和产品，在大众化的市场力量的作用下，资源将得到最优配置。</p><p style=\"text-align: center;\"><img title=\"1536826469910563.jpg\" alt=\"金融资产.jpg\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536826469910563.jpg\"/></p><p>不管是否认同，互联网金融行业的确正在发生巨变，或许很多人仍然怀疑互联网金融的未来，怀疑其巨大的变革力量。其实，理解互联网金融，我们需要拥有想像力，而不是传统的演绎。<br/><strong>数字货币将会成全球电商标配：</strong><br/>因为全球的外汇管制实在是一件让人蛋疼的事情，而数字货币天然的突破外汇管制的互联网属性。用数字货币进行全球支付，那真是买家的福音，买家想买什么就买什么，买完了走货运到家。便宜啊!真便宜啊!!从网友买笔记本就可以看出，真是让人爽到极点。别说中间商不能剪羊毛，就是国家也不能剪羊毛!关税什么的可能该交还是要交，但是17%的销售增值税，哈哈，想跟老子要?门也没有!<br/>最终的市场，永远是由供求关系决定的，从一个买家的角度进行思考，你觉得全世界的电商们最后有可能拒绝数字货币支付吗?<br/>数字货币将会成为全球跨国贸易重要支付手段：<br/>国与国之间大宗商品的支付，极有可能成为未来数字货币的重要支付形式。因为数字货币的支付，与传统的银行业务相比，具有非常大的优势。<br/>传统业务要开展国际贸易，付款繁琐让人头疼，而数字货币支付呢？只要和几个数字货币支付中心签订一些现金转换协议，配合多重签名，付款过程中只要使用数字货币钱包的时候小心一点，不要加错小数点，就一切都会非常顺畅OK，多大的金额也不用愁心。<br/>而随着互联网发展的时间越长、生活形态越来越数字化，两种经济趋势正彼此冲击与融合：<br/>一是实体经济交易正在虚拟化，我们越频繁使用电子錢包、线上刷卡、支付系統<br/>二是数字形式的数字货币也一步步入侵实体经济，让人不必花真实的钱，也能进行实体消费。<br/>在这一股互联网金融的冲击下，产生了巨量的经济活动，因此也孕生了另一个颠覆传统实体产业的新颖产品——数字货币！<br/><strong>数字货币的财富已经到来</strong><br/>随着互联网技术的发展，国内外对数字货币都在大力推崇，数字货币取代纸质货币已是必然趋势。由各主权国家中央银行发行的数字货币更具革命性，将会对未来的各国及世界经济产生深远影响。未来，数字货币的应用可以让中央政府做到从宏观到微观时刻对国民经济进行调整。<br/><strong>数字资产来袭，把握机遇就是把握财富！</strong><br/>马云说：<br/>任何一次商机的到来，都必将经历四个阶段:“看不见“、“看不起“、“看不懂”、“来不及” ;希望你不是来不及的那个人！<br/>纵观历史，每一波财富浪潮来临的时候，只要把握了这个浪潮的人，哪个不是赚的盆满钵满！</p>', 1),
(25, 3, 'G20：数字货币能给全球经济带来重大益处', '', 'G20：数字货币能给全球经济带来重大益处', '/uploads/20180913/1aede4a127d1009d7b941df9d60ff0e9.jpg', '', 1536768000, 0, 'G20 数字货币 全球经济 带来 重大益处', '', '', '', '<p>7月21至22日，20国集团财政部长和央行行长会议在阿根廷首都布宜诺斯艾利斯召开。这是自2018年以来的第三次G20峰会，会议针对经济全球化的挑战和机遇等话题进行讨论。</p><p style=\"text-align: center;\"><img title=\"1536829742874524.jpg\" alt=\"77777777.jpg\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536829742874524.jpg\"/></p><p>二十国集团财政部长表示加密资产对世界经济的影响持谨慎且乐观的态度，阿根廷财政部长Dujovne在会议中表示，G20不认为加密资产构成全球性金融风险。<br/>看到这里，小伙伴们可以长松一口气了，看来，G20对数字货币的态度比我们想象之中的要乐观呀！<br/>本次报告还指出了加密市场存在的监管问题和价格波动问题，进一步指出加密资产在消费者和投资保护、市场完整性、逃税、洗钱以及恐怖主义融资等方面的挑战。<br/>G20还重申3月份的有关执行FATF标准的承诺，要求其三个月后即10月份明确其标准如何适用加密资产监管。</p>', 1),
(26, 2, '区块链，它将改变全人类！', '', '区块链，它将改变全人类！', '/uploads/20180913/9814d14ca83e029a3e7d0b619d25e8e8.png', '', 1536768000, 0, '区块链 改变 全人类', '', '', '', '<p>人人都谈区块链。<br/>但区块链到底是不是泡沫？<br/>有多大价值？值不值得投资？<br/>乐搏资本创始人、空中网创始人原总裁兼首席技术官、ChianRen创始人杨宁对区块链有着非常激进的看法：<br/>区块链就是当年的互联网<br/>区块链一定会让少数拥有绝大部分财富的资本家投资人成为历史的产物<br/>马克思缺的就是区块链！区块链将带领我们走向共和！</p><p>&nbsp; &nbsp; “区块链这么火，就像是当年的互联网。你能说互联网是泡沫吗？”</p><p style=\"text-align: center;\"><img title=\"1536830344781160.png\" alt=\"1536830467(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536830344781160.png\"/></p><p>&nbsp; &nbsp;&nbsp; 杨宁作为很早就接触区块链的“技术投资人”，对区块链项目早就有所预言：区块链热，那是因为区块链是大势所趋。</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 一夜之间，区块链、数字货币、ICO，成为当下最火的字眼。就连全球达沃斯论坛上，各国领导人都不讨论世界和平了，都在讨论区块链，可见区块链现在已然成为全球热潮。</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 区块链是什么：去中心化、分布式账本、智能合约……理论上不难理解，但杨宁表示：“很多人对区块链还是没有深入了解。”这是因为现阶段的区块链应用还是一团迷雾，区块链对于很多创业者来说，更像是一个科幻故事，听说过没见过，更想象不到。</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 区块链早在2009年就应用于比特币。说起当时的经历，杨宁也是感慨万千，表示“错过几个亿，因为当时根本没把比特币当回事。”</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 他说：“当时的比特币，有人说是骗局，有人说是数字黄金。那时我还在空中网，有人跟我讲比特币，我觉得这是个伪概念。2012年的时候，比特币开始涨，我仍然没有把它当回事……一直到2017年，数字货币开始沸腾了，这时候大家开始谈论的不只是比特币了，大家开始热议一个全新的概念：区块链。于是我开始深入了解并研究区块链，那时我才终于意识到：区块链，它将改变全人类。”</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 在他看来，区块链是与造纸术、灯泡、蒸汽机、计算机、互联网这些发明比肩，并将改变人类历史的产生。</p><p>区块链就像是一个分水岭，因为有了区块链，世界将发生翻天覆地的变化，带给人类不可估量的变革。<br/></p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 仿佛一夜之间，区块链成为所有创投圈茶余饭后的谈资，所有的媒体都开始报道区块链对未来的改变。你也许会想，为什么区块链突然变得来势汹汹？</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 但杨宁却说：“可以想象这次的浪潮来袭是什么样的，因为这已经是我第二次感受到这种凶猛了。第一次，就是在互联网到来的时候。”</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 回顾1999年，互联网还是一片贫瘠，那时候还没有淘宝阿里巴巴，腾讯还叫自己OICQ。杨宁就在那时创办了他第一个网站——ChinaRen，一跃成为全国流量第四的大型网站，仅次于搜狐新浪网易。</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 他说：“你猜那时候我们一天的流量是多少？十几万的流量。因为那时候全国网民就这么多，也就相当于现在一个大V随便发条微博的阅读吧。”</p><p>回顾他第一次拿到ChinaRen的投资，是美国高盛银行投了500万美金。</p><p>&nbsp;&nbsp;&nbsp; 他说：“那时美金兑换人民币的汇率还是1:8，而且是1999年的500万美金，放到现在，就相当于第一轮融资几个亿人民币。也就是说美国高盛银行出资几个亿，投资了一个他也不知道能不能成功的网站。仅仅因为这是一个互联网项目。</p><p>&nbsp;&nbsp;&nbsp; 当时高盛银行的一个负责董事看了我的公司介绍，惊讶的说，哇，你才24岁。但当时我还没过生日，准确说我只有23岁。一个有百年悠久历史的老牌保守美国银行，拿了几个亿给一个23岁年轻人做网站。这就是当时大家对互联网投资的热度。”</p><p>以铜为鉴,可以正衣冠;以人为鉴,可以明得失;以史为鉴，可以知兴替。</p><p>&nbsp;&nbsp;&nbsp; “现在你回头再看历史，你敢说互联网是泡沫吗？互联网给人类生活带来了巨大的改变，它为人类社会创造了无限大的价值，它改变了很多社会形态，互联网怎么可能是泡沫呢？它是伟大的历史颠覆性产物！”杨宁表示，今天我们对区块链的态度，就是当年我们对互联网的态度。<br/>&nbsp;&nbsp;&nbsp; 还记得股神巴菲特在互联网兴起之初，就明确表示：“我不会投资任何互联网公司。”完美错过互联网的爆炸式增长。而今他又对媒体声称：“我不看好任何数字货币。”历史总是惊人的相似。<br/>&nbsp;&nbsp;&nbsp; 当年说互联网是泡沫、是黑色郁金香，是因为外界看不懂互联网：拼命烧钱、没有盈利模式，马云一直顶着骗子的头衔一步步走到事业的巅峰……而今我们对区块链又是一样的态度，这些耳熟能详的形容词汇又一股脑推到区块链创业的领域。所以，你还说区块链是泡沫吗？</p><p>“我不看好BAT做区块链，因为区块链改变了所有公司形态的公司”<br/>&nbsp;&nbsp;&nbsp;&nbsp; 杨宁明确表示：“BAT做区块链是不行的。因为他们的本质是与区块链精神不符的。”</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 在他看来，从古至今，公司形态，就是一个固定的存在，在东方和西方，都是一样的。</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 在西方，资本家创办一家公司，服务于资本家的叫做管理团队，服务于管理团队的叫员工。在中国，资本家就是东家，管理团队就是掌柜的，员工就是店小二。</p><p>&nbsp;&nbsp;&nbsp; 这个结构体系从骨子里来看就是一样的，几千年来从未改变。员工创造价值，但却拿不到全部价值，资本家们压榨员工创造的剩余价值。</p><p>&nbsp;&nbsp;&nbsp; 这时有个学者就站出来说：“这是不公平的！员工应该拿回属于自己劳动所得的价值！”</p><p>&nbsp;&nbsp;&nbsp; 于是这个学者写了《资本论》，很多人都认同马克思主义思想，但公司这个组织结构，却没有因为《资本论》的发表而彻底改变。因为在当时的科技环境下，劳动者的劳动量，是没有办法被准确计量的，劳动者都希望“按劳分配”，干活多、付出多，多拿钱；干活少、付出少，少拿钱。但实际情况却很复杂，怎么计算你的劳动所创造的价值呢？按劳分配是没有一个标准的，一旦老板“克扣了”你的薪水，也没有人能为你证实。</p><p>&nbsp;&nbsp;&nbsp; 杨宁表示：“现在有了区块链，我们所有的劳动，都变得可以计量、不可篡改、必须公示。这就是公平。”</p><p>&nbsp;杨宁不看好BAT进军区块链，就是因为区块链砍掉了剩余价值。因为有了区块链，“投资人”将成为“历史的产物”，公司的组织形式，将会发生彻底的改变。而BAT能不能做到彻底改革，这很难说。</p><p>公平公开是区块链最根本的精神，这个组织形态必须是不以私欲为前提理念的。<br/>&nbsp;&nbsp;&nbsp;&nbsp; 这也是区块链为什么能这样迅猛发展的原因之一，杨宁说：“因为这个社会上，无产阶级多，资产阶级少；穷人多，富人少；劳动者多，管理者少。受到不公待遇的人越多，区块链就越被他们追捧。让所有创造价值的人获得同等的报酬，这是区块链解决的一大问题。”</p><p>&nbsp;&nbsp;&nbsp; 面对很多人因为政策原因而不看好区块链，杨宁表示，这是趋势，也是未来，管理一定是顺应趋势的，只是早晚的问题，不需要太担心。</p><p>&nbsp;&nbsp;&nbsp; 但是现在有些创业圈的人表示，他们只做区块链，不做代币。杨宁对此表示不认同：“区块链和代币好比一枚硬币的正反面，只要区块链不要代币的形式是不存在的。”</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 更好的比喻，可以说区块链是一辆汽车，代币就是汽车的汽油。没有汽油的动力，汽车是不能上路的。区块链的生态需要代币作为奖励机制，如果奖励机制不明确，我们就回到了不公平的境遇。所谓的按劳分配必须有奖励机制作为驱动。</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 杨宁说：“没有代币的区块链生态等于零。”</p><p>&nbsp;&nbsp;&nbsp;&nbsp; 谈到如何面对现在的代币管理，他说：“在巨大的趋势面前，监管是要顺应趋势的，而不是由趋势去顺应监管。就像当年的互联网到来，我们的管理体系受到了挑战，于是我们出台了一系列政策，成立了特定的监管部门。而今面对区块链，我相信未来现有的监管体系一定会升级改革，将来一定是有一套单独的管理体制来有效管理区块链。”</p><p>&nbsp;&nbsp;&nbsp; 很多人关心，区块链已经到来，最先被颠覆的是哪些行业？杨宁表示：咱们毛主席说了，哪里有压迫，哪里就有反抗。<br/></p><p>&nbsp;&nbsp;&nbsp;&nbsp; 最先被区块链颠覆的行业，一定是金融领域。因为金融领域是一个很不公平的行业，存在着巨大的资源浪费。分配极其不公导致很少的人赚取了很多的“黑心钱”。</p><p>&nbsp;&nbsp;&nbsp; 如今互联网时代，有很多东西明明是我们自己创造的，却在不断被少数人操纵榨取利益，比如说数据。</p><p>在未来，区块链完全可以把数据还原给你自己。<br/></p><p>&nbsp;&nbsp;&nbsp; “我最近就看了一个非常好的区块链项目，他解决的就是大批消费者的刚需。 ”</p><p>它通过全球消费者自主采集的多种平台实体和电子化账单，形成去中心化的区块链广告网络，让上传账单的用户享受到商家投放的广告分成。</p><p>&nbsp;&nbsp;&nbsp; “这将革命性挑战Google等传统互联网巨头所垄断的中心化竞价广告模式，这种模式的核心是: 搜索行为由海量用户贡献，巨额广告收入却与用户无关，导致了对用户贡献极不公平的价值体系。”杨宁表示，由于各大中心化流量广告平台对个人消费数据收集的垄断，个人消费数据资产的孤岛化，隔绝化日益严重。<br/>&nbsp;&nbsp;&nbsp; 海量的消费者虽然贡献了巨大数据源，但却没有享受到个人消费资产被用于广告营销所带来的巨大红利。<br/>&nbsp;&nbsp;&nbsp; 举个例子，比如我在网上消费了什么游戏项目，买了什么东西，浏览了什么商品，这些都是我创造的消费数据。在此模式下，我们可以通过自己创造的数据，来享受广告商的广告分成；广告商可以通过海量数据，投放精准广告，且成本会比现在低很多。<br/>&nbsp;&nbsp;&nbsp; 区块链将这些数据真正还原给用户。<br/>&nbsp;&nbsp;&nbsp; 全球每天都会产生的巨大的海量账单数量，尤其在西方发达国家，个人消费实体账单更是必须保存的要件，虽然中国等亚太国家在线支付已经高度普及，但是用户对作为自己消费记录的账单百分百所有权是毋庸置疑的，支持用户上传截图化的，SDK化的主动上链行为。放眼全球，这数据的庞大程度是不可想象的，区块链解决消费数据链的价值是不可估量的。<br/>&nbsp;&nbsp;&nbsp; “仅全球餐饮行业，每年就有将近3万亿美金的消费体量，每天以百亿美金计。共享出行领域2016年3.9万亿美金，还有多个消费产业的全球规模超过万亿美金规模，可以想象巨大的市场潜力等待被唤醒。”杨宁表示这将是一场改革。<br/>&nbsp;&nbsp;&nbsp; 这些巨大的实体账单，消费数据资产还在沉睡当中。每个用户结账完毕后，账单的价值也就就马上大幅贬值，接近废纸，但是区块链让全球的账单变废为宝，成为新的数据黄金，同时区块链技术正是可以让消费者作为数据贡献者而享受不可逆不可篡改的数据资产获利的最好的基础，让消费者享受自己创造数据，自己获利的数据资产红利。<br/></p><p>&nbsp;&nbsp;&nbsp;&nbsp; 现在区块链应用的一定是急被大家所需的，暴利越多，被压迫的人越多，这个行业就越容易被区块链颠覆。“不以解决大众需求为前提的区块链项目，都是耍流氓。”<br/>&nbsp;&nbsp;&nbsp; 至于未来区块链应用如何发展，“百花齐放百家争鸣”，但总归都有一点，它是有利于我们底层人民的。“大势所趋，走向共和。”这就是杨宁对区块链的看法。<br/>&nbsp;&nbsp;&nbsp; “这就好比在19世纪20世纪，世界上绝大部分国家从君主体制走向共和。同样，未来绝大部分公司的组织形式，一定会走向区块链。”<br/>&nbsp;&nbsp;&nbsp; 相信在不久的将来，我们所有人都将被卷到这一历史性的变革中。</p><p><br/></p>', 1),
(27, 2, '区块链将挑战搜索引擎霸权', '', '区块链将挑战搜索引擎霸权', '/uploads/20180913/f99587bb02c3b352620fb0227afde047.jpg', '', 1536768000, 0, '区块链 挑战 搜索 引擎霸权', '', '', '', '<p style=\"text-align: center;\"><img title=\"1536830632298530.png\" alt=\"1536830769(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536830632298530.png\"/></p><p>搜索引擎似乎已经了统治互联网。以谷歌这位巨无霸为例，每四十秒钟，它就可以在全球范围内处理超过40000个搜索查询。通过每次点击，它们都会消耗来自全球用户的更多数据。也就是说，一但你使用搜索引擎输入内容，你就成为了“产品”。</p><p>很多用户都喜欢使用搜索引擎在网页上搜索自己感兴趣的内容，甚至有许多人直接使用搜索引擎作为浏览器的首页。大家是否都有注意到，每次在搜索的时候，总会有一些广告弹出来，说巧不巧，这些广告大多是你感兴趣的甚至是你刚好想要的。</p><p>这时候你会以为这个搜索引擎很懂你吗？是的它很懂你，因为你每次的搜索记录都被搜索引擎所捕获，它根据你的习惯和喜好，再向你推送相应的广告。</p><p>那么搜索引擎得到了什么？它得到了你免费送来的数据，得到了商家支付给它的高额广告费，得到了你看广告带来的流量。</p><p>另一方面，企业同样因为缺乏高质量的流量而受挫。Facebook和Google占全球广告支出的20％，分别为269亿美元和794亿美元。不过，估计有50％的广告流量都是“bot流量”。哪个企业不希望获得最佳投资回报率？ 由此可见， 当前的搜索引擎模型已被破坏且急需创新，而区块链技术可以做到！<br/>如何运用区块链技术打破现状</p><p>具体做法就是用户在使用搜索引擎时产生的数据会被加密成区块，由用户自己决定搜索记录是否要公开。如果选择公开，则可以收到相应数量的代币，用户可以使用代币在接受代币的商家进行消费。</p><p>这样一来，用户既对自己的搜索记录可以控制，商家可以浏览公开的搜索记录找到自己的最终客户。通过区块链技术改造搜索引擎，去掉搜索引擎这一中心，让商家和用户面对面，对传统搜索引擎的商业模式发起了挑战。</p><p>BitClave.com是一个从中脱颖而出的搜索引擎站点。他们的最终目标是破坏数字广告市场。 他们想切断中间商，直接连接用户和企业家，BitClave有一个激进的生态系统，鼓励客户控制他们的数据的使用时间和方式。BitClave搜索平台允许客户决定谁能够查看，访问，使用和销售他们的数据。 未经客户明确许可，不向用户提供优惠。</p><p>另一方面，企业受益于与合格消费者的直接联系。 有针对性的促销水平达到全新的空间，这得益于区块链模型。所有促销活动都是基于用户以前的搜索历史，与当前的模式类似，但是有一个明显的差异——客户可以选择是否显示数据并对其进行补偿。</p><p>当用户从事广告时，可以为他们选择与企业分享的数据获得代币。 这就是他们数据停止使用地方。 不会被吸入一个无限商业黑洞的数据。 这与客户对企业搜索引擎的方法不同。</p><p><br/></p>', 1),
(28, 2, '当疫苗遇上区块链', '', '当疫苗遇上区块链', '/uploads/20180913/fb6d8568fbfe6f5a09d44cd1f5932233.jpg', '', 1536768000, 0, '疫苗 区块链', '', '', '', '<p style=\"text-align: center;\"><img title=\"1536831005209959.jpg\" alt=\"微信图片_20180913173015.jpg\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536831005209959.jpg\"/></p><p>最近，某公司问题疫苗事件，可谓是闹得沸沸扬扬，牵动着全国人民的心。下面一张图片也在朋友圈疯传：曾今鼓起那么大勇气注射的疫苗，你特么告诉我这是无效的?于是感叹城市套路太深，我要回农村。殊不知，回农村，孩子也要打疫苗呀！<br/>别慌<br/>咱们克强总理就疫苗事件作出批示：必须给全国人民一个明明白白的交代。</p><p>那么问题来了，如果是使用传统的调查方式，必然会花费大量的人力物力，并且效率还不一定高。那该怎么办？或许区块链能很好地解决这个问题。</p><p><strong>01 区块链简介</strong></p><p>区块链是一种技术，它利用块链式数据结构来验证与存储数据、利用分布式节点共识算法来生成和更新数据、利用密码学的方式保证数据传输和访问的安全、利用由自动化脚本代码组成的智能合约来编程和操作数据的一种全新的分布式基础架构与计算方式。</p><p><strong>02 区块链特征</strong></p><p>去中心化管理，公开透明的数据，信息不可篡改以及信任机制是区块链的四大特点。</p><p><strong>03 解决方案</strong></p><p>解决监管脱节问题。疫苗的供应链是“生产企业——批发企业/疾控中心——疾控中心——接种单位”的链路。区块链技术可实现疫苗从生产到接种所有环节可追溯，监管部门可通过区块链获得产品在每一个流通环节的信息，实现信息透明化、共享化。同时，接种单位或接种者通过区块链溯源对疫苗扫码，即可按照时间顺序一步步追溯到疫苗信息，有消费者参与监管，黑色利益链将遁于无形。</p><p>解决问责机制不完善的问题。问题疫苗涉及到国家的问责机制，同时也涉及到企业内部的问责机制。如果疫苗生产、流通到使用过程都数据记录，监管部门对每一支疫苗的流通都有数据可查，在流通过程中的负责人是明确的，而且每一个重要环节都能确保疫苗属于真正有效的疫苗，那么这种造假自然就无处遁形了。</p><p>解决在流通环节出现的漏洞。该环节需要商家对产品进行上链，消费者则通过扫码获取商品信息。接种单位或者接种者扫溯源码提交的信息，相关监管部门即可获得该批次的疫苗在运输过程中的详细信息；假如该批次疫苗出现问题，相关部门可通过区块链溯源，针对问题疫苗直接发出预警及召回方案；另外问题疫苗的生产企业，国家相关部门也可通过区块链溯源，在第一时间对其发出勒令停产、整改等要求。</p><p>当然单单仅靠这项技术彻底解决整个问题也是不够的，而且就中国目前的环境实施起来也有些难度，但是区块链这项技术毫无疑问，是值得我们去深拥的。</p><p><br/></p>', 1),
(13, 1, '喜讯｜软银中国与增量科技战略合作签约成功', '', '软银中国与增量科技战略合作签约成功', '/uploads/20180913/638e1ae2eba4d7b4644f104ab72980d3.jpg', '', 1532707200, 0, '软银中国  增量科技 区块链  战略合作 签约', '', '', '', '<p>&nbsp; &nbsp; &nbsp;&nbsp; 2018年7月26日，“软银中国”&amp;“增量科技”全面战略合作签约仪式在增量科技总部会议厅隆重举行，此次签约，标志着两家企业全面合作的开启，软银中国将为增量科技引入其强大的资源、资本背景，助力增量科技的全面发展，这一签约，标着着双方强强联手的开启，必将加速增量科技在金融区块链领域的发展，为增量科技立志打造成世界一流高科技企业的目标添上浓墨重彩的一笔。</p><p style=\"text-align: center;\"><img title=\"1536807336575329.png\" alt=\"1536807426(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536807336575329.png\"/></p><p style=\"text-align: center;\">软银中国资本高级合伙人、广外尚融基金合伙人吴文生</p><p>&nbsp; &nbsp; &nbsp;&nbsp; 软银中国资本高级合伙人、广外尚融基金合伙人吴文生先生，戴振乾先生，国家发改委瞭望九州集团副总裁、观藏文化董事长刘毅刚先生，增量科技CEO胡添翼先生、达摩院车德先生、综合部总监刘文华女士、商学院李为均老师等出席签约仪式，戴振乾先生和胡添翼先生分别作为双方代表签订战略合作协议 。</p><p style=\"text-align: center;\"><img title=\"1536807134436787.png\" alt=\"1536807259(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536807134436787.png\"/></p><p style=\"text-align: center;\">增量科技CEO胡添翼</p><p>&nbsp; &nbsp; &nbsp;&nbsp; 增量科技CEO胡添翼先生在签约仪式开始前，首先向出席嘉宾详细介绍了企业的基本情况，包括基本的企业人事架构，董事会构成，财务、人事管理体系等，同时对目前企业的经营现状、技术研发进度，市场推广建设情况、下一步的发展规划等向嘉宾做了全面阐述。</p><p style=\"text-align: center;\"><img title=\"1536807422871586.png\" alt=\"1536807476(1).png\" src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180913/1536807422871586.png\"/></p><p style=\"text-align: center;\">&nbsp; &nbsp; &nbsp; &nbsp;瞭望九州集团副总裁刘毅刚</p><p>&nbsp; &nbsp; &nbsp;&nbsp; 瞭望九州集团副总裁刘毅刚先生首先对增量科技与软银中国成功签约表示祝贺。接着刘总表示对区块链行业十分看好，并对增量科技所搭建的平台予以认可。最后，作为瞭望九州的副总裁，刘总表示非常期待与增量科技的合作。</p><p>&nbsp; &nbsp; &nbsp;&nbsp; 软银中国全称软银中国资本(SBCVC)。软银中国资本成立于2000年，是一家领先的风险投资和私募股权基金管理公司，致力于在大中华地区投资优秀的高成长、高科技企业。</p><p>&nbsp; &nbsp; &nbsp;&nbsp; 曾成功投资了阿里巴巴、淘宝网、分众传媒、万国数据、神雾、普丽盛、迪安诊断、理邦仪器等一系列优秀企业。如今软银中国资本同时管理着多支美元和人民币基金，投资领域包括信息技术、清洁技术、医疗健康、消费零售和高端制造等行业，投资阶段涵盖早期、成长期和中后期各个阶段。</p><p>&nbsp; &nbsp; &nbsp;&nbsp; 软银中国资本的运营总部位于上海，在北京、天津、苏州、重庆、成都、西安、杭州、宁波、深圳及台湾等地设有办事机构。</p><p><br/></p>', 1);

-- --------------------------------------------------------

--
-- Table structure for table `think_news_category`
--

CREATE TABLE `think_news_category` (
  `cat_id` smallint(5) UNSIGNED NOT NULL,
  `cat_name` varchar(50) NOT NULL DEFAULT '',
  `note` varchar(200) NOT NULL DEFAULT '',
  `parent_id` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `thumb` varchar(300) NOT NULL DEFAULT '' COMMENT '缩略图',
  `sort` int(11) NOT NULL DEFAULT '0',
  `is_show` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_news_category`
--

INSERT INTO `think_news_category` (`cat_id`, `cat_name`, `note`, `parent_id`, `thumb`, `sort`, `is_show`) VALUES
(1, '增量链', 'zll', 0, '/uploads/20180828\\75528ef089259298464f214cd22bcae2.jpg', 0, 1),
(2, '区块链', 'qkl', 0, '/uploads/20180828\\8ce01d601f368842e999b9366cff383c.jpg', 0, 1),
(3, '金融', 'jr', 0, '/uploads/20180828\\34495fe539774e4d0b60a55b5926aa0d.jpg', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `think_order_goods`
--

CREATE TABLE `think_order_goods` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(11) NOT NULL DEFAULT '0',
  `pro_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `pro_name` varchar(200) NOT NULL DEFAULT '',
  `pro_thumb` varchar(200) NOT NULL DEFAULT '',
  `pro_attr` varchar(100) NOT NULL DEFAULT '',
  `attr_price` decimal(5,2) NOT NULL DEFAULT '0.00',
  `buy_number` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `price` decimal(7,2) NOT NULL DEFAULT '0.00',
  `market_price` decimal(7,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(8,2) NOT NULL DEFAULT '0.00'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_order_info`
--

CREATE TABLE `think_order_info` (
  `order_id` int(10) UNSIGNED NOT NULL,
  `order_sn` char(30) NOT NULL DEFAULT '',
  `order_pay` char(50) NOT NULL DEFAULT '',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `username` char(50) NOT NULL COMMENT '账号',
  `province` int(11) NOT NULL DEFAULT '0',
  `city` int(11) NOT NULL DEFAULT '0',
  `area` int(11) NOT NULL DEFAULT '0',
  `address` varchar(200) NOT NULL DEFAULT '',
  `zipcode` char(6) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '',
  `mobile` varchar(30) NOT NULL DEFAULT '',
  `note` varchar(200) NOT NULL DEFAULT '' COMMENT '补充说明',
  `pay` tinyint(4) NOT NULL DEFAULT '0' COMMENT '支付方式1微信/2支付宝/3余额',
  `shipping_fee` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT '运费',
  `total` decimal(9,2) NOT NULL DEFAULT '0.00',
  `add_time` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0提交1确认2取消',
  `pay_state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0未付款1已付款',
  `shipping_state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0未发货1已发货2已收货3已退货',
  `comment_state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0已评论1未评论',
  `cancel_time` int(11) NOT NULL DEFAULT '0' COMMENT '取消时间',
  `pay_time` int(11) NOT NULL DEFAULT '0' COMMENT '付款时间',
  `send_time` int(11) NOT NULL DEFAULT '0' COMMENT '发货时间',
  `get_time` int(11) NOT NULL DEFAULT '0' COMMENT '收货时间',
  `enfunds_time` int(11) NOT NULL DEFAULT '0' COMMENT '退货时间',
  `gold_static` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '订单返金币',
  `gold_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '当时金币价',
  `order_url` varchar(800) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_order_trend`
--

CREATE TABLE `think_order_trend` (
  `id` int(10) UNSIGNED NOT NULL,
  `dates` varchar(30) NOT NULL DEFAULT '',
  `date_time` int(11) NOT NULL DEFAULT '0',
  `price` decimal(8,2) NOT NULL DEFAULT '0.00',
  `highs` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '最高',
  `lows` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '最低',
  `add_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_order_trend`
--

INSERT INTO `think_order_trend` (`id`, `dates`, `date_time`, `price`, `highs`, `lows`, `add_time`) VALUES
(1, '2018-08-29', 1535472000, '2.50', '3.00', '2.00', 1535534589),
(2, '2018-09-03', 1535904000, '3.00', '4.00', '2.00', 1535953966),
(3, '2018-09-04', 1535990400, '4.00', '5.00', '3.00', 1535953984),
(4, '2018-09-07', 1536249600, '4.50', '11.00', '9.00', 1536288685),
(5, '2018-09-09', 1536422400, '3.00', '3.00', '3.00', 1536461685),
(6, '2018-09-11', 1536595200, '2.00', '2.00', '2.00', 1536627494),
(7, '2018-09-11', 1536595200, '5.00', '11.00', '4.00', 1536634764),
(8, '2018-09-12', 1536681600, '2.00', '2.00', '2.00', 1536735197),
(9, '2018-09-15', 1536940800, '3.00', '3.00', '3.00', 1536916547);

-- --------------------------------------------------------

--
-- Table structure for table `think_product`
--

CREATE TABLE `think_product` (
  `id` int(10) UNSIGNED NOT NULL,
  `pass_time` int(11) NOT NULL COMMENT '过期时间',
  `cat_id` smallint(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT '分类ID',
  `name` varchar(300) NOT NULL DEFAULT '' COMMENT '标的来源',
  `address` varchar(200) NOT NULL COMMENT '标的地址',
  `mianji` varchar(100) NOT NULL,
  `totalmianji` varchar(50) NOT NULL COMMENT '标的合计面积',
  `buy_price` decimal(12,2) NOT NULL COMMENT '收购价格',
  `start_money` decimal(12,4) NOT NULL COMMENT '起投价格',
  `dream_money` decimal(12,2) NOT NULL COMMENT '预计收益',
  `play_time` varchar(50) NOT NULL COMMENT '处置时间',
  `get_money` decimal(12,2) NOT NULL COMMENT '银行贷款',
  `closetime` varchar(50) NOT NULL COMMENT '处置时间',
  `finish` tinyint(1) DEFAULT '0' COMMENT '完成进度判断分红 0代完成 1 已完成',
  `thumb` varchar(200) NOT NULL DEFAULT '',
  `thumb1` varchar(200) NOT NULL,
  `thumb2` varchar(200) NOT NULL,
  `thumb3` varchar(200) NOT NULL,
  `oldPic` varchar(200) NOT NULL COMMENT 'laozhaopian',
  `oldPic1` varchar(200) NOT NULL,
  `oldPic2` varchar(200) NOT NULL,
  `oldPic3` varchar(200) NOT NULL,
  `content` text,
  `is_sale` tinyint(1) NOT NULL COMMENT '1开启 0关闭',
  `is_recommend` tinyint(4) NOT NULL DEFAULT '0',
  `add_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_product`
--

INSERT INTO `think_product` (`id`, `pass_time`, `cat_id`, `name`, `address`, `mianji`, `totalmianji`, `buy_price`, `start_money`, `dream_money`, `play_time`, `get_money`, `closetime`, `finish`, `thumb`, `thumb1`, `thumb2`, `thumb3`, `oldPic`, `oldPic1`, `oldPic2`, `oldPic3`, `content`, `is_sale`, `is_recommend`, `add_time`) VALUES
(1, 0, 0, '中国建设银行长沙分行', '芙蓉区德政街211号综合楼101', '两栋楼', '6230', '55000000.00', '300.0000', '59000000.00', '2018年7-8月', '17000000.00', '30', 0, '/uploads/20180903/3124bf3afac95974a9d7d26c97039efe.png', '/uploads/20180904/16ae0c7d9407df3b6bb0097fc4ad889a.png', '/uploads/20180904/4cf9da46eed1160f67949bef44573e53.png', '/uploads/20180914/411d1267d8c7888f930afd77bd82d0ac.png', '/uploads/20180903/3124bf3afac95974a9d7d26c97039efe.png', '/uploads/20180904/16ae0c7d9407df3b6bb0097fc4ad889a.png', '/uploads/20180904/4cf9da46eed1160f67949bef44573e53.png', '/uploads/20180904/8c2f4d7198a3248354c8dd5504398fe9.png', '<p><img src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180914/1536888248219982.png\" title=\"1536888248219982.png\" alt=\"pic1.png\"/></p>', 1, 0, 1536888436),
(2, 0, 0, '长沙银行', '天心区新开铺路178号万事佳景园2.3栋', '一、二层共计2900平米', '7544', '35000000.00', '300.0000', '70000000.00', '2018年7月', '30000000.00', '30', 0, '/uploads/20180903/426d3f526373d1224c18ea06e0600e0c.png', '/uploads/20180904/88ab60786ef60be78b49e2a833ccd7f1.png', '/uploads/20180904/2ea3f78369ced1ea6704d3e2fd8e4f5a.png', '/uploads/20180904/68eb7f997a695bb412b1a16175e0619c.png', '/uploads/20180903/426d3f526373d1224c18ea06e0600e0c.png', '/uploads/20180904/88ab60786ef60be78b49e2a833ccd7f1.png', '/uploads/20180904/2ea3f78369ced1ea6704d3e2fd8e4f5a.png', '/uploads/20180904/68eb7f997a695bb412b1a16175e0619c.png', '<p><img src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180914/1536888263872684.png\" title=\"1536888263872684.png\" alt=\"pic1.png\"/></p>', 1, 0, 1536888527),
(3, 0, 0, '华融湘江银行湘潭市支行', '湘潭市岳塘区', '5248.8平方', '7544', '70000000.00', '300.0000', '60000000.00', '2018年9月-10日', '39000000.00', '30', 0, '/uploads/20180903/1c3006cd6e6d40a69e5ec0e861b9b1ae.png', '/uploads/20180903/57a1daa448e355ad5aab702310f89433.png', '/uploads/20180903/1e8e52d4528235ff5b6d3e9f94818278.png', '/uploads/20180914/c7d4f4cdd9d6e8ea418d3344e987308c.png', '/uploads/20180903/1c3006cd6e6d40a69e5ec0e861b9b1ae.png', '/uploads/20180903/57a1daa448e355ad5aab702310f89433.png', '/uploads/20180903/1e8e52d4528235ff5b6d3e9f94818278.png', '/uploads/20180903/bb433c1571035c69a569e568d443f182.png', '<p><img src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180914/1536888295737754.png\" title=\"1536888295737754.png\" alt=\"pic1.png\"/></p>', 1, 0, 1536888297),
(4, 0, 0, '华融湘江银行湘潭市支行', '湘潭市岳塘区', '4050平方', '4050', '17000000.00', '300.0000', '13000000.00', '2018年7-9月', '9000000.00', '30', 0, '/uploads/20180903/f8b1c3ff960d3288bff6932f54010653.png', '/uploads/20180903/df0a98d619ca35587ad97b47db0c4576.png', '/uploads/20180903/f2918cdf4aeee03a684445d4d72cac38.png', '/uploads/20180914/dfc18292a3e15924fbf30890552b8cc1.png', '/uploads/20180903/f8b1c3ff960d3288bff6932f54010653.png', '/uploads/20180903/df0a98d619ca35587ad97b47db0c4576.png', '/uploads/20180903/f2918cdf4aeee03a684445d4d72cac38.png', '/uploads/20180914/dfc18292a3e15924fbf30890552b8cc1.png', '<p><img src=\"http://tic.zengliangkeji.com/ueditor/php/upload/image/20180914/1536888310692538.png\" title=\"1536888310692538.png\" alt=\"pic1.png\"/></p>', 1, 0, 1536888312);

-- --------------------------------------------------------

--
-- Table structure for table `think_product_attr`
--

CREATE TABLE `think_product_attr` (
  `pro_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `attr_id` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `price` decimal(5,2) NOT NULL DEFAULT '0.00',
  `attr_parent` smallint(5) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_product_category`
--

CREATE TABLE `think_product_category` (
  `cat_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `cat_name` varchar(50) NOT NULL,
  `is_show` tinyint(1) NOT NULL,
  `thumb` varchar(255) NOT NULL,
  `sort` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_product_category`
--

INSERT INTO `think_product_category` (`cat_id`, `parent_id`, `cat_name`, `is_show`, `thumb`, `sort`) VALUES
(1, 0, '金融', 1, '/uploads/20180901/eff110cf4387a99b1833af014400be0a.jpg', 0);

-- --------------------------------------------------------

--
-- Table structure for table `think_product_order`
--

CREATE TABLE `think_product_order` (
  `id` int(11) NOT NULL COMMENT 'id',
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `num` decimal(12,4) NOT NULL COMMENT '购买的资产',
  `product_id` int(11) NOT NULL COMMENT '资产id',
  `add_time` int(11) NOT NULL COMMENT '添加时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_product_order`
--

INSERT INTO `think_product_order` (`id`, `uid`, `username`, `num`, `product_id`, `add_time`) VALUES
(1, 100013, '18516067713', '315.0000', 1, 1536575918),
(2, 100013, '18516067713', '187.2000', 2, 1536588040),
(3, 100019, '13677337935', '1020.0000', 2, 1536663114),
(4, 100019, '13677337935', '500.0000', 3, 1536663150),
(5, 100024, '15387528217', '12000.0000', 2, 1536723767),
(6, 100017, '15367894550', '2000.0000', 1, 1536917400),
(7, 100017, '15367894550', '2000.0000', 2, 1536917448);

-- --------------------------------------------------------

--
-- Table structure for table `think_put_integral`
--

CREATE TABLE `think_put_integral` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL DEFAULT '0',
  `username` char(50) NOT NULL COMMENT '账号',
  `action` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '变动金额',
  `money_end` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '余额',
  `order_sn` varchar(200) NOT NULL DEFAULT '' COMMENT '订单号',
  `info` varchar(500) NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0未审核/2已取消/3已驳回/5已经成功',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '姓名',
  `card` varchar(100) NOT NULL DEFAULT '' COMMENT '银行卡',
  `khh` varchar(200) NOT NULL DEFAULT '' COMMENT '开户行',
  `khzh` varchar(200) NOT NULL DEFAULT '' COMMENT '开支户行',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '开始提现时间',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '处理提现时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_put_integral_log`
--

CREATE TABLE `think_put_integral_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL COMMENT '账号id',
  `username` char(50) NOT NULL COMMENT '账号',
  `action` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '变动金额',
  `money_end` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '余额',
  `info` varchar(300) NOT NULL DEFAULT '' COMMENT '备注',
  `order_sn` varchar(200) NOT NULL DEFAULT '' COMMENT '订单号',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型/0支出/1收入',
  `action_type` tinyint(4) NOT NULL DEFAULT '0',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '操作时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_region`
--

CREATE TABLE `think_region` (
  `region_id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `region_name` varchar(50) NOT NULL DEFAULT '',
  `region_type` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_static_config`
--

CREATE TABLE `think_static_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '名称',
  `gold_up` int(11) NOT NULL DEFAULT '0' COMMENT '上限',
  `gold_lt` int(11) NOT NULL DEFAULT '0' COMMENT '下限',
  `rate` decimal(5,3) NOT NULL DEFAULT '0.000' COMMENT '奖励',
  `type` smallint(6) NOT NULL DEFAULT '0' COMMENT '类型',
  `level` smallint(6) NOT NULL DEFAULT '0' COMMENT '等级',
  `add_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_static_config`
--

INSERT INTO `think_static_config` (`id`, `name`, `gold_up`, `gold_lt`, `rate`, `type`, `level`, `add_time`) VALUES
(1, '001', 3, 2, '0.100', 1, 3, 0),
(2, '002', 5, 2, '0.400', 1, 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `think_static_gold_rid`
--

CREATE TABLE `think_static_gold_rid` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL COMMENT '账号id',
  `username` char(50) NOT NULL COMMENT '账号',
  `action` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '变动金额',
  `money_end` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '余额',
  `info` varchar(300) NOT NULL DEFAULT '' COMMENT '备注',
  `order_sn` varchar(200) NOT NULL DEFAULT '' COMMENT '订单号',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型/0支出/1',
  `action_type` tinyint(4) NOT NULL DEFAULT '0',
  `status` smallint(6) NOT NULL DEFAULT '0' COMMENT '状态',
  `num` int(11) NOT NULL DEFAULT '0' COMMENT '累计释放次数',
  `sum_gold` decimal(8,3) NOT NULL DEFAULT '0.000' COMMENT '累计释放',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '开始操作时间',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '结束操作时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `think_tic_bobi`
--

CREATE TABLE `think_tic_bobi` (
  `id` int(11) NOT NULL COMMENT '主键自增id',
  `uid` int(11) NOT NULL COMMENT '拨币账户',
  `wallet_address` varchar(50) NOT NULL COMMENT '收款钱包地址',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 申请中 1 已通过 2拒绝',
  `persontic` decimal(11,4) NOT NULL COMMENT '个人拨币',
  `pttic` decimal(11,4) NOT NULL COMMENT '平台拨币',
  `totaltic` decimal(11,4) NOT NULL COMMENT '购买总数量',
  `add_time` int(11) NOT NULL COMMENT '申请时间',
  `pass_time` int(11) NOT NULL COMMENT '通过时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_tic_bobi`
--

INSERT INTO `think_tic_bobi` (`id`, `uid`, `wallet_address`, `type`, `persontic`, `pttic`, `totaltic`, `add_time`, `pass_time`) VALUES
(1, 100013, '17019c247cddc85ac9ddf6efec0324de3cc524395', 0, '300.0000', '300.0000', '600.0000', 1536460772, 0),
(2, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '100.0000', '100.0000', '200.0000', 1536480343, 0),
(3, 100013, '17019c247cddc85ac9ddf6efec0324de3cc524395', 1, '1000.0000', '1000.0000', '2000.0000', 1536486865, 1536487160),
(4, 100000, '17019c247cddc85ac9ddf6efec0324de3cc524395', 2, '1000.0000', '1000.0000', '2000.0000', 1536490938, 0),
(5, 100000, '17019c247cddc85ac9ddf6efec0324de3cc524395', 2, '5000.0000', '5000.0000', '10000.0000', 1536491626, 1536491758),
(6, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573941, 0),
(7, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573951, 0),
(8, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573952, 0),
(9, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573953, 0),
(10, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573953, 0),
(11, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573954, 0),
(12, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573954, 0),
(13, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573955, 0),
(14, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573955, 0),
(15, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573960, 0),
(16, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573961, 0),
(17, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573961, 0),
(18, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573961, 0),
(19, 100019, '141342d959767ca20e86488accf2e7cc7380db9ce', 0, '0.0000', '0.0000', '200.0000', 1536573961, 0),
(20, 100000, '17019c247cddc85ac9ddf6efec0324de3cc524395', 1, '50.0000', '50.0000', '100.0000', 1536720569, 1536720632),
(21, 100015, '1184a3ccf03cec7ef68d3655f06a3827f51591972', 0, '5.0000', '5.0000', '10.0000', 1536837049, 0),
(22, 100015, '1184a3ccf03cec7ef68d3655f06a3827f51591972', 0, '10.0000', '5.0000', '15.0000', 1536895059, 0),
(23, 100017, '1be93ad496057f2d6f502bb1ec801ab5506a26b8e', 1, '2.0000', '2.0000', '4.0000', 1536908808, 1536987431),
(24, 100017, '1be93ad496057f2d6f502bb1ec801ab5506a26b8e', 2, '50.0000', '50.0000', '100.0000', 1536981227, 0),
(25, 100042, '1be93ad496057f2d6f502bb1ec801ab5506a26b8e', 1, '50.0000', '50.0000', '100.0000', 1536991031, 1536991071);

-- --------------------------------------------------------

--
-- Table structure for table `think_tic_liutonglog`
--

CREATE TABLE `think_tic_liutonglog` (
  `id` int(11) NOT NULL COMMENT 'id',
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `type` varchar(25) NOT NULL COMMENT '1糖果兑换TIC 2矿石兑换tic 3交易 4转应用 5转储存 6应用转入',
  `num` varchar(25) NOT NULL COMMENT '转入转出数量',
  `add_time` int(11) NOT NULL COMMENT '添加时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_tic_liutonglog`
--

INSERT INTO `think_tic_liutonglog` (`id`, `uid`, `type`, `num`, `add_time`) VALUES
(1, 100013, '糖果兑换', '+1', 1536560159),
(2, 100013, '转储存', '+2', 1536561009),
(3, 100013, '转应用', '+1', 1536561115),
(4, 100013, '矿石兑换', '+50', 1536561357),
(5, 100000, '转储存', '-1000', 1536570518),
(6, 100019, '糖果兑换', '+1', 1536573847),
(7, 100000, '转储存', '-1000', 1536574549),
(8, 100000, '转应用', '-500', 1536575918),
(9, 100000, '转应用', '-500', 1536581123),
(10, 100000, '资产包转入', '+500', 1536583904),
(11, 100000, '资产包转入', '+80', 1536586924),
(12, 100000, '资产包转入', '+100', 1536587000),
(13, 100000, '转应用', '-100', 1536588040),
(14, 100000, '转应用', '-100', 1536588066),
(15, 100019, '糖果兑换', '+1', 1536624452),
(16, 100013, '矿石兑换', '+50', 1536628371),
(17, 100013, '转存储', '-1', 1536637703),
(18, 100013, '转存储', '-1', 1536645217),
(19, 100013, '资产包转入', '+0.8', 1536645817),
(20, 100013, '资产包转入', '+1.6', 1536645840),
(21, 100013, '资产包转入', '+1.6', 1536645911),
(22, 100013, '资产包转入', '+1.6', 1536645947),
(23, 100013, '资产包转入', '+0.8', 1536645993),
(24, 100013, '资产包转入', '+0.8', 1536645998),
(25, 100013, '资产包转入', '+1', 1536646161),
(26, 100013, '资产包转入', '+1.6', 1536646179),
(27, 100013, '资产包转入', '+0.8', 1536646240),
(28, 100013, '资产包转入', '+1', 1536646253),
(29, 100013, '转存储', '-1', 1536646290),
(30, 100013, '资产包转入', '+0.8', 1536647392),
(31, 100013, '资产包转入', '+1', 1536647882),
(32, 100013, '资产包转入', '+0.8', 1536647977),
(33, 100013, '资产包转入', '+0.8', 1536648006),
(34, 100013, '转存储', '-1', 1536648355),
(35, 100013, '资产包转入', '+0.8', 1536649733),
(36, 100019, 'TIC转ETH', '-2646.424', 1536650840),
(37, 100019, 'TIC转ETH', '-2641.392', 1536651134),
(38, 100019, 'TIC转ETH', '-263.84', 1536652235),
(39, 100019, 'TIC转EOS', '-6.8', 1536652306),
(40, 100019, 'TIC转ETH', '-527.2448', 1536654763),
(41, 100019, '矿石兑换', '+400', 1536659672),
(42, 100019, '转应用', '-300', 1536663114),
(43, 100019, '转应用', '-500', 1536663150),
(44, 100019, '矿石兑换', '+23', 1536667743),
(45, 100019, '矿石兑换', '+20', 1536667967),
(46, 100019, '矿石兑换', '+5', 1536668252),
(47, 100019, '矿石兑换', '+43', 1536668353),
(48, 100019, '糖果兑换', '+1', 1536668463),
(49, 100019, '矿石兑换', '+25', 1536668547),
(50, 100019, '糖果兑换', '+10', 1536668556),
(51, 100019, '矿石兑换', '+12', 1536668793),
(52, 100019, '矿石兑换', '+6', 1536668806),
(53, 100019, '转应用', '-500', 1536669427),
(54, 100019, '转应用', '-300', 1536669462),
(55, 100013, '糖果兑换', '+4', 1536719540),
(56, 100024, '转应用', '-20000', 1536723768),
(57, 100024, '资产包转入', '+8000', 1536723798),
(58, 100024, 'TIC转ETH', '-239.9992', 1536724048),
(59, 100024, 'TIC转ETH', '-2372.656', 1536724142),
(60, 100024, 'TIC转ETH', '-721.80342', 1536724318),
(61, 100017, '糖果兑换', '+1', 1536737933),
(62, 100019, '糖果兑换', '+2', 1536739955),
(63, 100019, '矿石兑换', '+5', 1536739967),
(64, 100013, '矿石兑换', '+213', 1536740127),
(65, 100013, '转存储', '-1', 1536740708),
(66, 100013, 'TIC转ETH', '-654.19575', 1536801618),
(67, 100025, '糖果兑换', '+1', 1536801650),
(68, 100015, '矿石兑换', '+20', 1536803784),
(69, 100015, 'TIC转ETH', '-647.7723', 1536819575),
(70, 100015, 'TIC转ETH', '-646.3296', 1536820251),
(71, 100013, '资产包转入', '+1', 1536830396),
(72, 100013, '转存储', '-1', 1536830412),
(73, 100013, '资产包转入', '+1', 1536830428),
(74, 100031, '糖果兑换', '+1', 1536831369),
(75, 100025, '转存储', '-1', 1536831813),
(76, 100013, '糖果兑换', '+2', 1536832012),
(77, 100013, '糖果兑换', '+3000', 1536832253),
(78, 100013, '糖果兑换', '+90', 1536832461),
(79, 100028, '矿石兑换', '+2', 1536832550),
(80, 100013, '糖果兑换', '+10', 1536832738),
(81, 100015, '糖果兑换', '+11', 1536832872),
(82, 100013, '糖果兑换', '+10', 1536833235),
(83, 100015, '糖果兑换', '+1', 1536833280),
(84, 100013, '糖果兑换', '+1', 1536833319),
(85, 100015, '糖果兑换', '+1', 1536833338),
(86, 100015, '糖果兑换', '+1', 1536833431),
(87, 100015, '糖果兑换', '+1', 1536833534),
(88, 100015, '糖果兑换', '+1', 1536833642),
(89, 100015, '糖果兑换', '+1', 1536833704),
(90, 100015, '糖果兑换', '+1', 1536833867),
(91, 100015, '糖果兑换', '+1', 1536834084),
(92, 100015, '糖果兑换', '+1', 1536834125),
(93, 100015, '糖果兑换', '+1', 1536834165),
(94, 100015, '糖果兑换', '+1', 1536834289),
(95, 100015, '糖果兑换', '+1', 1536834323),
(96, 100015, '糖果兑换', '+1', 1536834344),
(97, 100015, '糖果兑换', '+1', 1536834371),
(98, 100015, '矿石兑换', '+50', 1536837649),
(99, 100015, '糖果兑换', '+10', 1536837658),
(100, 100025, '糖果兑换', '+4', 1536849245),
(101, 100017, '转存储', '-1', 1536886626),
(102, 100019, '转存储', '-100', 1536897643),
(103, 100019, '资产包转入', '+80', 1536897662),
(104, 100017, '糖果兑换', '+2', 1536903701),
(105, 100028, '转存储', '-200', 1536907858),
(106, 100015, '糖果兑换', '+1', 1536913850),
(107, 100015, '糖果兑换', '+1', 1536916160),
(108, 100015, '糖果兑换', '+0', 1536916209),
(109, 100015, '糖果兑换', '+-2', 1536916221),
(110, 100015, '糖果兑换', '+-4', 1536916235),
(111, 100015, '糖果兑换', '+-6', 1536916246),
(112, 100015, '糖果兑换', '+1', 1536916362),
(113, 100017, '转应用', '-2000', 1536917400),
(114, 100017, '转应用', '-2000', 1536917448),
(115, 100017, '转存储', '-1000', 1536917506),
(116, 100015, '矿石兑换', '+5', 1536917684),
(117, 100015, '矿石兑换', '+4', 1536917702),
(118, 100015, '矿石兑换', '+3', 1536917705),
(119, 100015, '糖果兑换', '+2', 1536973586),
(120, 100015, '糖果兑换', '+1', 1536973597),
(121, 100015, '矿石兑换', '+2', 1536973618),
(122, 100015, '矿石兑换', '+1', 1536973646),
(123, 100013, '矿石兑换', '+36', 1536975594),
(124, 100039, '糖果兑换', '+1', 1536980471),
(125, 100017, '转存储', '-100', 1536981444),
(126, 100017, '糖果兑换', '+21', 1536982424),
(127, 100025, '矿石兑换', '+57', 1536986243),
(128, 100017, '矿石兑换', '+106', 1536988917),
(129, 100042, '糖果兑换', '+10', 1536991202),
(130, 100042, '糖果兑换', '+1', 1536991280),
(131, 100042, '矿石兑换', '+333', 1536991293),
(132, 100042, '矿石兑换', '+33', 1536991300),
(133, 100017, '糖果兑换', '+17', 1536991817);

-- --------------------------------------------------------

--
-- Table structure for table `think_tic_reless`
--

CREATE TABLE `think_tic_reless` (
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `releasetic` decimal(10,4) NOT NULL COMMENT '释放后可取用的数量',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '每次释放更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_tic_reless`
--

INSERT INTO `think_tic_reless` (`uid`, `releasetic`, `update_time`) VALUES
(100000, '6401.0000', '2018-09-14 09:56:08'),
(100011, '3000.0000', '2018-09-11 16:20:01'),
(100013, '11199.0000', '2018-09-15 02:39:14'),
(100019, '1480.0000', '2018-09-15 03:14:09');

-- --------------------------------------------------------

--
-- Table structure for table `think_tic_shifanglog`
--

CREATE TABLE `think_tic_shifanglog` (
  `id` int(11) NOT NULL COMMENT 'id',
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `num` decimal(12,4) NOT NULL COMMENT '释放数量',
  `add_time` int(11) NOT NULL COMMENT '释放时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_tic_shifanglog`
--

INSERT INTO `think_tic_shifanglog` (`id`, `uid`, `num`, `add_time`) VALUES
(6, 100019, '10.0000', 1536922966),
(7, 100019, '10.0000', 1536922967),
(8, 100019, '10.0000', 1536942001);

-- --------------------------------------------------------

--
-- Table structure for table `think_tic_static`
--

CREATE TABLE `think_tic_static` (
  `id` int(11) NOT NULL,
  `type` tinyint(1) NOT NULL COMMENT '1后台拨币 2兑冲 3币币交易 4流通转储存',
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `sid` int(11) DEFAULT '0' COMMENT '拨款用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `action` decimal(10,4) NOT NULL COMMENT '拨币数量',
  `statictic` decimal(10,4) NOT NULL COMMENT '锁死值',
  `releasetic` decimal(10,4) NOT NULL COMMENT '按当时比例固定的释放数量',
  `info` varchar(200) NOT NULL COMMENT '信息谁操作',
  `reless_time` int(11) NOT NULL COMMENT '开始释放的时间',
  `add_time` int(11) NOT NULL COMMENT '添加时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_tic_static`
--

INSERT INTO `think_tic_static` (`id`, `type`, `uid`, `sid`, `username`, `action`, `statictic`, `releasetic`, `info`, `reless_time`, `add_time`) VALUES
(27, 1, 100016, 0, '18890608054', '10000.0000', '10000.0000', '1000.0000', '管理员操作', 1538150400, 1536304077),
(30, 1, 100000, 0, '18163626560', '600.0000', '600.0000', '60.0000', '管理员操作', 1538150400, 1536305770),
(42, 1, 100000, 0, '18163626560', '1111.1111', '1111.1111', '111.1111', '管理员操作', 1538150400, 1536311963),
(43, 1, 100000, 0, '18163626560', '4444.4444', '4444.4444', '444.4444', '管理员操作', 1538150400, 1536314503),
(47, 1, 100013, 0, '18163626560', '1666.6667', '1666.6667', '166.6667', '管理员操作', 1538323200, 1536479102),
(48, 2, 100011, 0, '15211322811', '2000.0000', '2000.0000', '200.0000', '后台兑冲拨币,交易ID:3', 1538323200, 1536487160),
(49, 2, 100011, 0, '15211322811', '1000.0000', '1000.0000', '100.0000', '后台兑冲拨币,交易ID:5', 1538323200, 1536491678),
(50, 2, 100013, 0, '15211322811', '10000.0000', '10000.0000', '1000.0000', '后台兑冲拨币,交易ID:5', 1538323200, 1536491758),
(55, 4, 100000, 0, '18163626560', '5000.0000', '5000.0000', '500.0000', '管理员操作', 1538409600, 1536570151),
(56, 4, 100000, 0, '18163626560', '1000.0000', '1000.0000', '100.0000', '管理员操作', 1538409600, 1536570518),
(57, 4, 100000, 0, '18163626560', '1000.0000', '1000.0000', '100.0000', '用户操作流通转存储', 1538409600, 1536574549),
(58, 4, 100013, 0, '18516067713', '1.0000', '1.0000', '0.1000', '用户操作流通转存储', 1538496000, 1536637703),
(59, 4, 100013, 0, '18516067713', '1.0000', '1.0000', '0.1000', '用户操作流通转存储', 1538496000, 1536645217),
(60, 4, 100013, 0, '18516067713', '1.0000', '1.0000', '0.1000', '用户操作流通转存储', 1538496000, 1536646290),
(61, 4, 100013, 0, '18516067713', '1.0000', '1.0000', '0.1000', '用户操作流通转存储', 1538496000, 1536648355),
(66, 2, 100011, 0, '15211322811', '100.0000', '100.0000', '10.0000', '后台兑冲拨币,交易ID:20', 1538582400, 1536720632),
(67, 1, 100023, 0, '17052840030', '2100.0000', '2100.0000', '210.0000', '管理员操作', 1538582400, 1536720862),
(68, 1, 100023, 0, '17052840030', '2500.0000', '2500.0000', '250.0000', '管理员操作', 1538582400, 1536720941),
(69, 1, 100022, 0, '15274912795', '2500.0000', '2500.0000', '250.0000', '管理员操作', 1538582400, 1536721040),
(70, 1, 100024, 0, '15387528217', '2100.0000', '2100.0000', '210.0000', '管理员操作', 1538582400, 1536721416),
(71, 1, 100024, 0, '15387528217', '210000.0000', '210000.0000', '21000.0000', '管理员操作', 1538582400, 1536721447),
(72, 1, 100024, 0, '15387528217', '999999.9999', '999999.9999', '120000.0000', '管理员操作', 1538582400, 1536721479),
(73, 1, 100021, 0, '18163626562', '210000.0000', '210000.0000', '21000.0000', '管理员操作', 1538582400, 1536721514),
(74, 1, 100024, 0, '15387528217', '2000.0000', '2000.0000', '200.0000', '管理员操作', 1539273600, 1536731090),
(75, 1, 100022, 0, '15274912795', '2500.0000', '2500.0000', '250.0000', '管理员操作', 1539273600, 1536731525),
(76, 4, 100013, 0, '18516067713', '1.0000', '1.0000', '0.1000', '用户操作流通转存储', 1539273600, 1536740708),
(77, 1, 100028, 0, '13487583399', '10000.0000', '10000.0000', '1000.0000', '管理员操作', 1539273600, 1536747800),
(79, 4, 100013, 0, '18516067713', '1.0000', '1.0000', '0.1000', '用户操作流通转存储', 1539360000, 1536830412),
(80, 4, 100025, 0, '13720223000', '1.0000', '1.0000', '0.1000', '用户操作流通转存储', 1539360000, 1536831813),
(81, 4, 100017, 0, '15367894550', '1.0000', '1.0000', '0.1000', '用户操作流通转存储', 1539446400, 1536886626),
(82, 4, 100019, 0, '13677337935', '100.0000', '20.0000', '10.0000', '用户操作流通转存储', 1536665000, 1536897643),
(83, 4, 100028, 0, '13487583399', '200.0000', '200.0000', '20.0000', '用户操作流通转存储', 1539446400, 1536907858),
(84, 1, 100017, 0, '15367894550', '1000.0000', '1000.0000', '100.0000', '管理员操作', 1539446400, 1536913082),
(85, 1, 100025, 0, '13720223000', '50000.0000', '50000.0000', '5000.0000', '管理员操作', 1539446400, 1536916526),
(86, 1, 100017, 0, '15367894550', '47999.0000', '47999.0000', '4799.9000', '管理员操作', 1539446400, 1536917269),
(87, 4, 100017, 0, '15367894550', '1000.0000', '1000.0000', '100.0000', '用户操作流通转存储', 1539446400, 1536917506),
(88, 1, 100017, 0, '15367894550', '150000.0000', '150000.0000', '15000.0000', '管理员操作', 1539446400, 1536918451),
(89, 4, 100017, 0, '15367894550', '100.0000', '100.0000', '10.0000', '用户操作流通转存储', 1539532800, 1536981444),
(90, 2, 100017, 100017, '15367894550', '4.0000', '4.0000', '0.4000', '后台兑冲拨币,交易ID:23', 1539532800, 1536987431),
(91, 1, 100042, 0, '13606165222', '10000.0000', '10000.0000', '1000.0000', '管理员操作', 1539532800, 1536990867),
(92, 2, 100017, 100042, '15367894550', '100.0000', '100.0000', '10.0000', '后台兑冲拨币,交易ID:25', 1539532800, 1536991071);

-- --------------------------------------------------------

--
-- Table structure for table `think_tic_staticlog`
--

CREATE TABLE `think_tic_staticlog` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `sid` int(11) NOT NULL DEFAULT '0' COMMENT '拨款用户ID',
  `ristatus` tinyint(1) NOT NULL COMMENT '1后台拨币 2l流转存 3存转流',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `ticb` varchar(10) NOT NULL COMMENT '拨币价',
  `action` decimal(10,2) NOT NULL COMMENT '拨币数量',
  `info` varchar(200) NOT NULL COMMENT '信息谁操作',
  `type` tinyint(1) NOT NULL COMMENT ' 1 转入 2 转出',
  `add_time` int(11) NOT NULL COMMENT '添加时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_tic_staticlog`
--

INSERT INTO `think_tic_staticlog` (`id`, `uid`, `sid`, `ristatus`, `username`, `ticb`, `action`, `info`, `type`, `add_time`) VALUES
(1, 100011, 0, 0, '15211322811', '3', '1000.00', '管理员操作后台拨币', 1, 1536198895),
(2, 100011, 0, 0, '15211322811', '3', '1000.00', '管理员操作后台拨币', 1, 1536198895),
(3, 100011, 0, 0, '15211322811', '3', '1000.00', '管理员操作后台拨币', 1, 1536198895),
(4, 100012, 0, 0, '15211322888', '3', '1000.00', '管理员操作后台拨币', 1, 1536198895),
(5, 100012, 0, 0, '15211322888', '3', '1000.00', '管理员操作后台拨币', 1, 1536198895),
(6, 100011, 0, 0, '15211322811', '2', '2000.00', '管理员操作后台拨币', 1, 1536198895),
(10, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536198895),
(11, 100014, 100011, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536198895),
(12, 100014, 100000, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536198895),
(13, 100014, 0, 0, '17673055071', '10000', '3.00', '管理员操作后台拨币', 1, 1536299970),
(14, 100014, 0, 0, '17673055071', '10000', '2.00', '管理员操作后台拨币', 1, 1536300510),
(15, 100014, 0, 0, '17673055071', '10000', '2.00', '管理员操作后台拨币', 1, 1536300544),
(16, 100014, 0, 0, '17673055071', '3', '10000.00', '管理员操作后台拨币', 1, 1536300663),
(17, 100014, 0, 0, '17673055071', '3', '10000.00', '管理员操作后台拨币', 1, 1536300729),
(18, 100014, 0, 0, '17673055071', '3', '10000.00', '管理员操作后台拨币', 1, 1536300747),
(19, 100012, 0, 0, '15211322888', '3', '10000.00', '管理员操作后台拨币', 1, 1536300771),
(20, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536301250),
(21, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536301411),
(22, 100014, 0, 0, '17673055071', '3', '10000.00', '管理员操作后台拨币', 1, 1536301461),
(23, 100014, 0, 0, '17673055071', '3', '10000.00', '管理员操作后台拨币', 1, 1536301532),
(24, 100016, 0, 0, '18890608054', '2', '10000.00', '管理员操作后台拨币', 1, 1536304077),
(25, 100015, 0, 0, '15897381680', '2', '10000.00', '管理员操作后台拨币', 1, 1536304087),
(26, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536304098),
(27, 100000, 0, 0, '18163626560', '6', '600.00', '管理员操作后台拨币', 1, 1536305770),
(28, 100000, 0, 0, '18163626560', '6', '3000.00', '管理员操作后台拨币', 1, 1536305817),
(29, 100015, 0, 0, '15897381680', '6', '5000.00', '管理员操作后台拨币', 1, 1536305851),
(30, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536306627),
(31, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536306708),
(32, 100014, 0, 0, '17673055071', '1', '10000.00', '管理员操作后台拨币', 1, 1536306808),
(33, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536306904),
(34, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536306915),
(35, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536471862),
(36, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536307000),
(37, 100014, 0, 0, '17673055071', '2', '10000.00', '管理员操作后台拨币', 1, 1536307097),
(38, 100018, 0, 0, '18273154511', '1', '10000.00', '管理员操作后台拨币', 1, 1536307283),
(39, 100000, 0, 0, '18163626560', '4.50', '1111.11', '管理员操作后台拨币', 1, 1536311963),
(40, 100000, 0, 0, '18163626560', '4.50', '4444.44', '管理员操作后台拨币', 1, 1536314503),
(42, 100018, 0, 0, '18273154511', '5', '1000.00', '管理员操作后台拨币', 1, 1536471822),
(43, 100011, 0, 0, '15211322811', '5', '2000.00', '管理员操作后台拨币', 1, 1536471862),
(44, 100000, 0, 0, '18163626560', '3', '1666.67', '管理员操作后台拨币', 1, 1536479102),
(45, 100011, 0, 0, '15211322811', '3.00', '2000.00', '后台兑冲拨币,交易ID:3', 1, 1536487160),
(46, 100011, 0, 0, '15211322811', '3.00', '1000.00', '后台兑冲拨币,交易ID:5', 1, 1536491678),
(47, 100011, 0, 0, '15211322811', '3.00', '10000.00', '后台兑冲拨币,交易ID:5', 1, 1536491758),
(48, 100000, 0, 0, '18163626560', '3.00', '5000.00', '用户流通转存储', 1, 1536570151),
(49, 100000, 0, 0, '18163626560', '3.00', '1000.00', '用户流通转存储', 1, 1536570518),
(50, 100000, 0, 0, '18163626560', '3.00', '1000.00', '用户流通转存储', 1, 1536574549),
(51, 100013, 0, 0, '18516067713', '5', '1.00', '用户流通转存储', 1, 1536637703),
(52, 100013, 0, 0, '18516067713', '5', '1.00', '用户流通转存储', 1, 1536645217),
(53, 100013, 0, 0, '18516067713', '5', '1.00', '用户流通转存储', 1, 1536646290),
(54, 100013, 0, 0, '18516067713', '5', '1.00', '用户流通转存储', 1, 1536648355),
(59, 100011, 0, 0, '15211322811', '5', '100.00', '后台兑冲拨币,交易ID:20', 1, 1536720632),
(60, 100023, 0, 0, '17052840030', '1', '2100.00', '管理员操作后台拨币', 1, 1536720862),
(61, 100023, 0, 0, '17052840030', '2', '2500.00', '管理员操作后台拨币', 1, 1536720941),
(62, 100022, 0, 0, '15274912795', '2', '2500.00', '管理员操作后台拨币', 1, 1536721040),
(63, 100024, 0, 0, '15387528217', '1', '2100.00', '管理员操作后台拨币', 1, 1536721416),
(64, 100024, 0, 0, '15387528217', '1', '210000.00', '管理员操作后台拨币', 1, 1536721447),
(65, 100024, 0, 0, '15387528217', '1', '1200000.00', '管理员操作后台拨币', 1, 1536721479),
(66, 100021, 0, 0, '18163626562', '1', '210000.00', '管理员操作后台拨币', 1, 1536721514),
(67, 100024, 0, 0, '15387528217', '1', '2000.00', '管理员操作后台拨币', 1, 1536731090),
(68, 100022, 0, 0, '15274912795', '1', '2500.00', '管理员操作后台拨币', 1, 1536731525),
(69, 100013, 0, 0, '18516067713', '2', '1.00', '用户流通转存储', 1, 1536740708),
(70, 100028, 0, 0, '13487583399', '1', '10000.00', '管理员操作后台拨币', 1, 1536747800),
(71, 100019, 0, 0, '13677337935', '1', '2000.00', '管理员操作后台拨币', 1, 1536802676),
(72, 100013, 0, 0, '18516067713', '2', '1.00', '用户流通转存储', 1, 1536830412),
(73, 100025, 0, 0, '13720223000', '2', '1.00', '用户流通转存储', 1, 1536831813),
(74, 100017, 0, 0, '15367894550', '2', '1.00', '用户流通转存储', 1, 1536886626),
(75, 100019, 0, 2, '13677337935', '2', '100.00', '用户流通转存储', 1, 1536897643),
(76, 100028, 0, 1, '13487583399', '2', '200.00', '用户流通转存储', 1, 1536907858),
(77, 100017, 0, 1, '15367894550', '1', '1000.00', '管理员操作后台拨币', 1, 1536913082),
(78, 100025, 0, 1, '13720223000', '1', '50000.00', '管理员操作后台拨币', 1, 1536916526),
(79, 100017, 0, 1, '15367894550', '1', '47999.00', '管理员操作后台拨币', 1, 1536917269),
(80, 100017, 0, 2, '15367894550', '3', '1000.00', '用户流通转存储', 1, 1536917506),
(81, 100017, 0, 1, '15367894550', '1', '150000.00', '管理员操作后台拨币', 1, 1536918451),
(82, 100000, 0, 3, '18163626560', '3', '1000.00', '用户存储转流通', 1, 1536918968),
(83, 100013, 0, 3, '18516067713', '3', '1.00', '用户存储转流通', 1, 1536979154),
(84, 100019, 0, 3, '13677337935', '3', '100.00', '用户存储转流通', 1, 1536981232),
(85, 100019, 0, 3, '13677337935', '3', '100.00', '用户存储转流通', 1, 1536981249),
(86, 100017, 0, 2, '15367894550', '3', '100.00', '用户流通转存储', 1, 1536981444),
(87, 100017, 0, 0, '15367894550', '3', '4.00', '后台兑冲拨币,交易ID:23', 1, 1536987431),
(88, 100042, 0, 1, '13606165222', '1', '10000.00', '管理员操作后台拨币', 1, 1536990867),
(89, 100017, 0, 0, '15367894550', '3', '100.00', '后台兑冲拨币,交易ID:25', 1, 1536991071);

-- --------------------------------------------------------

--
-- Table structure for table `think_tic_totallog`
--

CREATE TABLE `think_tic_totallog` (
  `id` int(11) NOT NULL COMMENT 'id',
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `num` varchar(50) NOT NULL COMMENT '交易金额',
  `typetic` tinyint(1) NOT NULL COMMENT 'Tic类型 1 存储 2流通 3 应用',
  `info` varchar(50) NOT NULL COMMENT '信息',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态 1 无效 2通过',
  `add_time` int(11) NOT NULL COMMENT '添加时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `think_tic_totallog`
--

INSERT INTO `think_tic_totallog` (`id`, `uid`, `num`, `typetic`, `info`, `status`, `add_time`) VALUES
(1, 100013, '-1000.0000', 1, '提取', 1, 1536495317),
(2, 100013, '-1000.0000', 1, '提取', 1, 1536495330),
(3, 100013, '+1000.0000', 3, '流通转应用', 2, 1536495423),
(4, 100000, '-5000', 2, '转存储', 2, 1536570151),
(5, 100013, '-1000', 2, '转存储', 2, 1536570518),
(6, 100019, '+0', 2, '兑冲拨币', 1, 1536573941),
(7, 100019, '+0', 2, '兑冲拨币', 1, 1536573951),
(8, 100019, '+0', 2, '兑冲拨币', 1, 1536573952),
(9, 100019, '+0', 2, '兑冲拨币', 1, 1536573953),
(10, 100019, '+0', 2, '兑冲拨币', 1, 1536573953),
(11, 100019, '+0', 2, '兑冲拨币', 1, 1536573954),
(12, 100019, '+0', 2, '兑冲拨币', 1, 1536573954),
(13, 100019, '+0', 2, '兑冲拨币', 1, 1536573955),
(14, 100019, '+0', 2, '兑冲拨币', 1, 1536573955),
(15, 100019, '+0', 2, '兑冲拨币', 1, 1536573960),
(16, 100019, '+0', 2, '兑冲拨币', 1, 1536573961),
(17, 100019, '+0', 2, '兑冲拨币', 1, 1536573961),
(18, 100019, '+0', 2, '兑冲拨币', 1, 1536573961),
(19, 100019, '+0', 2, '兑冲拨币', 1, 1536573961),
(20, 100000, '-1000', 2, '转存储', 2, 1536574549),
(21, 100000, '+500', 3, '流通转应用', 2, 1536575918),
(22, 100000, '+500', 3, '流通转应用', 2, 1536581123),
(23, 100000, '-500', 3, '资产包转流通', 2, 1536583904),
(24, 100000, '-80', 3, '转流通', 2, 1536586924),
(25, 100000, '-100', 3, '转流通', 2, 1536587000),
(26, 100000, '+100', 3, '流通转应用', 2, 1536588040),
(27, 100000, '+100', 3, '流通转应用', 2, 1536588066),
(28, 100013, '-1', 1, '提取', 2, 1536635203),
(29, 100013, '-1', 1, '提取', 2, 1536635404),
(30, 100013, '-1', 1, '提取', 2, 1536635499),
(31, 100013, '-1', 1, '提取', 2, 1536635609),
(32, 100013, '-1', 1, '提取', 2, 1536635618),
(33, 100013, '-1', 1, '提取', 2, 1536635649),
(34, 100013, '-1', 1, '提取', 2, 1536635840),
(35, 100013, '-1', 1, '提取', 2, 1536636025),
(36, 100013, '-1', 1, '提取', 2, 1536636278),
(37, 100013, '-1', 1, '提取', 2, 1536636282),
(38, 100013, '-1', 1, '提取', 2, 1536636344),
(39, 100013, '-1', 1, '提取', 2, 1536636510),
(40, 100013, '-1', 1, '提取', 2, 1536636649),
(41, 100013, '-1', 1, '提取', 2, 1536636689),
(42, 100013, '-1', 1, '提取', 2, 1536636847),
(43, 100013, '-4', 1, '提取', 2, 1536637318),
(44, 100013, '-1', 2, '转存储', 2, 1536637703),
(45, 100013, '-1', 1, '提取', 2, 1536644332),
(46, 100013, '-1', 2, '转存储', 2, 1536645217),
(47, 100013, '-0.8', 3, '转流通', 2, 1536645817),
(48, 100013, '-1.6', 3, '转流通', 2, 1536645840),
(49, 100013, '-1.6', 3, '转流通', 2, 1536645911),
(50, 100013, '-1.6', 3, '转流通', 2, 1536645947),
(51, 100013, '-0.8', 3, '转流通', 2, 1536645993),
(52, 100013, '-0.8', 3, '转流通', 2, 1536645998),
(53, 100013, '-1', 3, '转流通', 2, 1536646161),
(54, 100013, '-1.6', 3, '转流通', 2, 1536646179),
(55, 100013, '-0.8', 3, '转流通', 2, 1536646240),
(56, 100013, '-1', 3, '转流通', 2, 1536646253),
(57, 100013, '-1', 2, '转存储', 2, 1536646290),
(58, 100013, '-1', 1, '提取', 2, 1536646307),
(59, 100013, '-0.8', 3, '转流通', 2, 1536647392),
(60, 100013, '-1', 3, '转流通', 2, 1536647882),
(61, 100013, '-0.8', 3, '转流通', 2, 1536647977),
(62, 100013, '-0.8', 3, '转流通', 2, 1536648006),
(63, 100013, '-1', 2, '转存储', 2, 1536648355),
(64, 100013, '-0.8', 3, '转流通', 2, 1536649733),
(65, 100013, '-1', 1, '提取', 2, 1536651536),
(66, 100019, '-30', 1, '提取', 2, 1536660907),
(67, 100019, '-25', 1, '提取', 2, 1536660926),
(68, 100019, '+300', 3, '流通转应用', 2, 1536663114),
(69, 100019, '+500', 3, '流通转应用', 2, 1536663150),
(70, 100019, '+500', 3, '流通转应用', 2, 1536669427),
(71, 100019, '+300', 3, '流通转应用', 2, 1536669462),
(72, 100000, '+50', 2, '兑冲拨币', 1, 1536720569),
(73, 100024, '+20000', 3, '流通转应用', 2, 1536723767),
(74, 100024, '-8000', 3, '转流通', 2, 1536723798),
(75, 100013, '-1', 1, '提取', 2, 1536733443),
(76, 100013, '-1', 1, '提取', 2, 1536740501),
(77, 100013, '-1', 2, '转存储', 2, 1536740708),
(78, 100019, '-200', 1, '提取', 2, 1536802928),
(79, 100013, '-1', 3, '转流通', 2, 1536830396),
(80, 100013, '-1', 2, '转存储', 2, 1536830412),
(81, 100013, '-1', 3, '转流通', 2, 1536830428),
(82, 100025, '-1', 2, '转存储', 2, 1536831813),
(83, 100015, '+5', 2, '兑冲拨币', 1, 1536837049),
(84, 100017, '-1', 2, '转存储', 2, 1536886626),
(85, 100015, '+10', 2, '兑冲拨币', 1, 1536895059),
(86, 100019, '-200', 1, '提取', 2, 1536897625),
(87, 100019, '-100', 2, '转存储', 2, 1536897643),
(88, 100019, '-80', 3, '转流通', 2, 1536897662),
(89, 100028, '-200', 2, '转存储', 2, 1536907858),
(90, 100017, '+2', 2, '兑冲拨币', 1, 1536908808),
(91, 100017, '+2000', 3, '流通转应用', 2, 1536917400),
(92, 100017, '+2000', 3, '流通转应用', 2, 1536917448),
(93, 100017, '-1000', 2, '转存储', 2, 1536917506),
(94, 100000, '-1000', 1, '提取', 2, 1536918968),
(95, 100013, '-1', 1, '提取', 2, 1536979154),
(96, 100017, '+50', 2, '兑冲拨币', 1, 1536981227),
(97, 100019, '-100', 1, '提取', 2, 1536981232),
(98, 100019, '-100', 1, '提取', 2, 1536981249),
(99, 100017, '-100', 2, '转存储', 2, 1536981444),
(100, 100042, '+50', 2, '兑冲拨币', 1, 1536991031);

-- --------------------------------------------------------

--
-- Table structure for table `think_trade_order`
--

CREATE TABLE `think_trade_order` (
  `id` int(10) UNSIGNED NOT NULL,
  `uid` int(11) NOT NULL DEFAULT '0',
  `username_buy` char(50) NOT NULL COMMENT '账号',
  `wallet_address_buy` char(50) NOT NULL DEFAULT '' COMMENT '我的钱包地址',
  `wechat_buy` varchar(100) NOT NULL DEFAULT '' COMMENT '微信',
  `alipay_buy` varchar(100) NOT NULL DEFAULT '' COMMENT '支付宝',
  `phone_buy` varchar(100) NOT NULL DEFAULT '' COMMENT '手机号',
  `cid` int(11) NOT NULL DEFAULT '0',
  `username_sell` char(50) NOT NULL COMMENT 'c账号',
  `wallet_address_sell` char(50) NOT NULL DEFAULT '' COMMENT '对方钱包地址',
  `wechat_sell` varchar(100) NOT NULL DEFAULT '' COMMENT '微信',
  `alipay_sell` varchar(100) NOT NULL DEFAULT '' COMMENT '支付宝',
  `phone_sell` varchar(100) NOT NULL DEFAULT '' COMMENT '手机号',
  `price` decimal(7,3) NOT NULL DEFAULT '0.000' COMMENT '交易价',
  `num` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '交易数量',
  `total` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '总金币',
  `sxf` decimal(7,3) NOT NULL DEFAULT '0.000' COMMENT '手续费',
  `note` varchar(200) NOT NULL DEFAULT '' COMMENT '补充说明',
  `trade_type` smallint(6) NOT NULL DEFAULT '0' COMMENT '1交易大厅/2对点/3交易专员/',
  `status` smallint(6) NOT NULL DEFAULT '0' COMMENT '0待买入,1已撤回,2已有买入,3取消,5成功交易,6投诉',
  `type` smallint(6) NOT NULL DEFAULT '0' COMMENT '1,买单，2卖单/是发起买还是发起卖单',
  `image1` varchar(500) NOT NULL DEFAULT '' COMMENT '交易证据1',
  `image2` varchar(500) NOT NULL DEFAULT '' COMMENT '交易证据2',
  `image3` varchar(500) NOT NULL DEFAULT '' COMMENT '交易证据3',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '开始交易时间',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '完成交易时间',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `think_admin`
--
ALTER TABLE `think_admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `think_adminmoney`
--
ALTER TABLE `think_adminmoney`
  ADD PRIMARY KEY (`money`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `think_adminmoney_log`
--
ALTER TABLE `think_adminmoney_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_attribute`
--
ALTER TABLE `think_attribute`
  ADD PRIMARY KEY (`attr_id`);

--
-- Indexes for table `think_auth_group`
--
ALTER TABLE `think_auth_group`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_auth_group_access`
--
ALTER TABLE `think_auth_group_access`
  ADD UNIQUE KEY `uid_group_id` (`uid`,`group_id`),
  ADD KEY `uid` (`uid`),
  ADD KEY `group_id` (`group_id`);

--
-- Indexes for table `think_auth_rule`
--
ALTER TABLE `think_auth_rule`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `think_banner`
--
ALTER TABLE `think_banner`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_cart`
--
ALTER TABLE `think_cart`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_comment`
--
ALTER TABLE `think_comment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_config`
--
ALTER TABLE `think_config`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_eth_log`
--
ALTER TABLE `think_eth_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_exchange`
--
ALTER TABLE `think_exchange`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_gold_log`
--
ALTER TABLE `think_gold_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uid` (`uid`) COMMENT 'uid索引';

--
-- Indexes for table `think_gold_static_gold`
--
ALTER TABLE `think_gold_static_gold`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uid` (`id`);

--
-- Indexes for table `think_gold_static_log`
--
ALTER TABLE `think_gold_static_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uid` (`uid`) COMMENT 'uid索引';

--
-- Indexes for table `think_integral_log`
--
ALTER TABLE `think_integral_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uid` (`uid`) COMMENT 'uid索引';

--
-- Indexes for table `think_kefu`
--
ALTER TABLE `think_kefu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `think_member`
--
ALTER TABLE `think_member`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `mobile` (`mobile`),
  ADD UNIQUE KEY `wallet_address` (`wallet_address`),
  ADD KEY `idx_parent_id` (`parent_id`) COMMENT 'parent_id索引',
  ADD KEY `idx_parent_mobile` (`parent_mobile`) COMMENT 'parent_mobile索引';

--
-- Indexes for table `think_member_address`
--
ALTER TABLE `think_member_address`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_member_card`
--
ALTER TABLE `think_member_card`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uid` (`uid`) COMMENT 'uid索引';

--
-- Indexes for table `think_member_fandian`
--
ALTER TABLE `think_member_fandian`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_member_getnum`
--
ALTER TABLE `think_member_getnum`
  ADD UNIQUE KEY `inx_num` (`uid`);

--
-- Indexes for table `think_member_info`
--
ALTER TABLE `think_member_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uid` (`uid`);

--
-- Indexes for table `think_member_randmoney`
--
ALTER TABLE `think_member_randmoney`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_member_tic`
--
ALTER TABLE `think_member_tic`
  ADD UNIQUE KEY `indx_user_id` (`uid`);

--
-- Indexes for table `think_message`
--
ALTER TABLE `think_message`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_money_log`
--
ALTER TABLE `think_money_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uid` (`uid`) COMMENT 'uid索引';

--
-- Indexes for table `think_news`
--
ALTER TABLE `think_news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_news_category`
--
ALTER TABLE `think_news_category`
  ADD PRIMARY KEY (`cat_id`);

--
-- Indexes for table `think_order_goods`
--
ALTER TABLE `think_order_goods`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_order_info`
--
ALTER TABLE `think_order_info`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `order_sn` (`order_sn`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_userid` (`user_id`);

--
-- Indexes for table `think_order_trend`
--
ALTER TABLE `think_order_trend`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_product`
--
ALTER TABLE `think_product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_product_category`
--
ALTER TABLE `think_product_category`
  ADD PRIMARY KEY (`cat_id`);

--
-- Indexes for table `think_product_order`
--
ALTER TABLE `think_product_order`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_put_integral`
--
ALTER TABLE `think_put_integral`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uid` (`uid`);

--
-- Indexes for table `think_put_integral_log`
--
ALTER TABLE `think_put_integral_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uid` (`uid`) COMMENT 'uid索引';

--
-- Indexes for table `think_region`
--
ALTER TABLE `think_region`
  ADD PRIMARY KEY (`region_id`);

--
-- Indexes for table `think_static_config`
--
ALTER TABLE `think_static_config`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_static_gold_rid`
--
ALTER TABLE `think_static_gold_rid`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uid` (`uid`) COMMENT 'uid索引';

--
-- Indexes for table `think_tic_bobi`
--
ALTER TABLE `think_tic_bobi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_tic_liutonglog`
--
ALTER TABLE `think_tic_liutonglog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_tic_reless`
--
ALTER TABLE `think_tic_reless`
  ADD PRIMARY KEY (`uid`);

--
-- Indexes for table `think_tic_shifanglog`
--
ALTER TABLE `think_tic_shifanglog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_tic_static`
--
ALTER TABLE `think_tic_static`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_tic_staticlog`
--
ALTER TABLE `think_tic_staticlog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_tic_totallog`
--
ALTER TABLE `think_tic_totallog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `think_trade_order`
--
ALTER TABLE `think_trade_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uid` (`uid`),
  ADD KEY `idx_cid` (`cid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `think_admin`
--
ALTER TABLE `think_admin`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `think_adminmoney_log`
--
ALTER TABLE `think_adminmoney_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id', AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `think_attribute`
--
ALTER TABLE `think_attribute`
  MODIFY `attr_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `think_auth_group`
--
ALTER TABLE `think_auth_group`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `think_auth_rule`
--
ALTER TABLE `think_auth_rule`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `think_banner`
--
ALTER TABLE `think_banner`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT for table `think_cart`
--
ALTER TABLE `think_cart`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `think_comment`
--
ALTER TABLE `think_comment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `think_config`
--
ALTER TABLE `think_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `think_eth_log`
--
ALTER TABLE `think_eth_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `think_exchange`
--
ALTER TABLE `think_exchange`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `think_gold_log`
--
ALTER TABLE `think_gold_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `think_gold_static_gold`
--
ALTER TABLE `think_gold_static_gold`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100000;

--
-- AUTO_INCREMENT for table `think_gold_static_log`
--
ALTER TABLE `think_gold_static_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `think_integral_log`
--
ALTER TABLE `think_integral_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `think_kefu`
--
ALTER TABLE `think_kefu`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `think_member`
--
ALTER TABLE `think_member`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100044;

--
-- AUTO_INCREMENT for table `think_member_address`
--
ALTER TABLE `think_member_address`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `think_member_card`
--
ALTER TABLE `think_member_card`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `think_member_fandian`
--
ALTER TABLE `think_member_fandian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id', AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT for table `think_member_info`
--
ALTER TABLE `think_member_info`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `think_member_randmoney`
--
ALTER TABLE `think_member_randmoney`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=411;

--
-- AUTO_INCREMENT for table `think_message`
--
ALTER TABLE `think_message`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100002;

--
-- AUTO_INCREMENT for table `think_money_log`
--
ALTER TABLE `think_money_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `think_news`
--
ALTER TABLE `think_news`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `think_news_category`
--
ALTER TABLE `think_news_category`
  MODIFY `cat_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `think_order_goods`
--
ALTER TABLE `think_order_goods`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `think_order_info`
--
ALTER TABLE `think_order_info`
  MODIFY `order_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `think_order_trend`
--
ALTER TABLE `think_order_trend`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `think_product`
--
ALTER TABLE `think_product`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `think_product_category`
--
ALTER TABLE `think_product_category`
  MODIFY `cat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `think_product_order`
--
ALTER TABLE `think_product_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `think_put_integral`
--
ALTER TABLE `think_put_integral`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100000;

--
-- AUTO_INCREMENT for table `think_put_integral_log`
--
ALTER TABLE `think_put_integral_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `think_region`
--
ALTER TABLE `think_region`
  MODIFY `region_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `think_static_config`
--
ALTER TABLE `think_static_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `think_static_gold_rid`
--
ALTER TABLE `think_static_gold_rid`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100000;

--
-- AUTO_INCREMENT for table `think_tic_bobi`
--
ALTER TABLE `think_tic_bobi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增id', AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `think_tic_liutonglog`
--
ALTER TABLE `think_tic_liutonglog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id', AUTO_INCREMENT=134;

--
-- AUTO_INCREMENT for table `think_tic_shifanglog`
--
ALTER TABLE `think_tic_shifanglog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id', AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `think_tic_static`
--
ALTER TABLE `think_tic_static`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `think_tic_staticlog`
--
ALTER TABLE `think_tic_staticlog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT for table `think_tic_totallog`
--
ALTER TABLE `think_tic_totallog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id', AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `think_trade_order`
--
ALTER TABLE `think_trade_order`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100000;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
