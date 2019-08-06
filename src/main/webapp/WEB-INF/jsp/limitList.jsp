<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8"/>

		<title>权限展示</title>
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
				<shiro:hasPermission name="limit:create">
					<button type='button' class='btn btn-success' data-toggle="modal" data-target="#myModal"  onclick='addLimit()'>
						<span></span>新增权限
					</button>
				</shiro:hasPermission>


			</div>
			<div style="height: 500px;">
				<div class="col-lg-4">
					<div class="text-center"><kbd>一级权限</kbd></div>
					<div id="showOne"></div>
					</div>
				<div class="col-lg-4 col-lg-push-0">
					<div class="text-center"><kbd>二级权限</kbd></div>
					<div id="showTwo"></div>
					</div>
				<div class="col-lg-4 col-lg-push-0">
					<div class="text-center"><kbd>三级级权限</kbd></div>
					<div id="showThree"></div>
				</div>

			</div>
			<%--新增modal--%>
			<div id="myModal" class="modal">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header text-center">
							<h4>新增权限</h4>
						</div>

						<div class="modal-body">
							<div class="form-group col-sm-12">
								权限名:<input type="text" class="form-control" name="limitName" placeholder="请输入您新增的权限名" id="limitName" onblur="checkLimitName()">
								<span id="nameMessage"></span>
							</div>
							<div class="form-group col-sm-12">
								url:<input type="text" class="form-control" name="limitUrl" placeholder="请输入您新增的权限的url,如'limit:add'" id="limitUrl" onblur="checkLimitUrl()" >
								<span id="urlMessage"></span>
							</div>
							<div class="form-group col-sm-12">
								<label >选择父级权限(只能选择一个权限,如果不选则默认为一级权限)</label>
							</div>
							<div class="form-group col-sm-12">
								<%--放置ztree--%>
								<div class="ztree" id="treeDemo">
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-success" data-dismiss="modal" onclick="addNewLimit()">确认</button>
							<button type="button" class="btn btn-warning" data-dismiss="modal">取消</button>
						</div>
					</div>
				</div>
			</div>
			<%--修改modal--%>
			<div id="myModal2" class="modal" style="display: none">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header text-center">
							<h4>修改权限</h4>
						</div>

						<div class="modal-body" id="modalBody">
							<%--<div class="form-group col-sm-12" >--%>
								<%--权限名:--%>
							<%--</div>--%>
							<%--<div class="form-group col-sm-12">--%>
								<%--<label >选择父级权限(只能选择一个权限,如果不选则默认不变)</label>--%>
							<%--</div>--%>
							<%--<div class="form-group col-sm-12">--%>
								<%--&lt;%&ndash;放置ztree&ndash;%&gt;--%>
								<%--<div class="ztree" id="treeDemo2">--%>
								<%--</div>--%>
							<%--</div>--%>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-success" data-dismiss="modal" onclick="updateOldLimit()">确认</button>
							<button type="button" class="btn btn-warning" data-dismiss="modal">取消</button>
						</div>
					</div>
				</div>
			</div>

		</div>
		<script type="application/javascript">

			$(document).ready(function () {
				$.ajax({
					url:"/toLimit/selectLimits",
                    type:"POST",
                    data:{
                    },
                    dataType:"JSON",
                    success:function(data){
                        if(data.status==200){
                           var list=data.object;
							var result="";
//			onmouseover当鼠标指针移动到图像上时执行一段 JavaScript：  				onmouseout事件会在鼠标指针移出指定的对象时发生。
                           for(var i=0;i<list.length;i++){
                               //在其中添加一个权限id
                               var limitName=list[i].limitname;
                           		result +="<a class='list-group-item text-center ' onmouseover='showbtn(this)' onmouseout='hidebtn(this)' onclick='showMsg2(this,"+list[i].limitId+")'>"+
                               limitName
                            +"<div style='float: right;' hidden='hidden' >"+

                                "<shiro:hasPermission name="limit:update"><button type='button' class='btn btn-warning btn-xs'  onclick='updateLimit("+list[i].limitId+")'>"+
                                "<span class='glyphicon glyphicon-pencil'></span>"+"修改"+
									"</button></shiro:hasPermission>"+
                                "<shiro:hasPermission name="limit:delete"><button type='button' class='btn btn-danger btn-xs' onclick='deleteLimit("+list[i].limitId+","+list[i].parentId+")'>"+
                                "<span class='glyphicon glyphicon-remove'></span>"+"删除"+
                                "</button></shiro:hasPermission>"+
                                "</div>"+
                                "</a>"
                           }
                            $("#showOne").html(result)
                        }
                    }
				})

            })

			function showbtn(obj){
				$(obj).find("div").removeAttr("hidden")
                $(obj).addClass(" active")
			}

			function hidebtn(obj){
				$(obj).find("div").attr("hidden","hidden")
                $(obj).removeClass("active")
			}
