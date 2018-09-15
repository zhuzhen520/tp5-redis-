<?php
namespace app\api\model;
use think\Model;

/**
* banner数据模型
*/
class Banner extends Model
{   
    
    /*获取*/
    public function getImagePathAttr($value)
    {
        return '/banner/'.$value;
    }
}