<?php

namespace app\api\controller;

use app\extend\Pay\Created;
use app\extend\Pay\Notify;
use think\Controller;
use think\Db;
use think\Log;

class Test extends Controller
{

    public function test()
    {
        $data = [
            'order_id' => time() . 'dss',
            'amount' => '0.01',
            'notifyUrl' => 'http://zll.chunapi.com/api/test/notify',
            'redirectUrl' => 'http://www.baidu.com',
            'goods' => '{"goodsName":"测试","goodsDesc":"123456"}',
            'userInfo' => json_encode([
                'bankCardNo' => '6217002920129603024',
                'idCardNo' => '433126199605062013',
                'cardName' => '陈旭']),
            'uid' => '1234'
        ];
        $order = new Created();
        $results = $order->order($data);

        dump($order->private_key);

        dump($results);
    }


    public function notify()
    {
        Log::write(json_encode($this->request->post()), 'notify', true);
        $data = $this->request->post();
        $data = [
            'response' => 'K4jdJaBoBJ0GadeG1IRxSRV_OBB3wrmGIA5j8YvrR_IDv4pdItwJM7Mpd5LZo5S4Dx0zY81WBz1c-zjqzk7b6ofSKQXHE3biah2ek94EyX7tl9fJcL4rCmRbX4Ayy9E6G9OCdBF0MPbBg80N45gKDiEMTHhNbuFSi9CMOnnbhkjOexRFVE_cWWl7A7m1WUwz-disZAqiSEasgNYLDTZmaXyoC0D3qsVKyUo9cc5pn_X5N5IPGcBk5zxrjKGqytYnO8XQSeaCHbgnyYWYH_bPokKaXBQ8uTHq241h86VSYV5TzMg_z5-8uJCITDsVKKY9SuUG9Epq9xICNFPduaOH9w$NcC1oXtSkjoUd-dtWAUQun8dejZZ6l7su58CTM6OgzfKr1TSOn6a3FOM2jpNYvJlRp3evUkIh0f2Ve3sBLWo4X6IUQMs5WVrv0QRV4LoUt0tUY_sk7Yi-KMck0cmGlCrCQWEYQrOLl4CAyZtbqQrDtVnDG5FIYd2PNRtVc7FxqGePsq1rKSZcoFPno1AILk6kwU-WJzuvfpsaNUbapgJiFNrziGqiv6JIHlghIBJv2fChi2h7ivFJsj6M1kOjyAoAIcK-yhrvqs-dYDrgvtHCnjRHVld1wlVjN2Vd6OW8N1ZdPZWz3HbfC5vLUFsStsRn_F0eHG6601kFP9mIn65suVNgoX3nrQqM9Qu2uRxvjlH_z_sQeEbexP4_DD_bYVFvqnZ21kYg4hkJtTgLLiiZBdbPWT19FhdSKuIQyECTshyh6tg3avORBKFUIE_BO3gzYahK48yBiSt-vfiUl9DObA3F1V0h9-9M6aaWCvsrgh0GWfjymPvNaMZ1WIQtIYnWKzN5FEikbY9gc4aVYKLcCkGnc8YaT7Kwrs3_8xDshkTUQp4oScQFvEDGCZBX4y8uue1dwPvlPegr6fjSSli6oo2fLgdD0FITLwoCiXVV8cj0GwxvL915jSpks5epvF6c5Oscwb4BDjy3kYBqNJ1MkxQaxILaEoVxq1CvHobGFJWNSrc2HFUPRD3gGu9Bdz1Scf4OWN1DsvkaHeXZKZQwKQV5k2qVdBChMmRs--og6xYImMc2Nn1GlMXh-jaE79ckSDmsscjhVL3S23CMR_44BDzLyNuds-U9ChsRFv0O44scFURZneyL8GdSMXFO8hgVs-mrnnS4aTn8r4TT9h_teVphQ8HOIzoY_5eA8YrUCtSx20076YDoCkOmBPzlrvJ1npGPLrsgy7JBUKLhg9kZU3bboWdfEAQg6-XMyy2gbL0MzC61Y1DfHb_i2MnCGSt_D6kBH5HZq39grayAhYbRJ2Cm9-DlAMrtHsojN2LyVylmIOJywyXsNFDUaZZmR4fq4icwR_u1YtYg4TQR05Y_VGflX-ktf_YJfS8KiNaSDq48Dcy0HCEtMyb5xm9a89XJsrh5TqQLhGahVgbUz8lzeb6dHLoggoH600Ehhd6yGE$AES$SHA256',
            'customerIdentification' => 'OPR:10014929805',
        ];
        $notify = new Notify();
        $data1 = $notify->callback($data['response']);
        echo '<pre>';
        $data1 = json_decode($data1, true);
        print_r($data1);
        if ($data1['status'] == 'SUCCESS') {
            // 处理业务逻辑  加上 事务
            Db::startTrans();
            try {


                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
            }
        }

        $res = true;
        if ($res) {
            //处理完成 输出 SUCCESS;
            echo 'SUCCESS';
        }
    }

}