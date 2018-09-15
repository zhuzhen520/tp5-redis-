<?php
namespace app\admin\controller;
use think\Db;

/**
*  会员奖励/记录
*/
class Reward extends Base
{
    /*会员积分记录*/
    public function integral(){
        $where = [];
        $input = input('param.');

        if($input['action_type']){
            $where['action_type'] = $input['action_type'];
        }
        if($input['word']){
            $where['uid|username'] = $input['word']; 
        }

        /* 日期查询 */
        $time_min = $input['start'];
        $time_max = $input['end'];

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = ['between',[$time_min,$time_max]];
            }else{
                $where['add_time'] = ['between',[$time_max,$time_min]];
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = ['between',[$time_min,$time_max]];
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = ['elt',$time_max];
        }

        $list = Db::name('integral_log')->order('id DESC')->where($where)->paginate(50,false,['query'=>request()->param()]);
        $count = Db::name('integral_log')->where($where)->count();
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        $this->assign('count',$count);
        return $this->fetch();
    }

    /*会员金币记录*/
    public function gold(){
        $where = [];
        $input = input('param.');

        if($input['word']){
            $where['uid|username|order_sn'] = $input['word'];
        }

        if($input['status'] > 0){
            $where['action_type'] = $input['status'];
        }

        /* 日期查询 */
        $time_min = $input['start'];
        $time_max = $input['end'];

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = ['between',[$time_min,$time_max]];
            }else{
                $where['add_time'] = ['between',[$time_max,$time_min]];
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = ['between',[$time_min,$time_max]];
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = ['elt',$time_max];
        }

        $list = Db::name('gold_log')->order('id DESC')->where($where)->paginate(50,false,['query'=>request()->param()]);
        //金额总和
        $gold_count['inc'] = Db::name('gold_log')
            ->where(array_merge($where,['type'=>0]))->sum('action');
        $gold_count['dec'] = Db::name('gold_log')
            ->where(array_merge($where,['type'=>1]))->sum('action');

        $count = Db::name('gold_log')->where($where)->count();
        $this->assign('list',$list);
        $this->assign('count',$count);
        $this->assign('gold_count',$gold_count);
        $this->assign('page',$list->render());
        return $this->fetch();
    }

    /*会员静态金币记录*/
    public function gold_static(){
        $input = input('param.');
        $where = [];
        if($input['word']){
            $where['uid|username'] = $input['word'];
        }

        if($input['status'] > 0){
            switch ($input['status']) {
                case 4:
                    $where['action_type'] = 4;
                    break;
                case 100:
                    $where['action_type'] = 100;
                    break;
                default:
                    $where['action_type'] = 5;
                    break;
            }
        }

        /* 日期查询 */
        $time_min = $input['start'];
        $time_max = $input['end'];

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = ['between',[$time_min,$time_max]];
            }else{
                $where['add_time'] = ['between',[$time_max,$time_min]];
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = ['between',[$time_min,$time_max]];
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = ['elt',$time_max];
        }

        $list = Db::name('gold_static_log')->order('id DESC')->where($where)->paginate(50,false,['query'=>request()->param()]);

        //金额总和
        $gold_count['inc'] = Db::name('gold_static_log')
            ->where(array_merge($where,['type'=>0]))->sum('action');
        $gold_count['dec'] = Db::name('gold_static_log')
            ->where(array_merge($where,['type'=>1]))->sum('action');

        $count = Db::name('gold_static_log')->where($where)->count();
        $this->assign('list',$list);
        $this->assign('count',$count);
        $this->assign('gold_count',$gold_count);
        $this->assign('page',$list->render());
        return $this->fetch();
    }


    /*会员资产记录*/
    public function money(){
        $input = input('param.');
        $where = [];
        if($input['word']){
            $where['uid|username'] = $input['word'];
        }
        if($input['action_type']){
            $where['action_type'] = $input['action_type'];
        }

        /* 日期查询 */
        $time_min = $input['start'];
        $time_max = $input['end'];

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = ['between',[$time_min,$time_max]];
            }else{
                $where['add_time'] = ['between',[$time_max,$time_min]];
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = ['between',[$time_min,$time_max]];
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = ['elt',$time_max];
        }

        $list = Db::name('money_log')->order('id DESC')->where($where)->paginate(50,false,['query'=>request()->param()]);

        $count = Db::name('money_log')->where($where)->count();
        //金额总和
        $money_count['inc'] = Db::name('money_log')
            ->where(array_merge($where,['type'=>0]))->sum('action');
        $money_count['dec'] = Db::name('money_log')
            ->where(array_merge($where,['type'=>1]))->sum('action');
        $this->assign('list',$list);    
        $this->assign('count',$count);
        $this->assign('money_count',$money_count);
        return $this->fetch();
    }

    /* 可提现积分日志 */
    public function put_integral_log(){
        $input = input('param.');
        $where = [];
        if($input['word']){
            $where['uid|username'] = $input['word'];
        }

        if($input['action_type']){
            $where['action_type'] = $input['action_type'];
        }

        /* 日期查询 */
        $time_min = $input['start'];
        $time_max = $input['end'];

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = ['between',[$time_min,$time_max]];
            }else{
                $where['add_time'] = ['between',[$time_max,$time_min]];
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = ['between',[$time_min,$time_max]];
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = ['elt',$time_max];
        }

        $list = Db::name('put_integral_log')->order('id DESC')->where($where)->paginate(50,false,['query'=>request()->param()]);
        $count = Db::name('put_integral_log')->where($where)->count();

        //金额总和
        $money_count['inc'] = Db::name('put_integral_log')
            ->where(array_merge($where,['type'=>0]))->sum('action');
        $money_count['dec'] = Db::name('put_integral_log')
            ->where(array_merge($where,['type'=>1]))->sum('action');

        $this->assign('list',$list);
        $this->assign('count',$count);
        $this->assign('money_count',$money_count);
        $this->assign('page',$list->render());
        return $this->fetch();
    }
}