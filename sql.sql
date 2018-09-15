create table think_admin(
id int unsigned primary key auto_increment,
username varchar(30) not null unique,
password char(32) not null default '',
entry char(32) not null default '',
nickname varchar(50) not null default '',
login_num int not null default 0,
login_ip varchar(30) not null default '',
login_time int not null default 0
)engine=myisam charset=utf8;

create table think_member(
id int unsigned primary key auto_increment,
username  char(50) not null unique comment '账号',
nickname varchar(60) not null default '' comment '昵称',
mobile varchar(30) not null unique  comment '电话',
password char(32) not null default '',
token char(32) not null default '' comment '支付密码',
entry char(6) not null default '',
wallet_address char(50) not null unique comment '钱包地址',
avatar varchar(300) not null default '' comment '头像',
money decimal(10,3) not null default 0.000 comment '余额',
gold_static decimal(10,3) not null default 0.000 comment '静态金币',
gold decimal(10,3) not null default 0.000 comment '金币',
integral decimal(10,3) not null default 0.000 comment '积分',
level smallint not null default 0 comment '级别',
parent_id int not null default 0 comment '上级id',
parent_mobile varchar(30) not null default '' comment '上级手机号码',
sex tinyint not null default 0,
reg_time int not null default 0 comment '注册时间',
rid_speed decimal(5,4) not null default 0.02 comment '释放速度',
is_trade tinyint not null default 0 comment '交易限制',
is_admin tinyint not null default 0 comment '管理员',
is_login tinyint not null default 0 comment '登陆限制',
login_time int not null default 0 comment '登陆时间',

gold_static_price decimal(10,3) not null default 0.000 comment '静态金币价',
put_integral decimal(10,3) not null default 0.000 comment '可提现额度',

index idx_parent_id(parent_id) comment 'parent_id索引',
index idx_parent_mobile(parent_mobile) comment 'parent_mobile索引'
)charset=utf8 auto_increment=100000;

create table think_member_info(
id int unsigned primary key auto_increment,
uid int not null unique comment '账号id',
username varchar(50) not null default '',
name varchar(50) not null default '' comment '姓名',
card_no char(50) not null default '' comment '身份证号码',
WeChat varchar(100) not null default '' comment '微信',
alipay varchar(50) not null default '' comment '支付宝'
)engine=myisam charset=utf8;

create table think_member_card(
id int unsigned primary key auto_increment,
uid int not null comment '账号id',
username varchar(50) not null default '',
name varchar(50) not null default '' comment '姓名',
card varchar(100) not null default '' comment '银行卡',
khh varchar(200) not null default '' comment '开户行',
khzh varchar(200) not null default '' comment '开支户行',
index idx_uid(uid) comment 'uid索引'
)engine=myisam charset=utf8;

create table think_integral_log(
id int unsigned primary key auto_increment,
uid int not null comment '账号id',
username  char(50) not null comment '账号',
action decimal(10,3) not null default 0.000 comment '变动金额',
money_end decimal(10,3) not null default 0.000 comment '余额',
info varchar(300) not null default '' comment '备注',
order_sn varchar(200) not null default '' comment '订单号',
type tinyint not null default 0 comment '类型/0支出/1收入',
action_type tinyint not null default 0 comment '1静态奖励/2首推奖/3团队管理/4新增业绩奖/5新增业同级绩奖/6兑换金币/7提现',
add_time int not null default 0 comment '操作时间',
index idx_uid(uid) comment 'uid索引'
)engine=myisam charset=utf8;

create table think_gold_log(
id int unsigned primary key auto_increment,
uid int not null comment '账号id',
username  char(50) not null comment '账号',
action decimal(10,3) not null default 0.000 comment '变动金额',
money_end decimal(10,3) not null default 0.000 comment '余额',
info varchar(300) not null default '' comment '备注',
order_sn varchar(200) not null default '' comment '订单号',
type tinyint not null default 0 comment '类型/0支出/1',
action_type tinyint not null default 0 comment '1普通来源/2交易/3兑换/4静态释放/5动态转静态',
add_time int not null default 0 comment '操作时间',
index idx_uid(uid) comment 'uid索引'
)engine=myisam charset=utf8;

create table think_gold_static_log(
id int unsigned primary key auto_increment,
uid int not null comment '账号id',
username  char(50) not null comment '账号',
action decimal(10,3) not null default 0.000 comment '变动金额',
money_end decimal(10,3) not null default 0.000 comment '余额',
info varchar(300) not null default '' comment '备注',
order_sn varchar(200) not null default '' comment '订单号',
type tinyint not null default 0 comment '类型/0支出/1',
action_type tinyint not null default 0 comment '1普通来源/2交易/3兑换/4静态释放/5动态转静态',
add_time int not null default 0 comment '操作时间',
index idx_uid(uid) comment 'uid索引'
)engine=myisam charset=utf8;

