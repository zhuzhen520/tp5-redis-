<?php
namespace app\api\controller;
use think\loader;
use think\Cache;
use think\Db;
use think\Config;
use think\Request;
/**
* 我的控制器
*/
class Info extends Base
{
    protected $a=[];
    /*我的糖果*/
    public function myCandy()
    {
        $m=$this->member['uid'];
        $data=Db::name('member')->where(array('id' => $m))->field(['candy'])->find();
        $rate=get_conf('rate');
        $data['ticnum']=intval((int)$data['candy']/(int)$rate['candy']);
        $time=date('Y-m-d 00:00:00',time());
        $tgjl=Db::name('member_randmoney')->where(['uid'=>$m,'status' =>2 ,'type' =>1,'create_time'=>['egt',$time]])->sum('num');
        $this->data['Tcandy']=$data;
        $this->data['Todaynew']=$tgjl;
        return json($this->data);
    }

    /*我的糖果兑换*/
    public function myCandyexchange()
    {
        $m=$this->member['uid'];
        $number=$this->POST['number'];
        $data=Db::name('member')->where(array('id' => $m))->field(['candy'])->find();
        $rate=get_conf('rate');
        $data['ticnum']=intval((int)$data['candy']/(int)$rate['candy']);
        //兑换的糖果数量；
        $exnum=(int)$number*(int)$rate['candy'];
        if((int)$exnum<(int)$data['candy']){
        	$b=Db::name('member')->where(['id' => $m])->setDec('candy',$exnum);
        	if($b){
                Db::name('member_tic')->where('uid',$m)->setInc('circulatetic',$data['ticnum']);
        	    $exCandy['uid']=$m;
        	    $exCandy['type']=1;   
        	    $exCandy['num']=$data['ticnum'];;
                $exCandy['dh_num']=$exnum;
        	    $exCandy['time']=date("Y-m-d H:i:s",time());  
        	    Db::name('exchange')->insert($exCandy);
                $lit['uid']=$m;
                $lit['type']='糖果兑换';
                $lit['num']='+'.$data['ticnum'];
                $lit['add_time']=time();
                Db::name('tic_liutonglog')->insert($lit);
                return json(['status'=>'0','info'=>'兑换成功']);
        	}else{
        		return json(['status'=>'1','info'=>'兑换失败，请重试']);
        	}
        }else{
        	return json(['status'=>'1','info'=>'糖果数量不足']);
        }
    }

    /*我的钻石兑换*/
    public function myMineralexchange()
    {
        $m=$this->member['uid'];
        $number=$this->POST['number'];
        $data=Db::name('member')->where(array('id' => $m))->field(['mineral'])->find();
        $rate=get_conf('rate');
        $data['ticnum']=intval((int)$data['mineral']/(int)$rate['mineraltic']);
        //兑换的糖果数量；
        $exnum=(int)$number*(int)$rate['mineraltic'];
        if((int)$exnum<(int)$data['mineral']){
            $b=Db::name('member')->where(array('id' => $m))->setDec('mineral',$exnum);
        	if($b){
                Db::name('member_tic')->where('uid',$m)->setInc('circulatetic',$data['ticnum']);
        	    $exCandy['uid']=$m;
        	    $exCandy['type']=2;   
        	    $exCandy['num']=$data['ticnum'];;
                $exCandy['dh_num']=$exnum;
        	    $exCandy['time']=date("Y-m-d H:i:s",time());
        	    Db::name('exchange')->insert($exCandy);
                $lit['uid']=$m;
                $lit['type']='矿石兑换';
                $lit['num']='+'.$data['ticnum'];
                $lit['add_time']=time();
                Db::name('tic_liutonglog')->insert($lit);
        	    return json(['status'=>'0','info'=>'兑换成功']);
        	}else{
        		return json(['status'=>'1','info'=>'兑换失败，请重试']);
        	}

        }else{
        	return json(['status'=>'1','info'=>'矿石数量不足']);
        }
    }

    /*我的钻石糖果记录*/
    public function myexchange()
    {
        $m=$this->member['uid'];
        $type=$this->POST['type'];
        $list= Db::name('exchange')->where(['uid'=>$m,'type'=>$type])->field(['type','num','time','dh_num','kind'])->select();
        return json($list);
    }

    /*z流通转存储 转应用 应用转流通API*/
    public function Ticchange()
    {
        $m=$this->member['uid'];
        $data=$this->POST;
        dump($m);die;
        
        return json($list);
    }

