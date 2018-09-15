<?php
namespace app\api\model;
use think\Model;

/**
* 地址
*/
class MemberCard extends Model
{
    protected $auto   = [];
    protected $update = ['card'];
    
    public function getCardAttr($value)
    {   
        return str_repeat('*',(strlen($value)-4)).substr($value,-4,4);
    }
}   