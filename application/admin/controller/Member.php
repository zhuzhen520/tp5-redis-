<?php
namespace app\admin\controller;
use think\Request;
use think\loader;
use think\Config;
use think\Cache;
use think\Log;
use think\Db;

class Member extends Base{
    protected $a=[];
    /*会员列表*/
    public function member_list(){
        $db = Db::name('member');
        $where = [];

        $input = input('param.');

        //排序
        if($input['gold_sort']){
            $order['gold_static'] = $input['gold_sort'];
        }
        if($input['id_sort']){
            $order['id'] = $input['id_sort'];
        }

        /* 日期查询 */
        $time_min = $input['start'];
        $time_max = $input['end'];

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['reg_time'] = ['between',[$time_min,$time_max]];
            }else{
                $where['reg_time'] = ['between',[$time_max,$time_min]];
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['reg_time'] = ['between',[$time_min,$time_max]];
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['reg_time'] = ['elt',$time_max];
        }

        //where
        switch ($input['member_type']) {
            case 'admin':
                $where['is_admin'] = 1;
            break;
            case 'trade':
                $where['is_trade'] = 1;
            break;
        }

        //等级
        if(is_numeric( $input['level'] )){
            $where['level'] = $input['level'];
        }

        if($input['word']){
            $where['id|username|mobile'] = $input['word'];
        }

        if($input['parent_id']){
            $where['parent_id'] = $input['parent_id'];
        }

