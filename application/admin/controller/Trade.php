<?php
namespace app\admin\controller;
use think\Db;
use think\Request;

/**
* 交易中心管理
*/
class Trade extends Base
{
    protected $a=[];
    /*交易列表*/
    public function trade_list(){
        $db = Db::name('eth_log');
        $input = input('param.');

        $where = [];

        $word = trim(input('word'));
        if(!empty($word)){
            $where['uid'] = ['like',"%$word%"];
        }
        if($input['status']){
            $where['status'] = $input['status'];
        }

        /* 日期查询 */
        $time_min = $input['time_min'];
        $time_max = $input['time_max'];

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['time'] = ['between',[$time_min,$time_max+86400]];
            }else{
                $where['time'] = ['between',[$time_max,$time_min+86400]];
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['time'] = ['between',[$time_min,$time_max+86400]];
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['time'] = ['elt',$time_max+86400];
        }

        $list = $db->where($where)->order('time desc')->paginate(10,flase,['query'=>request()->param()]);
        $count = $db->where($where)->count();
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        $this->assign('count',$count);
        return $this->fetch();
    }

    /*商城订单*/
    public function shop_order(){
        $db = Db::name('order_info');
        /* where 条件初始化 */
        $where = [];
        /* 状态查询 */
        $state = input('state');
        if($state > 0){
            switch ($state) {
                case 1:$where['state'] = 2;break;
                case 2:$where['pay_state'] = 1;break;
                case 3:$where['shipping_state'] = 1;break;
                case 4:$where['shipping_state'] = 3;break;
                case 5:$where['shipping_state'] = 2;break;
                case 6:$where['pay_state'] = 0;break;
                case 7:$where['pay_state'] = 1;$where['shipping_state']=0;break;
            }
        }
        /* 关键词查询 */
        $word = trim(input('word'));
        if(!empty($word)){
            $where['user_id|username|order_sn'] = ['like',"%$word%"];
        }
        /* 日期查询 */
        $time_min = input('time_min');
        $time_max = input('time_max');
        
        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = array('between',array($time_min,$time_max));
            }else{
                $where['add_time'] = array('between',array($time_max,$time_min));
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = array('between',array($time_min,$time_max));
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = array('elt',$time_max);
        }
        // var_dump($where);

        $count = $db->where($where)->count();
        /* 分页 */
        $list = $db->where($where)->order('add_time desc')->paginate(10,false,['query'=>request()->param()]);

        $this->assign('total',$db->sum('total'));
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        $this->assign('count',$count);
        return $this->fetch();
    }

    /*价格走势*/
    public function price_trend(){
        $db = Db::name('OrderTrend');

        $count = $db->where($where)->count();
        $list = $db->where($where)->order('dates DESC')->paginate(10);

        $this->assign('count',$count);
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        return $this->fetch();
    }

    //走势图
    public function chart(){
        $list = Db::name('OrderTrend')->select();
        $dates = '';
        $prices = '';
        foreach($list as $v){
            $dates .= "'".$v['dates']."',";
            $prices .= $v['price'].',';
        }
        $this->assign('dates',trim($dates,','));
        $this->assign('prices',trim($prices,','));
        return $this->fetch();
    }

    public function add_order_trend(){
        $db = Db::name('OrderTrend');
        if(Request::instance()->isPost()){
            $data = input('post.');
            //日期转时间
            $data['date_time'] = strtotime($data['dates']);

            if($data['id'] > 0){
                $b = $db->update($data);
                Db::name('config')->where(['name'=>'mineral','type'=>'rate'])->update(['value'=>$data['price']]);
            }else{
                $data['add_time'] = time();
                $b = $db->insert($data);
                Db::name('config')->where(['name'=>'mineral','type'=>'rate'])->update(['value'=>$data['price']]);
            }
            #结果
            if($b !== flase){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                 return json(['status'=>'n','info'=>'操作失败!']);
            }
        }else{
            $id = input('id',0);
            $row = $db->find($id);
            $this->assign('row',$row);
            return $this->fetch();
        }
    }

    public function order_show(){
        $id = input('id');
        $row = Db::name('order_info')->find($id);
        $row['order_goods'] =  Db::name('order_goods')->where(array('order_id'=>$id))->select();

        $this->assign('row',$row);
        return $this->fetch();
    }

    /*订单状态改变*/
    public function order_oper(){
        $order_id = input('order_id');
        $oper = input('oper');
        $db = Db::name('order_info');
        //查询订单的全部状态
        $row = $db->field('state,pay_state,shipping_state')->find($order_id);
        switch($oper){
                /* 确认订单 */
            case 'confirm': 
                if($row['state'] == 1){
                    return json(['status'=>'n','info'=>'该订单已经确认过了']);
                }
                if($row['state'] == 2){
                    return json(['status'=>'n','info'=>'该订单已经取消']);
                }
                $b = $db->where(array('order_id'=>$order_id))->setField('state',1);
            break;
                /* 取消订单 */
            case 'cancel':
                #'0提交1确认2取消',
                if($row['state'] == 2){
                    return json(['status'=>'n','info'=>'该订单已经取消']);
                }
                #物流状态 '0未发货1已发货2已收货3已退货',
                if($row['shipping_state'] > 0){
                    return json(['status'=>'n','info'=>'该订单已经发货,不能取消']);
                }
                $data = ['state'=>2,'cancel_time'=>time()];
                $b = $db->where(['order_id'=>$order_id])->update($data);
            break;
                /* 发货 */
            case 'send':
                #'0未付款1已付款',
                if($row['state'] == 2){
                    return json(['status'=>'n','info'=>'该订单已经取消']);
                }
                if($row['pay_state'] == 0){
                    return json(['status'=>'n','info'=>'该订单未付款']);
                }
                if($row['shipping_state'] > 0){
                    return json(['status'=>'n','info'=>'该订单已经发货']);
                }
                $data = ['state'=>1,'shipping_state'=>1,'send_time'=>time()];
                $b = $db->where(['order_id'=>$order_id])->update($data);
                break;
            case 'refunds': 
                if($row['shipping_state'] == 0){
                    return json(['status'=>'n','info'=>'该订单未发货']);
                }
                if($row['shipping_state'] == 3){
                    return json(['status'=>'n','info'=>'该订单已经退货']);
                }
                $data = array('state'=>1,'shipping_state'=>3,'enfunds_time'=>time());
                $b = $db->where(['order_id'=>$order_id])->update($data);
            break;
        }
        // dump($b);
        if($b){
            return json(['status'=>'y','info'=>'操作成功']);
        }else{
            return json(['status'=>'n','info'=>'操作失败!']);
        }
    }
    public function tic_order(){
        $db=Db::name('tic_staticlog');
        $ristatus = trim(input('ristatus'));
        if(!empty($ristatus)){
            $where['ristatus'] = $ristatus;
        }
        $word = trim(input('word'));
        if(!empty($word)){
            $where['uid|sid'] = ['like',"%$word%"];
        }
        /* 日期查询 */
        $time_min = input('time_min');
        $time_max = input('time_max');

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = array('between',array($time_min,$time_max));
            }else{
                $where['add_time'] = array('between',array($time_max,$time_min));
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = array('between',array($time_min,$time_max));
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = array('elt',$time_max);
        }
        // var_dump($where);

        $count = $db->where($where)->count();
        /* 分页 */
        $list = $db->where($where)->order('id desc')
            ->paginate(10,false,['query'=>request()->param()])
            ->each(function($item, $key){
            $id = $item["uid"]; //获取数据集中的id
            $item['buyer'] = Db::name('member')->where('id',$id)->field(['wallet_address','mobile'])->find(); //根据ID查询相关其他信息
            return $item;
        });
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        $this->assign('count',$count);
        return $this->fetch();
    }
    public function ticlog_del(){
        $id = trim(input('id'),',');
        $ids = explode(',',$id);
        $b=Db::name('tic_staticlog')->where('id','in',$ids)->delete();
        if($b){
            return json(['status'=>'y','info'=>'操作成功']);
        }else{
            return json(['status'=>'n','info'=>'操作失败!']);
        }
    }
    public function tic_duichong(){
        $db=Db::name('tic_bobi');
        $type = trim(input('type'));
        if(!empty($type)){
            $where['type'] = $type;
        }
        $word = trim(input('word'));
        if(!empty($word)){
            $where['uid'] = ['like',"%$word%"];
        }
        /* 日期查询 */
        $time_min = input('time_min');
        $time_max = input('time_max');

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = array('between',array($time_min,$time_max));
            }else{
                $where['add_time'] = array('between',array($time_max,$time_min));
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = array('between',array($time_min,$time_max));
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = array('elt',$time_max);
        }
        // var_dump($where);

        $count = $db->where($where)->count();
        /* 分页 */
        $list = $db->where($where)->order('id desc')
            ->paginate(10,false,['query'=>request()->param()])->each(function($item,$key){
                $item['getid']=Db::name('member')->where('wallet_address',$item['wallet_address'])->value('id');
                return $item;
            });
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        $this->assign('count',$count);
        return $this->fetch();
    }
    /*eth etc 交易列表通过*/
    public function ethetc_yes(){
    if(Request::instance()->isPost()) {
        $id = input('id');
        if (Db::name('eth_log')->where('id',$id)->update(['status'=>1])) {
            return json(['status' => 'y', 'info' => '操作成功']);
        }else{
            return json(['status' => 'n', 'info' => '操作失败']);
        }
        }
    }
    /*eth etc 交易列表拒绝*/
    public function ethetc_no(){
        if(Request::instance()->isPost()) {
            $id = input('id');
            if (Db::name('eth_log')->where('id',$id)->update(['status'=>2])) {
                return json(['status' => 'y', 'info' => '操作成功']);
            }else{
                return json(['status' => 'n', 'info' => '操作失败']);
            }
        }
    }
    public function ethetc_del(){
        $id = trim(input('id'),',');
        $ids = explode(',',$id);
        $b=Db::name('eth_log')->where('id','in',$ids)->delete();
        if($b){
            return json(['status'=>'y','info'=>'操作成功']);
        }else{
            return json(['status'=>'n','info'=>'操作失败!']);
        }
    }
    /*兑冲后台拨币*/
    public function duichong_pass(){
        if(Request::instance()->isPost()) {
            $data = input('post.');
            foreach (config('action_password') as $pass) {
                if (md5(md5($data['password']) . 'token') == $pass['pass']) {
                    $action_name = $pass;
                }
            }
            if (!$action_name) {
                return json(['status' => 'n', 'info' => '操作密码错误']);
            }
            $bobi = Db::name('tic_bobi')->where(['id'=>$data['id']])->find();
            if($bobi){
                Db::startTrans();// 启动事务
                try{
                    //修改记录状态
                    Db::name('tic_bobi')->where('id',$bobi['id'])->update(['type'=>1,'pass_time'=>time()]);
                    //根据钱包找到收款人
                    $getu=Db::name('member')->where(['wallet_address'=>$data['wallet_address']])->find();
                    //将币存入收款人静态存储账户
                    Db::name('member_tic')->where('uid',$getu['id'])->setInc('storagetic',$bobi["totaltic"]);
                    $t=Db::name('config')->where(['name'=>'static_gold_rid'])->value('value');
                    $data_tic = [
                        'uid'         => $getu['id'],
                        'username'    => $getu['username'],
                        'sid'          =>$bobi['uid'],
                        'action'      => abs($bobi['totaltic']),
                        'statictic'   => abs($bobi['totaltic']),//锁死值
                        'info'        => '后台兑冲拨币,交易ID:'. $bobi['id'],
                        'releasetic'  => abs($bobi['totaltic'])*0.1,
                        'reless_time'  => strtotime(date('Y-m-d',strtotime("+$t day"))),//开始释放的时间
                        'type'        => 2,
                        'add_time'    => time()
                    ];
                    // 锁仓期记录
                    Db::name('tic_static')->insert($data_tic);
                    //静态TIC日志   当时价放订单号字段
                    $data_log = [
                        'uid'         => $getu['id'],
                        'username'    => $getu['username'],
                        'action'      => abs($bobi['totaltic']),
                        'info'        => '后台兑冲拨币,交易ID:'. $bobi['id'],
                        'ticb'    =>  get_config('rate','mineral'),
                        'type'        => 1,
                        'add_time'    => time()
                    ];
                    //后台兑冲拨币记录
                    Db::name('tic_staticlog')->insert($data_log);
                    $this->levelup(Db::name('member_tic')->where(['uid'=>$getu['id']])->value('storagetic'),$getu['id']);
                    $this->sendmoney($getu['id'],$bobi['totaltic']);
                    // 更新成功 提交事务
                    Db::commit();
                    return json(['status'=>'y','info'=>'拨币成功']);
                } catch (\Exception $e) {
                    // 更新失败 回滚事务
                    echo $e->getMessage();
                    die;
                    Db::rollback();
                    return json(['status'=>'n','info'=>'拨币失败']);
                }
            }else{
                return json(['status' => 'n', 'info' => '不存在该订单']);
            }
        }else{
            $id = input('id');
            $row = Db::name('tic_bobi')->where(['id'=>$id])->find();
            $this->assign($row);
            return $this->fetch();
        }
    }
    /*实时判断等级*/
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
    public function levelup($storagetic,$id){
        $childtic=$this->childtic($id);
        if($storagetic > 1200000){
            $a=['level'=>3];
        }elseif($storagetic <= 2000){
            $a=['level'=>0];
        }elseif($storagetic <= 1200000 && $storagetic>=2000){
            if($storagetic>2000 && $storagetic <4000 ){
                $a=['level'=>1];
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
    public function duichong_no(){
        $id = input('id');
        $peng=Db::name('tic_bobi')->where(['id'=>$id])->find();
        Db::startTrans();// 启动事务
        try{
            Db::name('tic_bobi')->where(['id'=>$id])->update(['type'=>2]);
            Db::name('member_tic')->where('uid',$peng['uid'])->setInc('circulatetic',$peng["persontic"]);
            Db::commit();
            return json(['status' => 'y', 'info' => '拒绝成功']);
        } catch (\Exception $e) {
            // 更新失败 回滚事务
            echo $e->getMessage();
            Db::rollback();
            return json(['status'=>'n','info'=>'拒绝失败']);
        }
        return json(['status' => 'y', 'info' => '拒绝成功']);
    }
    /*返利方法组合*/
    public function sendmoney($uid,$dhnums){
        set_time_limit(0);
        $this->fandian($uid,$dhnums);
    }
    public function fandian($uid,$dhnums){
        //获取所有上级。
        $Lastinfo = $this->getAllpid($uid);
        $use_grade=Db::name('member')->where('id',$uid)->value('level');//获取该用户等级
        $use_grade=(int)$use_grade;
        $all_bili=0;
        $allgx_bili=0;
        $allfd_bili=0;
        $two_count=0;
        $two_counts=0;
        foreach ($Lastinfo as $k => $v) {
            //k==0即是直推
            if($k==0 && $v>0){
                //获取该pid用户等级
                $vip_grade=Db::name('member')->where('id',$v)->value('level');
                $vip_grade=(int)$vip_grade;
                //0 粉丝 1小节点 2大节点 3超级节点
                if($vip_grade>=3 && $use_grade>=3){
                    $fd_bili=26/100;
                    $gx_bili=2/100;
                }elseif($vip_grade==2 && $use_grade>=2){
                    $fd_bili=16/100;
                    $gx_bili=2/100;
                }elseif($vip_grade>=3){
                    $fd_bili=26/100;
                    $gx_bili=0;
                }elseif($vip_grade==2){
                    $fd_bili=16/100;
                    $gx_bili=0;
                }elseif($vip_grade==1){
                    $fd_bili=7/100;
                    $gx_bili=0;
                }else{
                    $fd_bili=0;
                    $gx_bili=0;
                }
            }elseif($k>=1 && $v>0){
                $ppid=$Lastinfo[$k-1];//获取当前下级id
                $use_grade=Db::name('member')->where('id',$ppid)->value('level');//当前$v下级等级
                $vip_grade=Db::name('member')->where('id',$v)->value('level');//当前等级
                if($vip_grade>=3 && $use_grade>=3){
                    if($all_bili<28/100){
                        $sy=(28/100)-$all_bili;
                        if($sy<(2/100)){
                            $fd_bili=0;
                            $gx_bili=$sy;
                        }else{
                            $fd_bili=0;
                            $gx_bili=2/100;
                        }
                    }else{
                        $fd_bili=0;
                        $gx_bili=0;
                    }
                }elseif($vip_grade==2 && $use_grade>=2){
                    foreach ($Lastinfo as $m => &$n){
                        if($m<$k){
                            $two_count[]=Db::name('member')->where(['id'=>$n,'level'=>2])->value('id');
                            $three_count[]=Db::name('member')->where(['id'=>$n,'level'=>3])->value('id');
                        }
                    }
                    $two_count=array_filter($two_count);
                    $two_counts=count($two_count);
                    $three_count=array_filter($three_count);
                    $three_counts=count($three_count);
                    if($three_counts>0){
                        $fd_bili=0;
                        $gx_bili=0;
                    }elseif($all_bili<28/100 && $two_counts<2){
                        $sy=(28/100)-$all_bili;
                        if($sy<(2/100)){
                            $fd_bili=0;
                            $gx_bili=$sy;
                        }else{
                            $fd_bili=0;
                            $gx_bili=2/100;
                        }
                    }else{
                        $fd_bili=0;
                        $gx_bili=0;
                    }
                }elseif($vip_grade>=3){
                    //判断贡献算力为0则按26/100计算 不为0则按28计算
                    if($allgx_bili>0){
                        $sy=(28/100)-$all_bili;
                        if($sy<(28/100)){
                            $fd_bili=$sy;
                            $gx_bili=0;
                        }else{
                            $fd_bili=28/100;
                            $gx_bili=0;
                        }
                    }else{
                        $sy=(26/100)-$all_bili;
                        if($sy<(26/100)){
                            $fd_bili=$sy;
                            $gx_bili=0;
                        }else{
                            $fd_bili=26/100;
                            $gx_bili=0;
                        }
                    }
                }elseif($vip_grade==2){
                    //判断贡献算力为0则按26/100计算 不为0则按28计算
                    //判断上面大节点数量
                    foreach ($Lastinfo as $m => &$n){
                        if($m<$k){
                            $two_count[]=Db::name('member')->where(['id' => $n,'level'=>2])->value('id');
                        }
                    }
                    $two_count=array_filter($two_count);
                    $two_counts=count($two_count);
                    if($two_counts>=1 &&$use_grade<=1){
                        $fd_bili=0;
                        $gx_bili=0;
                    }elseif($allgx_bili>0 && $two_counts<2){
                        $sy=(28/100)-$all_bili;
                        if($sy<(18/100)){
                            $fd_bili=$sy;
                            $gx_bili=0;
                        }else{
                            $fd_bili=16/100;
                            $gx_bili=0;
                        }
                    }elseif($allgx_bili<=0 && $two_counts<2){
                        $sy=(26/100)-$all_bili;
                        if($all_bili==7/100){
                            $fd_bili=16/100-7/100;
                            $gx_bili=0;
                        }elseif($sy<(16/100)){
                            $fd_bili=$sy;
                            $gx_bili=0;
                        }else{
                            $fd_bili=16/100;
                            $gx_bili=0;
                        }
                    }else{
                        $fd_bili=0;
                        $gx_bili=0;
                    }
                }else{
                    $fd_bili=0;
                    $gx_bili=0;
                }
                unset($two_count);
                unset($two_counts);
            }
            //当前用户总返
            $zfnums=$dhnums*($gx_bili+$fd_bili);
            if($zfnums>0){
                //存储资产数据库
                Db::name('member_tic')->where(['uid'=>$v])->setInc('circulatetic',$zfnums);
                if($gx_bili>0){
                    if($k==0){
                        Db::name('member_fandian')->insert(['uid'=>$v,'cid'=>$uid,'type'=>2,'num'=>$gx_bili*$dhnums,'add_time'=>time(),'sid'=>$uid]);
                    }else{
                        Db::name('member_fandian')->insert(['uid'=>$v,'cid'=>$Lastinfo[$k-1],'type'=>2,'num'=>$gx_bili*$dhnums,'add_time'=>time(),'sid'=>$uid]);
                    }
                    //添加资产记录（贡献算力）
                }
                if($fd_bili>0){
                    if($k==0){
                        Db::name('member_fandian')->insert(['uid'=>$v,'cid'=>$uid,'type'=>1,'num'=>$fd_bili*$dhnums,'add_time'=>time(),'sid'=>$uid]);
                    }else{
                        Db::name('member_fandian')->insert(['uid'=>$v,'cid'=>$Lastinfo[$k-1],'type'=>1,'num'=>$fd_bili*$dhnums,'add_time'=>time(),'sid'=>$uid]);
                    }
                    //添加资产记录（挖矿算力）
                }
            }
            //贡献算力增加比例
            $allgx_bili=$allgx_bili+$gx_bili;
            $allgx_bili=(float)$allgx_bili;
            //挖矿算力比例
            $allfd_bili=$allfd_bili+$fd_bili;
            $allfd_bili=(float)$allfd_bili;
            $all_bili=$allgx_bili+$allfd_bili;
        }
    }
    /*获取所有的PID数组*/
    public function getAllpid($uid){
        $i=0;
        while ($uid>0) {
            $Lastinfo[$i]=Db::name('member')->where(['id' => $uid])->value('parent_id');
            if($Lastinfo[$i]==0){
                unset($Lastinfo[$i]);
            }
            $uid=$Lastinfo[$i];
            $i++;
        }
        return $Lastinfo;
    }
    /*资产包交易列表*/
    public function product_order(){
        $db=Db::name('product_order');
        $input = input('param.');

        $where = [];
        /* 关键词查询 */
        $word = trim(input('word'));
        if(!empty($word)){
            $where['uid|username'] = ['like',"%$word%"];
        }

        /* 日期查询 */
        $time_min = $input['time_min'];
        $time_max = $input['time_max'];

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = ['between',[$time_min,$time_max]];
            }else{
                $where['add_time'] = ['between',[$time_max,$time_min]];
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = ['between',[$time_min,$time_max]];
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = ['elt',$time_max];
        }

        $list = $db->where($where)
            ->order('add_time desc')
            ->paginate(20,false,['query'=>request()->param()])
            ->each(function($item,$key){
                $item['product']=Db::name('product')->where(['id'=>$item['product_id']])->find();
                return $item;
            });
        $count = $db->where($where)->count();
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        $this->assign('count',$count);
        return $this->fetch();

    }
    /*资产包交易手续费列表*/
    public function handmoney(){

        $db=Db::name('adminmoney_log');

        $word = trim(input('word'));
        if(!empty($word)){
            $where['uid|username'] = ['like',"%$word%"];
        }
        /* 日期查询 */
        $time_min = input('time_min');
        $time_max = input('time_max');

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['create_time'] = ['between',[$time_min,$time_max]];
            }else{
                $where['create_time'] = ['between',[$time_max,$time_min]];
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['create_time'] = ['between',[$time_min,$time_max]];
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['create_time'] = ['elt',$time_max];
        }
        $list = $db->where($where)
            ->order('create_time desc')
            ->paginate(10,false,['query'=>request()->param()])
            ->each(function($item,$key){
                $item['product']=Db::name('product')->where(['id'=>$item['product_id']])->find();
                return $item;
            });
        $count = $db->where($where)->count();
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        $this->assign('count',$count);
        return $this->fetch();

    }

}