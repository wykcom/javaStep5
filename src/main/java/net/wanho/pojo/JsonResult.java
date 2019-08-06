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
public class JsonResult {
//    200 成功  500失败
    private Integer status;
    private String msg;
    private Object object;
}
