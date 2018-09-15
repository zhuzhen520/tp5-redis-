<?php
namespace app\api\model;
use think\Model;

/**
* 购物车
*/
class Cart extends Model
{
    
    protected $auth = [];
    protected $insert = ['ip','add_time'];
    protected $update = ['ip'];

    protected function setAddTimeAttr()
    {
        return time();
    }

    protected function setIpAttr()
    {
        return request()->ip();
    }

}