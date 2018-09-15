<?php
/*获取上三级的父级*/
function get_parent($member,$num){
    $data = []; 
    $member_parent = db('member')->where([
        'id' => $member['parent_id']
    ])->find();

    if($member_parent){
        $data[] = $member_parent;
        $data = array_merge($data,get_parent($member_parent,$num-1));
    }else{
        return $data; //如果空了返回
    }
    return $data; //全部返回
}

function get_conf($type,$name=null){

    $result = array();
    $data = db('config')->where(array('type'=>$type))->select();
    if($data){
        foreach($data as $v){
            if(!empty($name)){
                if($v['name'] == $name){
                    $result = $v['value'];
                    break;
                }
            }else{
                $result[$v['name']] = $v['value'];
            }
        }
    }
    return $result;
}