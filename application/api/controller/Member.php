<?php
namespace app\api\controller;
use think\loader;
use think\Cache;
use think\Db;
use think\Config;
use think\Request;
/**
* 会员控制器
*/
class Member extends Base
{
    /*邀请*/
    public function invitation(){
        import('phpqrcode/phpqrcode', EXTEND_PATH);

        $file_path = '/code/'.$this->member['username'].'.png';
        $data = $_SERVER['HTTP_HOST'].'/index.php/index/index/register/code/'.$this->member['username'];

        if(!is_file($file_path)){
            $level = 'L';
            $size = 4;
            \QRcode::png($data,$file_path,$level,$size); //生成
        }

        return json(['code_img'=>$file_path,'url'=>'http://'.$data,'code'=>$this->member['username']]);

    }
    /*会员点击采摘糖果或矿石*/
    public function getCandy()
    {
        if (Request::instance()->isPost()) {
            $token = input('post.token');
            $id = input('post.id');
            $value=Cache::get($token);
            if($value){
                $m=Db::name('member_randmoney')->where(['id'=>$id,'status'=>1])->find();
                if($m){
                    Db::name('member_randmoney')->where(['id'=>$id])->update(['status'=>2]);
                    if($m['type']==1){
                        Db::name('member')->where(['id'=>$m['uid']])->setInc('candy',$m['num']);
                        return json(['status'=>'y','info'=>'矿石收取成功']);
                    }elseif($m['type']==2){
                        Db::name('member')->where(['id'=>$m['uid']])->setInc('mineral',$m['num']);
                        return json(['status'=>'y','info'=>'矿石收取成功']);
                    }
                }else{
                    return json(['status'=>'n','info'=>'收取失败']);
                }
            }else{
                return json(['status'=>'n','info'=>'获取失败']);
            }
        }
    }
    /* 更新会员信息 */
    public function member_save(){
        $data = [
            'nickname' => $this->POST['nickname']
        ];
        $b = Db::name('member')->where(['id'=>$this->member['uid']])->update($data);
        return json(['status'=>$b,'info'=>'修改成功']);
    }

    /* 我的粉丝 */
    public function fans(){
        $list = Db::name('member')->field('id,username,nickname,gold_static,gold_static_price,level')->where(['parent_id'=>$this->member['uid']])->paginate(10)->each(function($item){
            $item['assets'] = round(($item['gold_static']*$item['gold_static_price']),4);
            $item['level_name'] = Config::get('role')[$item['level']];
            return $item;
        });
        
        //缓存一个小时之前
        $member_tree = Cache::get('member_tree');

        $member_list = member_tree($member_tree,$this->member['uid']);
        $team_assets = 0;
        foreach($member_list as $v){
            $team_assets += $v['gold_static'] * $v['gold_static_price'];
        }
        return json(['data'=>$list?:[],'team_assets'=>round($team_assets,4),'level1'=>count($list)]);

    }

    /* 安全中心 */
    public function member_info(){
        $data = $this->POST;
        $member_info = Db::name('member_info')->where(['uid'=>$this->member['uid']])->find();

        if($data && $member_info){
            $data['uid'] = $this->member['uid'];
            $data['username'] = $this->member['username'];
            $b = Db::name('member_info')->where(['id'=>$member_info['id']])->update($data);
            return json(['status'=>$b,'info'=>$b?'编辑成功':'编辑失败!']);
        }elseif($data && empty($member_info)){
            $data['uid'] = $this->member['uid'];
            $data['username'] = $this->member['username'];
            $b = Db::name('member_info')->insert($data);
            Db::name('member_randmoney')->insert(['uid'=>$this->member['uid'],'status'=>1,'num'=>50,'type'=>1,'getway'=>5,'pass_time'=>time()+172800]);
            return json(['status'=>$b,'info'=>$b?'添加成功':'操作失败!']);
        }
        return json(['status'=>'y','data'=>$member_info?:'']);
    }

