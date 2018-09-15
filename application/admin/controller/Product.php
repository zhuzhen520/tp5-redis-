<?php
namespace app\admin\controller;
use think\Db;
use think\Request;
use think\loader; 


class Product extends Base{
    public function category(){
        $db = Db::name('Product_category');
        #排序
        $sort = input('sort');
        if(!empty($sort)){
            foreach($sort as $k=>$v){
                $v = intval($v);
                $db->where(array('cat_id'=>$k))->setField('sort',$v);
            }
        }
        #查询分配数据
        $list = $db->order('sort,cat_id desc')->select();
        $list = category_merge($list);
        #print_r($list);
        $this->assign('list',$list);
        return $this->fetch();
    }
    public function category_add(){
        #实例化 new \Think\Model('category')#
        $db = Db::name('product_category');
        #所有分类数据
        $list = Db::name('product_category')->order('sort,cat_id desc')->select();

        if(Request::instance()->isPost()){
            #提交过程
            $data = input('post.');
            #print_r($data);die;
            #数据处理
            if(empty($data['cat_name'])){
                $this->error('分类名称不能为空');die;
            }
            #操作方式
            if($_POST['cat_id'] > 0){
                #不能把自己分到自己下级
                $children = get_children($list,$_POST['cat_id']);
                $children[] = $data['cat_id'];
                #print_r($children);die;
                if(in_array($data['parent_id'], $children)){
                    $this->error('不能使用自己或下级作为为上级分类');die;
                }
                #删除老的
                if($data['thumb'] != $data['oldlogo']){
                    @unlink('.'.$data['oldlogo']);
                }
                unset($data['oldlogo']);

                $b = $db->update($data);
            }else{
                unset($data['oldlogo']);
                $b = $db->insert($data);
            }
            #操作结果
            if($b !== flase){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'y','info'=>'操作失败！']);
            }
        }else{
            #显示数据
            $cat_id = input('cat_id',0);
            if($cat_id > 0){
                $row = $db->find($cat_id);
            }else{
                #添加情况,默认显示
                $row['is_show'] = 1;
            }
            $this->assign($row);

            #无极分类
            $list = category_merge($list);
            $this->assign('list',$list);

            return $this->fetch();
       }
    }
    public function category_del(){
        $id = trim(input('id'),',');
        $db = Db::name('product_category');
        #删除
        $b = $db->delete($id);
        if($b){
            $list = $db->select();
            #查询下级
            $ids = explode(',', $id);
            $children = array();
            foreach($ids as $v){
                #查出传来的所有id的子分类
                $tmp = get_children($list,$v);
                #集合
                $children = array_merge($children,$tmp);
            }
            if($children){
                $where['cat_id'] = array('in',$children);
                $db->where($where)->delete();
            }
            $count = $db->count();
            return json(['status'=>'y','info'=>'删除成功','children'=>$children,'count'=>$count]);
        }else{
            return json(['status'=>'n','info'=>'删除失败!']);
        }
    }
    public function attribute(){
        $db = Db::name('attribute');
        #排序
        $sort = input('sort');
        if(!empty($sort)){
            foreach($sort as $k=>$v){
                $v = intval($v);
                $db->where(array('attr_id'=>$k))->setField('sort',$v);
            }
        }
        #查询分配数据
        $list = $db->order('sort,attr_id desc')->select();
        $list = category_merge($list,0,0,'attr_id');
        // dump($list);
        $this->assign('list',$list);
        return $this->fetch();
    }
    public function attribute_add(){
        #实例化 new \Think\Model('category')#
        $db = Db::name('attribute');
        #所有分类数据
        $list = Db::name('attribute')->order('sort,attr_id desc')->select();

        if(Request::instance()->isPost()){
            #提交过程
            $data = input('post.');
            #print_r($data);die;
            #数据处理
            if(empty($data['attr_name'])){
                return json(['属性名称不能为空']);
            }

            #操作方式

            if($_POST['attr_id'] > 0){
                // if($data['parent'] == 0){
                //  $this->error('我是一级属性');die;
                // }
                #不能把自己分到自己下级
                $children = get_children($list,$_POST['attr_id'],'attr_id');
                $children[] = $data['attr_id'];
                #print_r($children);die;
                if(in_array($data['parent_id'], $children)){
                    return json(['status'=>'n','info'=>'不能使用自己或下级作为为上级分类']);
                }
                unset($data['parent']);
                $b = $db->update($data);
            }else{
                unset($data['parent']);
                $b = $db->insert($data);
            }
            #操作结果
            if($b !== flase){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'y','info'=>'操作失败！']);
            }
        }else{
            #显示数据
            $attr_id = input('attr_id',0);
            if($attr_id > 0){
                $row = $db->find($attr_id);
            }else{
                #添加情况,默认显示
                $row['is_show'] = 1;
            }
            $this->assign($row);

            #无极分类
            $list = category_merge($list,0,0,'attr_id');
            $this->assign('list',$list);

            return $this->fetch();
        }
    }
    public function attribute_del(){
        $id = trim(input('id'),',');
        $db = Db::name('attribute');
        #删除
        $b = $db->delete($id);
        if($b){
            $list = $db->select();
            #查询下级
            $ids = explode(',', $id);
            $children = array();
            foreach($ids as $v){
                #查出传来的所有id的子分类
                $tmp = get_children($list,$v,'attr_id');
                #集合
                $children = array_merge($children,$tmp);
            }
            if($children){
                $where['attr_id'] = array('in',$children);
                $db->where($where)->delete();
            }
            $count = $db->count();
            $this->ajaxReturn(array('status'=>'y','info'=>'删除成功^ ^','children'=>$children,'count'=>$count));
        }else{
            $this->ajaxReturn(array('status'=>'n','info'=>'删除失败* *'));
        }
    }

    public function product_list(){
        $db = Db::name('product');
//        /* 分类查询 */
//        $category=Db::name('product_category')->where(array('is_show'=>1))->order('sort,cat_id desc')->select();
//        $cat_id = input('cat_id');
//        if($cat_id > 0){
//            $children = get_children($category,$cat_id);
//            $children[] = $cat_id;
//            $where['cat_id'] = array('in',$children);
//        }
        /* 关键词查询 */
        $word = input('word');
        if(!empty($word)){
            $where['name'] = array('like',"%$word%");
        }
        /* 日期查询 */
        $time_min = input('time_min');
        $time_max = input('time_max');

        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['add_time'] = array('between',array($time_min,$time_max));
            }else{
                $where['add_time'] = array('between',array($time_max,$time_min));
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['add_time'] = array('between',array($time_min,$time_max));
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['add_time'] = array('elt',$time_max);
        }
        // var_dump($where);

        $count = $db->where($where)->count();
        /* 分页数据 */


        $list = $db->where($where)->order('id desc')->paginate(10)->each(function($item,$key){
            $now = time();
            #促销
            $item['price'] = $item['shop_price'];

            if($item['promote_price'] > 0 && $item['promote_start'] <= $now && $item['promote_end'] && $item['promote_end'] > $now){
                //促销价格
                $item['price'] = $item['promote_price'];
            }else{
                $item['promote_price'] = 0;
            }
            #评论
            $item['comment'] = Db::name('comment')->where(array('pro_id'=>$item['id']))->count();
            return $item;
        });

        // print_r($list);die;

        /* 分配数据 */
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        /* 无极分类 */
        //$category = category_merge($category);
       // $this->assign('category',$category);

        $this->assign('count',$count);
        return $this->fetch();
    }

    /* 产品添加 */
    public function product_add(){

        $db = Db::name('product');
        if(Request::instance()->isPost()){
            $POST = input('post.');
            $POST['is_recommend'] = input('is_recommend',0);
            $POST['add_time'] = time();
            $POST['finish'] = 0;
            $POST['is_sale'] = 1;
            #/图片数据
            $oldPic = $POST['oldPic'];
            $oldPic1 = $POST['oldPic1'];
            $oldPic2 = $POST['oldPic2'];
            $oldPic3 = $POST['oldPic3'];
            #验证数据
            $validate = loader::validate('Product');
            if(!$validate->check($POST)){
                return json(['status'=>'n','info'=>$validate->getError()]);
            }

            // print_r($POST);die;


            #操作方式
            if($POST['id'] > 0){

                #修改
                $b = $db->update($POST);
            }else{
                #添加
                $b = $db->insert($POST);
            }

            #结果
            if($b !== flase){
                /* 修改了图片 */
                if(!empty($oldPic) && $oldPic != $POST['thumb']){
                    @unlink('.'.$oldPic);
                }
                if(!empty($oldPic1) && $oldPic1 != $POST['thumb1']){
                    @unlink('.'.$oldPic1);
                }
                if(!empty($oldPic2) && $oldPic2 != $POST['thumb2']){
                    @unlink('.'.$oldPic2);
                }
                if(!empty($oldPic3) && $oldPic3 != $POST['$thumb3']){
                    @unlink('.'.$oldPic3);
                }
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'n','info'=>'操作失败!']);
            }
        }else{
            $id = input('id',0);
                #修改
                $row = $db->find($id);
        }

        $this->assign($row);
        #渲染模板
        return $this->fetch();
    }
    public function product_del(){
        $id = trim(input('id'),',');
        $ids = explode(',',$id);
        $db = Db::name('product');
        //查询缩略图和内容
        $data = $db->field('thumb,content')->where(array('id'=>array('in',$ids)))->select();
        $where['id'] = array('in',$id);
        $b = $db->where($where)->delete();

       $count = $db->count();
        if($b){
            foreach($data as $v){
                //删除缩略图
                if(!empty($v['thumb'])){
                    @unlink('.'.$v['thumb']);
                    @unlink('.'.$v['thumb1']);
                    @unlink('.'.$v['thumb2']);
                    @unlink('.'.$v['thumb3']);
                }
                //删除缩内容图片 ,属性，相册
                $content = htmlspecialchars_decode($v['content']);
                $imgs = get_img_src($content);
                if($imgs){
                    foreach($imgs as $img){
                        @unlink('.'.$img);
                    }
                }
            }
            //删除商品属性
//            Db::name('product_attr')->where(array('pro_id'=>array('in',$ids)))->delete();
//            //删除相册
//            $gallery = Db::name('gallery')->where(array('pro_id'=>array('in',$ids)))->select();
//            if(Db::name('gallery')->where(array('pro_id'=>array('in',$ids)))->delete()){
//                foreach($gallery as $v){
//                    @unlink('.'.$v['simg']);
//                    @unlink('.'.$v['bimg']);
//                }
//            }
            return json(array('status'=>'y','info'=>'删除成功^ ^','count'=>$count));
        }else{
            $this->ajaxReturn(array('status'=>'n','info'=>'删除失败!'));
        }
    }

    /* 回收站 */
    public function product_trash(){
        $id = trim(input('id'),',');
        $ids = explode(',',$id);
        $value = input('value',1);
        $db = Db::name('product');
        $b = $db->where(array('id'=>array('in',$ids)))->setField('is_delete',$value);
        if($value == 0){
            //多少条数据条件
            $where['is_delete'] = 1;
            $message = '还原成功^ ^';
        }else{
            $where['is_delete'] = 0;
            $message = '删除成功^ ^';
        }
        $count = $db->where($where)->count();
        if($b){
            $this->ajaxReturn(array('status'=>'y','info'=>$message,'count'=>$count));
        }else{
            $this->ajaxReturn(array('status'=>'n','info'=>$message));
        }
    }
    public function trash(){
        $db = Db::name('product');
        /* where 条件初始化 */
        $where['is_delete'] = 1; 
        /* 分类查询 */
    $category=Db::name('product_category')->where(array('is_show'=>1))->order('sort,cat_id desc')->select();
        $cat_id = input('cat_id');
        if($cat_id > 0){
            $children = get_children($category,$cat_id);
            $children[] = $cat_id;
            $where['cat_id'] = array('in',$children);
        }
        /* 关键词查询 */
        $word = input('word');
        if(!empty($word)){
            $where['name'] = array('like',"%$word%");
        }
        /* 日期查询 */
        $time_min = input('time_min');
        $time_max = input('time_max');
        
        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['insert_time'] = array('between',array($time_min,$time_max));
            }else{
                $where['insert_time'] = array('between',array($time_max,$time_min));
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['insert_time'] = array('between',array($time_min,$time_max));
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['insert_time'] = array('elt',$time_max);
        }
        // var_dump($where);

        $count = $db->where($where)->count();
        /* 分页 */
        $page = new \Think\Page($count,5);
        //->field('id,cat_id,name,insert_time,shop_price,is_recommend,is_sale,market_price,promote_price,promote_start,promote_end')查询全部
    $list = $db->where($where)->order('id desc')->limit($page->firstRow,$page->listRows)->select(); 
        $now = time();
        foreach($list as &$v){
                //本店价格
            $v['price'] = $v['shop_price'];
            /* 促销价 促销开始时间 结束时间 满足 */
            if($v['promote_price'] > 0 && $v['promote_start'] <= $now && $v['promote_end'] && $v['promote_end'] > $now){
                //促销价格
                $v['price'] = $v['promote_price'];
            }else{
                $v['promote_price'] = 0;
            }
        }
        /* 分配数据 */
        $this->assign('list',$list);
        $this->assign('page',$page->show());
        /* 无极分类 */
        $category = category_merge($category);
        $this->assign('category',$category);

        $this->assign('count',$count);
        return $this->fetch();
    }
    /* 产品相册 */
    public function gallery(){
        $db = Db::name('gallery');
        $pro_id = input('pro_id');
        $list = $db->where(array('pro_id'=>$pro_id))->select();
        /* 添加相册insert传递的pro_id */
        $this->assign('pro_id',$pro_id);
        $this->assign('list',$list);
        return $this->fetch();
    }
    public function gallery_del(){
        if(IS_POST){
            $id = trim(input('id'),',');
            $ids = explode(',',$id);
            $db = Db::name('gallery');
            $data = $db->field('id,simg,bimg')->select();
            $b = $db->where(array('id'=>array('in',$ids)))->delete();
            $count = $db->count();
            if($b){
                //删除图片
                foreach($data as $v){
                    if(in_array($v['id'],$ids)){
                        @unlink('.'.$v['simg']);
                        @unlink('.'.$v['bimg']);
                    }
                }
                $this->ajaxReturn(array('status'=>'y','info'=>'删除成功^ ^','count'=>$count));
            }else{
                $this->ajaxReturn(array('status'=>'n','info'=>'删除失败'));
            }
        }
    }

    /* 产品评价 */
    public function comment_list(){
        $where = [];
        $input = input('param.');
        $where['pro_id'] = $input['pro_id'];
        $list = Db::name('comment')->order('id DESC')->where($where)->paginate(10,flase,['query'=>request()->param()])->each(function($item){
            $item['username'] = Db::name('member')->column('username')[0];
            $item['add_time'] = date('Y-m-d H:i:s',$item['add_time']);
            return $item;
        });
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        $this->assign('count',Db::name('comment')->where($where)->count());
        return $this->fetch();
    }

}