<?php
namespace app\api\controller;
use think\Db;
use think\Request;
/**
* 首页资讯
*/
class News extends Base
{   
    //资讯列表
    public function index(){
        $news_model = new \app\api\model\News;
        $where = [];

        //分类
        switch ($this->POST['cat_type']) {
            case 'notice':
                $notice = get_config('base','notice');
                return json(['status'=>'y','notice'=>$notice]);
            break;
            case 'zll':
                $catgory = Db::name('news_category')->where(['note'=>'zll'])->find();
            break;
            case 'qkl':
                $catgory = Db::name('news_category')->where(['note'=>'qkl'])->find();
            break;
            case 'jr':
                $catgory = Db::name('news_category')->where(['note'=>'jr'])->find();
            break;
            default:
                $catgory = Db::name('news_category')->where(['note'=>'zll'])->find();
            break;

        }

        //分类
        if(isset($catgory)){
            $where['cat_id'] = $catgory['cat_id'];
        }
        //推荐
        if($this->POST['recommend']){
            $where['is_recommend'] = 1;
        }
        $catgory_list=Db::name('news_category')->select();
        $news_list = $news_model->where($where)->paginate(5);
        $this->data['news_catgory'] = $catgory_list;
        $this->data['news_list'] = $news_list;


        //返回
        return json($this->data);
    }
//资讯列表
    public function category(){
        $news_model = new \app\api\model\News;
        $where = [];
        //推荐
        if($this->POST['cat_id']){
            $where['cat_id'] = $this->POST['cat_id'];
        }

        $news_list = $news_model->where($where)->paginate(5);
        $this->data['news_list'] = $news_list;
        //返回
        return json($this->data);
    }
    public function details(){
        $news = Db::name('news')->where(['id'=>$this->POST['news_id']])->find();
        $news['publish_time'] = date('Y-m-d H:i',$news['publish_time']);
        $this->data['news'] = $news;
        return json($this->data);
    }
    
}