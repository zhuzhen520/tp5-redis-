<?php
namespace app\api\controller;
use think\Created; //pay
use think\Notify; //pay
use think\loader;
use think\Log;
use think\Db;

/**
* 商城
*/
class Shop extends Base
{

    /*商城首页*/
    public function index(){

        //商品分类
        $shop_category = Db::name('ProductCategory')->order('sort')->field('cat_id,cat_name,parent_id,thumb')->where(array('is_show'=>1))->select();
        $this->data['shop_category'] = $shop_category;

        //商品列表
        $where = [];
        if($this->POST['cat_id']){
            $where['cat_id'] = $this->POST['cat_id']; 
        }
        $where['is_delete'] = 0;

        $goods_model = new \app\api\model\Product;
        $shop_goods = $goods_model->where($where)->paginate(5);
        $this->data['goods'] = $shop_goods;

        //返回
        return json($this->data);

    }

    /* 产品详情 */
    public function product_details(){
        $this->data['product'] = Db::name('product')->find($this->POST['pro_id']);
        return json($this->data);
    }

    /*购物车
        最新的产品数据
    */
    public function shop_cart(){
        $pro_db = Db::name('Product'); //产品对象
        $list = Db::name('Cart')->where(['user_id'=>$this->member['uid']])->order('id')->select();

        foreach($list as &$v){
            $product = $pro_db->field('name as pro_name,thumb as pro_thumb,shop_price as price,market_price')->where(['id'=>$v['pro_id']])->find();
            $v = array_merge($v,$product); //合并
        }

        $cart = loader::model('Cart');
        $cart->saveAll($list);

        $this->data['cart'] = $list; //更新后的数据完美
        return json($this->data);
    }   

    /* 加入购物车 */
    public function shop_cart_add(){
        $product = Db::name('product')->where(['id'=>$this->POST['pro_id']])->find();

        if($product['stock'] <= 0){
            return json(['status'=>'n','info'=>$product['name'].'库存已不足']);
        }

        if(empty($product) || $product['is_delete'] ==1 || $product['is_sale'] == 0){
            return json(['status'=>'n','info'=>'产品已删除，或已下架']);
        }

        $data = [
            'user_id'      => $this->member['uid'],
            'pro_id'       => $product['id'],
            'pro_name'     => $product['name'],
            'pro_thumb'    => $product['thumb'],
            'pro_attr'     => '',
            'attr_id'      => '',
            'attr_price'   => '',
            'buy_number'   => $this->POST['buy_number'],
            'price'        => $product['shop_price'],
            'market_price' => $product['market_price'],
            'subtotal'     => ($product['shop_price'] * $this->POST['buy_number']), //总价
        ];

        //购物车商品存在
        $Cart = Db::name('Cart')->where(['user_id'=>$this->member['uid'],'pro_id'=>$this->POST['pro_id']])->find();
        if($Cart){
            $buy_number = $this->POST['buy_number']?:1;
            $data['buy_number'] = $Cart['buy_number'] + $buy_number;
            $data['subtotal']   = ($product['shop_price'] * ($Cart['buy_number']+$buy_number));

            if($data['buy_number'] <= 0 ){
                return json(['status'=>'n','info'=>'必须购买一个商品']);
            }
        }

        //验证数据
        $validate = loader::validate('Cart');
        if(!$validate->check($data)){            
            return json(['status'=>'n','info'=>$validate->getError()]);
        }

        //完成提交数据
        $cart_model = new \app\api\model\Cart;
        if($Cart['id'] > 0){
            $result = $cart_model->save($data,['id'=>$Cart['id']]);
        }else{
            $result = $cart_model->save($data);
        }

        if($result){
            return json(['status'=>'y','info'=>'成功添加到购物车']);
        }else{
            return json(['status'=>'n','info'=>'添加失败']);
        }

    }

