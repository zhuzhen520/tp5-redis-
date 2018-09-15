<?php
namespace app\api\controller;
use think\Controller;
use think\Request;
use think\Db;

class Allurl extends Controller
{
    protected $a=[];
    /* 会员每天的统计算力产生收益*/
    public function powerlevel(){
        $sql="SELECT a.id,b.storagetic FROM think_member AS a LEFT JOIN think_member_tic AS b ON a.id=b.uid";
        $arr=Db::query($sql);
        $time=time()+172800;
        set_time_limit(600);
        foreach($arr as $key=>$value){
            if((int)$value["storagetic"]<2000){
                $num=mt_rand(1000,1999)/100000;
                Db::name('member_randmoney')->insert(['num'=>$num,'uid'=>$value['id'],'status'=>1,'type'=>2,'getway'=>1,'pass_time'=>$time]);
                Db::name('member')->where(['id'=>$value['id']])->update(['power'=>0.002]);
            }elseif((int)$value["storagetic"]>=2000 && (int)$value["storagetic"]<10000){
                $num1=mt_rand(6,30);
                $pj=$num1/10;
                $i=0;
                for($i;$i<10;$i++){
                    Db::name('member_randmoney')->insert(['num'=>$pj,'uid'=>$value['id'],'status'=>1,'type'=>2,'getway'=>1,'pass_time'=>$time]);
                }
                Db::name('member')->where(['id'=>$value['id']])->update(['power'=>0.003]);
            }elseif((int)$value["storagetic"]>=10000 && (int)$value["storagetic"]<20000){
                $num2=mt_rand(30,60);
                $pj=$num2/10;
                $i=0;
                for($i;$i<10;$i++){
                    Db::name('member_randmoney')->insert(['num'=>$pj,'uid'=>$value['id'],'status'=>1,'type'=>2,'getway'=>1,'pass_time'=>$time]);
                }
                Db::name('member')->where(['id'=>$value['id']])->update(['power'=>0.003]);
            }elseif((int)$value["storagetic"]>=20000 && (int)$value["storagetic"]<30000){
                $num3=mt_rand(60,90);
                $pj=$num3/10;
                $i=0;
                for($i;$i<10;$i++){
                    Db::name('member_randmoney')->insert(['num'=>$pj,'uid'=>$value['id'],'status'=>1,'type'=>2,'getway'=>1,'pass_time'=>$time]);
                }
                Db::name('member')->where(['id'=>$value['id']])->update(['power'=>0.003]);
            }elseif((int)$value["storagetic"]>=30000){
                $num4=mt_rand(100,150);
                $pj=$num4/10;
                $i=0;
                for($i;$i<10;$i++){
                    Db::name('member_randmoney')->insert(['num'=>$pj,'uid'=>$value['id'],'status'=>1,'type'=>2,'getway'=>1,'pass_time'=>$time]);
                }
                Db::name('member')->where(['id'=>$value['id']])->update(['power'=>0.003]);
            }
        }
    }
    /* 会员每天释放静态tic转释放tic*/
    public function releaseTic(){
        Db::name('tic_static')->where('statictic',0)->delete();
        $sql="SELECT * FROM think_tic_static";
        $arr=Db::query($sql);
        set_time_limit(0);
        $time=time();
        foreach($arr as $key=>$value){
            if($value['reless_time']<$time){
                if($value["statictic"]>=$value["releasetic"]){
                    $data['statictic']=$value["statictic"]-$value["releasetic"];
                    Db::name('tic_static')->where('id',$value['id'])->update($data);
                    $have= Db::name('tic_reless')->where('uid',$value['uid'])->find();
                    if($have){
                        Db::name('tic_reless')
                            ->where('uid',$value['uid'])
                            ->inc('releasetic',$value['releasetic'])
                            ->update();
                    }else{
                        Db::name('tic_reless')->insert(['uid'=>$value['uid'],'releasetic'=>$value["releasetic"]]);
                    }
                    $log=[
                        'uid'=>$value['uid'],
                        'num'=>$value["releasetic"],
                        'add_time'=>time()
                    ];
                }elseif($value["statictic"]<$value["releasetic"] && $value["statictic"]>0 ){
                    $data['statictic']=0;
                    Db::name('tic_static')->where('id',$value['id'])->update($data);
                    $have= Db::name('tic_reless')->where('uid',$value['uid'])->find();
                    if($have){
                        Db::name('tic_reless')
                            ->where('uid',$value['uid'])
                            ->inc('releasetic',$value["statictic"])
                            ->update();
                    }else{
                        Db::name('tic_reless')->insert(['uid'=>$value['uid'],'releasetic'=>$value["statictic"]]);
                    }
                    $log=[
                        'uid'=>$value['uid'],
                        'num'=>$value["statictic"],
                        'add_time'=>time()
                    ];
                }
                Db::name('tic_shifanglog')->insert($log);
            }


        }
        $myfile = fopen("ticTorelease.txt", "a") or die("Unable to open file!");  //w为覆盖 a为追加
        $txt = date('Y-m-d H:i:s')."静态tic转释放tic\n";
        fwrite($myfile, $txt);
        fclose($myfile);
    }
    /*以太坊币接口数据*/
    public function ethapi(){
        $url='http://data.gateio.io/api2/1/marketlist';
        $ch = curl_init();
        //设置选项，包括URL
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_HEADER, 0);

