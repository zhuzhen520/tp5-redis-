<?php
namespace app\api\controller;
use think\Controller;
use think\Request;
use think\Cache;
use think\Db;
use think\Log;

/**
*  base验证控制器
*/


class Base extends Controller
{

    public $member = []; //会员缓存信息

    public $data = []; //保存需要查询的数据

    public $POST = [];

    public function _initialize()
    {
        if(Request::instance()->isPost()){
            $POST = input('post.');
            $this->POST = $POST;

            // token header和post都可以
            $token = $POST['token'] ? : $_SERVER['HTTP_TOKEN'];
            if($this->request->module() == 'admin'){
                $this->member_static_gold_price($POST['id']);
                return $this->assets_level($POST['id']);
            }elseif(empty($token)) {
                exit('请求错误~');
            }

            $Cache_member = Cache::get($token); //解析token

            if(empty($Cache_member)){
                exit(json_encode(['status'=>'n','info'=>'登陆已过期','code'=>400]));
            }
            unset($this->POST['token']);

            $this->member = $Cache_member;

            if(Db::name('member')->where(['id'=>$this->member['uid']])->value('is_login') == 1){
                Cache::rm($token);
                exit(json_encode(['status'=>'n','info'=>'账号已冻结','code'=>401]));
            }

            /*  需要特别数据  */
            #会员数据
            if(isset($POST['member'])){
                $this->getMember($this->member['uid']);
            }
            #banner
            if(isset($POST['banner'])){
                $this->getBanner();
            }

            if(isset($POST['payToken'])){
                $this->valitoken();
            }

        }else{
            throw new \think\Exception('请求异常', 40000);
        }

    }

    /* index */
    public function index(){
        return json($this->data);
    }

    /* 获取最新会员数据 */
    protected function getMember($uid){
        $this->data['member'] = Db::name('member')->field('password,entry',true)->where(['id'=>$uid])->find();
    }

    /* 获取顶部轮播 */
    protected function getBanner(){
        $model = new \app\api\model\Banner;
        $banner = $model->where(['type'=>$this->POST['type']])->select();
        $this->data['banner'] = $banner;
    }

    /* 验证支付 */
    protected function valitoken(){
        //初始化一次会员信息
        $this->getMember($this->member['uid']); 
        if( md5($this->POST['payToken']) != $this->data['member']['token'] ){
            if($this->data['member']['token']){
                $result = ['status'=>'n','info'=>'支付密码错误','code'=>100];
            }else{
                $result = ['status'=>'n','info'=>'请设置支付密码','code'=>101];
            }
            return $result;
        }
    }

    /* 上传图片 */
    public function upload_image(){
        $file = request()->file('file');

        // $file = $_FILES;
        // return json(['status'=>'y','info'=>$file['file']['size']]);

        if($file){
            #移动  1k = 1000 1m = 1024k 10m = 1024000
            $info = $file->validate(['size'=>3024000,'ext'=>'jpg,png,gif'])->move(ROOT_PATH . 'public' . DS . 'api');

            if($info){
                $image = 'http://'.$_SERVER['HTTP_HOST'].'/api/'.$info->getSaveName();

                switch ($this->POST['action']) {
                    case 'member':
                        $member = Db::name('member')->field('id,avatar')->where(['id'=>$this->member['uid']])->find();
                        $b = Db::name('member')->where(['id'=>$this->member['uid']])->setField('avatar',$image);
                        if($b){
                            //删除原来的
                            $b = unlink('.'.explode('http://'.$_SERVER['HTTP_HOST'], $member['avatar'])[1]);
                            $msg = '更新头像成功';
                        }else{
                            $msg = '更新头像失败';
                        }
                    break;
                }

                return json(['error'=>0,'info'=>$msg?:'上传成功','image'=>$image]);
            }else{
                // 上传失败获取错误信息
                echo $file->getError();
            }
        }
    }



    /*-------- 记录 --------*/

