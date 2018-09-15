<?php
namespace app\count\controller;
use think\Controller;
use think\Db; 

/**
* 添加测试数据
*/
class Test extends Controller
{
    
    public function index(){
        // $data = [
        //     'id'       => 140000,
        //     'password' => 'de683f3c55eda751ffb5a173fa2de5b9',
        //     'entry'    => 'vKmVZk',
        //     'token'    => '827ccb0eea8a706c4c34a16891f84e7b',
        // ];
        
        // $b = Db::name('member')->update($data);

        // dump($b);
        $a = 0;
        $member = Db::name('member')->limit(10000,20000)->select();
        foreach($member as $v){
            if($v['wallet_address'] == ''){
                $a++;
                echo $v['id']."<br>";
                Db::name('member')->where(['id'=>$v['id']])->update(['wallet_address'=>get_wallet_address($v['username'])]);
            }
            
        }
        echo $a;
    }
}