    /*银行卡*/
    public function member_card(){
        $db = loader::model('MemberCard');
        switch ($this->POST['action']) {
            case 'list':
                $list = $db->where(['uid'=>$this->member['uid']])->select();
                return json(['status'=>'y','data'=>$list?:'']);
            break;
            case 'set':
                if( $this->POST['name'] && $this->POST['card'] && $this->POST['khh'] && $this->POST['khzh']){
                    $data = [
                        'uid'      => $this->member['uid'],
                        'username' => $this->member['username'],
                        'name'     => $this->POST['name'],
                        'card'     => $this->POST['card'],
                        'khh'      => $this->POST['khh'],
                        'khzh'     => $this->POST['khzh']
                    ];
                    
                    if($this->POST['id'] > 0){
                        $b = Db::name('member_card')->where(['id'=>$this->POST['id'],'uid'=>$this->member['uid']])->update($data);
                    }else{
                        if(Db::name('member_card')->where(['uid'=>$this->member['uid']])->count() >= 3 ){
                            return json(['status'=>'n','info'=>'最多添加3张银行卡~']);
                        }
                        $b = Db::name('member_card')->insert($data);
                    }
                    
                    return json(['status'=>$b,'info'=>$b?'操作成功':'操作失败!']);
                }else{
                    return json(['status'=>'n','info'=>'请填写完整~']);
                }
                
            break;
            case 'get':
                $row = $db->where(['id'=>$this->POST['id'],'uid'=>$this->member['uid']])->find();
                return json(['status'=>$row?'y':'n','row'=>$row]);
            break;
        }
        
    }

    /* 银行卡删除 */
    public function card_del(){
        if(is_numeric($this->POST['id'])){
            $b = Db::name('MemberCard')->where([
                'id'=>$this->POST['id'],
                'uid'=>$this->member['uid']
            ])->delete();
            return json(['status'=>$b]);
        }
    }


    /* 重置密码 */
    public function reset_password(){
        $this->getMember($this->member['uid']);

        //返回member数据
        if(empty($this->POST['password'])){
            return json(['status'=>$this->data?'y':'n','data'=>$this->data]);
        }

        if($this->POST['password'] && strlen($this->POST['password']) >= 6 && $this->POST['password'] == $this->POST['repassword']){

            if($this->POST['sms_code']){
                //验证短信验证码
                $sms = $this->vailSms($this->data['member']['mobile'],$this->POST['sms_code']);
                if($sms['status'] == 'n'){
                    return json($sms);
                }
            }else{
                //发送短信验证码
                $sendSms = $this->sendSms($this->data['member']['mobile']);
                return json($sendSms);
            }
            $entry    = get_rand_str();
            $password = md5(md5($this->POST['password']).md5($entry));
            $b = Db::name('member')->where(['id'=>$this->member['uid']])->update(['entry'=>$entry,'password'=>$password]);
            return json(['status'=>$b,'info'=>$b?'修改密码成功':'操作失败']);
        }else{
            return json(['status'=>'n','info'=>'密码格式错误']);
        } 

    }

