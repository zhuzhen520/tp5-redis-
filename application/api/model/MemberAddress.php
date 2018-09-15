<?php
namespace app\api\model;
use think\Model;

/**
* 地址
*/
class MemberAddress extends Model
{
    protected $auto   = [];
    protected $insert = ['add_time'];
    
    protected function setAddTimeAttr(){
        return time();
    }
    
}   