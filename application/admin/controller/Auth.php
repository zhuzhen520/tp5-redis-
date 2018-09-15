<?php
namespace app\admin\controller;
use think\Db;
use think\request;

class Auth extends Base{

    /* 菜单列表/权限 */
    public function rule(){
        $db = Db::name('auth_rule');
        $sort = input('post.sort/a'); //接收到的强制转arrar

        if(!empty($sort)){
            foreach($sort as $k=>$v){
                $v = intval($v);
                $db-> where(array('id'=>$k))->setField('sort',$v);
            }
        }

        $list = $db->order('sort')->select();
        $list = category_merge($list,0,0,'id');
        #print_r($list);
        $this->assign('list',$list);
        return $this->fetch();
    }
    public function rule_add(){
        $db = Db::name('auth_rule');
        $list = $db->order('sort')->select();

        if(Request::instance()->isPost()){
            #提交过程
            $data = input('post.');
            #print_r($data);die;
            #数据处理
            if(empty($data['name'])){
                $this->error('规则不能为空');die;
            }
            #操作方式
            if($_POST['id'] > 0){
                #不能把自己分到自己下级
                $children = get_children($list,$_POST['id'],'id');
                $children[] = $data['id'];
                #print_r($children);die;
                if(in_array($data['parent_id'], $children)){
                    $this->error('不能使用自己或下级作为为上级分类');die;
                }
                $b = $db->update($data);
            }else{
                $b = $db->insert($data);
            }
            #操作结果
            if($b !== flase){
                return json(array('status'=>'y','info'=>'操作成功'));
            }else{
                return json(array('status'=>'n','info'=>'操作失败'));
            }
        }else{
            #显示数据
            $id = input('id',0);
            if($id > 0){
                $row = $db->find($id);
            }else{
                #添加情况,默认显示
                $row['status'] = 1;
            }
            $this->assign($row);

            #无极分类
            $list = category_merge($list,0,0,'id');
            $this->assign('list',$list);
            // dump($list);

            return $this->fetch();
        }
    }
    public function rule_del(){
        $id = trim(input('id'),',');
        $db = Db::name('auth_rule');
        #删除
        $b = $db->delete($id);
        if($b){
            $list = $db->select();
            #查询下级
            $ids = explode(',', $id);
            $children = array();
            foreach($ids as $v){
                #查出传来的所有id的子分类
                $tmp = get_children($list,$v,'id');
                #集合
                $children = array_merge($children,$tmp);
            }
            if($children){
                $where['id'] = array('in',$children);
                $db->where($where)->delete();
            }
            $count = $db->count();
            return json(['status'=>'y','info'=>'删除成功^ ^','children'=>$children,'count'=>$count]);
        }else{
            return json(['status'=>'n','info'=>'删除失败* *']);
        }
    }

