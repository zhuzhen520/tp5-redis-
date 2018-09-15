<?php
namespace app\api\controller;
use think\Config;
use think\Db;

/**
* 我的钱包
*/
class Wallet extends Base
{   
    /*我的积分*/
    public function integral(){

        if( isset($this->data['member']) ){
            $this->data['member']['level_name'] = Config::get('role')[$this->data['member']['level']];
        }
        return json($this->data);
    }

    /* 我的积分2 */
    public function integrals(){
        $db = Db::name('integral_log');
        $where = ['uid'=>$this->member['uid'],'type'=>1];

        $integral = [];

        //静态
        $integral['fixed_integr'] = $db->where(array_merge($where,['action_type'=>1]))->sum('action');

        //团队
        $integral['team_integr'] = $db->where(array_merge($where,['action_type'=>3]))->sum('action');

        //首推
        $integral['first_integr'] = $db->where(array_merge($where,['action_type'=>2]))->sum('action');

        //新增业绩
        $integral['new_integr'] = $db->where(array_merge($where,['action_type'=>4]))->sum('action');

        //新增同级业绩
        $integral['news_integr'] = $db->where(array_merge($where,['action_type'=>5]))->sum('action');

        $this->data['integral'] = $integral;
        return json($this->data);
    }

    /* 钱包地址 */
    public function wallet_address(){
        import('phpqrcode/phpqrcode', EXTEND_PATH);
        $this->getMember($this->member['uid']);

        $file_path = 'public/wallet/'.$this->member['username'].'.png';
        $data = $this->data['member']['wallet_address'];

        if(!is_file($file_path)){
            $level = 'L';
            $size = 4;
            \QRcode::png($data,$file_path,$level,$size); //生成
        }

        return json(['image'=>$file_path,'code'=>$data]);
    }

    /* 积分兑换金币 */
    public function change_gold(){

        //验证数据
        if($this->POST['number'] <= 0){
            return json(['status'=>'n','info'=>'兑换数量错误~']);
        }

        //支付密码,会调一次最新的会员数据    
        if($this->POST['payToken']){
            $valitoken = $this->valitoken();
            if($valitoken['status'] == 'n'){
                return json($valitoken);
            }
        }else{
            return json(['status'=>'n','info'=>'请填写支付密码']);
        }

        //发送短信
        if($this->POST['phone']){
            $sendSms = $this->sendSms($this->data['member']['mobile']);
            return json($sendSms);
        }

        //验证短信验证码
        $sms = $this->vailSms($this->data['member']['mobile'],$this->POST['sms_code']);
        if($sms['status'] == 'n'){
            return json($sms);
        }

        //进行兑换

        #当前金币价
        $Market = controller('Market');
        $Today = $Market->getToday();
        if(empty($Today)){
            return json(['status'=>'n','info'=>'获取当前TIC价失败']);
        }

        #金币数
        $gold = $this->POST['number'];

        $integral = $Today['price'] * $gold;


        if( $integral > $this->data['member']['integral']){
            return json(['status'=>'n','info'=>'积分不足,余额：'.$this->data['member']['integral']]);
        }   

        //余积分
        $integral_end = $this->data['member']['integral'] - $integral;
        //余金币
        $gold_end = $this->data['member']['gold'] + $gold;


        $integral_log = [
            'uid'         => $this->data['member']['id'],
            'username'    => $this->data['member']['username'],
            'action'      => $integral,
            'money_end'   => $integral_end,
            'info'        => '积分兑换TIC：['.$integral.']',
            'type'        => 0,
            'action_type' => 6,
            'add_time'    => time(),
        ];

        $gold_log = [
            'uid'         => $this->data['member']['id'],
            'username'    => $this->data['member']['username'],
            'action'      => $gold,
            'money_end'   => $gold_end,
            'info'        => '积分兑换TIC：['.$gold.']',
            'type'        => 1,
            'action_type' => 3,
            'add_time'    => time(),
        ];


        $b = Db::name('member')->where(['id'=>$this->data['member']['id']])->update(['gold'=>$gold_end,'integral'=>$integral_end]);

        if($b){
            Db::name('integral_log')->insert($integral_log);
            Db::name('gold_log')->insert($gold_log);
            return json(['status'=>'y','info'=>'兑换成功']);
        }else{
            return json(['status'=>'n','info'=>'兑换失败']);
        }

    }

