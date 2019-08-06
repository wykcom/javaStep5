package net.wanho.service.impl;

import net.wanho.mapper.LimitMapper;
import net.wanho.mapper.RoleMapper;
import net.wanho.pojo.JsonResult;
import net.wanho.pojo.Limit;
import net.wanho.service.LimitServiceI;
import net.wanho.util.Convert;
import net.wanho.util.StringUtils;
import net.wanho.vo.Tree;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2019/8/2/002.
 */
@Service
public class LimitServiceImpl implements LimitServiceI {


    @Autowired
    private LimitMapper limitMapper;

    @Autowired
    private RoleMapper roleMapper;

    //树形展示数据
    @Override
    public JsonResult selectAllLimits(Integer roleId) {
        JsonResult jsonResult = new JsonResult();
        //根据角色id查询是否有用户在使用
        List<Integer> list = roleMapper.selectUserRoleByRoleId(roleId);
        if(list != null && list.size()>0){
            jsonResult.setStatus(500);
            jsonResult.setMsg("该角色已有用户在使用,不准修改!!!!");
        }else{
            //查询全部权限
            List<Limit> limits = limitMapper.selectAllLimits();
            //根据roleId查询权限
            List<Integer> limitId = new ArrayList<Integer>();
            if(StringUtils.isNotEmpty(roleId)){
                limitId = limitMapper.selectLimitsByRoleId(roleId);
            }
            List<Tree> treeList = new ArrayList<Tree>();
            for (int i = 0; i < limits.size(); i++) {
                Tree tree = new Tree();
                tree.setId(limits.get(i).getLimitId());
                tree.setName(limits.get(i).getLimitname());
                tree.setPId(limits.get(i).getParentId());
                tree.setGrade(limits.get(i).getLimitgrade());
                //如果该roleId有权限,设置选中
                if(limitId != null && limitId.size()>0 ){
                    for (Integer id : limitId) {
                        if(id==limits.get(i).getLimitId()){
                            tree.setChecked(true);
                        }
                    }
                }
                treeList.add(tree);
            }
            jsonResult.setStatus(200);
            jsonResult.setMsg("查询成功");
            jsonResult.setObject(treeList);
        }

        return jsonResult;
    }

    //查询一级二级权限
    @Override
    public JsonResult selectAddLimits() {
        //查询全部权限
        List<Limit> limits = limitMapper.selectAllLimits();
        List<Tree> treeList = new ArrayList<Tree>();
        //添加一级二级权限
        for (int i = 0; i < limits.size(); i++) {
            if(limits.get(i).getLimitgrade()!=3){
                Tree tree = new Tree();
                tree.setId(limits.get(i).getLimitId());
                tree.setName(limits.get(i).getLimitname());
                tree.setPId(limits.get(i).getParentId());
                treeList.add(tree);
            }
        }
        //查询成功
        JsonResult jsonResult = new JsonResult();
        jsonResult.setStatus(200);
        jsonResult.setMsg("查询成功");
        jsonResult.setObject(treeList);
        return jsonResult;
    }

    //修改权限信息
    @Override
    public JsonResult updateLimitByLimitId(Integer limitId, String limitname, String url) {
        Limit limit = new Limit();
        limit.setLimitId(limitId);
        limit.setLimitname(limitname);
        limit.setUrl(url);
        JsonResult jsonResult = new JsonResult();
                limitMapper.updateLimitByLimitId(limit);
                jsonResult.setStatus(200);
                jsonResult.setMsg("权限修改成功");
        return jsonResult;


    }

    //根据id查询单个角色
    @Override
    public JsonResult selectLimitByLimitId(Integer limitId) {
        JsonResult jsonResult = new JsonResult();
        //先判断该权限是否包含子权限
        List<Integer> list = new ArrayList<Integer>();
        //取出limitId集合
        List<Integer> limitIdList = selectLimit(limitId, list);
        //判断这些集合中是否有与角色关联的
        for (Integer integer : limitIdList) {
            List<Integer> list2 = limitMapper.selectLimitsByLimitId(integer);
            if(list2 != null && list2.size()>0){
                jsonResult.setStatus(500);
                jsonResult.setMsg("该权限已有角色与之关联,不能修改");
                break;
            }
        }
        //判断jsonResult是否为空,为空则代表没有与角色关联,可以修改
        if(jsonResult.getMsg() == null){
            Limit limit = limitMapper.selectLimit(limitId);
            if(limit != null){
                jsonResult.setStatus(200);
                jsonResult.setMsg("查询成功");
                jsonResult.setObject(limit);
            }
        }
        return jsonResult;
    }

