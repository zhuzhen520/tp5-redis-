<?php
namespace app\api\validate;
use think\Validate;

/*
    会员注册验证
*/

class Register extends Validate
{
    protected $rule = [
        'code'       => 'require|length:11',
//        'PayToken'   => 'require',
        'username'   => 'require|unique:member|length:11',
        'password'   => 'require|length:6,20',
        'mobile'     => 'unique:member', //唯一，表
//        'repassword' =>'require|confirm:password',
    ];

    protected $message = [
        'code.require' => '邀请1码必须填写',
        'code.length' => '邀请码必须是11位',   
//        'PayToken.require' => '支付密码必须填写',

        'username.require' => '必须填写账号',
        'username.length' => '账号长度错误',
        'username.unique' => '账号已注册',

        'mobile.unique' => '手机号已注册',

        'password.require' => '必须填写密码',
        'password.length' => '密码长度错误',

//        'repassword.require' => '必须填写确认密码',
//        'repassword.confirm' => '确认密码错误',

    ];
} 