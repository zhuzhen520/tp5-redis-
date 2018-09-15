<?php
namespace app\api\validate;
use think\Validate;

class Market extends Validate
{
    protected $rule = [
        'wallet_address' => 'require',
        'num' => 'require|number|gt:0',
    ];

    protected $message = [
        'wallet_address.require' => '必须填写钱包地址',
        'num.require' => '必须填写转出数量',
        'num.number' => '转出数量错误',
        'num.gt' => '转出数量必须大于0',
    ];
}