    /*支付 付款*/
    public function puy_product(){
        //收货地址
        if((int)$this->POST['address_id'] > 0){
            $address = Db::name('MemberAddress')->where([
                'id'      => (int)$this->POST['address_id'],
                'user_id' => $this->member['uid'],
            ])->field('id,is_default',true)->find() ? : [];
        }else{
            $address = Db::name('MemberAddress')->where(['user_id'=>$this->member['uid'],'is_default'=>1])->field('id,is_default',true)->find() ? : [];
        }

        if(empty($address)){
            return json(['status'=>'n','info'=>'必须选择一个地址~']);
        }

        //获取会员身份证
        $member_info = Db::name('member_info')->where(['uid'=>$this->member['uid']])->find();
            if(empty($member_info)){
            return json(['status'=>'n','info'=>'请完善个人信息']);
        }
        //银行卡信息,选择了银行卡
        if($this->POST['card_id'] > 0){
            $member_card = Db::name('member_card')->where(['id'=>$this->POST['card_id'],'uid'=>$this->member['uid']])->find();
            if(empty($member_card)){
                return json(['status'=>'n','info'=>'此银行卡不可用']);
            }
        }

        //购物车
        $cart_total = Db::name('cart')->where(['user_id'=>$this->member['uid']])->sum('subtotal');
        $cart_list = Db::name('cart')->where(['user_id'=>$this->member['uid']])->field('user_id,ip,attr_id,add_time',true)->select();
        if(empty($cart_list)){
            return json(['status'=>'n','info'=>'请选择一个商品']);
        }

        //订单信息
        $order_data = [
            'order_sn' => 'TIC'.date('YmdHis',time()).rand(10000,99999),
            'user_id'  => $this->member['uid'],
            'username' => $this->member['username'],
        ];
        //收货
        $order_data = array_merge($order_data,$address);

        $order_data['note']         = $this->POST['note'];
        $order_data['pay']          = $this->POST['pay'];
        $order_data['shipping_fee'] = 0; //运费
        $order_data['total']        = $cart_total; //订单总金额
        $order_data['add_time']     = time();
        $order_data['state']        = 0; //0提交1确认2取消
        $order_data['pay_state']    = 0; //0未付款1已付款

        $b = Db::name('OrderInfo')->insert($order_data);
        $order_id = Db::name('OrderInfo')->getLastInsID();

        if($b){
            //添加订单商品
            foreach($cart_list as $v){
                Db::name('cart')->delete($v['id']);
                unset($v['id']); 
                $v['order_id'] = $order_id;
                Db::name('OrderGoods')->insert($v);

                //库存减少
                Db::name('product')->where(['id'=>$v['pro_id']])->setDec('stock',$v['buy_number']);
            }

            if($order_data['pay'] != 3){

                //在线支付
                import('pay/Created', EXTEND_PATH);
                import('pay/Notify', EXTEND_PATH);
                $data = [
                    'order_id' => $order_data['order_sn'],
                    'amount' => ($order_data['total'] + $order_data['shipping_fee']),
                    'notifyUrl' => 'http://'.$_SERVER['HTTP_HOST'].'/api/pay/notify',
                    'redirectUrl' => 'http://localhost:8080#home',
                    'goods' => '{"goodsName":"增量孵化器","goodsDesc":"增量孵化器商城"}',
                    'uid' => md5($this->member['uid'])
                ];
                if($this->POST['card_id'] > 0){
                    $data['userInfo'] = json_encode([
                        'bankCardNo' => $member_card['card'],
                        'idCardNo' => $member_info['card_no'],
                        'cardName' => $member_info['name']
                    ]);
                }

                // print_r($data);die;
                $order = new Created();
                $results = $order->order($data);

                if($results['status'] == 0 ){
                    //保存支付url
                    $b = Db::name('order_info')->where(['order_id'=>$order_id])->update(['order_url'=>$results['url']]);
                    return json(['status'=>'y','info'=>'生成支付订单成功','url'=>$results['url']]);
                }else{
                    return json(['status'=>'y','info'=>'生成支付订单失败']);
                }

            }else{
                //使用余额支付
                return json(['status'=>'y','info'=>'生成订单成功','order_id'=>$order_id,'order_sn'=>$order_data['order_sn']]);
            }
            
        }else{
            return json(['status'=>'n','info'=>'生成订单失败!']);
        }


    }   

