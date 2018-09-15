<?php
namespace app\admin\model;

use think\Model;

class Member extends Model
{

    public function setPasswordAttr($value,$data){
        return md5(md5($value).md5($data['entry']));
    }
}