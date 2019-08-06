package net.wanho.controller;

import com.github.pagehelper.PageInfo;
import net.wanho.pojo.JsonResult;
import net.wanho.pojo.Role;
import net.wanho.pojo.User;
import net.wanho.service.UserServiceI;
import net.wanho.vo.RegisterUserVo;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.Enumeration;
import java.util.Map;

/**
 * Created by Administrator on 2019/8/1/001.
 */
@Controller
@RequestMapping("login")
public class UserController {

    @Autowired
    private UserServiceI userServiceI;



    //跳转登录界面
    @RequestMapping("toLogin")
    public String  toLogin(HttpSession session){
       session.getAttribute("username");
        return "login";
    }
//


    //跳转到注册界面
    @RequestMapping("toRegister")
    public String  toRegister(){
        return "register";
    }


    //跳转到用户界面
    @RequiresPermissions("user:select")
    @RequestMapping("toUserList")
    public String  toUserList(@RequestParam(defaultValue = "1") Integer pageNum,Map map){
        PageInfo<User> pageInfo = userServiceI.selectAllUsersByPage(pageNum);
        map.put("pageInfo",pageInfo);
        return "userList";
    }


    //跳转到权限界面
    @RequiresPermissions("limit:select")
    @RequestMapping("toLimitList")
    public String  toLimitList(){
        return "limitList";
    }


    //跳转到角色界面
    @RequiresPermissions("role:select")
    @RequestMapping("toRoleList")
    public String  toRoleList(@RequestParam(defaultValue = "1") Integer pageNum,Map map){
        PageInfo<Role> pageInfo = userServiceI.selectAllRolesByPage(pageNum);
        map.put("pageInfo",pageInfo);
        return "roleList";
    }

    //登录
    @RequestMapping("check")
    @ResponseBody
    public JsonResult  check(@RequestBody RegisterUserVo user,HttpSession session){
        Subject subject = SecurityUtils.getSubject();
        JsonResult jsonResult = new JsonResult();
        if (user != null){
            UsernamePasswordToken token = new UsernamePasswordToken(user.getUsername(),user.getPassword(),user.getRememberMe());
            try {
                subject.login(token);
                jsonResult.setStatus(200);
                jsonResult.setMsg("登录成功");
                session.setAttribute("username",user.getUsername());
            } catch (UnknownAccountException e) {
                e.printStackTrace();
                jsonResult.setStatus(500);
                jsonResult.setMsg("账号密码错误或账号状态异常");
            }
        }else{
            jsonResult.setStatus(500);
            jsonResult.setMsg("不能输入空值");
        }
        return jsonResult;
    }

    //注册用户
    @RequestMapping("register")
    public String  register(User user){
        //重定向地址
        String viewName="fail";
        try {
            userServiceI.addUser(user);
            viewName="redirect:toLogin";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return viewName;
    }

    //查询是否有此用户
    @PostMapping("getUsername")
    @ResponseBody
    public Integer getUsername(@RequestParam("username") String username){
        Integer integer=0;
        try {
            User user = userServiceI.selectUserByName(username);
            if(user != null){
                integer=1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return integer;
    }

    //用户页面取得角色信息
    @RequiresPermissions("user:update")
    @RequestMapping("getRoleById")
    @ResponseBody
    public JsonResult getRoleById(@RequestParam("userId") Integer userId){

        return  userServiceI.getRoleById(userId);
    }

    //修改用户角色信息
    @RequiresPermissions("user:update")
    @RequestMapping("toUpdate")
    @ResponseBody
    public JsonResult toUpdate(@RequestParam("roleIds") String roleIds){

        return  userServiceI.updateRole(roleIds);
    }


    //修改用户状态
    @RequiresPermissions("user:update")
    @RequestMapping("toFobidUser")
    @ResponseBody
    public JsonResult toFobidUser(@RequestParam("userId") String userId){
        JsonResult jsonResult = userServiceI.updateUserByUserId(userId);

        return  jsonResult;
    }


    //删除用户
    @RequiresPermissions("user:delete")
    @RequestMapping("toDelUser")
    @ResponseBody
    public JsonResult toDelUser(@RequestParam("userId") String userId){
        JsonResult jsonResult = userServiceI.deleteUserByUserId(userId);

        return  jsonResult;
    }




    //跳转到测试界面
//    @RequestMapping("toTest")
//    public String  toTest(){
//        return "test1";
//    }

}
