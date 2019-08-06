<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/8/1/001
  Time: 19:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>主页</title>
    <link rel="icon" href="/img/2.ico" type="image/x-icon" >
    <script type="application/javascript" src="/js/jquery-1.10.2.js"></script>
    <script type="application/javascript" src="/js/jqPaginator.js"></script>
    <script type="application/javascript" src="/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/css/bootstrap.css">
    <link rel="stylesheet" href="/css/animate.css">
    <link rel="stylesheet" href="/css/font-awesome.css">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body class="fixed-sidebar full-height-layout gray-bg" style="overflow:hidden">

    <div id="wrapper">
        <!--左侧导航开始-->
        <nav class="navbar-default navbar-static-side" role="navigation">
            <div class="sidebar-collapse">
                <ul class="nav" id="side-menu">
                    <li class="nav-header">
                        <div class="dropdown profile-element">
                            <span><img alt="image" src="/img/1.ico" width="170px"/></span>
                            <h2>欢迎:${username}</h2>
                        </div>
                    </li>

                    <li>
                        <a class="J_menuItem" >用户管理</a>
                    </li>
                    <li>
                        <a class="J_menuItem" >角色管理</a>
                    </li>
                    <li>
                        <a class="J_menuItem" >权限管理</a>
                    </li>


                </ul>
            </div>
        </nav>
        <!--左侧导航结束-->
        <!--右侧部分开始-->
        <div id="page-wrapper" class="gray-bg dashbard-1">

            <div class="row content-tabs">
                <a href="toLogin" class="roll-nav roll-right J_tabExit"><i class="fa fa fa-sign-out"></i> 退出</a>
            </div>
            <div class="row J_mainContent" id="c1" style="display: block">
                <iframe class="J_iframe" name="iframe0" width="100%" height="100%" src="/login/toUserList" ></iframe>
            </div>
            <div class="footer">
                <div class="pull-right">&copy; 2019-2020  <a href="http://www.baidu.com/" target="_blank">wuyukun</a>
                </div>
            </div>
        </div>
        <!--右侧部分结束-->


    </div>


</body>
</html>
