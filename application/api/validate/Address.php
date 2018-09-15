<?php
namespace app\api\validate;
use think\Validate;

/**
* 地址验证
*/
class Address extends Validate
{
    protected $rule = [
        'province'   => 'require|number',
        'city'       => 'require|number',
        'area'       => 'require|number',
        'address'    => 'require',
        'name'       => 'require',
        'mobile'     => 'require',
        'is_default' => 'boolean',
    ];

    protected $message = [
        'province.require' =>  '必须选择省',
        'city.require'     =>  '必须选择市',
        'area.require'     =>  '必须选择区',
        'address.require'  => '必须填写地址',
    ];
}