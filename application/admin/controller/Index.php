<?php
namespace app\admin\controller;
use think\Controller;
use think\Db;

class Index extends Controller
{
    public function index()
    {
        if(session('?adminid')){
            $this->redirect('Main/index');
        }
        $user = ['',''];
        $online = cookie('online');
        if(!empty($online)){
            $info = authcode($online,'DECODE');
            if(!empty($info)){
                $user = explode('|', $info);
            }
        }

        $this->assign('user',$user);
        return $this->fetch();
    }

    public function login(){
    
        $this->assign('name','lty');
        $username = input('username');
        $password = input('password');
        $code = input('code');
        $online = input('online',0);
        
        if(empty($username)){
            $this->error('账号不能为空');
        }
        if(empty($password)){
            $this->error('密码不能为空');
        }
        if(empty($code) || $code == '验证码:'){
            $this->error('验证码不能为空');
        }

        if(!captcha_check($code)){
            $this->error('验证码错误');
        };

        $row = Db::name('admin')->where('username',$username)->find();
        if(empty($row)){
            $this->error('账号不存在');
        }

        if($row['password'] != md5(md5($password).md5($row['entry']))){
            $this->error('密码错误');
        }
        session('adminid',$row['id']);
        $data = array(
            'id' => $row['id'],
            'login_num' => $row['login_num'] + 1,
            'login_ip' => request()->ip(),
            'login_time' => time(),
            );
        if($online == 1){
            $info = $username.'|'.$password;
            $info = authcode($info);
            cookie('online',$info);
            cookie('online',$info,60*60*24*7);
        }else{
            cookie('online',null);
        }

        //更新admin
        Db::name('admin')->update($data);

        return json(array('status'=>'y','msg'=>'登陆成功','url'=>url('Main/index')));

    }

    public function logout(){
        session('adminid',null);
        $this->redirect('Index/index');
    }
}
