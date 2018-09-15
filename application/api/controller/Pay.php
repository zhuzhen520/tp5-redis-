<?php
namespace app\api\controller;
use think\Created; //pay
use think\Notify; //pay
use think\Controller;
use think\Db;
use think\Log;

class Pay extends Controller
{

    // public function test()
    // {
    //     $data = [
    //         'order_id' => time() . 'dss',
    //         'amount' => '0.01',
    //         'notifyUrl' => 'http://zll.chunapi.com/api/test/notify',
    //         'redirectUrl' => 'http://www.baidu.com',
    //         'goods' => '{"goodsName":"测试","goodsDesc":"123456"}',
    //         'userInfo' => json_encode([
    //             'bankCardNo' => '6217002920129603024',
    //             'idCardNo' => '433126199605062013',
    //             'cardName' => '陈旭']),
    //         'uid' => '1234'
    //     ];
    //     $order = new Created();
    //     $results = $order->order($data);
    //     dump($results);
    // }


    public function notify()
    {   
        import('pay/Created', EXTEND_PATH);
        import('pay/Notify', EXTEND_PATH);

        Log::write(json_encode($this->request->post()), 'notify', true);

        $data = $this->request->post();

        $notify = new Notify();
        $data1 = $notify->callback($data['response']);

        $data1 = json_decode($data1, true);
        // print_r($data1);
        Log::write($data1, 'notify', true);

        if ($data1['status'] == 'SUCCESS') {
            // 处理业务逻辑  加上 事务
            Db::startTrans();
            try {
                //修改订单支付状态
                $res = Db::name('order_info')->where(['order_sn'=>$data1['orderId']])->update(['pay_state'=>1,'pay_time'=>time(),'order_pay'=>$data1['uniqueOrderNo']]);
                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
            }
        }

        if ($res) {
            //处理完成 输出 SUCCESS;
            echo 'SUCCESS';
        }
    }

}