//			查询二级权限
			function showMsg2(obj,limitId){
			    $("#showThree").attr("hidden","hidden")
				$(obj).parent().find("a").removeClass("active")
				$(obj).addClass("active")
                $.ajax({
                    url: "/toLimit/selectLimits",
                    type: "POST",
                    data: {
                        parentId:limitId
					},
                    dataType: "JSON",
                    success: function (data) {
                        if(data.status==200){
                            var list=data.object;
                            var result="";
//			onmouseover当鼠标指针移动到图像上时执行一段 JavaScript：  				onmouseout事件会在鼠标指针移出指定的对象时发生。
                            for(var i=0;i<list.length;i++){
                                //在其中添加一个权限id
                                var limitName=list[i].limitname;
                                result +="<a class='list-group-item text-center ' onmouseover='showbtn(this)' onmouseout='hidebtn(this)' onclick='showMsg3(this,"+list[i].limitId+")'>"+
                                    limitName
                                    +"<div style='float: right;' hidden='hidden'  >"+
                                    "<shiro:hasPermission name="limit:update"><button type='button' class='btn btn-warning btn-xs' onclick='updateLimit("+list[i].limitId+")'>"+
                                    "<span class='glyphicon glyphicon-pencil'></span>"+"修改"+
                                    "</button></shiro:hasPermission>"+
                                    "<shiro:hasPermission name="limit:delete"><button type='button' class='btn btn-danger btn-xs'  onclick='deleteLimit("+list[i].limitId+","+list[i].parentId+")'>"+
                                    "<span class='glyphicon glyphicon-remove'></span>"+"删除"+
                                    "</button></shiro:hasPermission>"+
                                    "</div>"+
                                    "</a>"
                            }
                            $("#showTwo").html(result)
                        }
                    }
                })

			}
//			查询三级权限
            function showMsg3(obj,limitId){
                $("#showThree").removeAttr("hidden")
                $(obj).parent().find("a").removeClass("active")
                $(obj).addClass("active")
                $.ajax({
                    url: "/toLimit/selectLimits",
                    type: "POST",
                    data: {
                        parentId:limitId
                    },
                    dataType: "JSON",
                    success: function (data) {
                        if(data.status==200){
                            var list=data.object;
                            var result="";
//			onmouseover当鼠标指针移动到图像上时执行一段 JavaScript：  				onmouseout事件会在鼠标指针移出指定的对象时发生。
                            for(var i=0;i<list.length;i++){
                                //在其中添加一个权限id
                                var limitName=list[i].limitname;
                                result +="<a class='list-group-item text-center ' onmouseover='showbtn(this)' onmouseout='hidebtn(this)' >"+
                                    limitName
                                    +"<div style='float: right;' hidden='hidden' >"+
                                    "<shiro:hasPermission name="limit:update"><button type='button' class='btn btn-warning btn-xs'  onclick='updateLimit("+list[i].limitId+")'>"+
                                    "<span class='glyphicon glyphicon-pencil'></span>"+"修改"+
                                    "</button></shiro:hasPermission>"+
                                    "<shiro:hasPermission name="limit:delete"><button type='button' class='btn btn-danger btn-xs'  onclick='deleteLimit("+list[i].limitId+","+list[i].parentId+")'>"+
                                    "<span class='glyphicon glyphicon-remove'></span>"+"删除"+
                                    "</button></shiro:hasPermission>"+
                                    "</div>"+
                                    "</a>"
                            }
                            $("#showThree").html(result)
                        }
                    }
                })

            }