    /* 重置支付密码 */
    public function reset_PayPassword(){
        $this->getMember($this->member['uid']);
        //返回member数据
        if(empty($this->POST['PayToken'])){
            return json(['status'=>$this->data?'y':'n','data'=>$this->data]);
        }

        if($this->POST['PayToken'] && strlen($this->POST['PayToken']) >= 6 && $this->POST['PayToken'] == $this->POST['rePayToken']){

            if($this->POST['sms_code']){
                //验证短信验证码
                $sms = $this->vailSms($this->data['member']['mobile'],$this->POST['sms_code']);
                if($sms['status'] == 'n'){
                    return json($sms);
                }
            }else{
                //发送短信验证码
               $sendSms = $this->sendSms($this->data['member']['mobile']);
                return json($sendSms);
            }
            $b = Db::name('member')->where(['id'=>$this->member['uid']])->update(['Paytoken'=>md5($this->POST['PayToken'])]);
            return json(['status'=>$b,'info'=>$b?'修改支付密码成功':'操作失败']);
        }else{
            return json(['status'=>'n','info'=>'支付密码格式错误']);
        } 
    }
    public function sendSms($phone='',$forget=false){
        $phone = input('post.phone')?:$phone;

        if(!preg_match("/^1[345678]{1}\d{9}$/",$phone)){
            die('ss');
            return json(['status'=>'n','info'=>'请输入正确手机号']);
        }

        if(!Db::name('member')->where(['username'=>$phone])->find()){
            return json(['status'=>'n','info'=>'账号不存在']);
        }
        import('sms/sendSms', EXTEND_PATH);
        $Sms = new \Think\Sms;
        $code = rand(100000,999999);
        $message = get_conf('message');
        $result = $Sms->sendSms($code,$phone,$message['msgname'],$message['code']);

        //发送成功
        if($result->Message == "OK"){
            $value = [
                'SMS_code'  => $code,
                'SMS_phone' => $phone,
            ];
            Cache::set($phone,$value,280);
            return json(['status'=>'y','info'=>'发送短信成功']);
        }
        // print_r($result);die;
        return json(['status'=>'n','info'=>'发送失败!']);
    }
    /* 留言/反馈 */
    public function message(){

        switch ($this->POST['action']) {
            case 'list':
                $list = Db::name('message')->order('id DESC')->where(['uid'=>$this->member['uid']])->paginate(10)->each(function($item){
                    $item['add_time'] = date('Y-m-d H:i',$item['add_time']);
                    return $item;
                });
                return json(['status'=>'y','data'=>$list]);
            break;
            case 'set':
                if($this->POST['content']){
                    $data = [];
                    $data['uid'] = $this->member['uid'];
                    $data['username'] = $this->member['username'];
                    $data['content'] = $this->POST['content'];
                    $data['add_time'] = time();
                    $b = Db::name('message')->insert($data);
                    return json(['status'=>$b,'info'=>$b?'反馈成功':'反馈失败!,请重试']);
                }else{
                    return json(['status'=>'0','info'=>'请填写内容']);
                }
            break;
        }
        
    }

