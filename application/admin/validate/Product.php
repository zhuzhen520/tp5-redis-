<?php
namespace app\admin\validate;
use think\Validate;
/**
* 产品验证器
*/
class Product extends Validate
{
    
    protected $rule = [
        'name'         => 'require', //商品名称
        'totalmianji'      => 'require', // 内容
        'dream_money' => 'number', //预计收益
        'start_money'   => 'number', //商城价
    ];
    protected $message = [
        'name.require'        => '必须填写标的来源',
        'dream_money.require'        => '必须填写预计收益',
        'start_money.require'        => '必须填写起投金额',
    ];
}