    /*我的矿石*/
    public function myMineral()
    {
        $m=$this->member['uid'];
        $data=Db::name('member')->where(array('id' => $m, ))->field(['mineral'])->find();
        $rate=get_conf('rate');
        $data['ticnum']= intval($data['mineral']/(int)$rate['mineraltic']);
        $time=date('Y-m-d 00:00:00',time());
        $tgjl=Db::name('member_randmoney')->where(['uid'=>$m,'status' =>2 ,'type' =>2,'create_time'=>['egt',$time]])->sum('num');
        $this->data['Mineral']=$data;
        $this->data['Todaynew']=$tgjl;
        return json($this->data);
    }
    /*我的邀请推广*/
    public function myyaoqing()
    {
        $m=$this->member['uid'];
        $son= Db::name('member')->alias('a')
            ->join('member_info b','a.id=b.uid','LEFT')
            ->where('a.parent_id',$m)->field(['a.id','a.level','a.username','b.name'])->select();
        $num=count($son);
        foreach($son as $k=>$v){
            if($v['level']==0){
                    $son[$k]['lv']="粉丝";
            }elseif($v['level']==1){
                    $son[$k]['lv']="小节点";
            }elseif($v['level']==2){
                    $son[$k]['lv']="大节点";
            }elseif($v['level']==3){
                    $son[$k]['lv']="超级节点";
            }
        }
        $this->data['son']=$son;
        $this->data['num']=$num;
        return json($this->data);
    }
    public function myyaoqingtype()
    {
        $m=$this->member['uid'];
        $type=$this->POST['type'];
        $my=Db::name('member')->where('id',$m)->value(['level']);
        $son= Db::name('member')->where('parent_id',$m)->field(['id','level','username'])->select();
        $num=count($son);
        $where=[];
        $where['parent_id']=$m;
        if($type == 4){
            $where['level']=$my;
            $typeson=Db::name('member')->where($where)->field(['id','level','username'])->select();
            foreach($typeson as $k=>$v){
                $typeson[$k]['lv']="育成";
                $typeson[$k]['level']=1;
            }
        }else{
            $where['level']=$type;
            $typeson=Db::name('member')->where($where)->field(['id','level','username'])->select();
            foreach($typeson as $k=>$v){
                if($v['level']==0){
                    $typeson[$k]['lv']="粉丝";
                }elseif($v['level']==1){
                    $typeson[$k]['lv']="小节点";
                }elseif($v['level']==2){
                    $typeson[$k]['lv']="大节点";
                }elseif($v['level']==3){
                    $typeson[$k]['lv']="超级节点";
                }
                $typeson[$k]['level']=1;
                }
        }
        $this->data['son']=$typeson;
        $this->data['num']=$num;
        return json($this->data);
    }
    /*我的邀请收益*/
    public function mygetmoney()
    {
        $m=$this->member['uid'];
        $where['uid']=$this->member['uid'];
        $where['add_time']=['egt',strtotime(date('Y-m-d'))];
        $my=Db::name('member_fandian')->where($where)->field(['id','cid','num'])->select();
        $num= Db::name('member')->where('parent_id',$m)->count();
        foreach($my as $k=>$v){
            $son= Db::name('member')
                ->alias('a')
                ->join('member_info b','a.id=b.uid','LEFT')
                ->where('a.id',$v['cid'])
                ->field(['a.id','a.level','a.username','b.name'])
                ->find();
            if($son['level']==0){
                    $my[$k]['lv']="粉丝";
                $my[$k]['username']=$son['username'];
                $my[$k]['name']=$son['name'];
            }elseif($son['level']==1){
                    $my[$k]['lv']="小节点";
                $my[$k]['username']=$son['username'];
                $my[$k]['name']=$son['name'];
            }elseif($son['level']==2){
                    $my[$k]['lv']="大节点";
                $my[$k]['username']=$son['username'];
                $my[$k]['name']=$son['name'];
            }elseif($son['level']==3){
                    $my[$k]['lv']="超级节点";
                $my[$k]['username']=$son['username'];
                $my[$k]['name']=$son['name'];
            }
        }
        $this->data['son']=$my;
        $this->data['num']=$num;
        return json($this->data);
    }
   /*兑冲拨币*/
    public function dcmoneyindex(){
        $m=$this->member['uid'];
        $user=Db::name('member_tic')->where('uid',$m)->value('circulatetic');
        $this->data['user']['uid']=$m;
        $this->data['user']['releasetic']=$user;
        //dump($this->member);
        //die;
        return json($this->data);
    }
    /*兑冲拨币提交申请*/
    public function dcmoneyapply(){
        Db::startTrans();// 启动事务
        $data=$this->POST;
        $m=$this->member['uid'];
        $Paytoken=Db::name('member')->where('id',$m)->value('Paytoken');
        if($Paytoken != md5($this->POST['Paytoken'])){
            return json(['status'=>'n','info'=>'支付密码错误']);
        }
        $num=Db::name('member_tic')->where('uid',$m)->value('circulatetic');
        if($num<$data["persontic"]){
            return json(['status'=>'n','info'=>'个人拨币数量错误']);
        }
        $add=Db::name('member')->where('wallet_address',$data['wallet_address'])->find();
        if(empty($add)){
            return json(['status'=>'n','info'=>'不存在该钱包地址']);
        }
        try{
            //先减少拨币账户的流通tic
            Db::name('member_tic')->where('uid',$m)->setDec('circulatetic',$data["persontic"]);
            $sdata=[
                'uid'=>$m,
                'wallet_address'=>$data['wallet_address'],
                'persontic'=>$data['persontic'],
                'pttic'=>$data['pttic'],
                'totaltic'=>$data['totaltic'],
                'add_time'=>time()
            ];
            Db::name('tic_bobi')->insert($sdata);
            $log=[
                'uid'=>$m,
                'typetic'=>2,
                'info'=>'兑冲拨币',
                'num'=>'+'.$data["persontic"],
                'add_time'=>time(),
                'status'=>1
            ];
            Db::name('tic_totallog')->insert($log);
            // 更新成功 提交事务
            Db::commit();
            return json(['status'=>'y','info'=>'申请成功']);
        } catch (\Exception $e) {
            // 更新失败 回滚事务
            dump($e->getMessage());
            Db::rollback();
            return json(['status'=>'n','info'=>'申请失败']);
        }
    }
    /*个人算力*/
    public function mysuanli(){
        $m=$this->member['uid'];
        $tic=Db::name('member_tic')->where('uid',$m)->value('storagetic');
        $data=[];
        if((int)$tic<2000){
            $data['level']='粉丝算力';
            $data['get']='0.01~0.19';
        }elseif((int)$tic>=2000 && (int)$tic<10000){
            $data['level']='一级算力';
            $data['get']='6~30';
        }elseif((int)$tic>=10000 && (int)$tic<20000){
            $data['level']='二级算力';
            $data['get']='30~60';
        }elseif((int)$tic>=20000 && (int)$tic<30000){
            $data['level']='三级算力';
            $data['get']='60~90';
        }elseif((int)$tic>=30000){
            $data['level']='超级算力';
            $data['get']='100~150';
        }
        $data['totaltic']=$tic;
        $this->data['self']=$data;
        return json($this->data);
    }
    /*无限极下级查询*/
    public function xiajizongtic($uid){
        $son= Db::name('member')->where('parent_id',$uid)->field(['id'])->select();
        foreach($son as $key =>$value){
            $this->a[]=$value;
        }
        $this->getchild($son);
        $chd=$this->a;
        $this->a=[];
        return $chd;

    }
    /*获取下级*/
    public function getchild($son){
        foreach($son as $k=>$v){
            $n=Db::name('member')->where('parent_id',$v['id'])->field(['id'])->select();
            if($n){
                foreach($n as $key =>$value){
                    $this->a[]=$value;
                }
                self::getchild($n);
            }
        }

    }
    /*获取 直属下级*/
    public function getzchild($uid){
        $arr=[];
        $level=Db::name('member')->where('id',$uid)->value('level');
        $son=Db::name('member')->where(['parent_id'=>$uid,'level'=>$level])->field(['id'])->select();
        foreach($son as $k=>$v){
            $arr[]=$v['id'];
        }
        return $arr;
    }
    /*所有下级当日新增tic总数*/
    public function childtic($id){
        $arr=[];
        $s= $this->xiajizongtic($id);
        foreach($s as $value){
            foreach($value as $k=>$v){
                $arr[]=$v;
            }
        }
        $time=strtotime(date('Y-m-d'));
        $aaa=Db::name('tic_staticlog')->where(['uid'=>['in',$arr],'add_time'=>['egt',$time]])->sum('action');
        return $aaa;
    }
    /*团队所有人所有类型tic总数*/
    public function teamtic($id){
        $arr=[];
        $s= $this->xiajizongtic($id);
        foreach($s as $value){
            foreach($value as $k=>$v){
                $arr[]=$v;
            }
        }
        $time=strtotime(date('Y-m-d'));
        $n1=Db::name('member_tic')->where(['uid'=>['in',$arr]])->sum('storagetic');
        $n2=Db::name('member_tic')->where(['uid'=>['in',$arr]])->sum('circulatetic');
        $n3=Db::name('member_tic')->where(['uid'=>['in',$arr]])->sum('usetic');
        $n=$n1+$n2+$n3;
        return $n;
    }
    /*获取下级团队类型数量*/
    public function chdnum($ary,$level){
        $arr=[];
        foreach($ary as $value){
            foreach($value as $k=>$v){
                $arr[]=$v;
            }
        }
        $where['id']=['in',$arr];
        $where['level']=$level;
        $num=Db::name('member')->where($where)->count();
        return $num;
    }
    /*节点算力*/
    public function myjiedian(){
        $m=$this->member['uid'];
        $time=strtotime(date('Y-m-d'));
        $level=Db::name('member')->where('id',$m)->value('level');
        $ycmember=$this->getzchild($m);
        //当日育成算力
        $todayyc=Db::name('tic_staticlog')->where(['uid'=>['in',$ycmember],'add_time'=>['egt',$time]])->sum('action');
       //所有下级当日新增tic总数 当日新增算力
        $todayall= $this->childtic($m);
        //团队所有人所有类型tic总数
        $alltic=$this->teamtic($m);
        $cid=$this->xiajizongtic($m);
        //超级节点
        $super=$this->chdnum($cid,3);
        //粉丝
        $fans=$this->chdnum($cid,0);
        //小节点
        $small= $this->chdnum($cid,1);
        //大节点
        $big=$this->chdnum($cid,2);
        if($level == 0){
            $lv='粉丝';
        }elseif($level==1){
            $lv='小节点';
        }elseif($level==2){
            $lv='大节点';
        }elseif($level==3){
            $lv='超级节点';
        }
        $this->data['todayyc']=$todayyc;
        $this->data['todayall']=$todayall;
        $this->data['alltic']=$alltic;
        $this->data['super']=$super;
        $this->data['fans']=$fans;
        $this->data['small']=$small;
        $this->data['big']=$big;
        $this->data['lv']=$lv;
        return json($this->data);
    }
    /*存储tic转流通tic*/
    public function cTol(){
        $m=$this->member['uid'];
        $num=$this->POST['num'];
        $Paytoken=Db::name('member')->where('id',$m)->value('Paytoken');
        if($Paytoken != md5($this->POST['Paytoken'])){
            return json(['status'=>'n','info'=>'支付密码错误']);
        }
        $rle=Db::name('tic_reless')->where('uid',$m)->value('releasetic');
        if($rle<$num){
            return json(['status'=>'n','info'=>'额度超过,申请失败']);
        }
        Db::startTrans();// 启动事务
        try{
            //先减流通tic限额表中的数据
            Db::name('tic_reless')->where('uid',$m)->setDec('releasetic',$num);
            Db::name('member_tic')->where('uid',$m)->setDec('storagetic',$num);
            Db::name('member_tic')->where('uid',$m)->setInc('circulatetic',$num);
            $log=[
                'uid'=>$m,
                'typetic'=>1,
                'info'=>'提取',
                'num'=>'-'.$num,
                'add_time'=>time(),
                'status'=>2
            ];
            Db::name('tic_totallog')->insert($log);
            $data_log = [
                'uid'         => $m,
                'username'    => $this->member['username'],
                'action'      => abs($num),
                'info'        => '用户存储转流通',
                'ticb'    => get_conf('rate','mineral'),
                'type'        => 1,
                'add_time'    => time(),
                'ristatus'    =>3
            ];
            Db::name('tic_staticlog')->insert($data_log);
            // 更新成功 提交事务
            Db::commit();
            return json(['status'=>'y','info'=>'申请成功']);
        } catch (\Exception $e) {
            // 更新失败 回滚事务
            dump($e->getMessage());
            Db::rollback();
            return json(['status'=>'n','info'=>'申请失败']);
        }
    }
    /*存储 流通 应用tic明细*/
    public function storagetic_detail(){
        $m=$this->member['uid'];
        $where['uid']=$m;
        if($this->POST['typetic']){
            $where['typetic']=$this->POST['typetic'];
        }
        $res=Db::name('tic_totallog')->where($where)->select();
        $this->data['log']=$res;
        return json($this->data);
    }
    /*存储tic页面*/
    public function storagetic(){
        Db::name('tic_static')->where('statictic',0)->delete();
        $m=$this->member['uid'];
        $where['uid']=$m;
        $storagetic=Db::name('member_tic')->where($where)->value('storagetic');
        $releasetic=Db::name('tic_reless')->where($where)->value('releasetic');
        $storagetic_log=Db::name('tic_static')->where($where)->order('id desc')->paginate(5)
            ->each(function($item, $key){
                $item['havereless'] =$item['action']-$item['statictic'];
                return $item;
            });
        $this->data['storagetic']=$storagetic;
        $this->data['releasetic']=$releasetic;
        $this->data['storagetic_log']=$storagetic_log;
        return json($this->data);
    }
    /*钱包地址*/
    public function moneyadress(){
        $m=$this->member['uid'];
        $wallet_address=Db::name('member')->where(['id'=>$m])->value('wallet_address');
        $this->data['wallet_address']=$wallet_address;
        return json($this->data);
    }
    /*流通tic页面*/
    public function circulatetic(){
        $m=$this->member['uid'];
        $where['uid']=$m;
        $circulatetic=Db::name('member_tic')->where($where)->value('circulatetic');
        $this->data['circulatetic']=$circulatetic;
        return json($this->data);
    }
    /*流通tic记录页面*/
    public function circulatetic_log(){
        $m=$this->member['uid'];
        $where['uid']=$m;
        $circulatetic=Db::name('tic_liutonglog')->where($where)->order('id desc')->paginate(5);
        $this->data['circulatetic_log']=$circulatetic;
        return json($this->data);
    }
    /*兑冲拨币详情记录页*/
    public function dcmoneydetail(){
        $m=$this->member['uid'];
        $where['uid']=$m;
        $detail=Db::name('tic_bobi')
            ->where($where)
            ->field(['wallet_address','persontic','type','add_time'])
            ->order('id desc')->paginate(5)->each(function($item,$key){
            $item['username']=Db::name('member')->where('wallet_address',$item['wallet_address'])->value('username');
            return $item;
        });
        $this->data['detail']=$detail;
        return json($this->data);
    }

