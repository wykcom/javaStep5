package net.wanho.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Created by Administrator on 2019/8/2/002.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Tree {
    private int id;
    private String name;
    private int pId;
    private int grade;
    //判断是否选中
    private boolean checked=false;
}
