<?php

namespace app\extend\Pay;

require_once(__DIR__ . "/lib/YopClient.php");
require_once(__DIR__ . "/lib/YopClient3.php");
require_once(__DIR__ . "/lib/Util/YopSignUtils.php");

class Notify extends Conf
{

    public function callback($data)
    {
        return \YopSignUtils::decrypt($data, $this->private_key, $this->yop_public_key);
    }

}