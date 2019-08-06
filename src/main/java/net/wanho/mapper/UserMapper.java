package net.wanho.mapper;

import net.wanho.pojo.Limit;
import net.wanho.pojo.Role;
import net.wanho.pojo.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Created by Administrator on 2019/8/1/001.
 */

public interface UserMapper {
    List<User> selectAllUsersByPage();
    void addUser(User user);
    void addUserRoleByUserId(@Param("userId") Integer userId,@Param("roleId") Integer roleId);
    User selectUserByName(String username);
    List<Limit> selectAllLimitsByUsername(String username);
    List<Role> selectAllRoles();
    List<Role> selectRoleByUserId(Integer userId);
    void  deleteRoleByUserId(Integer userId);

    void  deleteUserByUserId(Integer userId);



    void  updateUserByUserId(@Param("userId") Integer userId,@Param("status") Integer status);

    User  selectUserByUserId(Integer userId);

    void addRoleByUserId(@Param("list") List<Integer> list,@Param("userId") Integer userId);

}
