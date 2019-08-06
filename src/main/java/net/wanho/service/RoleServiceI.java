package net.wanho.service;

import net.wanho.pojo.JsonResult;

/**
 * Created by Administrator on 2019/8/3/003.
 */
public interface RoleServiceI {
    JsonResult getRoleName(String roleName);
    JsonResult addRoleLimit(String roleName,String limitIds);
    JsonResult updateRoleByRoleId(String roleId);
    JsonResult deleteRoleByRoleId(String roleId);
}
