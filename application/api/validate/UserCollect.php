<?php

namespace app\api\validate;

use think\Validate;

class UserCollect extends Validate
{
    protected $rule = [
        'type' => 'require',
        'source_id' => 'require',
    ];

    protected $message = [
        'type.require' => '收藏类型',
        'source_id.require' => '收藏的资源ID',
    ];
}