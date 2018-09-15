<?php
    #无级分类（位置排序）
    function category_merge($data,$parent_id=0,$level=0,$pk='cat_id'){
        $res = array();
        foreach($data as $v){
            #一级分类
            if($v['parent_id'] == $parent_id){
                $v['level'] = $level;
                $res[] = $v;
                #寻找自己下级
                $res = array_merge($res,category_merge($data,$v[$pk],$level+1,$pk));
            }
        }
        return $res;
    }
    #查询子分类cat_id
    function get_children($data,$cat_id,$pk='cat_id'){
        $res = array();
        foreach($data as $v){
            #指定级
            if($v['parent_id'] == $cat_id){
                $res[] = $v[$pk];
                #寻找下级分类
                $res = array_merge($res,get_children($data,$v[$pk],$pk));
            }
        }
        return $res;
    }

    /* 分级（树状） */
    function rule_tree($data,$parent_id=0){
        $res = array();
        foreach($data as $v){
            if($v['parent_id'] == $parent_id){
                $v['child'] = rule_tree($data,$v['id']);
                $res[] = $v;
            }
        }
        return $res;
    }

    /* 获得cat_name */
    function get_catname($id,$table='news_category'){
        return db($table)->where(array('cat_id'=>$id))->column('cat_name')[0];
    }
    /* 获得图片位置 */
    function get_picture_type($id){
        $picture_type = Config('picture_type');
        $result = '';
        foreach($picture_type as $v){
            if($v['id'] == $id){
                $result = $v['name'];
                break;
            }
        }
        return $result;
    }

    /* 获取内容的图片src */
    function get_img_src($content){
        $pattern = "/<[img|IMG].*?src=[\'|\"](.*?(?:[\.gif|\.jpg]))[\'|\"].*?[\/]?>/";
        preg_match_all($pattern, $content, $match);
        return $match[1];
    }
    function get_username($user_id){
        return db('member')->where(array('id'=>$user_id))->getField('username');
    }
    
    /* 获取距离天数 */
    function get_gold_rid($satrt_time){
        $day = get_config('reward','static_gold_rid');
        $end_start = $day - (time()- $satrt_time)/86400;
        if($end_start < 0){
            return '正在释放';
        }
        return round($end_start,3).'天后释放';
    }