    /* 订单结算反金币 */
    protected function return_gold($order_id){
        //获取当前金币交易价
        $this_time = date('Y-m-d',time());
        $order_trend = Db::name('OrderTrend')->where(['dates'=>$this_time])->find();

        //订单金币
        $order_info = Db::name('OrderInfo')->where(['order_id'=>$order_id])->find();
        $gold = round( ($order_info['total'] / $order_trend['price']), 3);

        //订单自己记录结算的金币
        Db::name('OrderInfo')->where(['order_id'=>$order_id])->update(['gold_static'=>$gold,'gold_price'=>$order_trend['price']]); 

        //会员增加金币
        Db::name('member')->where(['id'=>$this->member['uid']])->setInc('gold_static',$gold);

        //添加后的数据
        $member = Db::name('member')->where(['id'=>$this->member['uid']])->find();

        //gold_log
        $data_log = [
            'uid'         => $this->member['uid'],
            'username'    => $this->member['username'],
            'action'      => $gold,
            'money_end'   => $member['gold_static'],
            'info'        => '购买商品返金币',
            'order_sn'    => $order_info['order_sn'],
            'type'        => 1, //0支出1收
            'action_type' => 1, //来源,1普通2交易
            'add_time'    => time(),
        ];
        //添加金币记录
        Db::name('gold_static_log')->insert($data_log);

        //计算静金币价 方便晚上结算(现在只有订单的，还要交易的)
        $this->member_static_gold_price();
    }

    /* 计算静态金币价，商城订单完成 & 交易买入 */
    protected function member_static_gold_price($uid){
    // public function member_static_gold_price(){
        $uid =  $uid ? : $this->member['uid'];

        // $uid =  100000;
        //商城订单
        // 订单总额 / 返的静态币

        $shop_order = Db::name('OrderInfo')->where([
            'user_id'        => $uid,
            'shipping_state' => 2
        ])->field('total,gold_static')->select();

        //复投转入静态金币
        $market_order = Db::name('gold_static_gold')->where([
            'uid' => $uid,
        ])->field('total,action as gold_static')->select();

        $member_gold_static = Db::name('gold_static_log')->where([
            'uid'         => $uid,
            'type'        => 1,   //收入
            'action_type' => 100, //后台操作
            'order_sn'    => ['gt',0],
        ])->field('action as gold_static,order_sn')->select();

        $member_gold_static_order = [];
        foreach($member_gold_static as $v){
            $member_gold_static_order[] = [
                'total'       => $v['gold_static'] * $v['order_sn'],
                'gold_static' => $v['gold_static'],
            ];
        }

        $gold_static = 0;
        $total       = 0;

        $list = array_merge($shop_order,$market_order,$member_gold_static_order);
        foreach($list as $v){
            $total += $v['total'];
            $gold_static += $v['gold_static'];
        }
        $gold_static_price = round(($total/$gold_static),3);

        Db::name('member')->where(['id'=>$uid])->setField('gold_static_price',$gold_static_price);
        //运行会员升级
        $this->assets_level($uid);
    }



    /* 发送短信 */
    protected function sendSms($phone){
        if(!preg_match("/^1[345678]{1}\d{9}$/",$phone)){  
            return ['status'=>'n','info'=>'请输入正确手机号'];
        }

        import('sms/sendSms', EXTEND_PATH);
        $Sms = new \Think\Sms;
        $code = rand(100000,999999);
        $result = $Sms->sendSms($code,$phone);
        //发送成功
        if($result->Message == "OK"){
            $value = [
                'SMS_code'  => $code,
                'SMS_phone' => $phone,
            ];
            Cache::set($phone,$value,280);
            return ['status'=>'y','info'=>'发送短信成功','sms'=>1];
        }

        return ['status'=>'n','info'=>'已发送成功,请查收!','sms'=>0];
    }

    /* 验证短信码 */
    protected function vailSms($phone,$code){

        $Sms = Cache::get($phone); //验证码缓存
        if(empty($Sms)){
            return ['status'=>'n','info'=>'请先获取验证码'];
        }
        if( $Sms['SMS_code'] != $code ){
            return ['status'=>'n','info'=>'短信验证码错误'];
        }

    }

