<?php
namespace app\api\controller;
use think\loader;
use think\Db;

/**
* 交易
*/
class Market extends Base
{   

    /* 获取今天交易价 */
    public function getToday(){
        $today_date = $this->POST['Today'] ? : date('Y-m-d',time());
        // $today_date = '2018-06-23';
        $Today = Db::name('order_trend')->where(['dates'=>$today_date])->find();
        if($this->POST['type'] == 'json'){
            return json($Today?:[]);
        }else{
            return $Today ? :[];
        }
    }

    /* 我的交易专员 */
    public function admin_market(){
        $list = Db::name('member')->field('id,username,nickname,wallet_address')->where(['is_admin'=>1])->paginate(10);
        return json(['status'=>$list?'y':'n','data'=>$list]);
    }

    /* 转账到钱包 */
    public function turn_gold(){
        //验证
        $validate = loader::validate('Market');
        if(!$validate->check($this->POST)){
            return json(['status'=>'n','info'=>$validate->getError()]);
        }

        $member_buy = Db::name('member')->where(['wallet_address'=>$this->POST['wallet_address']])->find();
        if(empty($member_buy)){
            return json(['status'=>'n','info'=>'钱包地址错误']);
        }

        //支付密码
        if($this->POST['payToken']){
            $valitoken = $this->valitoken();
            if($valitoken['status'] == 'n'){
                return json($valitoken);
            }
        }else{
            return json(['status'=>'n','info'=>'请填写支付密码']);
        }

        //短信验证码
        if($this->POST['sms_code']){
            //验证短信验证码
            $sms = $this->vailSms($this->member['username'],$this->POST['sms_code']);
            if($sms['status'] == 'n'){
                return json($sms);
            }
        }else{
            //发送短信验证码
            $sendSms = $this->sendSms($this->data['member']['mobile']);
            return json($sendSms);
        }

        $member_sell = Db::name('member')->where(['id'=>$this->member['uid']])->find();


        //必须有一方是交易转专员
        // if($member_buy['is_admin'] != 1 && $member_sell['is_admin'] != 1){
        if($member_sell['is_admin'] != 1){
            return json(['status'=>'n','info'=>'没有交易权限，转出失败']);
        }

        if($member_sell['gold'] < $this->POST['num']){
            return json(['status'=>'n','info'=>'TIC不足']);
        }

        //获取当前价
        $gold_price = $this->getToday();
        if(empty($gold_price)){
            return json(['status'=>'n','info'=>'获取当前价失败!']);
        }

        Db::startTrans();
        try{
            Db::name('member')->where(['id'=>$member_buy['id']])->setInc('gold',$this->POST['num']);
            Db::name('member')->where(['id'=>$member_sell['id']])->setDec('gold',$this->POST['num']);

            Db::commit();
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            return json(['status'=>'n','info'=>'转出失败，请稍后再试']);
        }

        //订单数据
        $order_data = [
            'uid' => $member_buy['id'],
            'username_buy' => $member_buy['username'],
            'wallet_address_buy' => $member_buy['wallet_address'],
            'cid' => $member_sell['id'],
            'username_sell' => $member_sell['username'],
            'wallet_address_sell' => $member_sell['wallet_address'],

            'price' => $gold_price['price'],
            'num' => $this->POST['num'],
            'total' => $gold_price['price'] * $this->POST['num'],
            'note' => '转账到钱包',
            'trade_type' => 3,
            'status' => 5,
            'type' => 2,
            'start_time' => time(),
            'add_time' => time()
        ];
        Db::name('trade_order')->insert($order_data);
        $order_id = Db::name('trade_order')->getLastInsID();

        $log = [];
        $log['log_buy'] = [
            'uid' => $member_buy['id'],
            'username' => $member_buy['username'],
            'action' => $this->POST['num'],
            'money_end' => $member_buy['gold'] + $this->POST['num'],
            'info' => '钱包转入',
            'type' => 1,
            'action_type' => '5',
            'order_sn' => $order_id,
            'add_time' => time(),
        ];
        $log['log_sell'] = [
            'uid' => $member_sell['id'],
            'username' => $member_sell['username'],
            'action' => $this->POST['num'],
            'money_end' => $member_sell['gold'] - $this->POST['num'],
            'info' => '钱包转入',
            'type' => 0,
            'action_type' => 5,
            'order_sn' => $order_id,
            'add_time' => time(),
        ];
        Db::name('gold_log')->insertAll($log);

        return json(['status'=>'y','info'=>'转入成功']);
    }   

