package net.wanho.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * Created by Administrator on 2019/8/6/006.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class RegisterUserVo implements Serializable {
    private String username;
    private String password;
    private Boolean rememberMe;
}