    /* 后置方法触发 */
    /*会员升级,资产触发,注册触发 */

    protected function assets_level($member_id)
    {      
        //最新会员信息
        $member = Db::name('member')->where(['id'=>$member_id])->find();

        //资产
        $assets = $member['gold_static'] * $member['gold_static_price'];

        //按资产直接升级（可升将级）
        $assets_level = Db::name('static_config')->where([
            'gold_up' => ['ELT',$assets],
            'rate'    => ['eq',0],
            'type'    => 2 //角色规则
        ])->order('gold_lt DESC')->find(); //按当前资产的最佳资产等级

        Db::name('member')->where(['id'=>$member['id']])->update(['level'=>$assets_level['level']]);

        Log::write('【资产直升】会员'.$member['id'].'升级'.$assets_level['level'].$assets_level['name'], 'level', true);
        Log::write($assets_level['name'].' ['.$assets_level['level'].'] id：'.$member['id'].' 资产：'.$assets, 'level', true);

        file_put_contents('level.txt', '【资产直升】会员'.$member['id'].'升级'.$assets_level['level'].$assets_level['name'].PHP_EOL,FILE_APPEND);

        //按推荐人选出最佳等级,只要满足即可
        //分类 [级别=>人数]
        $child_level_num = Db::name('member')->order('level DESC')->where(['parent_id'=>$member['id']])->field('level,count(*) as num')->group('level')->select();
        //补级
        $level_data = Db::name('static_config')->where([
            'rate' => ['gt',0],
            'type' => 2
        ])->order('level DESC')->select();

        $level_data[] = [
            'level' => (end($level_data)['level']-1)
        ];

        $tmp_child_level_num = [];
        foreach($level_data as $l_k=>$l_d){
            foreach($child_level_num as $c_m){
                if($l_d['level'] == $c_m['level']){
                    $tmp_child_level_num[$l_k] = $c_m; //如果有的话就替换了
                }else{
                    $tmp_child_level_num[] = ['level'=>$l_d['level'],'num'=>0];
                }
            }
        }

        //按分组的人数匹配最佳等级
        $parent_num = 0;

        //按大等级来，不满足则人数往下堆
        foreach($tmp_child_level_num as $child_num){ 

            $level_rule = Db::name('static_config')->where([
                'gold_up'    => ['ELT',$assets],              //资产
                'level' => $child_num['level']+1,             //想升
                'rate'  =>  ['ELT', $child_num['num'] + $parent_num ],   //必须有个会员
            ])->find();

            Log::write($member['id'].'有【'.($child_num['num'] + $parent_num).'】个'.$child_num['level']."级会员,想升".($child_num['level']+1)."需要【".($level_rule['rate'] ?:'不满足')."】个级会员", 'level', true);

            file_put_contents('level.txt', '----试探升级 '.$member['id'].'有【'.($child_num['num'] + $parent_num).'】个'.$child_num['level']."级会员,想升".($child_num['level']+1)."需要【".($level_rule['rate'] ?:'不满足')."】个级会员".PHP_EOL,FILE_APPEND);

            if($level_rule['rate']){ //满足升级才退出
                break; //退出
            }
            //浪费的高级会员 放下来
            $parent_num += $child_num['num']; 
        }
        
        //满足升级 （推荐升级必须有推荐人）
        if($level_rule && $level_rule['rate'] >= 1){
            Db::name('member')->where(['id'=>$member['id']])->update(['level'=>$level_rule['level']]);
            Log::write('【推荐升级】'.$member['id'].'升级-'.$level_rule['level'].$level_rule['name'],'level',true);
            file_put_contents('level.txt', '【推荐升级】'.$member['id'].'升级'.$level_rule['level'].$level_rule['name'].PHP_EOL,FILE_APPEND);
            //既然下级升级了/降级了，上级要看看
        }

        if($member['parent_id'] > 0){
            // Log::write('检查 id'.$member['parent_id'],'level',true);
            $this->assets_level($member['parent_id']);
        }


    }


}