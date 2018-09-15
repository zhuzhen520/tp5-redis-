<?php
// namespace Aliyun\DySDKLite\Sms;
namespace Think;
require_once "SignatureHelper.php";
use Aliyun\DySDKLite\SignatureHelper;
use think\Log;
// +----------------------------------------------------------------------
// | 单发发送短信
// +----------------------------------------------------------------------

ini_set("display_errors", "on"); // 显示错误提示，仅用于测试时排查问题
set_time_limit(0); // 防止脚本超时，仅用于测试使用，生产环境请按实际情况设置

class   Sms
{
    public $code = 0;
    public $phone = 0;

    // 验证发送短信(SendSms)接口
    // $result = $this->sendSms($code,$phone);

    // //发送成功
    // if($result->Message == "OK"){
    //     $_SESSION["SMS_code"]  = $code;
    //     $_SESSION["SMS_time"]  = time();
    // }else{
    //     session_destroy();
    // }

    //错误时候打开
    // print_r($result);

    public function sendSms($code,$phone='13142162302',$name,$template) {
        $params = array();
        /* 需用户填写部分 */
        
        $accessKeyId = "LTAI59YJOWJVsm82";
        $accessKeySecret = "rtTiEvHsI8S5mnZslthLI8QUBqojvz";

        #fixme 必填: 短信接收号码
        $params["PhoneNumbers"] = $phone;

        #签名
        $params["SignName"] = $name;

        #模板
        $params["TemplateCode"] =$template;

        #短信验证码/
        $params['TemplateParam'] = Array (
            "code" => $code,
            "product" => "mykj"
        );
        #流水号
        $params['OutId'] = "12345";
        #扩展码字段控制在7位或以下
        $params['SmsUpExtendCode'] = "1234567";

        // *** 需用户填写部分结束, 以下代码若无必要无需更改 ***
        if(!empty($params["TemplateParam"]) && is_array($params["TemplateParam"])) {
            $params["TemplateParam"] = json_encode($params["TemplateParam"], JSON_UNESCAPED_UNICODE);
        }

        $helper = new SignatureHelper();
        $content = $helper->request(
            $accessKeyId,
            $accessKeySecret,
            "dysmsapi.aliyuncs.com",
            array_merge($params, array(
                "RegionId" => "cn-hangzhou",
                "Action" => "SendSms",
                "Version" => "2017-05-25",
            ))
            // fixme 选填: 启用https
            // ,true
        );
        Log::write(json_encode($content,true).'id:'.$phone, 'sms', true);
        return $content;
    }


}