    /* 买入/卖出 */
    public function buy_gold(){
        return json(['status'=>'n','info'=>'Error']);

        $order_num = get_config('base','order');
        if(Db::name('trade_order')->where([
            'uid|cid' => $this->member['uid'],
            'status' => ['lt',5],//正在交易的 
        ])->count() >= $order_num){
            return json(['status'=>'n','info'=>'正在交易的订单不能超过'.$order_num.'单']);
        }

        $this->getMember($this->member['uid']);

        //支付密码
        if($this->POST['payToken']){
            $valitoken = $this->valitoken();
            if($valitoken['status'] == 'n'){
                return json($valitoken);
            }
        }else{
            return json(['status'=>'n','info'=>'请填写支付密码']);
        }

        //获取当前价
        $gold_price = $this->getToday();
        if(empty($gold_price)){
            return json(['status'=>'n','info'=>'获取当前价失败!']);
        }

        // if($this->POST['sms_code']){
        //     //验证短信验证码
        //     $sms = $this->vailSms($this->data['member']['mobile'],$this->POST['sms_code']);
        //     if($sms['status'] == 'n'){
        //         return json($sms);
        //     }
        // }else{
        //     //发送短信
        //     $sendSms = $this->sendSms($this->data['member']['mobile']);
        //     return json($sendSms);
        // }

        //交易专员信息
        $admin_market = Db::name('member')->where([
            'wallet_address' =>$this->POST['admin_market'],
            'is_admin|is_trade'     => 1,
        ])->find();


        if(empty($admin_market)){
            return json(['status'=>'n','info'=>'对方没有交易权限']);
        }
        if($admin_market['is_admin'] == 0 && $this->data['member']['is_trade'] == 0){
            return json(['status'=>'n','info'=>'您没有交易权限~']);
        }


        //我的信息
        $this->getMember($this->member['uid']);

        //购买数量
        if( !is_numeric($this->POST['gold_num']) || $this->POST['gold_num'] <= 0){
            return json(['status'=>'n','info'=>'交易数量错误']);
        }

        //订单基本信息
        $data = [
            'price'            => $gold_price['price'],
            'num'              => $this->POST['gold_num'],
            'total'            => round(($gold_price['price']*$this->POST['gold_num']),3),
            'sxf'              => 0, //手续费
            'trade_type'       => 3,
            'status'           => 2,
            'start_time'       => time(),
            'add_time'         => time()
        ];
    
        if($admin_market['is_admin'] != 1){
            $data['trade_type'] = 2;//对点交易
        }

        //买入gold
        if($this->POST['type'] == 'buy'){ 

            //买方信息
            $data_buy = DB::name('member_info')->field('uid as uid,username as username_buy,wechat as wechat_buy,alipay as alipay_buy,username as phone_buy')->where(['uid'=>$this->member['uid']])->find();
            //必须有安全中心
            if(empty($data_buy['wechat_buy']) || empty($data_buy['alipay_buy'])){
                return json(['status'=>'n','info'=>'请完善安全中心']);
            }

            //交易专员信息
            $data_sell = DB::name('member_info')->field('uid as cid,wechat as wechat_sell,alipay as alipay_sell,username as phone_sell')->where(['uid'=>$admin_market['id']])->find();

            if($data_buy['uid'] == $data_sell['cid']){
                return json(['status'=>'y','info'=>'买,卖方不能都是自己~']);
            }

            $data = array_merge($data,$data_buy,$data_sell); //合并信息

            $data['username_buy'] = $this->data['member']['username'];
            $data['wallet_address_buy'] = $this->data['member']['wallet_address'];

            $data['username_sell'] = $admin_market['username'];
            $data['wallet_address_sell'] = $admin_market['wallet_address'];
            $data['type'] = 1;  

            $info = '发起买入成功';

        }elseif($this->POST['type'] == 'sell'){ //卖
            //买方信息(交易专员)
            $data_buy = DB::name('member_info')->field('uid as uid,username as username_buy,wechat as wechat_buy,alipay as alipay_buy,username as phone_buy')->where(['uid'=>$admin_market['id']])->find();


            //卖家信息
            $data_sell = DB::name('member_info')->field('uid as cid,wechat as wechat_sell,alipay as alipay_sell,username as phone_sell')->where(['uid'=>$this->member['uid']])->find();
            //必须有安全中心
            if(empty($data_sell['wechat_sell']) || empty($data_sell['alipay_sell'])){
                return json(['status'=>'n','info'=>'请完善安全中心']);
            }

            if($data_buy['uid'] == $data_sell['cid']){
                return json(['status'=>'y','info'=>'买,卖方不能都是自己~']);
            }

            $data = array_merge($data,$data_buy,$data_sell); //合并信息

            $data['username_buy'] = $admin_market['username'];
            $data['wallet_address_buy'] = $admin_market['wallet_address'];

            $data['username_sell'] = $this->data['member']['username'];
            $data['wallet_address_sell'] = $this->data['member']['wallet_address'];
            $data['type'] = 2;  

            $info = '发起卖出成功';

            if($this->data['member']['gold'] < $data['total'] + $data['sxf']){
                return json(['status'=>'n','info'=>'TIC不足,卖出失败','code'=>1]);
            }

            //先扣卖家币
            $res = Db::name('member')->where(['id'=>$this->member['uid']])->setDec('gold',($data['num'] + $data['sxf']));
            
        }else{
            return json(['status'=>'n','info'=>'参数错误']);
        }

        $b = Db::name('trade_order')->insert($data);

        if($res){ //卖家gold记录
            Db::name('gold_log')->insert([
                'uid'         => $this->member['uid'],
                'username'    => $this->member['username'],
                'action'      => $data['num'] + $data['sxf'],
                'money_end'   => $this->data['member']['gold'] - ($data['num'] + $data['sxf']),
                'info'        => '跟交易专员出售TIC',
                'order_sn'    => Db::name('trade_order')->getLastInsID(),
                'type'        => 0,
                'action_type' => 2,
                'add_time'    => time()
            ]);
        }    
        return json(['status'=>$b,'info'=>$b?$info:'操作失败!']);

    }

