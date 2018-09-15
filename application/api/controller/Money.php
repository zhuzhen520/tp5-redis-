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
class Money extends Base
{
    /*钱包页面数据*/
    public function qianbao(){
        $m=$this->member['uid'];
        $arr =Db::name('member_tic')->where('uid',$m)->field(['usetic','storagetic','circulatetic'])->find();
        $n=$arr['usetic']+$arr['storagetic']+$arr['circulatetic'];
        $b=number_format($n,4,".","");
        $rate=get_conf('rate','mineral');
        $arr['total']=$b;
        $arr['yue']=$b*$rate;;
        $this->data['money']=$arr;
        return json($this->data);
    }
    /*应用TIC页面*/
    public function usetic(){
        $m=$this->member['uid'];
        $where['uid']=$m;
        $usetic=Db::name('member_tic')->where($where)->value('usetic');
        $this->data['usetic']=$usetic;
        return json($this->data);
    }
    /*应用tic记录页面*/
    public function usetic_log(){
        $m=$this->member['uid'];
        $where['uid']=$m;
        $where['typetic']=3;
        $usetic_log=Db::name('tic_totallog')->where($where)->order('id desc')->paginate(5);
        $this->data['usetic_log']=$usetic_log;
        return json($this->data);
    }
    /*流通转存储TIC*/
    public function lTos(){
        $m=$this->member;
        $Paytoken=Db::name('member')->where('id',$m['uid'])->value('Paytoken');
        if($Paytoken != md5($this->POST['Paytoken'])){
            return json(['status'=>'n','info'=>'支付密码错误']);
        }
        $ltnum=Db::name('member_tic')->where('uid',$m['uid'])->value('circulatetic');
        if($ltnum< $this->POST['num']){
            return json(['status'=>'n','info'=>'额度超限']);
        }
        Db::startTrans();
        try{
            //先增加存储tic数量
            Db::name('member_tic')->where('uid',$m['uid'])->setInc('storagetic',$this->POST['num']);
            //减少流通tic
            Db::name('member_tic')->where('uid',$m['uid'])->setDec('circulatetic',$this->POST['num']);
            //写入锁仓表
            $t=Db::name('config')->where(['name'=>'static_gold_rid'])->value('value');
            $data_tic = [
                'uid'         => $m['uid'],
                'username'    => $m['username'],
                'action'      => abs($this->POST['num']),
                'statictic'   => abs($this->POST['num']),//锁死值
                'info'        => '用户操作流通转存储',
                'releasetic'  => abs($this->POST['num'])*0.1,
                'reless_time'  => strtotime(date('Y-m-d',strtotime("+$t day"))),//开始释放的时间q
                'type'        => 4,
                'add_time'    => time()
            ];
            Db::name('tic_static')->insert($data_tic);
            //静态TIC日志   当时价放订单号字段
            $data_log = [
                'uid'         => $m['uid'],
                'username'    => $m['username'],
                'action'      => abs($this->POST['num']),
                'info'        => '用户流通转存储',
                'ticb'    => get_config('rate','mineral'),
                'type'        => 1,
                'add_time'    => time(),
                'ristatus'    =>2
            ];
            Db::name('tic_staticlog')->insert($data_log);
            $log=[
                'uid'=>$m['uid'],
                'typetic'=>2,
                'info'=>'转存储',
                'num'=>'-'.$this->POST['num'],
                'add_time'=>time(),
                'status'=>2
            ];
            Db::name('tic_totallog')->insert($log);
            $lit['uid']=$m['uid'];
            $lit['type']='转存储';
            $lit['num']='-'.$this->POST['num'];
            $lit['add_time']=time();
            Db::name('tic_liutonglog')->insert($lit);
            // 更新成功 提交事务
            Db::commit();
            return json(['status'=>'y','info'=>'申请成功']);
        } catch (\Exception $e) {
            // 更新失败 回滚事务
            dump($e->getMessage());
            Db::rollback();
            //return json(['status'=>'n','info'=>'申请失败']);
        }

    }
    /*流通转应用TIC*/
    public function lTou(){
        $m=$this->member;
        $Paytoken=Db::name('member')->where('id',$m['uid'])->value('Paytoken');
        if($Paytoken != md5($this->POST['Paytoken'])){
            return json(['status'=>'n','info'=>'支付密码错误']);
        }
        $ltnum=Db::name('member_tic')->where('uid',$m['uid'])->value('circulatetic');
        if($ltnum< $this->POST['num']){
            return json(['status'=>'n','info'=>'额度超限']);
        }
        if(empty($this->POST['id'])){
            return json(['status'=>'n','info'=>'订单出错']);
        }
        $bao=Db::name('product')->where('id',$this->POST['id'])->find();
        if(!$bao){
            return json(['status'=>'n','info'=>'不存在该资产包']);
        }
        if($bao['start_money']>$this->POST['num']){
            return json(['status'=>'n','info'=>'低于起投价格']);
        }
        Db::startTrans();
        try{
            //减少流通tic
            Db::name('member_tic')->where('uid',$m['uid'])->setDec('circulatetic',$this->POST['num']);
            Db::name('member_tic')->where('uid',$m['uid'])->setInc('usetic',$this->POST['num']);
            $have=Db::name('product_order')->where(['uid'=>$m['uid'],'product_id'=>$this->POST['id']])->find();
            if($have){
                Db::name('product_order')
                    ->where(['uid'=>$m['uid'],'product_id'=>$this->POST['id']])
                    ->setInc('num',$this->POST['num']);
            }else{
                $pro=[
                    'product_id'=>$this->POST['id'],
                    'uid'=>$m['uid'],
                    'num'=>$this->POST['num'],
                    'username'=>$m['username'],
                    'add_time'=>time()
                ];
                //插入资产订单表
                Db::name('product_order')->insert($pro);
            }

            $log=[
                'uid'=>$m['uid'],
                'typetic'=>3,
                'info'=>'流通转应用',
                'num'=>'+'.$this->POST['num'],
                'add_time'=>time(),
                'status'=>2
            ];
            //插入tic总表
            Db::name('tic_totallog')->insert($log);
            $lit['uid']=$m['uid'];
            $lit['type']='转应用';
            $lit['num']='-'.$this->POST['num'];
            $lit['add_time']=time();
            //插入流通专用表
            Db::name('tic_liutonglog')->insert($lit);
            // 更新成功 提交事务
            Db::commit();
            return json(['status'=>'y','info'=>'申请成功']);
        } catch (\Exception $e) {
            // 更新失败 回滚事务
           // dump($e->getMessage());
            Db::rollback();
            return json(['status'=>'n','info'=>'申请失败']);
        }

    }
    /*应用(资产包)转流通TIC*/
    public function uTol(){
        $m=$this->member;
        $Paytoken=Db::name('member')->where('id',$m['uid'])->value('Paytoken');
        if($Paytoken != md5($this->POST['Paytoken'])){
            return json(['status'=>'n','info'=>'支付密码错误']);
        }
        if(empty($this->POST['id'])){
            return json(['status'=>'n','info'=>'订单出错']);
        }
        $zc=Db::name('product')->where(['id'=>$this->POST['id']])->find();
        if(!$zc){
            return json(['status'=>'n','info'=>'不存在该资产包']);
        }
        $ltnum=Db::name('product_order')->where(['uid'=>$m['uid'],'product_id'=>$this->POST['id']])->find();
        if($ltnum['num']< $this->POST['num']){
            return json(['status'=>'n','info'=>'额度超限']);
        }

        Db::startTrans();
        try{
            if($zc['is_sale']==0){
                $money=$this->POST['num'];
            }else{
                $money=$this->POST['num']*0.8;
                $adminmoney=$this->POST['num']-$money;
                Db::name('adminmoney')->where('name','admin')->setInc('money',$adminmoney);
                Db::name('adminmoney_log')->insert(['uid'=>$m['uid'],'username'=>$m['username'],'product_id'=>$zc['id'],'num'=>$adminmoney,'create_time'=>time()]);
            }
            //增加流通tic减少应用tic
            Db::name('member_tic')->where('uid',$m['uid'])->setInc('circulatetic',$money);
            Db::name('member_tic')->where('uid',$m['uid'])->setDec('usetic',$money);
            //减少资产包num
            Db::name('product_order')->where(['uid'=>$m['uid'],'product_id'=>$this->POST['id']])->setDec('num',$money);
            $log=[
                'uid'=>$m['uid'],
                'typetic'=>3,
                'info'=>'转流通',
                'num'=>'-'.$money,
                'add_time'=>time(),
                'status'=>2
            ];
            //插入tic总表
            Db::name('tic_totallog')->insert($log);
            $lit['uid']=$m['uid'];
            $lit['type']='资产包转入';
            $lit['num']='+'.$money;
            $lit['add_time']=time();
            //插入流通专用表
            Db::name('tic_liutonglog')->insert($lit);
            // 更新成功 提交事务
            Db::commit();
            return json(['status'=>'y','info'=>'申请成功']);
        } catch (\Exception $e) {
            // 更新失败 回滚事务
             //dump($e->getMessage());
            Db::rollback();
            return json(['status'=>'n','info'=>'申请失败']);
        }

    }
    /*转出资产列表页*/
    public function outproduct(){
        $m=$this->member;
        $arr=[];
        $res=Db::name('product_order')->where('uid',$m['uid'])->field(['product_id'])->select();
       foreach($res as $valeu ){
            $arr[]=$valeu['product_id'];
       }
        $zichan=Db::name('product')->where('id','in',$arr)->field(['id','name','mianji','totalmianji','buy_price','dream_money','play_time','thumb'])->select();
        $this->data['zichan'] = $zichan;
        //返回
        return json($this->data);
    }
}   