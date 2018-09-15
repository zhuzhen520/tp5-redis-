<?php

namespace app\api\model;

use think\Model;

/**
 * 数据模型
 */
class UserCollect extends Model
{

    protected $table = 'think_member_collect';

    public function getSourceIdAttr($value, $data) {

        switch ($data['type']) {
            case 1 :
                return db('news')->where(['id' => $value])->find();
                break;
            case 2 :
                return db('news')->where(['id' => $value])->find();
                break;
            case 3 :
                return db('product')->where(['id' => $value])->find();
                break;
        }
    }
}