    //查询权限名是否重名
    @Override
    public JsonResult selectLimitByLimitName(String limitName) {

        JsonResult jsonResult = new JsonResult();

        if(StringUtils.isNotEmpty(limitName)){
            //查询全部权限
            List<Limit> limits = limitMapper.selectAllLimits();
            for (Limit limit : limits) {
                if(limitName.equals(limit.getLimitname())){
                    jsonResult.setStatus(500);
                    jsonResult.setMsg("权限名重复");
                    break;
                }
            }
            //如果jsonresult的setmsg为空
            if(jsonResult.getMsg() == null){
                jsonResult.setStatus(200);
                jsonResult.setMsg("权限名可以使用");
            }
        }
        return jsonResult;
    }

    //查询权限
    @Override
    public JsonResult selectLimitsByParent(Integer parentId) {
        JsonResult jsonResult = new JsonResult();

        try {
            List<Limit> limits = limitMapper.selectAllLimitsByParentId(parentId);
            jsonResult.setStatus(200);
            jsonResult.setMsg("查询成功");
            jsonResult.setObject(limits);
        } catch (Exception e) {
            e.printStackTrace();
        }


        return jsonResult;
    }

    //修改角色权限
    @Override
    public JsonResult updateLimits(String limitIds) {
        //用工具类将roleIds转换成integer数组
        Integer[] integers = Convert.toIntArray(",", limitIds);
        //权限集合
        List<Integer> list = new ArrayList<Integer>();
        //角色id
        Integer roleId=0;
        for(int i=0;i<integers.length;i++){
            //删除角色权限
            if(i==integers.length-1){
                roleId=integers[i];
                limitMapper.deleteLimitsByRoleId(integers[i]);
            }else{
                list.add(integers[i]);
            }
        }
        JsonResult jsonResult = new JsonResult();
        //新增角色权限
        try {
            if(list.size()>0 && list != null){
                limitMapper.addLimits(list,roleId);
            }
            jsonResult.setStatus(200);
            jsonResult.setMsg("修改权限成功");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jsonResult;
    }

    //删除权限
    @Override
    public JsonResult deleteLimitByLimitIdParentId(Integer limitId, Integer parentId) {
        JsonResult jsonResult = new JsonResult();
        //先判断该权限是否包含子权限
        List<Integer> list = new ArrayList<Integer>();
        //取出limitId集合
        List<Integer> limitIdList = selectLimit(limitId, list);
        //判断这些集合中是否有与角色关联的
        for (Integer integer : limitIdList) {
            List<Integer> list2 = limitMapper.selectLimitsByLimitId(integer);
            if(list2 != null && list2.size()>0){
                jsonResult.setStatus(500);
                jsonResult.setMsg("该权限已有角色与之关联,不能删除");
                break;
             }
        }
        //判断jsonResult是否为空,为空则代表没有与角色关联,可以删除
        if(jsonResult.getMsg() == null){
            for (Integer integer : limitIdList) {
                limitMapper.deleteLimitsByLimitId(integer);
            }
            jsonResult.setStatus(200);
            jsonResult.setMsg("权限删除成功");
        }
        return jsonResult;

    }

    //新增权限
    @Override
    public JsonResult addLimitByLimitIdParentId(String limitName, Integer parentId,String limitUrl) {

        JsonResult jsonResult = new JsonResult();
        if(StringUtils.isNotEmpty(limitName)){
            //查询权限等级
            Integer grade=1;
            if(parentId==0){
                grade=1;
            }else{
                Limit limit = limitMapper.selectLimit(parentId);
                grade=limit.getLimitgrade();
                grade=grade+1;
            }
            limitMapper.addLimitByLimitIdParentId(limitName,parentId,grade,limitUrl);
            jsonResult.setStatus(200);
            jsonResult.setMsg("新增权限成功");
        }

        return jsonResult;
    }

    //递归查询
    public List<Integer> selectLimit(Integer limitId,List<Integer> list){
        Integer flag=0;
        list.add(limitId);
        //查询该权限是否有子权限
        List<Limit> limits = limitMapper.selectAllLimitsByParentId(limitId);
        if(limits == null){
//            结束
        }else {
//            如果该limitId作为父id,则查询
            for (Limit limit : limits) {
                selectLimit(limit.getLimitId(),list);
            }
        }
        return list;
    }

}
