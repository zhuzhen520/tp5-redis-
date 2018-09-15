<?php
namespace app\count\controller;
use think\Request;
use think\Cache;
use think\Db;


class Member
{   
    public function member_tree(){
        //这个地方需要优化一下，就是如果重复运行会重复数据，只能一个小时运行次才正常，
        //如果下一个小时没有人运行二次的话又恢复正常,
        $data = Cache::get('member_tree')?:[];
        $member = Db::name('member')->field('id,username as name,parent_id,gold_static,gold_static_price,level')->paginate(50)->toArray()['data'];
        $data = array_merge($data,$member); 
        Cache::set('member_tree',$data,3530);
    }

    public function get_tree(){
        $data = Cache::get('member_tree');
        dump($data);
        Cache::set('member_tree',null);
    }

    /*生成树状会员*/
    public function member_add($id = 100000 ){
        
        $username  ='13'.rand(100000000,999999999);
        $data = [
            'username' => $username,
            'mobile' => $username,
            'parent_id' => $id
        ];
        Db::name('member')->insert($data);
        $id = Db::name('member')->getLastInsID();

        $this->member_add($id);
    }

}