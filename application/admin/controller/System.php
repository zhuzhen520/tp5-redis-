<?php
namespace app\admin\controller;
use think\Db;
use think\Request;
use think\Config;
use tp5er\Backup;

class System extends Base{
        public function config(){
        $db = Db::name('config');
        if(Request::instance()->isPost()){
            $base = input('post.base/a');
            $reward = input('post.reward/a');
            $static = input('post.static/a');
            $message = input('post.message/a');
            $rate = input('post.rate/a');
            $data = [];

            foreach($base as $bk=>$bv){
                $data[] = array(
                    'name' => $bk,
                    'value' => $bv,
                    'type' => 'base'
                );
            }
            foreach($reward as $rk=>$rv){
                $data[] = array(
                    'name' => $rk,
                    'value' => $rv,
                    'type' => 'reward'
                );
            }

            foreach($message as $sk=>$sv){
                $data[] = array(
                    'name' => trim($sk),
                    'value' =>trim($sv),
                    'type' => 'message'
                );
            }
            foreach($rate as $sk=>$sv){
                $data[] = array(
                    'name' => trim($sk),
                    'value' =>trim($sv),
                    'type' => 'rate'
                );
            }
            foreach($static as $sk=>$sv){
                $data[] = array(
                    'name' => $sk,
                    'value' => $sv,
                    'type' => 'static'
                );
            }

            foreach($data as $v){
                $row = $db->where(array('name'=>$v['name'],'type'=>$v['type']))->find();
                if(!empty($row)){
                    $v['id'] = $row['id'];
                    $db->update($v);
                }else{
                    $db->insert($v);
                }
            }

            if(!empty($_POST['oldlogo']) && $_POST['oldlogo'] != $base['logo']){
                @unlink('.'.$_POST['oldlogo']);
            }
            if(!empty($_POST['oldimg']) && $_POST['oldimg'] != $water['img']){
                @unlink('.'.$_POST['oldimg']);
            }

            return json(['status'=>'y','info'=>'操作成功']);
        }else{
            $role = Config::get('role');
            $base = get_config('base');
            $reward = get_config('reward');
            $static = get_config('static');
            $message = get_config('message');
            $rate = get_config('rate');
            $this->assign('base',$base);
            $this->assign('role',$role);
            $this->assign('reward',$reward);
            $this->assign('static',$static);
            $this->assign('rate',$rate);
            $this->assign('message',$message);
            return $this->fetch();
        }
    }

    /* banner */
    public function banner(){
        $list = Db::name('banner')->order('type,id')->select();
        $this->assign('list',$list);
        return $this->fetch();
    }

    public function banner_add(){
        return $this->fetch();
    }
    public function banner_del(){
        if(Request::instance()->isPost()){
            $id = trim(input('post.id'));
            $list = Db::name('banner')->where(['id'=>['in',$id]])->select();
            foreach($list as $v){
                $path = './banner/'.$v['image_path'];
                $b = unlink($path); //删
            }
            Db::name('banner')->delete($id);
            if($b){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'n','info'=>'删除失败']);
            }
        }
    }

    /*客服*/
    public function kefu(){
        $list = Db::name('kefu')->order('type,id')->select();
        $this->assign('list',$list);
        return $this->fetch();
    }

    public function kefu_add(){
        $db = Db::name('kefu');
        if(Request::instance()->isPost()){
            #提交过程
            $data = input('post.');
            $data['add_time']=time();
            #数据处理
            if(empty($data['title'])){
                return json(['status'=>'n','info'=>'客服名称不能为空']);
            }
            $db->insert($data);
            #操作结果
            if($b !== flase){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'n','info'=>'操作失败']);
            }
        }else{
            return $this->fetch();
        }
    }
    public function kefu_del(){
        if(Request::instance()->isPost()){
            $id = trim(input('id'),',');
            $ids = explode(',',$id);
            $list = Db::name('kefu')->where('id','in',$ids)->select();
            foreach($list as $v){
                $path = ''.$v['thumb'];
                $b = unlink($path); //删
            }
            $b=Db::name('kefu')->delete($id);
            if($b){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'n','info'=>'删除失败']);
            }
        }
    }
    /*静态规则*/
    public function static_config(){
        $input = input('get.');
        $type = input('type','1');
        $where = [];
        if($type){
            $where['type'] = $type;
        }

        $list = Db::name('static_config')->order('gold_lt')->where($where)->select();
        $this->assign('list',$list);
        return $this->fetch();
    }

    public function static_config_add(){
        $db = Db::name('static_config');
        if(Request::instance()->isPost()){
            $data = input('post.');
            if($data['id'] > 0){
                $b = $db->update($data);
            }else{
                $b = $db->insert($data);
            }
            return json(['status'=>$b?'y':'n','info'=>$b?'操作成功':'操作失败']);
        }else{

            $row = $db->where(['id'=>input('id')])->find($id);
            $this->assign($row);
            return $this->fetch();
        }
    }

    /* 留言管理 */
    public function message(){
        $input = input('param.');
        // print_r($input);

        $where = [];

        if(isset($input['state'])){
            $where['state'] = $input['state'];
        }

        $list = Db::name('message')->where($where)->paginate(10);
        $count = Db::name('message')->where($where)->count();
        $this->assign('list',$list);
        $this->assign('count',$count);
        $this->assign('page',$list->render());
        return $this->fetch();
    }

    /* 留言回复 */
    public function message_add(){
        $data = input('param.');
        if(Request::instance()->isPost()){
            $data['admin_id'] = session('adminid');
            $b = Db::name('message')->where(['id'=>$data['id']])->update($data);
            if($b){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'n','info'=>'操作成功']);
            }
        }else{
            $this->assign('id',$data['id']);
            return $this->fetch();
        }
        
    }

    /* 留言提醒 */
    public function message_count(){
        $count = Db::name('message')->where(['state'=>0])->count();
        return json(['status'=>'y','count'=>$count < 99 ? $count : '99+']);
    }

    public function message_del(){
        $b = Db::name('message')->delete(input('id'));
        if($b){
            return json(['status'=>'y','info'=>'删除成功']);
        }else{
            return json(['status'=>'n','info'=>'删除失败']);
        }
    }

    /* 发现 */
    public function info(){
        $list = Db::name('system_info')->select();
        $this->assign('list',$list);
        return $this->fetch();
    }

    public function info_add(){
        if(Request()->instance()->isPost()){}
    }

    /* 操作日志 */
    public function action_log(){
        
    }
    /*数据库备份*/
    public function databackup(){
        return $this->fetch();
    }
}