create table think_money_log(
id int unsigned primary key auto_increment,
uid int not null comment '账号id',
username  char(50) not null comment '账号',
action decimal(10,3) not null default 0.000 comment '变动金额',
money_end decimal(10,3) not null default 0.000 comment '余额',
info varchar(300) not null default '' comment '备注',
order_sn varchar(200) not null default '' comment '订单号',
type tinyint not null default 0 comment '类型/0支出/1',
action_type tinyint not null default 0 comment '1线下充值/2商城余额支付',
add_time int not null default 0 comment '操作时间',
index idx_uid(uid) comment 'uid索引'
)engine=myisam charset=utf8;

create table think_static_gold_rid(
id int unsigned primary key auto_increment,
uid int not null comment '账号id',
username  char(50) not null comment '账号',
action decimal(10,3) not null default 0.000 comment '变动金额',
money_end decimal(10,3) not null default 0.000 comment '余额',
info varchar(300) not null default '' comment '备注',
order_sn varchar(200) not null default '' comment '订单号',
type tinyint not null default 0 comment '类型/0支出/1',
action_type tinyint not null default 0 comment '',
status smallint not null default 0 comment '状态',
num int not null default 0 comment '累计释放次数',
sum_gold decimal(8,3) not null default 0.000 comment '累计释放',
start_time int not null default 0 comment '开始操作时间',
end_time int not null default 0 comment '结束操作时间',
index idx_uid(uid) comment 'uid索引'
)engine=myisam charset=utf8 auto_increment=100000;

create table think_put_integral_log(
id int unsigned primary key auto_increment,
uid int not null comment '账号id',
username  char(50) not null comment '账号',
action decimal(10,3) not null default 0.000 comment '变动金额',
money_end decimal(10,3) not null default 0.000 comment '余额',
info varchar(300) not null default '' comment '备注',
order_sn varchar(200) not null default '' comment '订单号',
type tinyint not null default 0 comment '类型/0支出/1收入',
action_type tinyint not null default 0 comment '',
add_time int not null default 0 comment '操作时间',
index idx_uid(uid) comment 'uid索引'
)engine=myisam charset=utf8;

create table think_news(
id int unsigned primary key auto_increment,
cat_id smallint unsigned not null default 0,
title varchar(300) not null default '',
title_tmp varchar(200) not null default '', 
description varchar(500) not null default '',
thumb varchar(200) not null default '',
src varchar(200) not null default '',
publish_time int not null default 0,
add_time int not null default 0,
keywords varchar(300) not null default '',
resource varchar(300) not null default '',
img_resource varchar(300) not null default '',
author varchar(200) not null default '',
content text,
is_recommend tinyint not null default 0
)engine=myisam charset=utf8;

create table think_news_category(
cat_id smallint unsigned primary key auto_increment,
cat_name varchar(50) not null default '',
note varchar(200) not null default '',
parent_id smallint unsigned not null default 0,
thumb varchar(300) not null default '' comment '缩略图',
sort int not null default 0,
is_show tinyint not null default 1
)engine=myisam charset=utf8;

create table think_product(
id int unsigned primary key auto_increment,
number char(20) not null unique default 0, 
cat_id smallint unsigned not null default 0,
name varchar(300) not null default '',
short_name varchar(300) not null default '',
thumb varchar(200) not null default '',
add_time int not null default 0,
content text,
is_recommend tinyint not null default 0,
shop_price decimal(7,2) not null default 0.00,
market_price decimal(7,2) not null default 0.00,
promote_price decimal(7,2) not null default 0.00,
promote_start int not null default 0,
promote_end int not null default 0,
stock smallint not null default 0,
is_delete tinyint not null default 0,
is_sale tinyint not null default 1
)engine=myisam charset=utf8;

create table think_attribute(
attr_id smallint unsigned primary key auto_increment,
attr_name varchar(50) not null default '',
parent_id smallint unsigned not null default 0,
sort int not null default 0,
is_show tinyint not null default 1
)engine=myisam charset=utf8;

create table think_product_attr(
pro_id int unsigned not null default 0,
attr_id smallint unsigned not null default 0,
price decimal(5,2) not null default 0.00,
attr_parent smallint unsigned not null default 0
)engine=myisam charset=utf8;

