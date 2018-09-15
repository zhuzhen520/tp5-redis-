<?php
namespace app\admin\controller;
use think\Controller;
use think\Db;
use think\Config;
use think\File;
use think\Log;
use tp5er\Backup;

class Base extends Controller
{   
    public function _initialize(){

        if(!session('?adminid')){
            $this->redirect('Index/index');
        }
        $uid = session('adminid');
        $row = Db::name('admin')->find($uid);
        $this->assign('admin',$row);

        //生成左边菜单
        $menu = array();
        $group_id = Db::name('auth_group_access')->where(array('uid'=>$uid))->column('group_id');
        // dump($group_id);die; //角色
        if($group_id){
            $rules = Db::name('auth_group')->where(array('id'=>array('in',$group_id)))->column('rules');
            $tmp_arr = array();
            foreach($rules as $v){
                $tmp_arr = array_merge($tmp_arr,explode(',', $v));  
            }
            $tmp_arr = array_unique($tmp_arr); //登录用户的所有权限
            $menu = Db::name('auth_rule')->order('sort')->where(array('id'=>array('in',$tmp_arr)))->field('id,title,parent_id,name,param')->select();
            $menu = rule_tree($menu);
        }
        // echo '<pre>';
        // print_r($menu);
        $this->assign('menu',$menu);

        /* 进行权限管理 */

        if(Config::get('AUTH_CONFIG.AUTH_ON')){
            import('Auth', EXTEND_PATH);
            $auth = new \Think\Auth;

            $name = request()->module() . '/' . request()->controller() .'/'. request()->action();
            // echo $name;
            /* 不需要验证的控制器 */     
            if(!in_array(request()->controller(), Config::get('no_auth_controller'))){
                $res = $auth->check($name,$uid);

                if(!$res){

                    if( $this->request->isAjax() ){
                        return json(['status'=>'n','info'=>'没有操作权限']);
                    }else{
                        die("<h3 style='color:red;text-align: center; margin-top:200px;'>没有操作权限</h3>");
                    }
                }
            }
        }

        //操作日志
        $log_action = [  //需要记录的日志
            'member_add','product_add','static_config_add',
        ];
        if(in_array(request()->action(), $log_action) && input('post.')){
            Log::write(input('post.'), 'admin', true);
        }

    }

    /*切换显示*/
    public function toggle_status(){
        $id = input('id');
        $status = input('status');
        $table = input('table');
        $field = input('field');
        $db = Db::name($table);
        $pk = $db->getPk(); #获取主键名称
        $where[$pk] = $id;
        $b = $db->where($where)->setField($field,$status);
        echo $b?1:0;
    }

    /*上传图片*/
    public function uploadImg(){
        $file = request()->file('imgFile');
        if($file){
            #移动
            $info = $file->move(ROOT_PATH . 'public' . DS . 'uploads');
            if($info){
                return json(['error'=>0,'url'=>$info->getSaveName(),'title'=>$info->getSaveName()]);
            }else{
                // 上传失败获取错误信息
                echo $file->getError();
            }
        }
    }

    public function upload_banner($type){

        $file = request()->file('file');

        if($file){
            #移动
            $info = $file->move(ROOT_PATH . 'public' . DS . 'banner');
            if($info){
                $data = [
                    'image_path' => $info->getSaveName(),
                    'type'       => $type,
                    'add_time'   =>time()
                ];
                $b = Db::name('banner')->insert($data);
                return json(['error'=>0,'info'=>'上传成功']);
            }else{
                // 上传失败获取错误信息
                echo $file->getError();
            }
        }

    }
    public function upload_bannerp($type){

        $file = request()->file('file');

        if($file){
            #移动
            $info = $file->move(ROOT_PATH . 'public' . DS . 'banner');
            if($info){
                $image_path ='public' . DS . 'banner'.$info->getSaveName();
                return json(['error'=>0,'info'=>$image_path]);

            }else{
                // 上传失败获取错误信息
                echo $file->getError();
            }
        }

    }
    /*数据库备份*/
    public function databackupjson(){
        set_time_limit(300);
        $i = 1;
        $db = new Backup();
        $tables = $db->dataList();
        foreach ($tables as $key => $value) {
            $file = ['name' => "zengliangkeji" . date('Ymd'), 'part' => 1];
            $res = $db->setFile($file)->backup($value['name'], 0);
        }
        $db->downloadFile1($file['name'] . "-1");
    }
}