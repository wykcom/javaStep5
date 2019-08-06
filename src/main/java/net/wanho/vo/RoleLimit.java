package net.wanho.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Created by Administrator on 2019/8/3/003.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class RoleLimit {
    private String roleName;
    private String limitIds;
}