    /* 继续重新支付 */
    public function again_pay(){
        if(!is_numeric($this->POST['order_id'])){
            return json(['status'=>'n','info'=>'订单错误']);
        }        
        $order = Db::name('order_info')->where([
            'order_id'  =>$this->POST['order_id'],
            'user_id'   =>$this->member['uid'],
            'pay_state' => 0,//未付款
        ])->find();

        if(empty($order)){
            return json(['status'=>'y','info'=>'此订单不需要付款']);
        }
        //在线支付的
        if($order['order_url']){
            return json(['status'=>'y','info'=>'生成支付订单成功','url'=>$order['order_url']]);
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

        //使用余额支付
        $member = Db::name('member')->where(['id'=>$this->member['uid']])->find();
        if($member['money'] < ($order['total'] + $order['shipping_fee']) ){
            return json(['status'=>'n','info'=>'余额不足','code'=>'0']);
        }

        // 启动事务
        Db::startTrans();
        try{
            Db::name('member')->where(['id'=>$this->member['uid']])->setDec('money',($order['total']+$order['shipping_fee']));
            Db::name('order_info')->where(['order_id'=>$this->POST['order_id']])->update([
                'pay_state' => 1, //付款
                'state'     => 1, //认确
                'pay_time'  => time(),
            ]);
            // 提交事务
            Db::commit();
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            return json(['status'=>'n','info'=>'付款失败']);
        }

        Db::name('money_log')->insert([
            'uid'         => $this->member['uid'],
            'username'    => $this->member['username'],
            'action'      => $order['total'],
            'money_end'   => $member['money'] - $order['total'],
            'info'        => '商城余额支付',
            'order_sn'    => $order['order_sn'],
            'type'        => 0,
            'action_type' => 2,
            'add_time'    => time(),
        ]);

        return json(['status'=>'y','info'=>'付款成功']);
    }


    /*地址列表*/
    public function address(){
        $list = Db::name('member_address')->where(['user_id'=>$this->member['uid']])->paginate(10)->each(function($item, $key){
            $item['province_name'] = get_region_name($item['province']);
            $item['city_name'] = get_region_name($item['city']);
            $item['area_name'] = get_region_name($item['area']);
            return $item;
        });
        return json($list);
    }

    /*地址详情*/
    public function address_row(){
        $where = ['user_id' => $this->member['uid']];
        if($this->POST['is_default']){
            $where['is_default'] = 1;
        }else{
            $where['id'] = $this->POST['id'];
        }
        $model = loader::model('MemberAddress');
        $row = $model->where($where)->find();
        if($row){
            $row['area_name'] = get_region_name($row['area']);
            $row['city_name'] = get_region_name($row['city']);
            $row['province_name'] = get_region_name($row['province']);
        }
        return json(['status'=>$row?'y':'n','data'=>$row?:'']);
    }


    /* 添加编辑地址 */
    public function address_add(){

        $validate = loader::validate('Address');

        if(!$validate->check($this->POST)){
            return json(['status'=>'n','info'=>$validate->getError()]);
        }

        $model = loader::model('MemberAddress');

        //如果默认,其它全部不默认
        if($this->POST['is_default']){
            $model->where(['user_id'=>$this->member['uid']])->update(['is_default'=>0]);
        }

        if($this->POST['id'] > 0){

            $b = $model->where(['id'=>$this->POST['id'],'user_id'=>$this->member['uid']])->update($this->POST);
        }else{
            $address_num = get_config('base','address');
            if(Db::name('member_address')->where(['user_id'=>$this->member['uid']])->count() >= $address_num){
                return json(['status'=>'n','info'=>'收货地址最多'.$address_num.'个']);
            }

            $this->POST['user_id'] = $this->member['uid'];
            $b = $model->save($this->POST);
        }

        return json(['status'=>$b?'y':'n','info'=>$b?'操作成功':'编辑失败']);

    }

    /* 默认 */
    public function address_default(){
        if($this->POST['id'] > 0 && $this->POST['is_default'] == 1){
            Db::name('member_address')->where(['user_id'=>$this->member['uid']])->update(['is_default'=>0]);
            
            $b = Db::name('member_address')->where([
                'id'      => $this->POST['id'],
                'user_id' => $this->member['uid']
            ])->update(['is_default'=>1]);   
            return json(['status'=>$b,'info'=>$b?'操作成功':'操作失败!']);
        }else{
            return json(['status'=>'n','info'=>'参数错误']);
        }
    } 

    /* 更新购物车商品
        id 购物车id 更新的商品的数量
     */
    public function update_cart(){
        $Cart = Db::name('cart')->where(['id'=>$this->POST['id']])->find();
        if( empty($Cart) ){
            return json(['status'=>'购物车不存在，或已结算']);
        }

        //更新数量 & 更新总价
        $data = [
            'buy_number' => $this->POST['buy_number'],
            'subtotal'   => round(($this->POST['buy_number'] * $Cart['price']),3),
        ];

        if($data['buy_number'] <= 0 || $data['subtotal'] <= 0 ){
            return json(['status'=>'n','info'=>'更新错误~']);
        }

        //更新自己的购物车
        $b = Db::name('cart')->where(['id'=>$this->POST['id'],'user_id'=>$this->member['uid']])->update($data);
        return json(['status'=>$b?'y':'n','info'=>$b?'更新成功':'更新失败!']);
    }


    /* 删除购物车商品
        @购物车id
     */
    public function cart_del(){
        $b = Db::name('cart')->where(['id'=>$this->POST['id'],'user_id'=>$this->member['uid']])->delete();
        return json(['status'=>$b?'y':'n','info'=>$b?'删除成功':'删除失败!']);
    }

    /* 删除地址 */
    public function address_del(){
        $b = Db::name('MemberAddress')->where(['id'=>$this->POST['id'],'user_id'=>$this->member['uid']])->delete();
        return json(['status'=>$b?'y':'n','info'=>$b?'删除成功':'删除失败!']);
    }

    /* 全国地址 */
    public function get_region(){
        if(!is_numeric($this->POST['region_id'])) return json(['status'=>'y','inof'=>'参数错误']);
        $data = Db::name('region')->field('region_id,region_name')->where(array('parent_id'=>$this->POST['region_id']))->select();
        return json($data);
    }

    /* 商城订单 */
    public  function order(){
        $model = loader::model('OrderInfo');

        $where = ['user_id'=>$this->member['uid']];

        switch ($this->POST['status']) {
            case '1':
                $where['pay_state'] = 0; //未付款
                break;
            case '2':
                $where['pay_state'] = 1; //已付款
                $where['shipping_state'] = 0; //未发货
                break;
            case '3':
                $where['pay_state'] = 1; //  已付款
                $where['shipping_state'] = 1; // 已发货
                break;
            case '4':
                $where['pay_state'] = 1; //  已付款
                $where['shipping_state'] = 2; // 已收货
                $where['comment_state'] = 0;//未评价
                break;
            default:
                $where['pay_state'] = 0; //未付款
            break;
        }


        $list = $model->where($where)->order('order_id DESC')->paginate(10)->each(function($item, $key){
            $item['orderGoods'] = Db::name('order_goods')->where(['order_id'=>$item['order_id']])->select();
            return $item;
        });
        return json($list);
    }

    /*删除未付款*/
    public function order_del()
    {   
        $order_id = input('post.order_id/d');
        $b = Db::name('order_info')->where([
            'order_id'  => $order_id,
            'user_id'   => $this->member['uid'],
            'pay_state' => 0, //未付款
        ])->delete();
        if($b){
            Db::name('order_goods')->where(['order_id'=>$order_id])->delete();
            return json(['status'=>'y','info'=>'删除成功']);
        }else{
            return json(['status'=>'n','info'=>'删除失败']);
        }
    }

    /* 订单详情 */
    public function order_details(){
        $order = Db::name('order_info')->where([
            'order_id' => $this->POST['order_id'],
            'user_id'  => $this->member['uid']
        ])->find();
        if($order){
            $order['orderGoods'] = Db::name('order_goods')->where(['order_id'=>$this->POST['order_id']])->select();
        }

        $order['province'] = ['province'=>$order['province'],'province_name'=>get_region_name($order['province'])];
        $order['city'] = ['city'=>$order['city'],'city_name'=>get_region_name($order['city'])];
        $order['area'] = ['area'=>$order['area'],'area_name'=>get_region_name($order['area'])];
        $order['add_time'] = date('Y-m-d H:i',$order['add_time']);

        return json(['status'=>$order?'y':'n','data'=>$order?:[]]);
    }

    /*确认收货*/
    public function order_receive(){
        
        if(!is_numeric($this->POST['order_id']) || empty($this->POST['order_id'])){
            return json(['status'=>'n','info'=>'参数错误']);
        }
        #'0提交1确认2取消',
        // $now_state = Db::name('order_info')->where(array('order_id'=>$this->POST['order_id'],'user_id'=>$this->member['uid']))->column('shipping_state')[0];
        $order = Db::name('order_info')->where(array('order_id'=>$this->POST['order_id'],'user_id'=>$this->member['uid']))->find();

        if($order === null){
            return json(['status'=>'n','info'=>'订单不存在']);
        }
        if($order['shipping_state'] == 0){
            return json(['status'=>'n','info'=>'该订单尚未发货']);
        }
        if($order['shipping_state'] == 2){
            return json(['status'=>'n','info'=>'该订单已收货']);
        }
        if($order['shipping_state'] == 3){
            return json(['status'=>'n','info'=>'该订单已退货']);
        }

        //获取当前金币交易价
        $this_time = date('Y-m-d',time());
        $order_trend = Db::name('OrderTrend')->where(['dates'=>$this_time])->find();
        if(empty($order_trend)){
            return json(['status'=>'n','info'=>'获取交易价失败！']);
        }


        $data = array(
            'order_id' => $this->POST['order_id'],
            'state' => 1,
            'shipping_state' => 2,
            'get_time' => time(),
        );

        $b = Db::name('order_info')->update($data);
        if($b){
            //上级可提现 
            // $parent = Db::name('member')->alias('M')->join('__MEMBER__ P ','M.parent_id= P.id')
            // ->where(['M.id'=>$this->member['uid']])
            // ->find();

            // // 必须有足够的积分
            // if( ($parent['integral'] - $parent['put_integral']) > $order['total'] ){
            //     // 增加可提现额度 
            //     $config = get_config('base');
            //     $total = ($config['put_integral_'.$parent['level']]/100) * $order['total'];

            //     Db::name('member')->where(['id'=>$parent['id']])->update([
            //         'integral' => $parent['integral'] - $total,
            //         'put_integral' => $parent['put_integral'] + $total
            //     ]);

            //     //扣除积分
            //     Db::name('integral_log')->insert([
            //         'uid'         => $parent['id'],
            //         'username'    => $parent['username'],
            //         'action'      => $total,
            //         'money_end'   => $parent['integral'] - $total,
            //         'info'        => '返可提现积分'.$this->member['username'],
            //         'order_sn'    => $order['order_sn'],
            //         'type'        => 0,
            //         'action_type' => 7,
            //         'add_time'    => time(),
            //     ]);

            //     //可提积分
            //     Db::name('put_integral_log')->insert([
            //         'uid'         => $parent['id'],
            //         'username'    => $parent['username'],
            //         'action'      => $total,
            //         'money_end'   => $parent['put_integral'] + $total,
            //         'info'        => '商城购物'.$this->member['username'],
            //         'order_sn'    => $order['order_sn'],
            //         'type'        => 1,
            //         'action_type' => 1,
            //         'add_time'    => time(),
            //     ]);

            //     Log::write('orderid'.$order['id'].'pid['.$parent['id'].']integral['.($parent['integral'] - $parent['put_integral']).']订单：'.$order['total'], 'order', true);
            // }

            $this->first_order();                             //首推
            $this->return_gold($this->POST['order_id']);      //结算反金币
            $this->news_order_prize($this->POST['order_id']); //新增业绩/|同级奖
            $this->assets_level($this->member['uid']);        //升级
            return json(['status'=>'y','info'=>'收货成功']);
        }else{
            return json(['status'=>'n','info'=>'收货失败']);
        }
    }
    
    /* 首推奖励[烧] */
    protected function first_order()
    {   
        $where = [
            'user_id'        => $this->member['uid'],
            'shipping_state' => 2 //已收货
        ];
        $order = Db::name('OrderInfo')->where($where)->select();

        //如果上级没有消费过也不会反
        if(count($order) == 1){
            $this->getMember($this->member['uid']);
            //父级资产
            $Pmember = Db::name('member')->where(['id'=>$this->data['member']['parent_id']])->find();
            $assets = $Pmember['gold_static'] * $Pmember['gold_static_price'];  //资产

            $info = '首推奖励';
            if($assets > $order[0]['total']){
                $action = $order[0]['total'] * (get_config('reward','first')/100);
            }else{
                //烧伤了 (￣▽￣)""
                $info .= '[烧伤]';
                $action = $assets * (get_config('reward','first')/100);
            }
            $action = round($action,3);

            $data_log = [
                'uid'         => $Pmember['id'],
                'username'    => $Pmember['username'],
                'action'      => $action,
                'money_end'   => $Pmember['integral'] + $action,
                'info'        => $info,
                'order_sn'    => $order[0]['order_sn'],
                'type'        => 1,
                'action_type' => 2, //首推奖
                'add_time'    => time(),
            ];

            $b = Db::name('member')->where(['id'=>$Pmember['id']])->setInc('integral',$action);
            if($b){
                Db::name('integral_log')->insert($data_log);
            }

        }

    }

    /*  
        新增业绩奖
        每个结算的订单都进行
    */
    protected function news_order_prize($order_id)
    {   
        $order = Db::name('OrderInfo')->where(['order_id'=>$order_id])->find();
        if(empty($order)){
            return flase;
        }
        //配置
        $config = get_config('reward');
        $data_log = [];

        $member = Db::name('member')->where(['id'=>$this->member['uid']])->find();
        $parent = get_parent($member,3);


        //上3代级以上 --4--5[4]
        //如果上级不到3级则 $parent['2']['level']空

        //经理 等级4
        if($parent['2']['level'] == 4 || $parent['2']['level'] == 5){
            $action2 = $order['total'] * ($config['new_orderA']/100);
            $data_log[] = [
                'uid'         => $parent['2']['id'],
                'username'    => $parent['2']['username'],
                'action'      => $action2,
                'money_end'   => $parent['2']['integral'] + $action2,
                'info'        => '新增业绩奖',
                'order_sn'    => $order['order_sn'],
                'type'        => 1,
                'action_type' => 4,
                'add_time'    => time(),
            ];
            $b[0] = Db::name('member')->where(['id'=>$parent['2']['id']])->setInc('integral',$action2);
        }

        if($parent['3']['level'] == 4){ 
            $action3 = $action2 * ($config['new_order_count']/100);
            $data_log[] = [
                'uid'         => $parent['3']['id'],
                'username'    => $parent['3']['username'],
                'action'      => $action3,
                'money_end'   => $parent['3']['integral'] + $action3,
                'info'        => '新增业绩同级奖',
                'order_sn'    => $order['order_sn'],
                'type'        => 1,
                'action_type' => 5,
                'add_time'    => time(),
            ];
            if($action3 >= 0.001){
                $b[1] = Db::name('member')->where(['id'=>$parent['3']['id']])->setInc('integral',$action3);
            }
            
        }elseif($parent['3']['level'] == 5){
            $action3 = $order['total'] * ($config['new_orderB']/100);
            $data_log[] = [
                'uid'         => $parent['3']['id'],
                'username'    => $parent['3']['username'],
                'action'      => $action3,
                'money_end'   => $parent['3']['integral'] + $action3,
                'info'        => '新增业绩奖',
                'order_sn'    => $order['order_sn'],
                'type'        => 1,
                'action_type' => 4,
                'add_time'    => time(),
            ];
            $b[1] = Db::name('member')->where(['id'=>$parent['3']['id']])->setInc('integral',$action3);
        }

        Db::name('integral_log')->insertAll($data_log);
    }


    /*评论*/
    public function comment(){
        if($this->POST['order_id'] <= 0){
            return json(['status'=>'n','info'=>'订单错误']);
        }
        if($this->POST['score'] <= 0){
            return json(['status'=>'n','info'=>'必须打分']);
        }
        if(empty($this->POST['content'])){
            return json(['status'=>'n','info'=>'您还没评论']);
        }
        $data = [];
        $list =Db::name('order_goods')->where(['order_id'=>$this->POST['order_id']])->field('pro_id')->select();

        foreach($list as $v){
            $data[] = array(
                'user_id'  => $this->member['uid'],
                'pro_id'   => $v['pro_id'],
                'order_id' => $this->POST['order_id'],
                'score'    => $this->POST['score'],
                'content'  => $this->POST['content'],
                'add_time' => time()
            );
        }

        $b = Db::name('comment')->insertAll($data);
        if($b){
            //修改订单状态
            Db::name('order_info')->where(['order_id'=>$this->POST['order_id']])->setField('comment_state',1);
            return json(['status'=>'y','info'=>'评论成功']);
        }else{
            return json(['status'=>'n','info'=>'评论失败']);
        }

    }

}