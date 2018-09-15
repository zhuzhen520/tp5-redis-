<?php
namespace app\admin\controller;

use think\Controller;
use think\Db;

class Test extends Controller
{
    public function index(){
        $member = Db::name('member')->select();

        foreach($member as $v){
            $b = Db::name('gold_static_log')->where([
                    'uid'         => $v['id'],
                    'action_type' =>100
                ])->update(['order_sn'=>$v['gold_static_price']]);

            echo Db::name('gold_static_log')->getLastSql();
            dump($b);
        }


    }
}