        //执行并获取HTML文档内容
        $output = curl_exec($ch);
        curl_close($ch);
        $t=json_decode($output,true);
        $mm=array();
        foreach ($t['data'] as $k => $v){
            if($v['pair']=='btc_usdt' || $v['pair']=='eth_usdt' || $v['pair']=='eos_usdt' || $v['pair']=='bch_usdt' || $v['pair']=='ltc_usdt'){
                $mm[]=$v;
            }
        }
        $mm=array_slice($mm,0,12);
        $rate=get_conf('rate');
        $usdt=(float)$rate['usdt'];
        foreach ($mm as $j => &$s){
            $s['rmb']=$s['rate']*$usdt;
        }
        return json($mm);
    }
    /*无限极下级查询*/
    public function xiajizongtic($uid){
        $son= Db::name('member')->where('parent_id',$uid)->field(['id'])->select();
        foreach($son as $key =>$value){
            $this->a[]=$value;
        }
        $this->getchild($son);
        $chd=$this->a;
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
    /*所有下级tic总数*/
    public function childtic($id){
        $arr=[];
        $s= $this->xiajizongtic($id);
        foreach($s as $value){
            foreach($value as $k=>$v){
              $arr[]=$v;
            }
        }
        $aaa=Db::name('member_tic')->where('uid','in',$arr)->sum('storagetic');
        return $aaa;
    }
    /*实时判断等级*/
    public function levelup($storagetic,$id){
        $childtic=$this->childtic($id);
        if($storagetic > 1200000){
            $a=['level'=>3];
        }elseif($storagetic <= 2000){
            $a=['level'=>0];
        }elseif($storagetic <= 1200000 && $storagetic>=2000){
            if($storagetic>2000 && $storagetic <4000 ){
                $a=['level'=>3];
            }elseif($storagetic>= 4000 && $storagetic <20000){
                //level=1
                $num=Db::name('member')->where(['parent_id'=>$id,'level'=>1])->count();
                if($num>=3){
                    if($childtic>200000){
                        $a=['level'=>2];
                    }else{
                        $a=['level'=>1];
                    }
                }else{
                    $a=['level'=>1];
                }
            }elseif($storagetic>= 20000 && $storagetic <= 200000){
                //level=2
                $num=Db::name('member')->where(['parent_id'=>$id,'level'=>2])->count();
                if($num>=3){
                    if($childtic>1200000){
                        $a=['level'=>3];
                    }else{
                        $a=['level'=>1];
                    }
                }else{
                    //level=1
                    $num2=Db::name('member')->where(['parent_id'=>$id,'level'=>1])->count();
                    if($num2 >=3){
                        if($childtic>200000){
                            $a=['level'=>2];
                        }else{
                            $a=['level'=>1];
                        }
                    }else{
                        $a=['level'=>1];
                    }

                }
            }elseif($storagetic > 200000){
                //level=2
                $num=Db::name('member')->where(['parent_id'=>$id,'level'=>2])->count();
                if($num >=3){
                    if($childtic>1200000){
                        $a=['level'=>3];
                    }else{
                        $a=['level'=>2];
                    }
                }else{
                    $a=['level'=>2];
                }
            }
        }
        Db::name('member')->where('id',$id)->update($a);
    }

    /*返利方法组合*/
//    public function sendmoney(){
//        $uid=100013;
//        $parent=$this->getAllpid($uid);
//        foreach($parent as $key=> $value){
//            $storagetic=Db::name('member_tic')->where('uid',$value)->value('storagetic');
//            $this->levelup($storagetic,$value);
//        }
//    }
//    public function fandian(){
//        //获取所有上级。
//        $uid=100014;
//        $dhnums=10000;
//        $Lastinfo = $this->daishu($uid);
//        $myselflevel=Db::name('member')->where(['id' => $uid])->value('level');//获取该用户等级
//        $myselflevel=(int)$myselflevel;
//        $all_bili=0;
//        $allgx_bili=0;
//        $allfd_bili=0;
//        foreach ($Lastinfo as $k => $v) {
//            //k==0即是直推
//            if($k==0 && $v>0){
//                //获取该pid用户等级
//                $level=Db::name('member')->where(['id' => $v])->value('level');
//                $level=(int)$level;
//                //0 粉丝 1小节点 2大节点 3超级节点
//                if($level>=3 && $myselflevel>=3){
//                    $fd_bili=26/100;
//                    $gx_bili=2/100;
//                }elseif($level==2 && $myselflevel>=2){
//                    $fd_bili=16/100;
//                    $gx_bili=2/100;
//                }elseif($level>=3){
//                    $fd_bili=26/100;
//                    $gx_bili=0;
//                }elseif($level==2){
//                    $fd_bili=16/100;
//                    $gx_bili=0;
//                }elseif($level==1){
//                    $fd_bili=7/100;
//                    $gx_bili=0;
//                }else{
//                    $fd_bili=0;
//                    $gx_bili=0;
//                }
//            }elseif($k>=1 && $v>0){
//                $ppid=$Lastinfo[$k-1];//获取当前上级id
//                $myselflevel=Db::name('member')->where(['id' => $ppid])->value('level');//当前$v下级等级
//                $level=Db::name('member')->where(['id' => $v])->value('level');//当前等级
//                if($level>=3 && $myselflevel>=3){
//                    if($all_bili<28/100){
//                        $sy=(28/100)-$all_bili;//剩余可分配
//                        if($sy<(2/100)){
//                            $fd_bili=0;
//                            $gx_bili=$sy;
//                        }else{
//                            $fd_bili=0;
//                            $gx_bili=2/100;
//                        }
//                    }else{
//                        $fd_bili=0;
//                        $gx_bili=0;
//                    }
//                }elseif($level==2 && $myselflevel>=2){
//                    if($all_bili<28/100){
//                        $sy=(28/100)-$all_bili;
//                        if($sy<(2/100)){
//                            $fd_bili=0;
//                            $gx_bili=$sy;
//                        }else{
//                            $fd_bili=0;
//                            $gx_bili=2/100;
//                        }
//                    }else{
//                        $fd_bili=0;
//                        $gx_bili=0;
//                    }
//                }elseif($level>=3){
//                    //判断贡献算力为0则按26/100计算 不为0则按28计算
//                    if($allgx_bili>0){
//                        $sy=(28/100)-$all_bili;
//                        if($sy<(28/100)){
//                            $fd_bili=$sy;
//                            $gx_bili=0;
//                        }else{
//                            $fd_bili=26/100;
//                            $gx_bili=2/100;
//                        }
//                    }else{
//                        $sy=(26/100)-$all_bili;
//                        if($sy<(26/100)){
//                            $fd_bili=$sy;
//                            $gx_bili=0;
//                        }else{
//                            $fd_bili=26/100;
//                            $gx_bili=0;
//                        }
//                    }
//                }elseif($level==2){
//                    //判断贡献算力为0则按26/100计算 不为0则按28计算
//                    if($allgx_bili>0){
//                        $sy=(28/100)-$all_bili;
//                        if($sy<(18/100)){
//                            $fd_bili=$sy;
//                            $gx_bili=0;
//                        }else{
//                            $fd_bili=16/100;
//                            $gx_bili=2/100;
//                        }
//                    }else{
//                        $sy=(26/100)-$all_bili;
//                        if($sy<(16/100)){
//                            $fd_bili=$sy;
//                            $gx_bili=0;
//                        }else{
//                            $fd_bili=16/100;
//                            $gx_bili=0;
//                        }
//                    }
//                }else{
//                    $fd_bili=0;
//                    $gx_bili=0;
//                }
//
//            }
//            //当前用户总返
//            $zfnums=$dhnums*($gx_bili+$fd_bili);
//            if($zfnums>0){
//                //存储资产数据库
//                Db::name('member_tic')->where(['uid'=>$v])->setInc('circulatetic',$zfnums);
//                if($gx_bili>0){
//                    //添加资产记录（贡献算力）
//                }
//                if($fd_bili>0){
//                    //添加资产记录（挖矿算力）
//                }
//            }
//            dump($zfnums);
//            echo "<hr>";
//            dump($v);
//            //贡献算力增加比例
//            $allgx_bili=$allgx_bili+$gx_bili;
//            $allgx_bili=(float)$allgx_bili;
//            //挖矿算力比例
//            $allfd_bili=$allfd_bili+$fd_bili;
//            $allfd_bili=(float)$allfd_bili;
//            $all_bili=$allgx_bili+$allfd_bili;
//        }
//
//    }
//    /*获取所有的PID数组*/
//    public function getAllpid($uid){
//        $i=0;
//        while ($uid>0) {
//            $Lastinfo[$i]=Db::name('member')->where(['id' => $uid])->value('parent_id');
//            if($Lastinfo[$i]==0){
//                unset($Lastinfo[$i]);
//            }
//            $uid=$Lastinfo[$i];
//            $i++;
//        }
//        return $Lastinfo;
//    }

    /*客服二维码数据数据*/
    public function kefu(){
        $kefu=Db::name('kefu')->field(['id','title','type'])->select();
        $this->data['kefu']=$kefu;
        return json($this->data);

    }
    /*客服二维码*/
    public function kefu_img(){
        $id=input('id');
        $kefu=Db::name('kefu')->where('id',$id)->value('thumb');
        $this->data['img']=$kefu;
        return json($this->data);

    }
}
