package net.wanho.service.impl;

import net.wanho.mapper.LimitMapper;
import net.wanho.mapper.RoleMapper;
import net.wanho.pojo.JsonResult;
import net.wanho.pojo.Role;
import net.wanho.service.RoleServiceI;
import net.wanho.util.Convert;
import net.wanho.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

/**
 * Created by Administrator on 2019/8/3/003.
 */
@Service
public class RoleServiceImpl implements RoleServiceI {

    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private LimitMapper limitMapper;
    //查看是否重名
    @Override
    public JsonResult getRoleName(String roleName) {
        JsonResult jsonResult = new JsonResult();
        if(StringUtils.isNotEmpty(roleName)){
            Role role = roleMapper.getRoleName(roleName);
            if(role != null && role.getStatus()!=2){
                jsonResult.setStatus(500);
                jsonResult.setMsg("角色名已存在");
            }else{
                jsonResult.setStatus(200);
                jsonResult.setMsg("该角色名可以使用");
            }

        }
        return jsonResult;
    }

    //新增角色和权限
    @Override
    public JsonResult addRoleLimit(String roleName, String limitIds) {
        //判断角色是否为逻辑删,有则删除
        Role roleOld = roleMapper.getRoleName(roleName);
        if(roleOld != null){
            //删除角色 真删
            roleMapper.deleteRoleByRoleIdTrue(roleOld.getRoleId());
            //删除原有角色和权限表
            limitMapper.deleteLimitsByRoleId(roleOld.getRoleId());
        }
        JsonResult jsonResult = new JsonResult();
        Role role = new Role();
        role.setRolename(roleName);
        role.setStatus(1);
        //新增角色
        roleMapper.addRole(role);
        //获取新增角色的id
        Integer roleId=role.getRoleId();
        if(StringUtils.isNotEmpty(limitIds)){
            //新增权限
            //去除末尾","
            StringUtils.trimEndComma(new StringBuilder(limitIds));
            //转成integer数组
            Integer[] integers = Convert.toIntArray(",", limitIds);
            List<Integer> list =Arrays.asList(integers);
            try {
                limitMapper.addLimits(list,roleId);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        jsonResult.setStatus(200);
        jsonResult.setMsg("新增角色成功");
        return jsonResult;
    }

    //修改角色状态
    @Override
    public JsonResult updateRoleByRoleId(String roleId) {
        JsonResult jsonResult = new JsonResult();
        //根据角色id查询是否有用户在使用
        List<Integer> list = roleMapper.selectUserRoleByRoleId(Integer.parseInt(roleId));
        if(list != null && list.size()>0){
            jsonResult.setStatus(500);
            jsonResult.setMsg("该角色已有用户在使用,不准禁用!!!!");
        }else{
            //根据角色id查询原有状态
            Role role = roleMapper.selectRoleByRoleId(Integer.parseInt(roleId));
            //根据用户原有状态修改
            Integer status=role.getStatus();
            if(status==2){
                jsonResult.setStatus(500);
                jsonResult.setMsg("该角色已删除");
            }else if(status==0){
                jsonResult.setStatus(500);
                jsonResult.setMsg("该角色已禁用");
            }else {
                status=0;
                roleMapper.updateRoleByRoleId(Integer.parseInt(roleId),status);
                jsonResult.setStatus(200);
                jsonResult.setMsg("禁用角色成功");
            }
        }
        return jsonResult;
    }

    //删除角色
    @Override
    public JsonResult deleteRoleByRoleId(String roleId) {
        JsonResult jsonResult = new JsonResult();
        //根据角色id查询是否有用户在使用
        List<Integer> list = roleMapper.selectUserRoleByRoleId(Integer.parseInt(roleId));
        if(list != null && list.size()>0){
            jsonResult.setStatus(500);
            jsonResult.setMsg("该角色已有用户在使用,不准删除!!!!");
        }else{
            //根据角色id查询原有状态
            Role role = roleMapper.selectRoleByRoleId(Integer.parseInt(roleId));
            //根据用户原有状态修改
            Integer status=role.getStatus();
            if(status==2){
                jsonResult.setStatus(500);
                jsonResult.setMsg("该角色已删除");
            }else {
                roleMapper.deleteRoleByRoleId(Integer.parseInt(roleId));
                jsonResult.setStatus(200);
                jsonResult.setMsg("删除角色成功");
            }
        }
        return jsonResult;

    }
}
