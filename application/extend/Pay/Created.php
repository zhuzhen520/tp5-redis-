<?php

namespace app\extend\Pay;

require_once(__DIR__ ."/lib/YopClient3.php");
require_once(__DIR__."/lib/Util/YopSignUtils.php");

class Created extends Conf
{

    public function order(array $order)
    {
        $data['parentMerchantNo'] = $this->parentMerchantNo;
        $data['merchantNo'] = $this->merchantNo;
        $data['orderId'] = $order['order_id'];
        $data['orderAmount'] = $order['amount'];
        $data['notifyUrl'] = $order['notifyUrl'];
        $hmacstr = hash_hmac('sha256', $this->toString($data), $this->hmacKey, true);
        $hmac = bin2hex($hmacstr);

        return $this->url($hmac, $order);
    }

    public function toString($arraydata)
    {
        $Str = "";
        foreach ($arraydata as $k => $v) {
            $Str .= strlen($Str) == 0 ? "" : "&";
            $Str .= $k . "=" . $v;
        }
        return $Str;
    }


    public function getUrl($response, $private_key)
    {
        $content = $this->toString($response);
        $sign = \YopSignUtils::signRsa($content, $private_key);
        $url = $content . "&sign=" . $sign;
        return $url;
    }

    public function object_array($array)
    {
        if (is_object($array)) {
            $array = (array)$array;
        }
        if (is_array($array)) {
            foreach ($array as $key => $value) {
                $array[$key] = $this->object_array($value);
            }
        }
        return $array;
    }

    public function url($hmac, $order)
    {
        $request = new \YopRequest("OPR:10014929805", $this->private_key, "https://open.yeepay.com/yop-center", $this->yop_public_key);
        $request->addParam("parentMerchantNo", $this->parentMerchantNo);
        $request->addParam("merchantNo", $this->merchantNo);
        $request->addParam("orderId", $order['order_id']);
        $request->addParam("orderAmount", $order['amount']);
//        $request->addParam("timeoutExpress", $order['timeoutExpress']);
        $request->addParam("requestDate", date('Y-m-d H:i:s'));
        $request->addParam("redirectUrl", $order['redirectUrl']);
        $request->addParam("notifyUrl", $order['notifyUrl']);
        $request->addParam("goodsParamExt", $order['goods']);
        $request->addParam("paymentParamExt", $order['userInfo']);
//        $request->addParam("industryParamExt", $order['industryParamExt']);
//        $request->addParam("memo", $order['memo']);
//        $request->addParam("riskParamExt", $order['riskParamExt']);
//        $request->addParam("csUrl", $order['csUrl']);
//        $request->addParam("fundProcessType", $order['fundProcessType']);
//        $request->addParam("divideDetail", $order['divideDetail']);
//        $request->addParam("divideNotifyUrl", $order['divideNotifyUrl']);
        $request->addParam("hmac", $hmac);
        $response = \YopClient3::post("/rest/v1.0/sys/trade/order", $request);

        if ($response->validSign == 1) {
            $data = $this->object_array($response);
            $token = $data['result']['token'];
            if (!$token) {
                return ['status' => 1, 'msg' => 'token不存在', 'data' => $data];
            }
            $cashter = array(
                "merchantNo" => $this->parentMerchantNo,
                "token" => $token,
                "timestamp" => strtotime('now'),
                "directPayType" => '',
                "cardType" => '',
                "userNo" => $order['uid'],
                "userType" => 'USER_ID',
                "ext" => '',
            );
            $getUrl = $this->getUrl($cashter, $this->private_key);
            $getUrl = str_replace("&timestamp", "&timestamp", $getUrl);
            $url = "https://cash.yeepay.com/cashier/std?" . $getUrl;
            return ['status' => 0, 'url' => $url];
        }


    }
}