<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8"/>
		<title>角色列表</title>
		<link rel="icon" href="/img/2.ico" type="image/x-icon" >
		<script type="application/javascript" src="/js/jquery-1.10.2.js">
		</script>
		<script type="application/javascript" src="/js/jqPaginator.js"></script>
		<script type="application/javascript" src="/js/bootstrap.min.js"></script>

		<link rel="stylesheet" href="/css/demo.css" type="text/css">
		<link rel="stylesheet" href="/css/zTreeStyle/zTreeStyle.css" type="text/css">
		<script type="text/javascript" src="/js/jquery.ztree.core-3.5.js"></script>
		<script type="text/javascript" src="/js/jquery.ztree.excheck-3.5.js"></script>

		<link rel="stylesheet" href="/css/bootstrap.css">
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
			<%--<hr>--%>
			<hr>

			<div style="padding: 5px">
				<shiro:hasPermission name="role:create">
					<a type="button" class="btn btn-success" data-toggle="modal" data-target="#myModal2" onclick="addModal()">新增角色</a>
				</shiro:hasPermission>


			</div>

			<table class="table">
				<tr>
					<td>ID</td>
					<td>角色</td>
					<td>状态</td>
					<td>操作</td>
				</tr>
				<c:forEach items="${pageInfo.list}" var="role" varStatus="v">
					<tr>
						<td>${role.roleId}</td>
						<td>${role.rolename}</td>
						<td><button class="${role.status==1?'btn btn-success':'btn btn-danger'}" ><c:choose>
							<c:when test="${role.status==0}">禁用</c:when>
							<c:when test="${role.status==1}">启用</c:when>
							<c:when test="${role.status==2}">已删除</c:when>
						</c:choose></button></td>
						<td>
							<shiro:hasPermission name="role:update">
								<a type="button" class="btn btn-warning"  onclick="query(${role.roleId})" >修改</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="role:delete">
								<button class="btn btn-danger" onclick="del(${role.roleId})">删除</button>
							</shiro:hasPermission>
							<shiro:hasPermission name="role:update">
								<button class="btn btn-primary" onclick="forbid(${role.roleId})">禁用</button></td>
							</shiro:hasPermission>



					</tr>
				</c:forEach>
			</table>
			<div class="pagination-layout">
				<div class="pagination">
					<ul class="pagination" total-items="pageInfo.totalRows" max-size="10" boundary-links="true">
					</ul>
				</div>
			</div>
		</div>
		<%--权限修改模态框--%>
		<div id="myModal" class="modal" style="display: none" >
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header text-center">
						<h4>权限修改</h4>
					</div>
					<div id="tmodel"></div>
					<div class="modal-body">
						<%--放置ztree--%>
						<div class="ztree" id="treeDemo">
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-success" data-dismiss="modal" onclick="onCheck()">确认</button>
						<button type="button" class="btn btn-warning" data-dismiss="modal">取消</button>
					</div>
				</div>
			</div>
		</div>
		<%--新增角色模态框--%>
		<div id="myModal2" class="modal">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header text-center">
						<h4>新增角色</h4>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="col-sm-12">
								<div class="ibox float-e-margins">
									<div class="ibox-content">
											<div class="form-group">
												<label class="col-sm-2 control-label">角色名</label>
												<div class="col-sm-10">
													<input type="text" class="form-control" name="roleName" placeholder="请输入您新增的角色名" id="roleName" onblur="checkRoleName()"><span id="nameMessage"></span>
												</div>
											</div>
											<div class="form-group">
												<label class="col-sm-2 control-label">权限表</label>
												<div class="col-sm-10">
													<%--放置ztree--%>
													<div class="ztree" id="treeDemo2">
													</div>
												</div>
											</div>
											<div class="form-group">
												<div class="col-sm-4 col-sm-offset-2">
													<button type="button" class="btn btn-success" data-dismiss="modal" onclick="addRole()">确认</button>
													<button type="button" class="btn btn-warning" data-dismiss="modal">取消</button>
												</div>
											</div>
									</div>
								</div>
							</div>
						</div>

					</div>

				</div>
			</div>
		</div>


		<script type="text/javascript">

            //            更改角色状态
            function forbid(id){
                $.ajax({
                    url:"/toRole/toFobidRole",
                    type:"POST",
                    data:{
                        roleId:id
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
            //			删除角色
            function del(id) {
                $.ajax({
                    url:"/toRole/toDelRole",
                    type:"POST",
                    data:{
                        roleId:id
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

            //分页
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
                location.href = "/login/toRoleList?pageNum=" + num;
            }


//            下面为ztre配置
                var setting = {
                    check : {
                        enable : true,
                        chkStyle : "checkbox",    //复选框//每个节点上是否显示 CheckBox
                        chkboxType: { "Y": "s", "N": "p" }
//                        Y 属性定义 checkbox 被勾选后的情况；
           				 //N 属性定义 checkbox 取消勾选后的情况；
						//"p" 表示操作会影响父级节点；
						//"s" 表示操作会影响子级节点。
						//请注意大小写，不要改变
                    },
                    view: {
                        showLine: true, //显示辅助线
                        dblClickExpand: true,//单击展开树
                        showIcon:true    //有没有文件夹的那个图标
                    },
                    data: {
                        simpleData: {
                            enable: true,
                            idKey: "id",
                            pIdKey: "pid",
                            rootPId: 0
                        }
                    }
                };
//            查询权限
            function query(id){
                    var zNodes;
                    $.ajax({
                        url:"/toLimit/selectAllLimitsByTree",
                        type:"POST",
                        data:{
                            roleId:id
                        },
                        dataType:"JSON",
                        success:function(data){
                            if(data.status==200){
//                               alert(data.msg);
                                $("#myModal").modal("show")
                                //在模态框中添加一个角色id
                                var result="<input type='hidden'  name='RoleId' value='"+id+"'>";
                                $("#tmodel").html(result)
                                zNodes=data.object;
                                var treeObj = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                                //设置全部展开
                                treeObj.expandAll(true);
//                            //当数据回填时设置选中
                                for(var i=0;i<zNodes.length;i++){
                                    if(zNodes[i].checked){
                                        var Lid=zNodes[i].id;
                                        treeObj.getNodeByParam("id",Lid);
                                    }
                                }

							}

							if(data.status==500){
                                location.replace(location)
                                alert(data.msg)
                            }

                        }
                    });
                };
//            点击确定时修改权限
            function onCheck(){
                var treeObj=$.fn.zTree.getZTreeObj("treeDemo"),
                    nodes=treeObj.getCheckedNodes(true),
                    v="";//获取选中节点的id
                for(var i=0;i<nodes.length;i++){
                    v+=nodes[i].id + ",";
                }
                v += $('input:hidden[name="RoleId"]').val();//添加角色id
                console.log("节点id:"+v);
                $.ajax({
                    url:"/toLimit/updateLimits",
                    type:"POST",
                    data:{
                        limitIds:v
                    },
                    dataType:"JSON",
                    success:function(data){
                        if(data.status==200){
                            alert(data.msg);
                        }
                    }
                })
            };
//            打开新增角色时,显示全部权限
            function addModal(){
//                alert("新增角色");
                var zNodes;
                $.ajax({
                    url:"/toLimit/selectAllLimitsByTree",
                    type:"POST",
                    data:{
                        roleId:0
                    },
                    dataType:"JSON",
                    success:function(data){
                        zNodes=data.object;
                        var treeObj = $.fn.zTree.init($("#treeDemo2"), setting, zNodes);
                        //设置全部展开
                        treeObj.expandAll(true);
                    }
                });
			}
//           新增角色的重名认证认证
			function checkRoleName() {
                        var roleName=$("#roleName").val();

                        $.ajax({
                            url:"/toRole/getRoleName",//地址
                            type:"POST",//请求方式
                            data:{
                                roleName:roleName
                            },
                            dataType:"JSON", //返回数据的类型
                            success:function(data){  //回调函数 ,成功时返回的数据存在形参data里
                                //找到要检测的输入框并且取得输入框当前的值
                                var message=document.getElementById("nameMessage");
                                //判断
                                //是否为空    最小/大长度
                                if(roleName.length==0){
                                    message.innerText="角色名不能为空"
                                    document.getElementById("nameMessage").style.color="red";
                                }else if(data.status==500){
                                    message.innerText="角色名已存在"
                                    document.getElementById("nameMessage").style.color="red";
                                }else if(data.status==200){
                                    message.innerText="角色名可以使用"
                                    document.getElementById("nameMessage").style.color="green";
                                }
                            }
                        })

				}
//			新增角色和他的权限
			function addRole() {
                var flag=$('#nameMessage').text();
                if(flag != "角色名可以使用"){
                    alert("您输入的角色名有问题")
				}else{
                    var roleName=$("#roleName").val();
                    var treeObj=$.fn.zTree.getZTreeObj("treeDemo2"),
                        nodes=treeObj.getCheckedNodes(true),
                        v="";//获取选中节点的id
                    for(var i=0;i<nodes.length;i++){
                        v+=nodes[i].id + ",";
                    }
//                alert(v+"  "+roleName);
                    $.ajax({
                        url:"/toRole/addRoleLimit",
                        type:"POST",
                        data:{
                            roleName:roleName,
                            limitIds:v
                        },
                        dataType:"JSON",
                        success:function(data){
                            if(data.status==200){
                                alert(data.msg)
                                location.replace(location)
                            }
                        }
                    });
				}

            }
                jQuery.browser = {};
            (function () {
                jQuery.browser.msie = false;
                jQuery.browser.version = 0;
                if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
                    jQuery.browser.msie = true;
                    jQuery.browser.version = RegExp.$1;
                }
            })();




		</script>
	</body>
</html>
