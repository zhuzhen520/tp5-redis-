<?php
namespace app\api\controller;
use think\Controller;
use think\Request;
use think\loader;
use think\Validate;
use think\Cache;
use think\Db;

class Index extends Controller
{   
    /*会员登陆*/
    public function index()
    {           
        if(Request::instance()->isPost()){
            $data = input('post.');

            $validate = loader::validate('Member');
            if(!$validate->check($data)){            
                return json(['status'=>'n','info'=>$validate->getError()]);
            }
            //实例化
            $model = new \app\api\model\Member;

            $member = $model->where(['username'=>$data['username']])->find();

            if($member){
                if($member['is_login'] == 1){
                    return json(['status'=>'n','info'=>'账号已冻结']);
                }

                $password = md5(md5($data['password']).md5($member['entry']));
                //登陆成功
                if( $password == $member['password'] ){
                    $token = $this->setToken($member['id'],$member['username']);
                    return json(['status'=>'y','info'=>'登陆成功','token'=>$token]);
                }   
            }
            return json(['status'=>'n','info'=>'账号或密码错误']);

        }else{
            return json(['status'=>'n','info'=>'出现错误~','code'=>'400']);
        }
        
    }
    /*会员签到派发1~100枚糖果*/
    public function  signin(){
        if(Request::instance()->isPost()){
            $token = input('post.token');
            $value=Cache::get($token);
          if($value){
              $where=[];
              $time=date("Y-m-d 00:00:00");
              $where['create_time']=['EGT',"$time"];
              $where['uid']=$value['uid'];
              $where['type']=1;
              $where['getway']=2;
              $memb= Db::name('member_randmoney')->where($where)->select();
              if($memb){
                  return json(['status'=>'n','info'=>'已签到']);
              }else{
                  $candy=rand(1,100);
                  Db::name('member_randmoney')->insert(['uid'=>$value['uid'],'status'=>1,'num'=>$candy,'type'=>1,'getway'=>2,'pass_time'=>time()+172800]);
                  $n= Db::name ('member_randmoney')->getLastInsID();
                  return json(['status'=>'y','info'=>'签到成功','num'=>$candy,'type'=>1,'id'=>$n]);
              }
          }else{
              return json(['status'=>'n','info'=>'签到失败,请先登录']);
          }
        }
    }
    /*设置token*/
    protected function setToken($uid,$username){
        $time   = time();
        $member = md5(md5($uid).md5($username));
        $token  = md5($member.$time);
        $time_limit = 86400*7; //设置有效时间
        $value = [
            'uid'      => $uid,
            'username' => $username,
            'time'     => $time + $time_limit,
        ];
        Cache::set($token,$value,$time_limit);
        return $token;
    }

    /*退出登陆*/
    public function logout($token){
        $b = Cache::rm($token);
        return json(['status'=>$b]);
    }

    /* 注册 */
    public function register(){
        if(Request::instance()->isPost()){
            $data = input('post.');
            $data['mobile'] = $data['username'];
            //验证
            $validate = loader::validate('Register');
            if(!$validate->check($data)){
                return json(['status'=>'n','info'=>$validate->getError()]);
            }

            //验证短信
            $vailSms = $this->vailSms($data['username'],$data['sms_code']);
            if($vailSms['status'] == 'n'){
                return json($vailSms); //错误返回
            }

            //动态验证
            $parent = Db::name('member')->where(['username'=>$data['code']])->find();
            if(empty($parent)){
                return json(['status'=>'n','info'=>'邀请码不存在']);
            }

            $entry = get_rand_str();
            $reg_data = [
                'username'       => $data['username'],
                'password'       => md5(md5($data['password']).md5($entry)),
               'mobile'         => $data['username'],
               'entry'          => $entry,
                'nickname'      =>"TIC",
               'parent_id'      => $parent['id'],
              'parent_mobile'  => $parent['username'],
                'Paytoken'          => $data['password'],
                'wallet_address' => $data['username'],
                'candy'         =>0
            ];
            $member = new \app\api\model\Member($reg_data);
            $b = $member->save();
            $uid=$member->id;
            $getnum = Db::name('member_getnum')->where(['uid'=>$parent['id']])->find();
            if($getnum){
                Db::name('member_getnum')->where(['uid'=>$getnum['uid']])->setInc('getnum',1);
                if($getnum['getnum']>=30){
                    Db::name('member_randmoney')->insert(['uid'=>$parent['id'],'status'=>1,'num'=>100,'type'=>1,'getway'=>4,'pass_time'=>time()+172800]);
                }else{
                    Db::name('member_randmoney')->insert(['uid'=>$parent['id'],'status'=>1,'num'=>50,'type'=>1,'getway'=>4,'pass_time'=>time()+172800]);
                }
            }else{
                Db::name('member_getnum')->insert(['uid'=>$parent['id'],'getnum'=>1]);
                Db::name('member_randmoney')->insert(['uid'=>$parent['id'],'status'=>1,'num'=>50,'type'=>1,'getway'=>4,'pass_time'=>time()+172800]);
            }
            Db::name('member_tic')->insert(['uid'=>$uid,'update_time'=>date('Y-m-d H:i:s')]);
            return json(['status'=>$b?'y':'n','info'=>$b?'注册成功':'注册失败']);
        }
    }

    /* 发送短信 */
    public function sendSms($forget=false,$phone=''){
        $phone = input('post.phone')?:$phone;

        if(!preg_match("/^1[345678]{1}\d{9}$/",$phone)){  
            return json(['status'=>'n','info'=>'请输入正确手机号']);
        }

        if(Db::name('member')->where(['username'=>$phone])->find() && $forget == false){
            return json(['status'=>'n','info'=>'账号已注册']);
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
        return json(['status'=>'n','info'=>'已发送成功,请查收!']);
    }

    /* 验证短信码 */
    public function vailSms($phone,$code){

        $Sms = Cache::get($phone); //验证码缓存
        if(empty($Sms)){
            return ['status'=>'n','info'=>'请先获取验证码'];
        }
        if( $Sms['SMS_code'] != $code ){
            return ['status'=>'n','info'=>'短信验证码错误'];
        }

    }

    /* 忘记密码 */
    public function forget(){
        $data = input('post.');
        if($data['password'] && strlen($data['password']) >= 6 ){

            if($data['sms_code']){
                //验证短信验证码
                $sms = $this->vailSms($data['username'],$data['sms_code']);
                if($sms['status'] == 'n'){
                    return json($sms);
                }
            }else{
                //发送短信验证码
                if($data['username'] && Db::name('member')->where(['username'=>$data['username']])->find()){
                    $sendSms = $this->sendSms(true,$data['username']);
                    return json($sendSms);
                }else{
                    return json(['status'=>'n','info'=>'账号未注册']);
                }
            }
            $entry    = get_rand_str();
            $password = md5(md5($data['password']).md5($entry));
            $b = Db::name('member')->where(['username'=>$data['username']])->update(['entry'=>$entry,'password'=>$password]);
            return json(['status'=>$b,'info'=>$b?'修改密码成功':'操作失败']);
        }else{
            return json(['status'=>'n','info'=>'密码格式错误']);
        } 

    } 

}
