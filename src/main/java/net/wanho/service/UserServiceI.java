package net.wanho.service;

import com.github.pagehelper.PageInfo;
import net.wanho.pojo.JsonResult;
import net.wanho.pojo.Limit;
import net.wanho.pojo.Role;
import net.wanho.pojo.User;

import java.util.List;


/**
 * Created by Administrator on 2019/8/1/001.
 */
public interface UserServiceI {

    PageInfo<User> selectAllUsersByPage(Integer pageNum);
    PageInfo<Role> selectAllRolesByPage(Integer pageNum);

    void addUser(User user);
    User selectUserByName(String username);
    List<Limit> selectAllLimitsByUsername(String username);

    JsonResult getRoleById(Integer userId);
    JsonResult updateRole(String roleIds);


    JsonResult updateUserByUserId(String userId);



    JsonResult deleteUserByUserId(String userId);

}