    /*usdt汇率*/
    public function usdthuilv(){
        $m=$this->member['uid'];
        $rate=get_conf('rate');
        return json($rate);
    }


    //兑换eth、btc
    public function okduihuan(){
        $m=$this->member['uid'];
        $data=$this->POST;
        $rate=get_conf('rate');
        $Paytoken=Db::name('member')->where('id',$m)->value('Paytoken');
        foreach ($data as $k => $v) {
            if(empty($v)){
                return json(['status'=>'n','info'=>'信息不能为空']);
            }
        }
        if($Paytoken != md5($data['psw2'])){
            return json(['status'=>'n','info'=>'支付密码错误']);
        }
        $num=Db::name('member_tic')->where('uid',$m)->value('circulatetic');
        //计算需要tic数量
        $ticnum=(float)$data['rmbnum']*(float)$data['dh_num']/(float)$rate['mineral'];
        if((float)$num<(float)$ticnum){
            return json(['status'=>'n','info'=>'TIC数目不足']);
        }else{
            Db::name('member_tic')->where('uid',$m)->setDec('circulatetic',$ticnum);
            $db=array('uid' =>$m,'type'=>'TIC转'.$data['type'],'num'=>'-'.$ticnum,'add_time' =>time());
            $m=Db::name('tic_liutonglog')->insert($db);
            if($m){
                $dat=array('uid' => $this->member['uid'],'currency'=>$data['currency'],'address'=>$data['address'],'dh_num' =>$data['dh_num'],'rmbnum' => $data['rmbnum'],'type'=>$data['type'],'tic'=>$ticnum,'status'=>0,'time'=>time());
                Db::name('eth_log')->insert($dat);
                return json(['status'=>'y','info'=>'兑换申请已提交']);
            }else{
                return json(['status'=>'n','info'=>'兑换失败，请重试']);
            }
        }

    }

    //兑换eth、btc记录
    public function eth_log(){
        $m=$this->member['uid'];
        $type=$this->POST['type'];
        $currency=$this->POST['currency'];
        $data=Db::name('eth_log')->where(['uid'=>$m,'type'=>$type])->select();
        foreach ($data as $k => &$v){
            $v['time']=date('m-d H:i',$v['time']);
            if($v['status']==0){
               $v['status']='待审核';
            }elseif($v['status']==1){
               $v['status']='通过';
            }elseif($v['status']==2){
                 $v['status']='被驳回';
            }
        }
        return json($data);
    }

    //充币地址
    public function eth_chargeMoney(){
        $m=$this->member['uid'];
        $rate=get_conf('base');
        $address['code']=$rate['money_address'];
        return json($address);
    }
    //公告内容
    public function gonggao(){
        $m=$this->member['uid'];
        $rate=get_conf('base');
        return json($rate);
    }

    //版本控制
    public function version(){
        $m=$this->member['uid'];
        $rate=get_conf('base');
        $data['apk']=$rate['apk'];
        $data['apk1']=$rate['apk1'];
        $data['version']=$rate['version'];
        return json($data);

    }
}   