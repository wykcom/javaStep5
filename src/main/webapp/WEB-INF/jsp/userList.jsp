<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>

<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>用户列表</title>
		<link rel="icon" href="/img/2.ico" type="image/x-icon" >
		<%--<link rel="shortcut icon" href="#" />--%>
		<%--//去除GET http://localhost:8080/favicon.ico 404 (Not Found)--%>
		<script type="application/javascript" src="/js/jquery-1.10.2.js"></script>
		<script type="application/javascript" src="/js/jqPaginator.js"></script>
		<script type="application/javascript" src="/js/bootstrap.min.js"></script>
		<link rel="stylesheet" href="/css/bootstrap.css">

		<%--页面自动刷新--%>
		<%--<meta http-equiv="refresh" content="10">--%>
	</head>

	<body>
		<div class="container">
			<h2 style="align-content: center">你好:${username}</h2>
			<shiro:hasPermission name="user:select">
			<a type="button" class="btn btn-success" href="/login/toUserList" >用户界面</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="role:select">
				<a type="button" class="btn btn-danger" href="/login/toRoleList" >角色界面</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="limit:select">
				<a type="button" class="btn btn-primary" href="/login/toLimitList" >权限界面</a>
			</shiro:hasPermission>
			<hr>
			<%--<div style="width: inherit ;height: 2px;color-interpolation: blur"  >--%>

			<%--</div>--%>
			<hr>

			<table class="table">
				<tr>
					<td>ID</td>
					<td>用户</td>
					<td>状态</td>
					<td>操作</td>
				</tr>
				<c:forEach items="${pageInfo.list}" var="user" varStatus="v">
					<tr>
						<td><span id="userId">${user.userId}</span></td>
						<td>${user.username}</td>
						<td><button class="${user.status==1?'btn btn-success':'btn btn-danger'}" ><c:choose>
							<c:when test="${user.status==0}">禁用</c:when>
							<c:when test="${user.status==1}">启用</c:when>
							<c:when test="${user.status==2}">已删除</c:when>
						</c:choose></button></td>

						<td>
							<shiro:hasPermission name="user:update">
								<a type="button" class="btn btn-warning" data-toggle="modal" data-target="#myModal" onclick="query(${user.userId})">修改</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="user:delete">
								<button class="btn btn-danger" onclick="del(${user.userId})">删除</button>
							</shiro:hasPermission>

							<shiro:hasPermission name="user:update">
							<button class="btn btn-primary" onclick="forbid(${user.userId})">禁用</button>
							</shiro:hasPermission>
							</td>
					</tr>
				</c:forEach>
			</table>
			<div id="myModal" class="modal">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header text-center">
							<h4>角色修改</h4>
						</div>
						<div class="modal-body" >
							<div class="checkbox" id="tmodel">
							</div>
						</div>
						<div class="modal-footer">
							<button class="btn btn-success" data-dismiss="modal" onclick="update()">确认</button>
							<button type="button" class="btn btn-warning" data-dismiss="modal">取消</button>
						</div>

					</div>
				</div>
			</div>
			<div class="pagination-layout">
				<div class="pagination">
					<ul class="pagination" total-items="pageInfo.totalRows" max-size="10" boundary-links="true">
					</ul>
				</div>
			</div>
		</div>
		<%--修改--%>

	<script type="text/javascript">

		$(document).ready(function () {

        })
			//修改查询
		    function query(id){
				$.ajax({
					url:"/login/getRoleById",
					type:"POST",
					data:{
					    userId:id
					},
					cache:false,//清除页面缓存
					dataType:"JSON",
					success:function(data){
					    if(data.status==200){
                            var roleList=data.object;
                            var result="<input type='hidden'  name='userRoleId' value='"+id+"'>";
                            for(var i=0; i<roleList.length;i++){
                                var roleId = roleList[i].roleId;
                                if(roleList[i].flag == true){
                                    result +="<label><input type='checkbox' checked='checked' name='role'  value='"+roleId+"'>"+roleList[i].rolename+"</label></br>";
                                }else{
                                    result +="<label><input type='checkbox' name='role' value='"+roleId+"'>"+roleList[i].rolename+"</label></br>";
                                }
                            }
                            $("#tmodel").html(result)
						}

					}
				})
			}
//			修改角色
            function update(){
		        var roleIds=$('input:checkbox[name="role"]:checked').map(function (index,elm) {
					return $(elm).val();
                }).get().join(',');
				roleIds += ","+$('input:hidden[name="userRoleId"]').val()
                $.ajax({
                    url:"/login/toUpdate",
                    type:"POST",
                    data:{
                        "roleIds":roleIds,
                    },
                    cache:false,//清除页面缓存
                    dataType:"JSON",
                    success:function(data){
                        if(data.status==200){
                            alert(data.msg)
                            location.replace(location)
                        }
                        if(data.status==500){
                            alert(data.msg)
                            location.replace(location)
                        }

                    }
                })
            }
//            更改用户状态
            function forbid(id){
                 $.ajax({
                    url:"/login/toFobidUser",
                    type:"POST",
                    data:{
                        userId:id
                    },

                    dataType:"JSON",
                    success:function(data){
                        if(data.status==200){
                            alert(data.msg)
                            location.replace(location)
						}
						if(data.status==500){
                            alert(data.msg)
                            location.replace(location)
                        }

                    }
                })

            }
//			删除用户
            function del(id) {
                $.ajax({
                    url:"/login/toDelUser",
                    type:"POST",
                    data:{
                        userId:id
                    },
                    dataType:"JSON",
                    success:function(data){
                        if(data.status==200){
                            alert(data.msg);
                            location.replace(location)
                        }
                        if(data.status==500){
                            alert(data.msg);
                            location.replace(location)
                        }

                    }
                })
            }


        var if_firstime = true;
        window.onload = function () {
            $('.pagination').jqPaginator({
                totalPages: ${pageInfo.pages},
                visiblePages: 5,
                currentPage: ${pageInfo.pageNum},

                first: '<li class="first"><a href="javascript:void(0);">第一页</a></li>',
                prev: '<li class="prev"><a href="javascript:void(0);">上一页</a></li>',
                next: '<li class="next"><a href="javascript:void(0);">下一页</a></li>',
                last: '<li class="last"><a href="javascript:void(0);">最末页 </a></li>',
                page: '<li class="page"><a href="javascript:void(0);">{{page}}</a></li>',

                onPageChange: function (num) {
                    if (if_firstime) {
                        if_firstime = false;
                    } else if (!if_firstime) {
                        changePage(num);
                    }

                }
            });
        }

        function changePage(num) {
            location.href = "/login/toUserList?pageNum=" + num;
        }
	</script>
	</body>
</html>