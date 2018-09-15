<?php
namespace app\admin\controller;
use think\Db;

class Main extends Base
{   
    /*欢迎界面*/
    public function welcome(){
        $count = [];
        
        //全部
        $start_time = strtotime(date('Y-m-d',time())); //今天开始时间

        $count['member'] = Db::name('member')->count();
        $count['member_day'] = Db::name('member')->where(['reg_time'=>['GT',$start_time]])->count();

        $count['order'] = "全部订单：".(Db::name('order_info')->count())." 待发货：".(Db::name('order_info')->where(['pay_state'=>1,'shipping_state'=>0])->count());

        $count['order_day'] = "全部订单：".(Db::name('order_info')->where(['add_time'=>['GT',$start_time]])->count())." 待发货：".(Db::name('order_info')->where(['pay_state'=>1,'shipping_state'=>0,'add_time'=>['GT',$start_time]])->count());

        $count['product'] = Db::name('product')->count();

        $count['trade'] = Db::name('trade_order')->count();
        $count['trade_day'] = Db::name('trade_order')->where(['start_time'=>['GT',$start_time]])->count();

        $count['news'] = Db::name('news')->count();
        $count['news_day'] = Db::name('news')->where(['add_time'=>['GT',$start_time]])->count();
        $count['storagetic']=Db::name('member_tic')->sum('storagetic');
        $count['circulatetic']=Db::name('member_tic')->sum('circulatetic');
        $count['usetic']=Db::name('member_tic')->sum('usetic');
        $count['totalrate']=Db::name('adminmoney')->value('money');
        $count['candy']=Db::name('member')->sum('candy');
        $count['mineral']=Db::name('member')->sum('mineral');
        $this->assign('count',$count);
        return $this->fetch();
    }

    public function index(){
        return $this->fetch();
    }
}