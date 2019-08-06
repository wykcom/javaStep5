

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登陆</title>
    <link rel="icon" href="/img/2.ico" type="image/x-icon" >
    <script type="application/javascript" src="/js/jquery-1.10.2.js"></script>
    <script type="application/javascript" src="/js/jqPaginator.js"></script>
    <script type="application/javascript" src="/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/css/bootstrap.css">
    <link rel="stylesheet" href="/css/animate.css">
    <link rel="stylesheet" href="/css/font-awesome.css">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row" style="padding-top: 70px">
        <div class="col-sm-2"></div>
        <div class="col-sm-8">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h2 style="color: #0d8ddb">账户</h2>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-sm-6 b-r">
                            <h3 class="m-t-none m-b">登录</h3>
                            <p>欢迎登录本站(⊙o⊙)</p>
                            <%--<form role="form" action="" method="post">--%>
                                <div class="form-group">
                                    <label>用户名</label>
                                    <input type="text" placeholder="请输入您注册的用户名" class="form-control" name="username" id="username">
                                </div>
                                <div class="form-group">
                                    <label>密码</label>
                                    <input type="password" placeholder="请输入密码" class="form-control" name="password" id="password">
                                </div>
                                <div>
                                    <button class="btn btn-sm btn-primary pull-right m-t-n-xs" type="submit" onclick="check()"><strong>登 录</strong>
                                    </button>
                                    <label>
                                        <input type="checkbox" name="rememberMe" class="i-checks" id="rememberMe" value="true" checked="checked">记住密码</label>
                                </div>
                            <%--</form>--%>
                        </div>
                        <div class="col-sm-6">
                            <h4>还不是本公司的人？</h4>
                            <p>您可以注册一个新账户</p>
                            <p class="text-center">
                                <a href="toRegister"><img src="/img/register.jpg" width="300px"></a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
            <div class="col-sm-2"></div>
    </div>

</div>
<script type="text/javascript">
    function check() {
        var userName=$("#username").val();
        var passWord=$("#password").val();
        var remember=false;
        if(document.getElementById("rememberMe").checked){
            remember=true
        };

        var data={
            username:userName,
            password:passWord,
            rememberMe:remember
        };
        $.ajax({
            url: "/login/check",
            type: "POST",
            contentType:"application/json",
            data: JSON.stringify(data),
            cache: false,//清除页面缓存
            dataType: "JSON",
            success: function (data) {
                if(data.status==200){
                    alert(data.msg)
                    window.location.href="/login/toUserList"
                }
                if(data.status==500){
                    alert(data.msg)
//                    window.location.href="/login/toLogin"
                }
            }

        })

    }
</script>

</body>
</html>
