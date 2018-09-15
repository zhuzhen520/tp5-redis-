<?php
namespace app\api\model;
use think\Model;

/**
* 资讯数据
*/
class News extends Model
{
    public function getPublishTimeAttr($value){
        return date('Y-m-d',$value);
    } 

}