create table think_comment(
id int unsigned primary key auto_increment,
user_id int not null default 0,
pro_id int not null default 0,
order_id int not null default 0,
score tinyint not null default 0,
content varchar(300) not null default '',
add_time int not null default 0
)engine=myisam charset=utf8;



create table think_order_info(
order_id int unsigned primary key auto_increment,
order_sn char(30) unique not null default '',
order_pay char(50) not null default '',
user_id int unsigned not null default 0,
username  char(50) not null comment '账号',
province int not null default 0,
city int not null default 0,
area int not null default 0,
address varchar(200) not null default '',
zipcode char(6) not null default '',
name varchar(50) not null default '',
mobile varchar(30) not null default '',
note varchar(200) not null default '' comment '补充说明',
pay tinyint not null default 0 comment '支付方式' comment '支付方式1微信/2支付宝/3余额',
shipping_fee decimal(5,2) not null default 0.00 comment '运费',
total decimal(9,2) not null default 0.00,
add_time int not null default 0,
state tinyint not null default 0 comment '0提交1确认2取消',
pay_state tinyint not null default 0 comment '0未付款1已付款',
shipping_state tinyint not null default 0 comment '0未发货1已发货2已收货3已退货',
comment_state tinyint not null default 0 comment '0已评论1未评论',
cancel_time int not null default 0 comment '取消时间',
pay_time int not null default 0 comment '付款时间',
send_time int not null default 0 comment '发货时间',
get_time int not null default 0 comment '收货时间',
enfunds_time int not null default 0 comment '退货时间',
gold_static decimal(10,3) not null default 0.000 comment '订单返金币',
gold_price decimal(8,2) not null default 0.00 comment '当时金币价',

order_url varchar(800) not null default '',
index idx_username(username),
index idx_userid(user_id)
)charset=utf8;


create table think_order_goods(
id int unsigned primary key auto_increment,
order_id int not null default 0,
pro_id int unsigned not null default 0,
pro_name varchar(200) not null default '',
pro_thumb varchar(200) not null default '',
pro_attr varchar(100) not null default '',
attr_price decimal(5,2) not null default 0.00,
buy_number smallint unsigned not null default 0,
price decimal(7,2) not null default 0.00,
market_price decimal(7,2) not null default 0.00,
subtotal decimal(8,2) not null default 0.00
)engine=myisam charset=utf8;


create table think_region(
region_id int unsigned primary key auto_increment,
parent_id int unsigned not null default 0,
region_name varchar(50) not null default '',
region_type int unsigned not null default 0
)engine=myisam charset=utf8;


CREATE TABLE IF NOT EXISTS `think_order_trend` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dates` varchar(30) NOT NULL DEFAULT '',
  `date_time` int(11) NOT NULL DEFAULT '0',
  `price` decimal(8,2) NOT NULL DEFAULT '0.00',
  `highs` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '最高',
  `lows` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '最低',
  `add_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;


create table think_banner(
id int unsigned primary key auto_increment,
title int not null default 0,
image_path varchar(300) not null default '',
type char(10) not null default 0,
add_time varchar(50) not null default ''
)engine=myisam charset=utf8;

create table think_cart(
id int unsigned primary key auto_increment,
user_id int not null default 0,
ip varchar(30) not null default '',
pro_id int unsigned not null default 0,
pro_name varchar(200) not null default '',
pro_thumb varchar(200) not null default '',
pro_attr varchar(100) not null default '',
attr_id varchar(100) not null default '',
attr_price decimal(5,2) not null default 0.00,
buy_number smallint unsigned not null default 0,
price decimal(7,2) not null default 0.00,
market_price decimal(7,2) not null default 0.00,
subtotal decimal(8,2) not null default 0.00,
add_time int not null default 0
)engine=myisam charset=utf8;

create table think_member_address(
id int unsigned primary key auto_increment,
user_id int unsigned not null default 0,
province int not null default 0,
city int not null default 0,
area int not null default 0,
address varchar(200) not null default '',
zipcode char(6) not null default '',
name varchar(50) not null default '',
mobile varchar(30) not null default '',
is_default tinyint not null default 0,
add_time int not null default 0
)engine=myisam charset=utf8;

create table think_static_config(
id int unsigned primary key auto_increment,
name varchar(100) not null default '' comment '名称',
gold_up int not null default 0 comment '上限',
gold_lt int not null default 0 comment '下限',
rate decimal(5,3) not null default 0.000 comment '奖励',
type smallint not null default 0 comment '类型',
level smallint not null default 0 comment '等级',
add_time int not null default 0
)engine=myisam charset=utf8;


