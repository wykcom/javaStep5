package net.wanho.controller;

import net.wanho.pojo.JsonResult;
import net.wanho.service.RoleServiceI;
import net.wanho.vo.RoleLimit;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by Administrator on 2019/8/3/003.
 */
@Controller
@RequestMapping("toRole")
public class RoleController {

    @Autowired
    private RoleServiceI roleServiceI;


    //重名认证
    @RequestMapping("getRoleName")
    @ResponseBody
    public JsonResult getRoleName(@RequestParam("roleName") String roleName){
        JsonResult jsonResult = roleServiceI.getRoleName(roleName);
        return jsonResult;
    }

    //新增角色
    @RequiresPermissions("role:create")
    @RequestMapping("addRoleLimit")
    @ResponseBody
    public JsonResult addRoleLimit(@RequestParam("roleName") String roleName,@RequestParam("limitIds") String limitIds){
        JsonResult jsonResult = roleServiceI.addRoleLimit(roleName, limitIds);
        return jsonResult;
    }

    //禁用角色
    @RequiresPermissions("role:update")
    @RequestMapping("toFobidRole")
    @ResponseBody
    public JsonResult toFobidRole(@RequestParam("roleId") String roleId){
        JsonResult jsonResult = roleServiceI.updateRoleByRoleId(roleId);

        return  jsonResult;
    }

    //删除角色
    @RequiresPermissions("role:delete")
    @RequestMapping("toDelRole")
    @ResponseBody
    public JsonResult toDelRole(@RequestParam("roleId") String roleId){
        JsonResult jsonResult = roleServiceI.deleteRoleByRoleId(roleId);

        return  jsonResult;
    }
}
