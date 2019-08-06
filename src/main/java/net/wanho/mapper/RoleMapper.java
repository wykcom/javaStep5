package net.wanho.mapper;

import net.wanho.pojo.Role;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Created by Administrator on 2019/8/3/003.
 */
public interface RoleMapper {
    Role getRoleName(String roleName);
    void addRole(Role role);
    Role  selectRoleByRoleId(Integer roleId);
    List<Integer>  selectUserRoleByRoleId(Integer roleId);
    void  updateRoleByRoleId(@Param("roleId") Integer roleId, @Param("status") Integer status);
    void  deleteRoleByRoleId(Integer roleId);
    void  deleteRoleByRoleIdTrue(Integer roleId);


}