        $list = $db->alias('a')
            ->join('member_tic b','a.id = b.uid')
            ->where($where)
            ->order($order)
            ->paginate(50,false,['query'=>request()->param()])
            ->each(function($item,$key){
                $item['rz']=Db::name('member_info')->where('uid', $item['id'])->find();
                if((int)$item['storagetic']<2000){
                    $item['power']='粉丝算力';
                    // $data['get']='0.01~0.19';
                }elseif((int)$item['storagetic']>=2000 && (int)$item['storagetic']<10000){
                    $item['power']='一级算力';
                    //$data['get']='6~30';
                }elseif((int)$item['storagetic']>=10000 && (int)$item['storagetic']<20000){
                    $item['power']='二级算力';
                    // $data['get']='30~60';
                }elseif((int)$item['storagetic']>=20000 && (int)$item['storagetic']<30000){
                    $item['power']='三级算力';
                    //$data['get']='60~90';
                }elseif((int)$item['storagetic']>=30000){
                    $item['power']='超级算力';
//                    $data['get']='100~150';
                }

                return $item;
            });
        $this->assign('list', $list);
        $this->assign('count', $db->where($where)->count());
        $this->assign('page', $list->render());
        $this->assign('role',Config::get('role'));
        return $this->fetch();
    }

    /*会员编辑*/
    public function member_add(){
        $id = input('id/s');
        $row = Db::name('member')->find($id);

        if(Request::instance()->isPost()){
            $data = input('post.');
            $data['is_trade'] = input('post.is_trade',0);
            $data['is_admin'] = input('post.is_admin',0);
            $data['is_login'] = input('post.is_login',0);

            if($data['rid_speed'] > 1){
                return json(['status'=>'n','info'=>'释放速度不能超过1']);
            }

            if($data['id'] > 0){
                //修改密码
                if( strlen($data['password']) >= 6){
                    $data['entry'] = get_rand_str();
                    $member = loader::model('Member');
                    $b = $member->save($data,['id'=>$data['id']]);
                }else{
                    unset($data['password']);
                    $b = Db::name('member')->update($data);
                }

                $data_log = [
                        'uid'         => $row['id'],
                        'username'    => $row['username'],
                        'add_time'    => time(),
                        'info'        => '管理员操作',
                        'action_type' => 100 , //管理员操作
                    ];

                //金币日志
                if($row['gold'] != $data['gold'] ){
                    $action = $data['gold'] - $row['gold'];
                    $data_log['action'] = abs($action);
                    $data_log['money_end'] = $data['gold'];
                    $data_log['type'] = $action > 0 ? 1:0;
                    Db::name('gold_log')->insert($data_log);
                }
                //积分日志
                if($row['integral'] != $data['integral'] ){
                    $action = $data['integral'] - $row['integral'];
                    $data_log['action'] = abs($action);
                    $data_log['money_end'] = $data['integral'];
                    $data_log['type'] = $action > 0 ? 1:0;
                    Db::name('integral_log')->insert($data_log);
                }

                //升级
                $apiBase = new \app\api\controller\Base;
            }else{
                //没有添加会员功能
                // $b = Db::name('member')->insert($data);
            }

            if($b !== false){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'n','info'=>'操作失败！']);
            }

        }else{
            //打开时日志 提交在base
            Log::write($row, 'admin', true);
            $role = Config::get('role');
            $this->assign($row);
            $this->assign('role',$role);
            return $this->fetch();
        }
    }

    /* 线下入金 */
    public function member_money(){
        $id = input('uid');
        if(Request::instance()->isPost()){
            $data = input('post.');
//            Db::name('member_tic')->where(['uid'=>$data['uid']])->setDec('circulatetic',100);
//            die('dd');
            $action_name = []; //操作者
            foreach(config('action_password') as $pass){
                if( md5(md5($data['password']).'token') == $pass['pass'] ){
                    $action_name = $pass;
                }
            }
            if(!$action_name){ return json(['status'=>'n','info'=>'操作密码错误']); }

            if(empty($data['action'])){
                return json(['status'=>'n','info'=>'请填写金额']);
            }
            if(empty($data['addtype'])){
                return json(['status'=>'n','info'=>'请选择操作类型']);
            }
            if(empty($data['moneytype'])){
                return json(['status'=>'n','info'=>'请选择操作币种']);
            }

            Db::startTrans();
            try{
                if($data['addtype'] == 1){
                    if($data['moneytype']==1){
                        Db::name('member')->where(['id'=>$data['uid']])->setInc('candy',$data['action']);
                        $adtpye='增加糖果';
                        $ristatus=1;
                    }elseif($data['moneytype']==2){
                        Db::name('member')->where(['id'=>$data['uid']])->setInc('mineral',$data['action']);
                        $adtpye='增加矿石';
                        $ristatus=2;
                    }elseif($data['moneytype']==3){
                        Db::name('member_tic')->where(['uid'=>$data['uid']])->setInc('circulatetic',$data['action']);
                        $adtpye='增加流通TIC';
                        $ristatus=3;
                    }
                    $mtpye='+'.$data['action'];
                }elseif($data['addtype'] == 2){
                    if($data['moneytype']==1){
                        Db::name('member')->where(['id'=>$data['uid']])->setDec('candy',$data['action']);
                        $adtpye='减少糖果';
                        $ristatus=1;
                    }elseif($data['moneytype']==2){
                        Db::name('member')->where(['id'=>$data['uid']])->setDec('mineral',$data['action']);
                        $adtpye='减少矿石';
                        $ristatus=2;
                    }elseif($data['moneytype']==3){
                        Db::name('member_tic')->where(['uid'=>$data['uid']])->setDec('circulatetic',$data['action']);
                        $adtpye='减少流通TIC';
                        $ristatus=3;
                    }
                    $mtpye='-'.$data['action'];
                }
                $data_log = [
                    'uid'         => $data['uid'],
                    'username'    =>Db::name('member')->where(['id'=>$data['uid']])->value('username'),
                    'action'      => abs($data['action']),
                    'num'          =>$mtpye,
                    'info'        => $data['info'].'['.$action_name['name'].']操作' ,
                    'type'        => $adtpye,
                    'status'      =>$data['addtype'],
                    'add_time'    => time(),
                    'ristatus'     =>$ristatus
                ];
                Db::name('money_log')->insert($data_log);
                Db::commit();
                return json(['status'=>'y','info'=>'操作成功']);
            }catch(\Exception $e) {
                // 回滚事务
                Db::rollback();
                return json(['status'=>'n','info'=>$e->getMessage()]);
            }
        }else{
            $row = Db::name('member')->alias('a')
                ->join('member_tic b','a.id=b.uid','LEFT')
                ->field(['a.id','a.candy','a.mineral','a.username','a.nickname','b.circulatetic'])
                ->where(['a.id'=>$id])->find();
            $this->assign($row);
            return $this->fetch();
        }
    }

    /* 安全中心 */
    public function member_info(){
        $uid = input('uid');
        if(Request::instance()->isPost()){
            $data = input('post.');
            // print_r($data);
            $b = Db::name('member_info')->where(['id'=>$data['id']])->update($data);
            if($b !== false){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'y','info'=>'操作失败！']);
            }
        }else{
            $member_info = Db::name('member_info')->where(['uid'=>$uid])->find();
            $member_info['member_card'] = Db::name('member_card')->where(['uid'=>$uid])->select();
            $this->assign('member_info',$member_info);
            return $this->fetch();  
        }
    }

    /* 静态金币释放 */
    public function gold_rid(){
        $db = Db::name('tic_shifanglog');
        $input = input('param.');
        $where = [];

        if($input['word']){
            $where['uid'] = $input['word'];
        }
        $time_min = input('time_min');
        $time_max = input('time_max');

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = array('between',array($time_min,$time_max+86400));
            }else{
                $where['add_time'] = array('between',array($time_max,$time_min+86400));
            }
        }elseif(!empty($time_min)){
            // $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? $time_max : time()+86400;
            /* 只填开始时间 */
            $where['add_time'] = array('between',array($time_min,$time_max+86400));
        }elseif(!empty($time_max)){
            // $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = array('elt',$time_max+86400);
        }
        $list = $db->where($where)->order('id DESC')->paginate(10,false,['query'=>request()->param()]);

        $this->assign('list', $list);
        $this->assign('count', $db->where($where)->count());
        $this->assign('page', $list->render());
        return $this->fetch();
    }
    /*批量删除明细*/
    public function sf_del(){
        $id = trim(input('id'),',');
        $ids = explode(',',$id);
        $b=Db::name('tic_shifanglog')->where('id','in',$ids)->delete();
        if($b){
            return json(['status'=>'y','info'=>'操作成功']);
        }else{
            return json(['status'=>'n','info'=>'操作失败!']);
        }
    }
    /* 积分提现 */
    public function put_integral(){
        $db = Db::name('put_integral');
        $where = [];
        $list = $db->where($where)->order('id DESC')->paginate(10);
        $this->assign('list', $list);
        $this->assign('count', $db->where($where)->count());
        $this->assign('page', $list->render());
        return $this->fetch();
    }

    /* 操作积分提现 */
    public function put_integral_add(){
        if(Request::instance()->isPost()){
            $data = input('post.');
            switch($data['status']){
                case '5':
                    $b = Db::name('put_integral')
                    ->where(['id'=>$data['id']])
                    ->update([
                        'order_sn' => $data['order_sn'],
                        'status'   => 5,
                    ]);
                break;

                case '3':   
                    $put_integral = Db::name('put_integral')->where(['id'=>$data['id'],'status'=>0])->find();
                    if(empty($put_integral)){
                        return json(['status'=>'n','info'=>'已驳回或已成功~']);
                    }

                    $member = Db::name('member')->where(['id'=>$put_integral['uid']])->find();
                    Db::startTrans();
                    try {
                        //会员到账
                        $b = Db::name('member')
                        ->where(['id'=>$put_integral['uid']])
                        ->update([
                            'put_integral' => $member['put_integral'] + $put_integral['action'],
                        ]);

                        if( !$b ){
                            throw new \Exception("会员到账失败");
                        }

                        //订单记录
                        if( !Db::name('put_integral')->where(['id'=>$put_integral['id']])->update(['status'=>3,'info'=>$data['order_sn']]) ){
                            throw new \Exception("提现订单失败");
                        }

                        //可提限日志
                        if(!Db::name('put_integral_log')->insert([
                            'uid'         => $put_integral['uid'],
                            'username'    => $put_integral['username'],
                            'action'      => $put_integral['action'],
                            'money_end'   => $member['put_integral'] + $put_integral['action'],
                            'info'        => '可提积分提现返回',
                            'order_sn'    => $put_integral['id'],
                            'type'        => 1,
                            'action_type' => 3,
                            'add_time'    => time(),
                        ])){
                            throw new \Exception("添加日志失败,请稍后再试"); 
                        }

                        // 提交
                        Db::commit();

                    }catch(\Exception $e) {
                        // 回滚事务
                        Db::rollback();
                        return json(['status'=>'n','info'=>$e->getMessage()]);
                    }
                break;
            }

            return json(['status'=>$b?'y':'n','info'=>$b?'操作成功':'操作失败!']);

        }else{
            return $this->fetch();
        }
    }

    /* 会员结构 */
    public function member_tree(){
        $member = Cache::get('member_tree')?:[];
        $list = member_tree($member);
        $this->assign('data',json_encode($list[0],true));
        return $this->fetch();
    }
    public function empty_data(){
        Cache::set('member_tree',null);
    }

    /* 复投明细 */
    public  function gold_static_gold(){
        $where = [];

        $input = input('param.');
        if($input['word']){
            $where['uid'] = $input['word'];
        }

        $list = Db::name('gold_static_gold')->order('id DESC')->where($where)->paginate(50,false,['query'=>request()->param()]);

        $this->assign('list',$list);
        $this->assign('count',Db::name('gold_static_gold')->where($where)->count());
        $this->assign('page',$list->render());
        return $this->fetch();
    }