    /* 积分提现 */
    public function put_integral(){
        $num = $this->POST['num'];
        if(!is_numeric($num) || $num <= 0){
            return json(['status'=>'n','info'=>'提现数量错误!']);
        }

        $member = Db::name('member')->field('id,username,integral,put_integral')->where(['id'=>$this->member['uid']])->find();
        if( $member['put_integral'] < $num ){
            return json(['status'=>'n','info'=>'可提现积分不足']);
        }

        //加载配置
        $config = get_config('base');
        if($num < (int)$config['integral_up'] || $num > (int)$config['integral_lt']){
            return json(['status'=>'n','info'=>'积分提现区间,'.$config['integral_up'].'~'.$config['integral_lt']]);
        }   
        
        // 银行卡
        $member_card = Db::name('member_card')->where(['id'=>$this->POST['card_id'],'uid'=>$this->member['uid']])->field('id',true)->find();
        if(empty($member_card)){
            return json(['status'=>'n','info'=>'此银行卡不可用~']);
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

        // 启动事务
        Db::startTrans();
        try{

            if(!Db::name('member')->where(['id'=>$this->member['uid']])->update([
                'put_integral' => $member['put_integral']-$num, //可提现积分
            ])){
                return json(['status'=>'n','info'=>'操作失败,请稍后再试']);
            }

            // 提现订单
            $data_log = [
                'uid'       => $this->member['uid'],
                'username'  => $this->member['username'],
                'action'    => $num,
                'money_end' => $member['put_integral'] - $num,
                'info'      => '会员提现',
                'status'    => 0,
                'add_time'  => time()
            ];
            if(!Db::name('put_integral')->insert(array_merge($data_log,$member_card))){
                throw new \Exception("添加订单失败,请稍后再试");
            }

            //可提限日志
            if(!Db::name('put_integral_log')->insert([
                'uid'         => $this->member['uid'],
                'username'    => $this->member['username'],
                'action'      => $num,
                'money_end'   => $member['put_integral'] - $num,
                'info'        => '积分提现',
                'order_sn'    => Db::name('put_integral')->getLastInsID(),
                'type'        => 0,
                'action_type' => 3,
                'add_time'    => time(),
            ])){
               throw new \Exception("添加日志失败,请稍后再试"); 
            }

            Db::commit();

            return json(['status'=>'y','info'=>'发起提现成功']);
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            // return json(['status'=>'n','info'=>$e->getMessage()]); //查看原因打开
            return json(['status'=>'n','info'=>'提现失败!']);
        }

    }

    /* 收藏 */
    public function collect()
    {
        $validate = loader::validate('UserCollect');

        if(!$validate->check($this->POST)){
            return json(['status'=>'n','info'=>$validate->getError()]);
        }
        $collect = new \app\api\model\UserCollect();

        $results = $collect->where([
            'uid' => $this->member['uid'],
            'type' => $this->POST['type'],
            'source_id' => $this->POST['source_id']
        ])->find();

        if ($results) {
            $res = $results->delete();
            return $res ? json(['status' => 'y', 'info' => '取消成功']): json(['status' => 'n', 'info' => '取消失败']);
        }

        $res = $collect->insert([
            'uid' => $this->member['uid'],
            'type' => $this->POST['type'],
            'source_id' => $this->POST['source_id'],
        ], true);
        
        return $res ? json(['status' => 'y', 'info' => '收藏成功']) : json(['status' => 'n', 'info' => '收藏失败']);
    }

    public function getCollect()
    {
        $collect = new \app\api\model\UserCollect();
        $this->data['collect'] = $collect->where([
            'type' => $this->POST['type'] ? : 1,
            'uid' => $this->member['uid']
        ])->paginate();
        return json($this->data);
    }

    /* 复投,动态转静态 */
    public function gold_static_gold(){
        //获取当天金币价
        $this_time = date('Y-m-d',time());
        $order_trend = Db::name('OrderTrend')->where(['dates'=>$this_time])->find();
        if(empty($order_trend)){
            return json(['status'=>'n','info'=>'获取交易价失败！']);
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

        if(!is_numeric($this->POST['num']) || $this->POST['num'] <= 0){
            return json(['status'=>'n','info'=>'转入数量错误']);
        }

        $sxf_conf = get_config('base','gold_static_gold') ? : 0;
        $sxf = ($this->POST['num'] * $sxf_conf);

        if($this->data['member']['gold']  < ( $this->POST['num'] +  $sxf ) ){
            return json(['status'=>'n','info'=>'余额不足']);
        }

        //操作数据
        $b = Db::name('member')->where(['id'=>$this->member['uid']])->update([
            'gold'        => $this->data['member']['gold'] - $this->POST['num'] - $sxf,
            'gold_static' => $this->data['member']['gold_static'] + $this->POST['num'],
        ]);

        if($b){
            //复投订单
            Db::name('gold_static_gold')->insert([
                'uid'        => $this->member['uid'],
                'username'   => $this->member['username'],
                'action'     => $this->POST['num'],
                'money_end'  => $this->data['member']['gold_static'] + $this->POST['num'],
                'gold_price' => $order_trend['price'],
                'total'      => $this->POST['num'] * $order_trend['price'],
                'add_time'   => time()
            ]);
            //记录日志
            $gold_log = [
                'uid'         => $this->member['uid'],
                'username'    => $this->member['username'],
                'action'      => $this->POST['num'] + $sxf,
                'money_end'   => $this->data['member']['gold'] - $this->POST['num'] - $sxf,
                'info'        => '转入到复投,手续费'.$sxf_conf.'%',
                'order_sn'    => '',
                'type'        => 0,
                'action_type' => 5,
                'add_time'    => time(),
            ];
            Db::name('gold_log')->insert($gold_log); //动日志
            $gold_log['type'] = 1;
            $gold_log['action'] = $this->POST['num'];
            $gold_log['money_end'] = $this->data['member']['gold_static'] + $this->POST['num'];
            
            Db::name('gold_static_log')->insert($gold_log); //静日志

            //这里需要计算均价
            $this->member_static_gold_price();

            return json(['status'=>'y','info'=>'复投成功']);
        }else{
            return json(['status'=>'y','info'=>'复投失败']);
        }
    }

    /* 复投日志 */
    public function gold_static_gold_log(){
        $list = Db::name('gold_static_gold')->where(['uid'=>$this->member['uid']])->paginate(10)->each(function($item){
            $item['add_time'] = date('Y-m-d H:i',$item['add_time']);
            return $item;
        });
        return json(['data'=>$list?:[]]);
    }

    /* 可提积分明细 */
    public function put_integral_log(){
        $list = Db::name('put_integral_log')->order('id DESC')->where(['uid'=>$this->member['uid']])->paginate(10)->each(function($item ,$key){
            $item['add_time'] = date('Y-m-d H:i',$item['add_time']);
            return $item;
        });
        return json(['status'=>$list?'y':'n','data'=>$list?:'']);
    }
    /*糖果/矿石排名*/
    public function candyrank(){
        $time=strtotime(date("Y-m-d"),time());
        $type = $this->POST['type'] ? : 1;
        $page=$this->POST['page'];
        $cpage=($page-1)*5;
        $sql="SELECT ZZ.* FROM  (
                SELECT tmp.*, @k:=@k +1 AS rank FROM
                ( SELECT sum(num) as total,uid FROM
                 think_member_randmoney WHERE create_time > $time AND status = 2
                 AND type = $type group by uid ORDER BY total DESC) AS tmp ,
                 (SELECT @k :=0) total) AS ZZ LIMIT $cpage,5";
        $total=Db::query($sql);
        foreach($total as $key =>$value){
            $tic=Db::name('member_tic')->where('uid',$value['uid'])->value('storagetic');
            if((int)$tic<2000){
                $total[$key]['level']='粉丝';
            }elseif((int)$tic>=2000 && (int)$tic<10000){
                $total[$key]['level']='一级';
            }elseif((int)$tic>=10000 && (int)$tic<20000){
                $total[$key]['level']='二级';
            }elseif((int)$tic>=20000 && (int)$tic<30000){
                $total[$key]['level']='三级';
            }elseif((int)$tic>=30000){
                $total[$key]['level']='超级';
            }
            $total[$key]['username']=substr_replace(Db::name('member')->where(['id'=>$value['uid']])->value(['username']),'****',3,4);
        }
        return json(['data'=>$total?:[],'current_page'=>$page,"per_page"=>5,]);
    }

    /*糖果矿石采摘区域*/
    public function candynum(){
        $member=$this->member;
        $time=time();
        $where=[];
        $where['status']=1;
        $where['pass_time']=['EGT',$time];
        $where['uid']=$member['uid'];
        $row=Db::name('member_randmoney')->where($where)->field(['id','num','type'])->select();
         $this->data['candynum']=$row;
        return json($this->data);
    }
    /*获取会员信息*/
    public function getvip(){
        $m=$this->member['uid'];
        $role= config('role');
        $sql="SELECT a.id,a.level,a.username,a.nickname,b.storagetic FROM think_member AS a
              LEFT JOIN think_member_tic AS b ON a.id=b.uid
              WHERE a.id = $m";
        $arr=Db::query($sql);
        foreach($arr as $key =>$value){
            if((int)$value['storagetic'] < 2000){
                $arr[$key]['suanli']="粉丝算力";
            }elseif((int)$value["storagetic"]>=2000 && (int)$value["storagetic"]<10000){
                $arr[$key]['suanli']="一级算力";
            }elseif((int)$value["storagetic"]>=10000 && (int)$value["storagetic"]<20000){
                $arr[$key]['suanli']="二级算力";
            }elseif((int)$value["storagetic"]>=20000 && (int)$value["storagetic"]<30000){
                $arr[$key]['suanli']="三级算力";
            }elseif((int)$value["storagetic"]>=30000){
                $arr[$key]['suanli']="超级算力";
            }
            $arr[$key]['l']=$role[$value['level']];
        }
        $rz=Db::name('member_info')->where('uid',$m)->find();
        if($rz){
            $arr['status']='已认证';
        }else{
            $arr['status']='未认证';
        }
        $this->data['member']=$arr;
       return json($this->data);
    }
    /*获取糖果/矿石数量和来源*/
    public function kcsource(){
        $m=$this->member['uid'];
        $where=[];
        $where['type']=$this->POST['type'];
        $where['uid']=$m;
        $where['status']=2;
        if($this->POST['type']==1){
            $totalnum=Db::name('member')->where('id',$m)->value('candy');
        }elseif($this->POST['type']==2){
            $totalnum=Db::name('member')->where('id',$m)->value('mineral');
        }
        $data=Db::name('member_randmoney')->where($where)->field(['num','getway','create_time'])->paginate(10);
        $this->data['totalnum']=$totalnum;
        $this->data['sourcedata']=$data;
        return json($this->data);
    }
}   