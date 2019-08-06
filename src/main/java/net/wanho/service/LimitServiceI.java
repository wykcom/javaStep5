package net.wanho.service;

import net.wanho.pojo.JsonResult;
import net.wanho.pojo.Limit;
import net.wanho.vo.Tree;

import java.util.List;

/**
 * Created by Administrator on 2019/8/2/002.
 */
public interface LimitServiceI {
    JsonResult selectAllLimits(Integer roleId);
    JsonResult selectAddLimits();
    JsonResult updateLimitByLimitId(Integer limitId,String limitname,String url);
    JsonResult selectLimitByLimitId(Integer limitId);
    JsonResult selectLimitByLimitName(String limitName);
    JsonResult selectLimitsByParent(Integer parentId);
    JsonResult updateLimits(String limitIds);
    JsonResult deleteLimitByLimitIdParentId(Integer limitId,Integer parentId);
    JsonResult addLimitByLimitIdParentId(String limitName,Integer parentId,String limitUrl);
}