//    public function member_gold_static(){
//        $id = input('uid');
//        $row = Db::name('member')->where(['id'=>$id])->find();
//
//        if(Request::instance()->isPost()){
//            $data = input('post.');
//            $action = input('post.action/f');
//
//            $action_name = []; //操作者
//            foreach(config('action_password') as $pass){
//                if( md5(md5($data['password']).'token') == $pass['pass'] ){
//                    $action_name = $pass;
//                }
//            }
//
//            if(!$action_name){ return json(['status'=>'n','info'=>'操作密码错误']); }
//
//            if(!is_numeric($data['Today']) || $data['Today'] <= 0){
//                return json(['status'=>'n','info'=>'今日交易价错误']);
//            }
//
//            if( $action ){
//
//                if( !Db::name('member')->where(['id'=>$id])->setInc('gold_static',$action) ){
//                    return json(['status'=>'n','info'=>'操作失败']);
//                }
//
//                //静态金币日志   当时价放订单号字段
//                $data_log = [
//                    'uid'         => $row['id'],
//                    'username'    => $row['username'],
//                    'action'      => abs($action),
//                    'money_end'   => $row['gold_static'] + $action,
//                    'info'        => '管理员操作',
//                    'order_sn'    => $data['Today'],
//                    'type'        => $action > 0 ? 1 : 0,
//                    'action_type' => 100, //后台拨币
//                    'add_time'    => time()
//                ];
//                Db::name('gold_static_log')->insert($data_log);
//
//                //升级 及均价
//                $apiBase = new \app\api\controller\Base;
//
//                return json(['status'=>'y','info'=>'操作成功']);
//            }
//        }else{
//            $this->assign($row);
//            return $this->fetch();
//        }
//    }
    /*拨币入账并计入锁死时间 并计入tic_log*/
    public function member_gold_static(){
        $id = input('uid');
        $row = Db::name('member')->alias('a')->join('member_tic b','a.id = b.uid')->where(['id'=>$id])->find();

        if(Request::instance()->isPost()){
            $data = input('post.');
            $action = input('post.action/f');

            $action_name = []; //操作者
            foreach(config('action_password') as $pass){
                if( md5(md5($data['password']).'token') == $pass['pass'] ){
                    $action_name = $pass;
                }
            }

            if(!$action_name){ return json(['status'=>'n','info'=>'操作密码错误']); }

            if(!is_numeric($data['Today']) || $data['Today'] <= 0){
                return json(['status'=>'n','info'=>'今日交易价错误']);
            }

            if( $action){
                if( !Db::name('member_tic')->where(['uid'=>$id])->setInc('storagetic',$action) ){
                    return json(['status'=>'n','info'=>'操作失败']);
                }
                //静态TIC 用于计算锁死释放
                $t=Db::name('config')->where(['name'=>'static_gold_rid'])->value('value');
                $data_tic = [
                    'uid'         => $row['id'],
                    'username'    => $row['username'],
                    'action'      => abs($action),
                    'statictic'   => abs($action),//锁死值
                    'info'        => '管理员操作',
                    'releasetic'  => abs($action)*0.1,
                    'reless_time'  => strtotime(date('Y-m-d',strtotime("+$t day"))),//开始释放的时间
                    'type'        => 1,
                    'add_time'    => time()
                ];
                Db::name('tic_static')->insert($data_tic);
                //静态TIC日志   当时价放订单号字段
                $data_log = [
                    'uid'         => $row['id'],
                    'username'    => $row['username'],
                    'action'      => abs($action),
                    'info'        => '管理员操作后台拨币',
                    'ticb'    => $data['Today'],
                    'type'        => 1,
                    'add_time'    => time(),
                    'ristatus'      =>1
                ];
                Db::name('tic_staticlog')->insert($data_log);

                //升级 及均价
               // $apiBase = new \app\api\controller\Base;
                $this->levelup(Db::name('member_tic')->where(['uid'=>$id])->value('storagetic'),$id);
                $this->sendmoney($id,$action);
                return json(['status'=>'y','info'=>'操作成功']);
            }
        }else{
            $rate= get_config('rate','mineral');
            $this->assign('rate',$rate);
            $this->assign($row);
            return $this->fetch();
        }
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
    /*糖果收益明细，矿石收益明细*/
    public function member_kcsource(){
        $db=Db::name('member_randmoney');
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
//            $time_max = strtotime($time_max);
//            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = array('between',array($time_min,$time_max));
            }else{
                $where['add_time'] = array('between',array($time_max,$time_min));
            }
        }elseif(!empty($time_min)){
           // $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? $time_max : date("Y-m-d",strtotime("+30 day"));
            /* 只填开始时间 */
            $where['add_time'] = array('between',array($time_min,$time_max));
        }elseif(!empty($time_max)){
           // $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = array('elt',$time_max);
        }
        // var_dump($where);
        $where['status']=2;
        $count = $db->where($where)->count();
        /* 分页 */
        $list = $db->where($where)->order('id desc')
            ->paginate(10,false,['query'=>request()->param()])
            ->each(function($item, $key){
                $id = $item["uid"]; //获取数据集中的id
                $item['buyer'] = Db::name('member')->where('id',$id)->field(['wallet_address','mobile'])->find(); //根据ID查询相关其他信息
                $tic=Db::name('member_tic')->where('uid',$id)->value('storagetic');
                if((int)$tic<2000){
                    $item['level']='粉丝算力';
                   // $data['get']='0.01~0.19';
                }elseif((int)$tic>=2000 && (int)$tic<10000){
                    $item['level']='一级算力';
                    //$data['get']='6~30';
                }elseif((int)$tic>=10000 && (int)$tic<20000){
                    $item['level']='二级算力';
                   // $data['get']='30~60';
                }elseif((int)$tic>=20000 && (int)$tic<30000){
                    $item['level']='三级算力';
                    //$data['get']='60~90';
                }elseif((int)$tic>=30000){
                    $item['level']='超级算力';
//                    $data['get']='100~150';
                }

                return $item;
            });
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        $this->assign('count',$count);
        return $this->fetch();

    }
    /*批量删除明细*/
    public function ks_del(){
        $id = trim(input('id'),',');
        $ids = explode(',',$id);
        $b=Db::name('member_randmoney')->where('id','in',$ids)->delete();
        if($b){
            return json(['status'=>'y','info'=>'操作成功']);
        }else{
            return json(['status'=>'n','info'=>'操作失败!']);
        }
    }

    public function member_class(){
    	$pid = input('word');
    	if($pid == null){
    		$pid=0;
    	}
    	$tree=$this->getTree($pid);
        $this->assign('tree',$tree);
        return $this->fetch();
    }

    public  function getTree($pid='0')
    {
        $t=Db::name('member');
        $wherea=array("parent_id"=>$pid,);
        $list=$t->where($wherea)->order('id asc')->select();
        if(is_array($list)){
            $html = '';
                $i++;
                foreach($list as $k => $v)
                {
                    $map['parent_id']=$v['id'];
                    $count=$t->where($map)->count(1);
                    $class=$count==0 ? 'fa-user':'fa-sitemap';
                   if($v['parent_id'] == $pid)
                   {   
                        //父亲找到儿子
                        $html .= '<li style="display:none" >';
                        $html .= '<span><i class="icon-plus-sign '.$class.' blue "></i>';
                        $html .= 'ID:'.$v['id'].'('.$v['username'].')';
                        $html .= '</span>';
                        $html .= $this->getTree($v['id']);
                        $html = $html."</li>";
                   }
                }
            return $html ? '<ul>'.$html.'</ul>' : $html ;
        }
    }
    /*后台增扣会员糖果 矿石 流通TIC*/
    public function member_zjmoney(){
       $db = Db::name('money_log');
       $where = [];
       $input = input('param.');
       $word = trim(input('word'));
        if(!empty($word)){
            $where['uid|username'] = ['like',"%$word%"];
        }
        $ristatus = trim(input('ristatus'));
        if(!empty($ristatus)){
            $where['ristatus'] = $ristatus;
        }
        /* 日期查询 */
        $time_min = $input['time_min'];
        $time_max = $input['time_max'];

       if(!empty($time_max) && !empty($time_min)){
           $time_max = strtotime($time_max);
           $time_min = strtotime($time_min);
           /* 两个都填 between 范围内 */
           if($time_max >= $time_min){
               $where['add_time'] = ['between',[$time_min,$time_max+86400]];
           }else{
               $where['add_time'] = ['between',[$time_max,$time_min+86400]];
           }
       }elseif(!empty($time_min)){
           $time_min = strtotime($time_min);
           $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
           /* 只填开始时间 */
           $where['add_time'] = ['between',[$time_min,$time_max]];
       }elseif(!empty($time_max)){
           $time_max = strtotime($time_max);
           /* 只填结束时间 elt小于等于 */
           $where['add_time'] = ['elt',$time_max+86400];
       }


       $list = $db->where($where)->order('id desc')->paginate(20,false,['query'=>request()->param()]);
       $this->assign('list', $list);
       $this->assign('count', $db->where($where)->count());
       $this->assign('page', $list->render());
       $this->assign('role',Config::get('role'));
       return $this->fetch();
    }
    /*节点算力明细记录*/
    public function member_jiedian(){
        $db = Db::name('member_fandian');
        $where = [];
        $type = trim(input('type'));
        if(!empty($type)){
            $where['type'] = $type;
        }
        $input = input('param.');
        $word = trim(input('word'));
        if(!empty($word)){
            $where['uid|cid'] = ['like',"%$word%"];
        }

        /* 日期查询 */
        $time_min = $input['time_min'];
        $time_max = $input['time_max'];

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['create_time'] = ['between',[$time_min,$time_max+86400]];
            }else{
                $where['create_time'] = ['between',[$time_max,$time_min+86400]];
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = ['between',[$time_min,$time_max]];
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['create_time'] = ['elt',$time_max+86400];
        }


        $list = $db->where($where)->order('id desc')
            ->paginate(20,false,['query'=>request()->param()])
            ->each(function($item,$key){
                $id=$item['uid'];
                $level=Db::name('member')->where('id',$id)->value('level');
                if($level==0){
                    $item['level']='粉丝';
                    // $data['get']='0.01~0.19';
                }elseif($level==1){
                    $item['level']='小节点';
                    //$data['get']='6~30';
                }elseif($level==2){
                    $item['level']='大节点';
                    // $data['get']='30~60';
                }elseif($level==3){
                    $item['level']='超级节点';
                    //$data['get']='60~90';
                }
                return $item;
            });
        $this->assign('list', $list);
        $this->assign('count', $db->where($where)->count());
        $this->assign('page', $list->render());
        $this->assign('role',Config::get('role'));
        return $this->fetch();
    }
}