create table think_trade_order(
id int unsigned primary key auto_increment,

uid int not null default 0,
username_buy  char(50) not null comment '账号',
wallet_address_buy char(50) not null default '' comment '我的钱包地址',
wechat_buy varchar(100) not null default '' comment '微信',
alipay_buy varchar(100) not null default '' comment '支付宝',
phone_buy varchar(100) not null default '' comment '手机号', 

cid int not null default 0,
username_sell  char(50) not null comment 'c账号',
wallet_address_sell char(50) not null default '' comment '对方钱包地址',
wechat_sell varchar(100) not null default '' comment '微信',
alipay_sell varchar(100) not null default '' comment '支付宝',
phone_sell varchar(100) not null default '' comment '手机号', 

price decimal(7,3) not null default 0.000 comment '交易价',
num decimal(10,3) not null default 0.000 comment '交易数量',
total decimal(10,3) not null default 0.000 comment '总金币',
sxf decimal(7,3) not null default 0.000 comment '手续费',
note varchar(200) not null default '' comment '补充说明',
trade_type smallint not null default 0 comment '1交易大厅/2对点/3交易专员/',
status smallint not null default 0 comment '0待买入,1已撤回,2已有买入,3取消,5成功交易,6投诉',
type smallint not null default 0 comment '1,买单，2卖单/是发起买还是发起卖单',
image1 varchar(500) not null default '' comment '交易证据1',
image2 varchar(500) not null default '' comment '交易证据2',
image3 varchar(500) not null default '' comment '交易证据3',
start_time int not null default 0 comment '开始交易时间',
end_time int not null default 0 comment '完成交易时间',
add_time int not null default 0 comment '创建时间',
index idx_uid(uid),
index idx_cid(cid)
)engine=myisam charset=utf8 auto_increment=100000;

create table think_message(
id int unsigned primary key auto_increment,
uid int not null default 0,
username char(50) not null comment '账号',
admin_id int not null default 0,
name varchar(200) not null default '',
email varchar(200) not null default '',
phone varchar(200) not null default '',
content varchar(600) not null default '',
content_admin varchar(600) not null default '' comment '回复内容',
add_time int not null default 0,
state tinyint not null default 0 comment '0未阅读,1已回复'
)engine=myisam charset=utf8 auto_increment=100000;

create table think_put_integral(
id int unsigned primary key auto_increment,
uid int not null default 0,
username char(50) not null comment '账号',
action decimal(10,3) not null default 0.000 comment '变动金额',
money_end decimal(10,3) not null default 0.000 comment '余额',
order_sn varchar(200) not null default '' comment '订单号',
info varchar(500) not null default '' comment '备注',
status tinyint not null default 0 comment '0未审核/2已取消/3已驳回/5已经成功',
name varchar(50) not null default '' comment '姓名',
card varchar(100) not null default '' comment '银行卡',
khh varchar(200) not null default '' comment '开户行',
khzh varchar(200) not null default '' comment '开支户行',
add_time int not null default 0 comment '开始提现时间',
end_time int not null default 0 comment '处理提现时间',
index idx_uid(uid)
)charset=utf8 auto_increment=100000;

create table think_gold_static_gold(
id int unsigned primary key auto_increment,
uid int not null default 0,
username char(50) not null comment '账号',
action decimal(10,3) not null default 0.000 comment '转入数量',
money_end decimal(10,3) not null default 0.000 comment '余额',
total decimal(10,3) not null default 0.000 comment '总',
gold_price decimal(8,2) not null default 0.00 comment '当时金币价', 
add_time int not null default 0,
index idx_uid(id)
)charset=utf8 auto_increment=100000;



CREATE TABLE think_auth_rule(  
    `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,  
    `name` char(80) NOT NULL DEFAULT '',  
    `title` char(20) NOT NULL DEFAULT '',  
    `type` tinyint(1) NOT NULL DEFAULT '1',    
    `status` tinyint(1) NOT NULL DEFAULT '1',  
    `condition` char(100) NOT NULL DEFAULT '',  
    parent_id mediumint unsigned not null default 0,
    sort int not null default 0,
    param varchar(100) not null default '',
    PRIMARY KEY (`id`),  
    UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `think_auth_group` ( 
    `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT, 
    `title` char(100) NOT NULL DEFAULT '', 
    `status` tinyint(1) NOT NULL DEFAULT '1', 
    `rules` char(200) NOT NULL DEFAULT '',
    note varchar(200) not null default '',
    PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `think_auth_group_access` (  
    `uid` mediumint(8) unsigned NOT NULL,  
    `group_id` mediumint(8) unsigned NOT NULL, 
    UNIQUE KEY `uid_group_id` (`uid`,`group_id`),  
    KEY `uid` (`uid`), 
    KEY `group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;