    /* 角色列表 */
    public function role(){
        $db = Db::name('auth_group');
        $list = $db->order('id desc')->select();
        foreach($list as $k=>$v){
            $users = '';
            $uid = Db::name('auth_group_access')->where(array('group_id'=>$v['id']))->column('uid',true);
            if($uid){
                $admin = Db::name('admin')->where(array('id'=>array('in',$uid)))->column('username',true);
                $users = implode('，', $admin);
            }
            $list[$k]['users'] = $users;
        }
        #print_r($list);
        $this->assign('list',$list);
        return $this->fetch();
    }
    /* 角色添加/修改 */
    public function role_add(){
        $db = Db::name('auth_group');

        if(Request::instance()->isPost()){
            #提交过程
            $data = input('post.');
            #print_r($data);die;
            #数据处理
            if(empty($data['title'])){
                return json(['status'=>'n','info'=>'角色名称为空']);
            }
            $data['rules'] = !empty($data['rules']) ? implode(',',$data['rules']) : '';

            #操作方式
            if($data['id'] > 0){
                $b = Db::name('auth_group')->update($data);
            }else{
                if(Db::name('auth_group')->field('id')->where('title',$data['title'])->find()){
                    return json(['status'=>'n','info'=>'角色名称不能重复']);
                }
                $b = Db::name('auth_group')->insert($data);
            }
            #操作结果
            if($b !== flase){
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'n','info'=>'操作失败']);
            }
        }else{
            #显示数据
            $id = input('id',0);
            if($id > 0){
                $row = $db->find($id);
                $row['rules'] = !empty($row['rules']) ? explode(',', $row['rules']) : array();
            }else{
                #添加情况,默认显示
                $row = array('status'=>1,'rules'=>array());
            }
            // dump($row);

            #所有的权限(权限菜单) 
            $rule = Db::name('auth_rule')->field('id,title,parent_id')->where(array('status'=>1))->order('sort')->select();
            #重新组装成树状
            $rule = rule_tree($rule);
            // echo '<pre>';
            // print_r($rule);
            $this->assign($row);
            $this->assign('rule',$rule);
            return $this->fetch();
        }
    }
    public function role_del(){
        $id = trim(input('id'),',');
        $db = Db::name('auth_group');
        #删除
        $b = Db::name('auth_group')->delete($id);
        if($b){
            return json(['status'=>'y','info'=>'删除成功']);
        }else{
            return json(['status'=>'n','info'=>'删除失败']);
        }
    }

    public function admin(){
        $db = Db::name('admin');
        $list = $db->order('id desc')->select();
        foreach($list as $k=>$v){
            $role = '';
            $group_id = Db::name('auth_group_access')->where(array('uid'=>$v['id']))->column('group_id',true);
            if($group_id){
                $group = Db::name('auth_group')->where(array('id'=>array('in',$group_id)))->column('title',true);
                $rule = implode('，', $group);
            }
            $list[$k]['roles'] = $rule;
        }
        #print_r($list);
        $this->assign('list',$list);
        return $this->fetch();
    }

    public function admin_add(){
        $db = Db::name('admin');

        if(Request::instance()->isPost()){
            
            #提交过程
            $data = input('post.');
            // print_r($data);die;
            $role = input('post.role/a');
            if(empty($role)){
                return json(['status'=>'n','info'=>'必须选择角色']);
            }
            #数据处理
            /* 添加 */
            if($data['id'] <= 0 && !empty($data['username'])){
                $c = $db->where(array('username'=>$data['username']))->column('id');
                if($c){
                    return json(['status'=>'n','info'=>'此账号已被使用']);
                }
            }
            if($data['id'] <= 0 && empty($data['username'])){
                return json(['status'=>'n','info'=>'账号不能为空']);
            }
            if($data['id'] <= 0 && empty($data['password'])){
                return json(['status'=>'n','info'=>'密码不能为空']);
            }
            if($data['id'] <= 0 && empty($data['nickname'])){
                return json(['status'=>'n','info'=>'昵称不能为空']);
            }

            /* 密码不空修改/或添加 */
            if(!empty($data['password'])){
                $data['entry'] = get_rand_str();
                $data['password'] = md5(md5($data['password']).md5($data['entry']));
            }else{
                unset($data['password']);
            }

            unset($data['role']);
            // print_r($data);die;
            #操作方式
            if($data['id'] > 0){
                $b = $db->update($data);
            }else{
                $b = $db->insert($data);
            }
            #操作结果
            if($b !== flase){
                /* 配置管理员的角色 */
                $uid = $data['id'] > 0 ? $data['id'] : $db->getLastInsID();
                #清空当前的角色信息
                Db::name('auth_group_access')->where(array('uid'=>$uid))->delete();
                $role_data = array();
                foreach($role as $v){
                    $role_data[] = array(
                        'uid' => $uid,
                        'group_id' => $v
                    );
                }
                Db::name('auth_group_access')->insertAll($role_data);
                return json(['status'=>'y','info'=>'操作成功']);
            }else{
                return json(['status'=>'n','info'=>'操作失败']);
            }
        }else{
            #显示数据
            $id = input('id',0);
            if($id > 0){
                $row = $db->find($id);
                /* 当前管理员拥有的角色 */
                $row['roles'] = Db::name('auth_group_access')->where(array('uid'=>$id))->column('group_id',true);
            }else{
                $row['roles'] = array();
            }
            
            /* 角色列表 */
            $role = Db::name('auth_group')->field('id,title')->where(array('status'=>1))->select();

            $this->assign($row);
            $this->assign('role',$role);
            return $this->fetch();
        }
    }
    public function admin_del(){
        $id = trim(input('id'),',');
        $ids = explode(',', $id);
        if(in_array(1,$ids)){
            return json(['status'=>'n','info'=>'不允许删除超级管理员']);
        }
        $b = Db::name('admin')->delete($id);
        if($b){
            Db::name('auth_group_access')->where(array('uid'=>array('in',$id)))->delete();
            return json(['status'=>'y','info'=>'删除成功']);
        }else{
            return json(['status'=>'n','info'=>'删除失败']);
        }
    }
    public function repeat(){
        //会员重复
        $repeat = input('repeat');
        if(!empty($repeat)){
            $b = Db::name('admin')->where(array('username'=>$repeat))->column('id');
            if($b){
                return json(['status'=>'n','此账号已经被使用']);
            }
        }
    }
}