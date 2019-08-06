package net.wanho.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import net.wanho.mapper.RoleMapper;
import net.wanho.mapper.UserMapper;
import net.wanho.pojo.JsonResult;
import net.wanho.pojo.Limit;
import net.wanho.pojo.Role;
import net.wanho.pojo.User;
import net.wanho.service.UserServiceI;
import net.wanho.util.StringUtils;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Administrator on 2019/8/1/001.
 */
@Service
public class UserServiceImpl implements UserServiceI {

    @Autowired
    private UserMapper userMapper;

    //查询全部用户
    @Override
    public PageInfo<User> selectAllUsersByPage(Integer pageNum) {
        PageHelper.startPage(pageNum,4);
        List<User> users = userMapper.selectAllUsersByPage();
        PageInfo<User> pageInfo = new PageInfo<User>(users);
        return pageInfo;
    }

    //查询全部角色
    @Override
    public PageInfo<Role> selectAllRolesByPage(Integer pageNum) {
        PageHelper.startPage(pageNum,4);
        List<Role> roles = userMapper.selectAllRoles();
        PageInfo<Role> pageInfo = new PageInfo<Role>(roles);
        return pageInfo;
    }

    //注册用户
    @Override
    public void addUser(User user1) {
        //判断用户是否为空
        if(user1 == null){
            throw new RuntimeException("参数为空");
        }
        User user = new User();
        user.setUsername(user1.getUsername());
        user.setPassword(user1.getPassword());
        //给新增用户加状态
        user.setStatus(1);
        //给新增用户加权限
        String salt = UUID.randomUUID().toString();
        user.setSalt(salt);
        user.setPassword(shiroMD5(user.getPassword(),salt));

        userMapper.addUser(user);
        //获取id
        Integer userId = user.getUserId();
        //为他添加普通员工角色
        userMapper.addUserRoleByUserId(userId,4);

    }

    public String shiroMD5(String password,String salt){
//      加密方式
        String hashAlgorithmName="MD5";
//        加密次数
        int hashIterations=2;
//        把salt转成ByteSource
        ByteSource saltSource = ByteSource.Util.bytes(salt);
        Object object = new SimpleHash(hashAlgorithmName, password, saltSource, hashIterations);
        return object.toString();
    }
    //根据用户姓名查找
    @Override
    public User selectUserByName(String username) {
      return userMapper.selectUserByName(username);
    }

    //查询全部权限
    @Override
    public List<Limit> selectAllLimitsByUsername(String username) {

        return userMapper.selectAllLimitsByUsername(username);
    }

    //    根据用户id查询角色
    @Override
    public JsonResult getRoleById(Integer userId) {
        //查询所有角色
        List<Role> roles = userMapper.selectAllRoles();
        List<Role> role2 = new ArrayList<Role>();

        //去除已删除和禁用的角色
        for (Role role : roles) {
            if(role.getStatus()==1){
                role2.add(role);
            }
        }
        //根据用户id查询他的角色
        List<Role> roleByUserId = userMapper.selectRoleByUserId(userId);

        //遍历,如果该用户有此角色,则设定flag为true
        for (Role role : roleByUserId) {
            for (Role role1 : role2) {
                if(role.getRoleId()==role1.getRoleId()){
                    role1.setFlag(true);
                    break;
                }
            }
        }
        JsonResult jsonResult = new JsonResult();
        jsonResult.setStatus(200);
        jsonResult.setMsg("查询成功");
        jsonResult.setObject(role2);

        return jsonResult;
    }

    //修改用户角色
    @Override
    public JsonResult updateRole(String roleIds) {

            String[] split = roleIds.split(",");
            Integer userId=0;
            List<Integer> roleId= new ArrayList<Integer>();
            JsonResult jsonResult = new JsonResult();
            for(int i=0;i<split.length;i++){
                //取出用户id
                if(i==(split.length-1)){
                    userId=Integer.parseInt(split[split.length-1]);
                }else{
                    if(StringUtils.isNotEmpty(split[i])){
                        //取出roleid
                        roleId.add(Integer.parseInt(split[i]));
                    }
                }
            }
            try {
                //删除用户原有角色
                userMapper.deleteRoleByUserId(userId);
                if(roleId != null && roleId.size()>0){
                    //新增用户角色
                    userMapper.addRoleByUserId(roleId,userId);
                }
                jsonResult.setStatus(200);
                jsonResult.setMsg("修改用户成功");
            } catch (Exception e) {
                e.printStackTrace();
            }


        return jsonResult;
    }

    //修改用户状态
    @Override
    public JsonResult updateUserByUserId(String userId) {
        JsonResult jsonResult = new JsonResult();
        //根据用户id查询原有状态
        User user = userMapper.selectUserByUserId(Integer.parseInt(userId));
        //根据用户原有状态修改
        Integer status=user.getStatus();
        if(status==2){
            jsonResult.setStatus(500);
            jsonResult.setMsg("该用户已删除");
        }else if(status==0){
            jsonResult.setStatus(500);
            jsonResult.setMsg("该用户已禁用");
        }else {
            status=0;
            userMapper.updateUserByUserId(Integer.parseInt(userId),status);
            jsonResult.setStatus(200);
            jsonResult.setMsg("禁用账户成功");
        }
        return jsonResult;
    }



    //删除用户
    @Override
    public JsonResult deleteUserByUserId(String userId) {
        JsonResult jsonResult = new JsonResult();
        if(StringUtils.isNotEmpty(userId)){
        //根据用户id查询原有状态
        User user = userMapper.selectUserByUserId(Integer.parseInt(userId));
        //根据用户原有状态修改
        Integer status=user.getStatus();
        if(status==2){
            jsonResult.setStatus(500);
            jsonResult.setMsg("用户已经删除");
        }else{
            userMapper.deleteUserByUserId(Integer.parseInt(userId));
            jsonResult.setStatus(200);
            jsonResult.setMsg("删除用户成功");
        }
        }
        return jsonResult;
    }


}
