package net.wanho.controller;

import com.fasterxml.jackson.annotation.JsonFormat;
import net.wanho.pojo.JsonResult;
import net.wanho.pojo.Limit;
import net.wanho.service.LimitServiceI;
import net.wanho.util.StringUtils;
import net.wanho.vo.Tree;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Created by Administrator on 2019/8/2/002.
 */
@Controller
@RequestMapping("toLimit")
public class LimitController {

    @Autowired
    private LimitServiceI limitServiceI;

    //查询角色权限
    @RequestMapping("selectAllLimitsByTree")
    @ResponseBody
    public JsonResult selectAll(@RequestParam("roleId") Integer roleId){
        JsonResult jsonResult = limitServiceI.selectAllLimits(roleId);
        return jsonResult;
    }

    //新增时查询一级二级权限
    @RequiresPermissions("limit:create")
    @RequestMapping("selectAddLimits")
    @ResponseBody
    public JsonResult selectAddLimits(){
        JsonResult jsonResult = limitServiceI.selectAddLimits();
        return jsonResult;
    }

    //修改角色权限
    @RequiresPermissions("role:update")
    @RequestMapping("updateLimits")
    @ResponseBody
    public JsonResult updateLimits(@RequestParam("limitIds") String limitIds){
        JsonResult jsonResult = limitServiceI.updateLimits(limitIds);
        return jsonResult;
    }

    //修改权限信息
    @RequiresPermissions("limit:update")
    @RequestMapping("updateLimitByLimitId")
    @ResponseBody
    public JsonResult updateLimitByLimitId(@RequestParam("limitId") Integer limitId,@RequestParam("limitname") String limitname,@RequestParam("url") String url){
        JsonResult jsonResult = limitServiceI.updateLimitByLimitId(limitId,limitname,url);
        return jsonResult;
    }

    //查询权限
    @RequestMapping("selectLimits")
    @ResponseBody
    public JsonResult selectLimits(@RequestParam(defaultValue = "0") Integer parentId){
        JsonResult jsonResult = limitServiceI.selectLimitsByParent(parentId);
        return jsonResult;
    }

    //查询权限名是否重名
    @RequestMapping("getLimitName")
    @ResponseBody
    public JsonResult getLimitName(@RequestParam("limitName") String limitName){
        JsonResult jsonResult = limitServiceI.selectLimitByLimitName(limitName);
        return jsonResult;
    }

    //删除权限
    @RequiresPermissions("limit:delete")
    @RequestMapping("deleteLimits")
    @ResponseBody
    public JsonResult deleteLimits(@RequestParam("limitId") Integer limitId,@RequestParam("parentId") Integer parentId){
        JsonResult jsonResult = limitServiceI.deleteLimitByLimitIdParentId(limitId,parentId);
        return jsonResult;
    }

    //新增权限
    @RequiresPermissions("limit:create")
    @RequestMapping("addLimit")
    @ResponseBody
    public JsonResult addLimit(@RequestParam("limitName") String limitName,@RequestParam("parentId") Integer parentId,@RequestParam("limitUrl") String limitUrl){
        JsonResult jsonResult = limitServiceI.addLimitByLimitIdParentId(limitName,parentId,limitUrl);
        return jsonResult;
    }
    //根据id查询单个权限
    @RequiresPermissions("limit:update")
    @RequestMapping("getLimit")
    @ResponseBody
    public JsonResult getLimit(@RequestParam("limitId") Integer limitId){
        JsonResult jsonResult = limitServiceI.selectLimitByLimitId(limitId);
        return jsonResult;
    }


}
