package net.wanho.mapper;

import net.wanho.pojo.Limit;
import net.wanho.pojo.Role;
import net.wanho.pojo.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Created by Administrator on 2019/8/1/001.
 */

public interface LimitMapper {
    List<Limit> selectAllLimits();

    List<Limit> selectAllLimitsByParentId(Integer parentId);
    List<Integer> selectLimitsByRoleId(Integer roleId);
    List<Integer> selectLimitsByLimitId(Integer limitId);
    void deleteLimitsByRoleId(Integer roleId);
    void updateLimitByLimitId(Limit limit);

    Limit selectLimit(Integer limitId);
    void deleteLimitsByLimitId(Integer LimitId);
    void addLimitByLimitIdParentId(@Param("limitName") String limitName,@Param("parentId") Integer parentId,@Param("limitgrade") Integer limitgrade,@Param("url") String url);
    void addLimits(@Param("list") List<Integer> list,@Param("roleId") Integer roleId);

}
