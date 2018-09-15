<?php
namespace app\count\controller;
use think\Controller;
use think\Request;
use think\Cache;
use think\Db;

/**
* 结算系统
*/
class Index extends Controller
{

    protected $member_data = []; //静态奖励池
    protected $parent_data = []; //团队管奖池

    protected $config = [];
    protected $SystemConfig = []; //系统配置
 
    protected $static_gold_log = []; //静态金币释放记录


    /* 加载配置 */
    public function _initialize(){
        if(!Request::instance()->isCli()){
            die();//运行错误
        }

        //有下限排序
        $this->config = Db::name('static_config')->order('gold_lt')->where(['type'=>1])->select();

        $this->SystemConfig = get_config('reward');
    }


    /* 静态奖励
        @每次结算1万个有效会员,
        page 页 
    */

    public function member_list($page=1){

        $db = Db::name('member');

        //id排序
        $member_list = $db->field('id,username,gold_static,integral,put_integral,gold_static_price,parent_id')->where(['gold_static'=>['gt',0]])->order('id ASC')->paginate(10000);

        // $data_log = [];

        foreach($member_list as $v){
            $assets = $v['gold_static'] * $v['gold_static_price']; //资产
            $member_assets = $this->getMemberSatr($assets); // 等级资产率

            if($member_assets){

                $integral = $assets*$member_assets['rate']; // 等级积分

                echo '['.$v['id'].']'.$integral.'+'.$member_assets['rate']."\n";

                //记录信息
                $this->member_data[$v['id']] = [
                    'uid'         => $v['id'],
                    'username'    => $v['username'],
                    'action'      => $integral,
                    'money_end'   => $v['put_integral'] + $integral,
                    'info'        => '资产结算'.$member_assets['rate'],
                    'order_sn'    => '',
                    'type'        => 1,
                    'action_type' => 2,
                    'add_time'    => time(),
                ];

                //保存全部，供团队查找
                $Cache = Cache::get('member_data') ? : [];   //缓存内容
                Cache::set('member_data',($Cache+$this->member_data),360); //保存以前的这次的[不要修改key索引]

                //个人增加可提积分
                $db->where(['id'=>$v['id']])->setInc('put_integral',round($integral,3));
                //团队管理 这个是拿会员总资产
                $this->team_admin($v,$assets); 
            }

        }

        //可提积分日志
        Db::name('put_integral_log')->insertAll($this->member_data);
        //团队积分日志
        $this->integral_log($this->parent_data); //团队

        return '运行成功【page='.$page.'】'.date('Y-m-d H:i:s',time())."\n";
    }

    /* 获取会员星级 */
    protected function getMemberSatr($assets){
        if($assets < 6000 ){
            return false;
        }
        foreach($this->config as $k => $v){
            if($assets >= $v['gold_up'] && $assets <= $v['gold_lt']){
                return $this->config[$k]; //当前级别
            }
        }
        return end($this->config); //最高级别
    }

    /* 添加积分记录 */
    protected function integral_log($list){
        Db::name('integral_log')->insertAll($list);
    }


    /*
        团队管理奖,会员结算完成过来
        member 会员
        param assets 会员资产 总资产
    */
    protected function team_admin($member,$assets){
        $db = Db::name('member');
        $where = ['id'=>$member['parent_id']];
        $parent = $db->field('id,username,gold_static,gold_static_price,integral,level')->where($where)->find();

        if( empty($parent) ){
            return false;
        }

        //全部会员的缓存内容
        $whole_member_data = Cache::get('member_data');
        // dump($whole_member_data);die;

        // $member_action =  $whole_member_data[$member['id']]['action']; //当前会员积分
        // $parent_action =  $whole_member_data[$parent['id']]['action']; //父级会员积分
        
        $member_action =  $assets; //当前会员资产
        $parent_action =  $parent['gold_static'] * $parent['gold_static_price']; //父级会员资产

        echo '--'.$member['id'].'【'.$member_action.'】'.$parent['id'].'【'.$parent_action."】\n";

        //率
        $rate = $this->SystemConfig['team_role'.$parent['level']]/1000;


        //烧伤
        if($parent_action < $member_action){
            $info = '[烧伤] 团队管理奖'.$member['username'];
            $integral = $parent_action * $rate;
        }else{
            $info = '团队管理奖'.$member['username'];
            $integral = $member_action * $rate;
        }

        if($integral < 0.001){
            return false; //太少了不反
        }

        //增加积分
        $db->where(['id'=>$parent['id']])->setInc('integral',round($integral,3));

        $this->parent_data[] = [
            'uid'         => $parent['id'],
            'username'    => $parent['username'],
            'action'      => round($integral,3),
            'money_end'   => $parent['integral'] + round($integral,3),
            'info'        => $info,
            'type'        => 1,
            'action_type' => 3,
            'add_time'    => time(),
        ];

    }


    /* 静态金币释放 */
    public function static_gold_rid(){

        $db = Db::name('member');
        $static_db = Db::name('static_gold_rid');

        //释放订单
        $order_where = ['status'=>0];

        //开始时间 > 当前时间 - 限制时间 = 可以释放
        $order_where['start_time'] = ['lt',time()-(86400*$this->SystemConfig['static_gold_rid'])];

        $order_list = $static_db->where($order_where)->select();
            
        // print_r($order_list);
        // echo "\n".$static_db->GetLastSql();die;

        foreach($order_list as $v){
            $static_data = [];

            $this_member = $db->where(['id'=>$v['uid']])->find();

            //结算
            $action = round(($v['action'] * $this_member['rid_speed']),3);


            $info = "静态金币释放".($this_member['rid_speed']*100).'%';

            //释放超过要释放的
            if($v['sum_gold'] + $action >= $v['action']){
                $action = $v['action'] - $v['sum_gold']; //把剩下的全部给他
                $info = "[last]静态金币释放".($this_member['rid_speed']*100).'%';
                $static_data['status'] = 1; //释放完成
                $static_data['end_time'] = time();
            }

            //释放订单修改
            $static_data['sum_gold'] = $v['sum_gold'] + $action;
            $static_data['num']      = $v['num'] + 1;

            $static_db->where(['id'=>$v['id']])->update($static_data);

            //金币记录
            $this->static_gold_log[] = [
                'uid'         => $this_member['id'],
                'username'    => $this_member['username'],
                'action'      => $action,
                'money_end'   => $this_member['gold'] + $action,
                'info'        => $info,
                'order_sn'    => $v['id'],
                'type'        => 1,
                'action_type' => 4,
                'add_time'    => time(),
            ];

            echo '会员'.$this_member['id'].'释放了【'.$action."】\n";

            $b = $db->where(['id'=>$this_member['id']])->setInc('gold',$action);

        }

        Db::name('gold_log')->insertAll($this->static_gold_log);

    }


}