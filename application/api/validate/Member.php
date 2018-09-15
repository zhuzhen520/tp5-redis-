<?php
namespace app\api\validate;
use think\Validate;

/*
    会员登陆验证
*/

class Member extends Validate
{
    protected $rule = [
        'username' => 'require|length:11',
        'password' => 'require|length:6,20',
    ];

    protected $message = [
        'username.require' => '必须填写账号',
        'password.require' => '必须填写密码',
        'password.length' => '密码长度错误',
        'username.length' => '账号长度错误',
    ];
} 