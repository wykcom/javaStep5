<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>注册页面</title>
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
<div class="container">
    <h2 align="center">欢迎注册(⊙o⊙)</h2>
    <div class="ibox-content">
        <form class="form-horizontal" action="" method="post">

            <div class="form-group">

                <label class="col-sm-3 control-label">用户名：</label>

                <div class="col-sm-8">
                    <input type="text" placeholder="用户名" class="form-control" name="username" id="name"> <span class="help-block m-b-none">请输入注册账号</span>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">密码：</label>

                <div class="col-sm-8">
                    <input type="password" placeholder="密码" class="form-control" name="password" id="password">
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-3 col-sm-8">
                    <button class="btn btn-sm btn-white" type="button" onclick="changeAction()">注册</button>
                </div>
            </div>
        </form>
    </div>
    <%--<form class="form-horizontal" action="" method="post">--%>
        <%--<div class="input-group">--%>
            <%--<span class="input-group-addon" id="basic-addon1">用户名：</span>--%>
            <%--<input type="text" class="form-control" placeholder="用户名" aria-describedby="basic-addon1" name="username" id="name">--%>
        <%--</div>--%>
        <%--<div class="input-group">--%>
            <%--<span class="input-group-addon" id="basic-addon2">密  码：</span>--%>
            <%--<input type="password" class="form-control" placeholder="密码" aria-describedby="basic-addon2" name="password" id="password" >--%>
        <%--</div>--%>

        <%--<div class="input-group">--%>
            <%--<input type="button" value="注册" class="btn btn-warning" onclick="changeAction()" >--%>
        <%--</div>--%>
    <%--</form>--%>
</div>
<script type="application/javascript">
    $(document).ready(function(){
//重名认证
        $("#name").blur(function(){
            var username=$("#name").val();
            $.ajax({
                url:"/login/getUsername",//地址
                type:"POST",//请求方式
                data:{
                    username:username
                },
                dataType:"JSON", //返回数据的类型
                success:function(data){  //回调函数 ,成功时返回的数据存在形参data里
                    if(data == 1){
                        alert("用户名已存在");
                        console.log(data)
                    }
                }
            })
        })
    });

    function changeAction() {
        var username=$("#name").val();
        var password=$("#password").val();
        if(username != null & username != ""){
            if(password != null & password != ""){
                $(".form-horizontal").attr("action","/login/register").submit();
            }else{
                alert("密码不能为空")
            }
        }else{
            alert("用户名不能为空")
        }

    }

</script>
</body>
</html>