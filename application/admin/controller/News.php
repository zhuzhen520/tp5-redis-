<?php
namespace app\admin\controller;
use think\Db;
use think\Request;
/**
* 新闻咨询
*/
class News extends Base
{
    
    /*咨询分类*/
    public function news_list(){
        $db = Db::name('news');
        /* where 条件初始化 */
        $where = array();
        /* 分类查询 */
        $category = Db::name('news_category')->where(array('is_show'=>1))->order('sort,cat_id desc')->select();
        $cat_id = input('cat_id');
        if($cat_id > 0){
            $children = get_children($category,$cat_id);
            $children[] = $cat_id;
            $where['cat_id'] = array('in',$children);
        }
        /* 关键词查询 */
        $word = input('word');
        if(!empty($word)){
            $where['title'] = array('like',"%$word%");
        }
        /* 日期查询 */
        $time_min = input('time_min');
        $time_max = input('time_max');
        
        if(!empty($time_max) && !empty($time_min)){
            $time_max = strtotime($time_max);
            $time_min = strtotime($time_min);
            /* 两个都填 between 范围内 */
            if($time_max >= $time_min){
                $where['publish_time'] = array('between',array($time_min,$time_max));
            }else{
                $where['publish_time'] = array('between',array($time_max,$time_min));
            }
        }elseif(!empty($time_min)){
            $time_min = strtotime($time_min);
            $time_max = !empty($time_max) ? strtotime($time_max) : time()+999999999;
            /* 只填开始时间 */
            $where['publish_time'] = array('between',array($time_min,$time_max));
        }elseif(!empty($time_max)){
            $time_max = strtotime($time_max);
            /* 只填结束时间 elt小于等于 */
            $where['publish_time'] = array('elt',$time_max);
        }
        // var_dump($where);

        $count = $db->where($where)->count();

        /* 分页 */
        $list = $db->field('id,cat_id,title,thumb,publish_time,is_recommend')->where($where)->order('id desc')->paginate(5);
        $this->assign('list',$list);
        $this->assign('page',$list->render());
        /* 无极分类 */
        $category = category_merge($category);
        $this->assign('category',$category);
        /* 总数据 */
        $this->assign('count',$count);
        return $this->fetch();
    }


    /*添加新闻*/
    public function news_add(){

        $db = Db::name('news');
        if(Request::instance()->isPost()){
            $data = input('post.');

            $data['is_recommend'] = $data['is_recommend'] ? : 0;
            $data['publish_time'] = strtotime($data['publish_time']);
            // print_r($data);die;
            #操作方式

            /* 修改了图片 */
            if(!empty($data['oldPic']) && $data['oldPic'] != $data['thumb']){
                @unlink('.'.$data['oldPic']);
            }
            unset($data['oldPic']);

            if($_POST['id'] > 0){
                #修改
                $b = $db->update($data);
            }else{
                #添加
                $b = $db->insert($data);
            }
            #结果
            if($b !== flase){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'n','info'=>'操作失败!']);
            }
        }else{
            $id = input('id',0);
            if($id > 0){
                #修改
                $row = $db->find($id);
                $row['publish_time'] = date('Y-m-d',$row['publish_time']);
            }else{
                #添加
                $row = array('publish_time'=>date('Y-m-d'));
            }
        }
        /* 分配数据 */
        #添加和修改需要的数据
        $this->assign($row);
        #分类选择
        $list = Db::name('news_category')->where(array('is_show'=>1))->order('sort,cat_id desc')->select();
        $list = category_merge($list);
        $this->assign('list',$list);

        return $this->fetch();
    }


    public function category(){
        $db = Db::name('news_category');
        #排序
        $sort = input('post.sort/a');
        if(!empty($sort)){
            foreach($sort as $k=>$v){
                $v = intval($v);
                $db-> where(array('cat_id'=>$k))->setField('sort',$v);
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
        $db = Db::name('news_category');
        #所有分类数据
        $list = Db::name('news_category')->order('sort,cat_id desc')->select();

        if(Request::instance()->isPost()){
            #提交过程
            $data = input('post.');
            #print_r($data);die;
            #数据处理
            if(empty($data['cat_name'])){
                return json(['status'=>'n','info'=>'分类名称不能为空']);
            }
            #操作方式
            if($_POST['cat_id'] > 0){
                #不能把自己分到自己下级
                $children = get_children($list,$_POST['cat_id']);
                $children[] = $data['cat_id'];
                #print_r($children);die;
                if(in_array($data['parent_id'], $children)){
                    return json(['status'=>'n','info'=>'不能使用自己或下级作为为上级分类']);
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
                return json(['status'=>'n','info'=>'操作失败']);
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
        $db = Db::name('news_category');
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
           return json(['status'=>'n','info'=>'删除失败']);
        }
    }

    public function news_del(){
        $id = trim(input('id'),',');
        $ids = explode(',',$id);
        $db = Db::name('news');
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
                }
                //删除缩内容图片
                $content = htmlspecialchars_decode($v['content']);
                $imgs = get_img_src($content);
                if($imgs){
                    foreach($imgs as $img){
                        @unlink('.'.$img);
                    }
                }
            }
            
            return json(['status'=>'y','info'=>'删除成功','count'=>$count]);
        }else{
            return json(['status'=>'n','info'=>'删除失败!']);
        }
    }

}