    /* 交易专员的订单 */
    public function admin_order()
    {   
        $where = [
            'uid|cid' => $this->member['uid'],
        ];
        //交易状态
        switch ($this->POST['status']) {
            case '1':
                $where['status'] = ['ELT',2];
            break;
            case '5':
                $where['status'] = ['EQ',5];
            break;
            default:
                $where['status'] = ['ELT',2];
            break;
        }
        //买单，卖单
        switch ($this->POST['type']) {
            case 'buy':
                $where['type'] = 1;
            break;
            case 'sell':
                $where['type'] = 2;
            break;
        }

        $list = Db::name('trade_order')->order('id DESC')->where($where)->paginate(10)->each(function($item ,$key){
            $item['add_time'] = date('Y-m-d H:i',$item['add_time']);
            return $item;
        });
        return json(['status'=>$list?'y':'n','data'=>$list?:'']);
    }

    /* 订单详情/编辑 */
    public function market_details(){
        //交易详情
        $row = Db::name('trade_order')->where(['id' => $this->POST['id'],'uid|cid' => $this->member['uid']])->find();

        switch ($this->POST['action']) {
            case 'get':
                return json(['status'=>$row?'y':'n','data'=>$row?:'']);
            break;
            case 'set':
                $this->valitoken(); //验证交易密码

                if($row['status'] != 2){
                    return json(['status'=>'n','info'=>'订单已确认或取消']);
                }

                $member_buy = Db::name('member')->where(['id'=>$row['uid']])->find();
                $member_sell = Db::name('member')->where(['id'=>$row['cid']])->find();

                if(empty($member_buy) || empty($member_sell) ){
                    return json(['status'=>'n','info'=>'404']);
                }

                //买单卖家操作，卖单买家操作
                if($row['type'] == 1 && $row['cid'] != $this->member['uid']){
                    return json(['status'=>'y','info'=>'此交易只能卖家确认']);
                }elseif( $row['type'] == 2 && $row['uid'] != $this->member['uid'] ){
                    return json(['status'=>'y','info'=>'此交易只能买家确认']);
                }

                $Log = [];

                //买家增加币
                $res_buy = Db::name('member')->where(['id'=>$row['uid']])->setInc('gold',$row['num']);
                if(empty($res_buy)){
                    return json(['status'=>'n','info'=>'404']);
                }

                $Log[] = [
                    'uid'         => $row['uid'],
                    'username'    => $row['username_buy'],
                    'action'      => $row['num'],
                    'money_end'   => $member_buy['gold'] + $row['num'],
                    'info'        => 'TIC买入',
                    'type'        => 1, //收入
                    'action_type' => 2, //交易中心
                    'order_sn'    => $row['id'],
                    'add_time'    => time()
                ];


                //卖单,卖家在发起时就减了
                if($row['type'] == 1){
                    //卖加减少币
                    $res_sell = Db::name('member')->where(['id' => $row['cid']])->setDec('gold',$row['num']);

                    $Log[] = [
                        'uid'         => $row['cid'],
                        'username'    => $row['username_sell'],
                        'action'      => $row['num'],
                        'money_end'   => $member_sell['gold'] - $row['num'],
                        'info'        => 'TIC卖出',
                        'type'        => 0, //支出
                        'action_type' => 2,
                        'order_sn'    => $row['id'],
                        'add_time'    => time()
                    ];
                }

                //增加记录
                Db::name('gold_log')->insertAll($Log);

                //订单状态完成
                Db::name('trade_order')->where([
                    'id' => $this->POST['id'],
                    'uid|cid' => $this->member['uid'],
                ])->update(['status'=>5,'end_time'=>time()]);

                return json(['status'=>$res_buy,'info'=>$res_buy?'操作成功':'操作失败!']);
            break;
        }

    }

    /*交易金币明细*/
    public function  market_list()
    {   
        $where = [
            'uid|cid' => $this->member['uid'],
            'status' => ['EQ',5], //正在交易的
        ];
        switch ($this->POST['type']) {
            case 'buy':
                $where['type'] = 1;
            break;
            case 'sell':
                $where['type'] = 2;
            break;
        }
        $list = Db::name('trade_order')->order('id DESC')->where($where)->paginate(10)->each(function($item ,$key){
            $item['add_time'] = date('Y-m-d H:i',$item['add_time']);
            return $item;
        });
        return json(['status'=>$list?'y':'n','data'=>$list?:'']);
    }


}