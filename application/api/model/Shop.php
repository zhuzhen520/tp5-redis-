<?php
namespace app\api\model;
use think\Model;

/**
* 数据模型
*/
class Shop extends Model
{   
    
    protected $table;

    public function setImagePathAttr($value)
    {
        return '/public/banner/'.$value;
    }
}