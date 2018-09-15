<?php
namespace app\api\controller;
use think\Created; //pay
use think\Notify; //pay
use think\loader;
use think\Log;
use think\Db;

/**
* 商城
*/
class Alication extends Base
{
    /*应用页面banner*/
    public function index()
    {
        $sql="SELECT sum(buy_price) as tbuy,sum(dream_money) as tdream FROM think_product";
        $totalmoney=Db::query($sql);
        $sqlliyun="SELECT sum(dream_money) as liyun FROM think_product WHERE finish =1 ";
        $lmoney=Db::query($sqlliyun);
        $db=Db::name('Product');
        $product_list = $db->where('is_sale',1)->field(['id','name','mianji','totalmianji','buy_price','dream_money','play_time','thumb'])->paginate(5);
        $this->data['product_list'] = $product_list;
        $this->data['totalmoney'] = $totalmoney;
        $this->data['lmoney'] = $lmoney;
        //返回
        return json($this->data);
    }
    public function lTou_list()
    {
        $db=Db::name('Product');
        $product_list = $db->where('is_sale',1)->field(['id','name','mianji','totalmianji','buy_price','dream_money','play_time','thumb'])->paginate(5);
        $this->data['product_list'] = $product_list;
        //返回
        return json($this->data);
    }
    /*判断用户签到*/
    public function has_sign(){
        $m=$this->member['uid'];
        $time=date("Y-m-d 00:00:00");
        $where['create_time']=['EGT',"$time"];
        $where['uid']=$m;
        $where['type']=1;
        $where['getway']=2;
        $memb= Db::name('member_randmoney')->where($where)->select();
        if($memb){
            return json(['status'=>'y','info'=>'已签到']);
        }else{
            return json(['status'=>'n','info'=>'未签到']);
        }
    }
}