    /* 积分记录 */
    public function integral_details(){
        $uid = $this->member['uid'];

        $model = new \app\api\model\IntegralLog;

        $where = ['uid'=>$uid];
        if(is_numeric($this->POST['action_type'])){
            $where['action_type'] = $this->POST['action_type'];
        }

        $list = $model->order('id desc')->where($where)->paginate(10)->each(function($item, $key){
            $item['add_time'] = date('Y-m-d H:i',$item['add_time']);
            return $item;
        });
        return json($list);
    }

    /* 金币记录 */
    public function gold_details(){
        $uid = $this->member['uid'];

        $where = ['uid'=>$uid];

        if(is_numeric($this->POST['action_type'])){
            $where['action_type'] = $this->POST['action_type'];
        }

        $list = Db::name('gold_log')->order('id desc')->where($where)->paginate(10)->each(function($item, $key){
            $item['add_time'] = date('Y-m-d H:i',$item['add_time']);
            return $item;
        });
        return json($list);
    }

    /* 静态金币释放 */
    public function static_gold_release(){

        //支付密码,会调一次最新的会员数据    
        if($this->POST['payToken']){
            $valitoken = $this->valitoken();
            if($valitoken['status'] == 'n'){
                return json($valitoken);
            }
        }else{
            return json(['status'=>'n','info'=>'请填写支付密码']);
        }

        $this_static_gold = Db::name('static_gold_rid')->where(['uid'=>$this->member['uid'],'status'=>0])->find();
        if($this_static_gold){
            return json(['status'=>'n','info'=>'已有订单在释放~']);
        }

        // //发送短信 【当有手机号码时发送】
        // if($this->POST['phone']){
        //     $sendSms = $this->sendSms($this->data['member']['mobile']);
        //     return json($sendSms);
        // }

        // //验证短信验证码
        // $sms = $this->vailSms($this->data['member']['mobile'],$this->POST['sms_code']);
        // if($sms['status'] == 'n'){
        //     return json($sms);
        // }

        if(!is_numeric($this->POST['number']) || $this->POST['number'] <= 0){
            return json(['status'=>'n','info'=>'数量错误']);
        }

        //必须有静态金币
        if($this->data['member']['gold_static'] <= 0 || $this->data['member']['gold_static'] < $this->POST['number']){
            return json(['status'=>'n','info'=>'转出数量不足']);
        }

        //静态金币记录 [记录]
        $data_log = [
            'uid'         => $this->data['member']['id'],
            'username'    => $this->data['member']['username'],
            'action'      => $this->POST['number'],
            'money_end'   => $this->data['member']['gold_static'] - $this->POST['number'],
            'info'        => '静态金币释放',
            'type'        => 0,
            'action_type' => 4,
            'add_time'    => time(),
        ];  

        //释放过程 加速在金币记录 [订单]
        $data_order = [
            'uid'        => $this->data['member']['id'],
            'username'   => $this->data['member']['username'],
            'action'     => $this->POST['number'],
            'money_end'  => $this->data['member']['gold_static'] - $this->POST['number'],
            'info'       => '静态金币释放',
            'type'       => 0,
            'start_time' => time(),
        ];

        $b = Db::name('member')->where(['id'=>$this->member['uid']])->setDec('gold_static',$this->POST['number']);
        if($b){
            Db::name('static_gold_rid')->insert($data_order);
            Db::name('gold_static_log')->insert($data_log);

            $this->assets_level($this->member['uid']);
            return json(['status'=>'y','info'=>'释放成功']);
        }else{
            return json(['status'=>'释放失败！']);
        }

    }

    /* 静态金币明细 */
    public function static_gold_details(){
        $list = Db::name('static_gold_rid')->where([
            'uid' => $this->member['uid'],
        ])->order('id DESC')->paginate(10)->each(function($item, $key){
            $item['start_time'] = date('Y-m-d',$item['start_time']);
            return $item;
        });
        return json($list?:[]);
    }

    /* 余额明细 */
    public function money_details(){
        $list = Db::name('money_log')->where([
            'uid' => $this->member['uid'],
        ])->order('id DESC')->paginate(10)->each(function($item, $key){
            $item['info'] = explode('[', $item['info'])[0];
            $item['add_time'] = date('Y-m-d H:i',$item['add_time']);
            return $item;
        });
        return json($list?:[]);
    }

}
