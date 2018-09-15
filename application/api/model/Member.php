<?php
namespace app\api\model;
use think\Model;

class Member extends Model
{   
    protected $auto = [];
    protected $insert = ['wallet_address','reg_time','Paytoken'];

    /*
        钱包地址
        return string
    */
    protected function setWalletAddressAttr($value, $data)
    {
        return  get_wallet_address($data['username']);
    }

    protected function setRegTimeAttr($value, $data)
    {
        return time();
    }

    protected function setPaytokenAttr($value,$data)
    {
        return md5($value);
    }



}