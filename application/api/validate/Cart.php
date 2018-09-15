<?php
namespace app\api\validate;
use think\Validate;

/*
    会员登陆验证
*/

class Cart extends Validate
{
    protected $rule = [
        'user_id'    => 'require',
        'pro_id'     => 'require',
        'price'      => 'require|gt:0',
        'buy_number' => 'gt:0',
        'subtotal'   => 'require',
    ];

    protected $message = [
        'user_id'          => '登陆已过期',
        'pro_id.require'   => '产品错误',
        'price.require'    => '价格错误',
        'price.gt'         => '价格错误',
        'buy_number.gt'    => '购买数量必须大于0',
        'subtotal.require' => '错误',
    ];
} 