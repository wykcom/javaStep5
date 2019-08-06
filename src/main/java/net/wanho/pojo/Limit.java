package net.wanho.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Created by Administrator on 2019/8/2/002.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Limit {
    private Integer limitId;
    private String limitname;
    private Integer parentId;

    //权限等级
    private Integer limitgrade;
    //权限
    private String url;
}
