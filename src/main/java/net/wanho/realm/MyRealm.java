package net.wanho.realm;

import net.wanho.pojo.Limit;
import net.wanho.pojo.User;
import net.wanho.service.RoleServiceI;
import net.wanho.service.UserServiceI;
import net.wanho.util.StringUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2019/7/30/030.
 */
@Component
public class MyRealm extends AuthorizingRealm {

    @Autowired
    private UserServiceI userServiceI;

    @Autowired
    private RoleServiceI roleServiceI;

    //授权
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
//        给当前对象赋予角色和权限

        //查数据库
        String username=principals.getPrimaryPrincipal().toString();
        List<Limit> limits = userServiceI.selectAllLimitsByUsername(username);
        List<String> permissions = new ArrayList<String>();

        SimpleAuthorizationInfo simpleAuthorizationInfo = new SimpleAuthorizationInfo();
        //有这个账户
        if(limits != null && limits.size()>0 ){
            //有权限
            //添加权限名
            for (Limit limit : limits) {
                if(limit != null ){
                    permissions.add(limit.getUrl());
                    simpleAuthorizationInfo.addStringPermissions(permissions);
                }

            }
        }
        return simpleAuthorizationInfo;
    }

    //认证
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        /*自定义认证,可以从数据库查
        获取账号*/
        String username = (String) token.getPrincipal();
//        获取密码
        String password =new String((char[]) token.getCredentials());

        //查数据库
        User user = userServiceI.selectUserByName(username);
        if(user == null){
            throw new UnknownAccountException("没有此账号");
        }
        if(user.getStatus()==0){
            throw new UnknownAccountException("此账号已被禁用");
        }
        if(user.getStatus()==2){
            throw new UnknownAccountException("此账号已被删除");
        }
//        取出用户密码,按照同样的方式进行比对
        if(!StringUtils.isNotEmpty(password)){
            throw new UnknownAccountException("没有密码");
        }
        if((user.getPassword()).equals(password)){
            throw new UnknownAccountException("密码不正确");
        }

        return new SimpleAuthenticationInfo(username,user.getPassword(), ByteSource.Util.bytes(user.getSalt()),getName());

    }
}