//            删除权限
			function deleteLimit(limitId,parentId) {
//				alert(limitId+" -------"+parentId);
                $.ajax({
                    url: "/toLimit/deleteLimits",
                    type: "POST",
                    data: {
                        limitId:limitId,
                        parentId: parentId
                    },
                    dataType: "JSON",
                    success: function (data) {
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

//            下面为ztre配置
            var setting = {
                check : {
                    enable : true,
                    chkStyle : "checkbox",    //复选框//每个节点上是否显示 CheckBox
                    chkboxType: { "Y": "", "N": "" }
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
//        新增权限
			function addLimit() {
                var zNodes;
                $.ajax({
                    url:"/toLimit/selectAddLimits",
                    type:"POST",
                    data:{
                    },
                    dataType:"JSON",
                    success:function(data){
                        if(data.status==200){
                            //在模态框中添加一个角色id
                            zNodes=data.object;
                            var treeObj = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                            //设置全部展开
                            treeObj.expandAll(true);
						}


                    }
                });
            }
//            新增权限的重名认证
            function checkLimitName() {
                var limitName=$("#limitName").val();

                $.ajax({
                    url:"/toLimit/getLimitName",//地址
                    type:"POST",//请求方式
                    data:{
                        limitName:limitName
                    },
                    dataType:"JSON", //返回数据的类型
                    success:function(data){  //回调函数 ,成功时返回的数据存在形参data里
                        //找到要检测的输入框并且取得输入框当前的值
                        var message=document.getElementById("nameMessage");

                        //判断
                        //是否为空    最小/大长度
                        if(limitName.length==0){
                            message.innerText="权限名不能为空";
                            document.getElementById("nameMessage").style.color="red";
                            return false;
                        }else if(data.status==500){
                            message.innerText="权限名已存在"
                            document.getElementById("nameMessage").style.color="red";
                            return false;
                        }else if(data.status==200){
                            message.innerText="权限名可以使用"
                            document.getElementById("nameMessage").style.color="green";
                            return true;
                        }

                    }
                })

            }
//            新增权限url为空认证
            function checkLimitUrl(){
                var limitUrl=$("#limitUrl").val();
                var urlMessage=document.getElementById("urlMessage");
                if(limitUrl.length==0){
                    urlMessage.innerText="url不能为空";
                    document.getElementById("urlMessage").style.color="red";
                    return false;
                }else{
                    urlMessage.innerText="url可以使用"
                    document.getElementById("urlMessage").style.color="green";
                    return true;
                }
			}
//            新增权限//真的
			function addNewLimit() {
                var flag=$('#nameMessage').text();
                var flag2=$('#urlMessage').text();
                var limitName=$("#limitName").val();
                var limitUrl=$("#limitUrl").val();
//                alert(flag+"00000000000"+flag2)
                if(flag !="权限名可以使用"  ){
                    alert("您输入的权限名有问题")

				}else{
                    if(flag2 !="url可以使用"){
                        alert("您输入的url有问题")
                    }else{
                        var treeObj=$.fn.zTree.getZTreeObj("treeDemo"),
                            nodes=treeObj.getCheckedNodes(true);
                        if(nodes.length >1){
                            alert("父级权限只能选择一个或者不选")
                        }else{
//                            alert(limitName+"1212   "+nodes);
                            var parentid=0;
                            if(nodes !=null && nodes != ""){
                                parentid=nodes[0].id;
                            }
                            $.ajax({
                                url:"/toLimit/addLimit",//地址
                                type:"POST",//请求方式
                                data:{
                                    limitName:limitName,
                                    parentId:parentid,
                                    limitUrl:limitUrl
                                },
                                dataType:"JSON", //返回数据的类型
                                success:function(data) {  //回调函数 ,成功时返回的数据存在形参data里}
                                    if(data.status==200){
                                        alert(data.msg)
                                        location.replace(location)
                                    }
                                }

                            })

                        }
                    }

				}
            }
//            修改权限,信息回填
			function updateLimit(limitId) {
                $.ajax({
                    url:"/toLimit/getLimit",//地址
                    type:"POST",//请求方式
                    data:{
                        limitId:limitId
                    },
                    dataType:"JSON", //返回数据的类型
                    success:function(data) {  //回调函数 ,成功时返回的数据存在形参data里}
                        if(data.status==200){
                            $("#myModal2").modal("show");
                            var result=data.object;
                            var val="<input type='hidden' name='limitId' id='updateId' value='"+result.limitId+"'/><br>"+
									"权限名:<input type='text' name='limitname' id='updateName' value='"+result.limitname+"'/><br>"+
									"url:<input type='text' name='url' id='updateUrl' value='"+result.url+"'/>"
                            $("#modalBody").html(val);
                        }
                        if(data.status==500){
                            location.replace(location);
                            alert(data.msg)
						}
                    }

                })

            }

//            修改权限(真)
			function updateOldLimit() {
				var limitId = $("#updateId").val();
				var limitname = $("#updateName").val();
				var url = $("#updateUrl").val();
                $.ajax({
                    url: "/toLimit/updateLimitByLimitId",//地址
                    type: "POST",//请求方式
                    data: {
                        limitId: limitId,
                        limitname:limitname,
                        url:url
                    },
                    dataType: "JSON", //返回数据的类型
                    success: function (data) {  //回调函数 ,成功时返回的数据存在形参data里
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