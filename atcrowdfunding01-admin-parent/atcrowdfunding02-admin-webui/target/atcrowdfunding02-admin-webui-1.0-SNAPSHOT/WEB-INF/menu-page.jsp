<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="include-head.jsp" %>
<link rel="stylesheet" href="ztree/zTreeStyle.css"/>
<script type="text/javascript" src="ztree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript">
    $(function () {
        // 调用专门封装好的函数初始化树形结构
        generateTree();
        // 给添加子节点按钮绑定单机事件
        $("#treeDemo").on("click", ".addBtn", function () {
            // 将当前节点的id作为新节点的pid保存在全局变量
            window.pid = this.id;
            $("#menuAddModal").modal("show");
            return false;
        });
        // 给添加子节点保存按钮绑定单击事件
        $("#menuSaveBtn").click(function () {
            // 收集表单中输入的数据
            var name = $("#menuAddModal [name=name]").val().trim();
            var url = $("#menuAddModal [name=url]").val().trim();
            // 单选按钮要定位到被选中的那一个
            var icon = $("#menuAddModal [name=icon]:checked").val();
            // 发送ajax请求
            $.ajax({
                url: "menu/save.json",
                type: "POST",
                data: {
                    "pid": window.pid,
                    "name": name,
                    "url": url,
                    "icon": icon
                },
                dataType: "json",
                success: function (response) {
                    var result = response.result;
                    if (result == "SUCCESS") {
                        layer.msg("操作成功");
                        generateTree();
                    }
                    if (result == "FAILED") {
                        layer.msg("操作失败:" + response.message);
                    }
                },
                error: function (response) {
                    layer.msg(response.status + " " + response.statusText);
                }
            });
            $("#menuAddModal").modal("hide");
            // 清空表单
            // jQuery对象调用click()里面不传任何参数，就相当于用户点击了一下
            $("#menuResetBtn").click();
        });
        $("#treeDemo").on("click",".editBtn",function (){
            // 将当前节点的id保存到全局变量
            window.id = this.id;
            // 打开模态框
            $("#menuEditModal").modal("show");
            // 获取zTreeObj对象
            var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");
            // 根据id属性查询节点对象
            // 用来搜索节点的属性名
            var key = "id";
            // 用来搜索节点的属性值
            var value = this.id;
            var currentNode = zTreeObj.getNodeByParam(key,value);
            // 回显表单数据
            $("#menuEditModal [name=name]").val(currentNode.name);
            $("#menuEditModal [name=url]").val(currentNode.url);
            // 被选中的radio的value属性可以组成一个数组，然后再用数组设置回这个radio，就能够把对应的值选中
            $("#menuEditModal [name=icon]").val([currentNode.icon]);
            return false;
        });
        $("#menuEditBtn").click(function (){
            // 收集表单数据
            var name = $("#menuEditModal [name=name]").val();
            var url = $("#menuEditModal [name=url]").val();
            var icon = $("#menuEditModal [name=icon]:checked").val();
            if(name == "" || url == "" || icon == "") {
                layer.msg("更新的数据不能为空");
                $("#menuEditModal").modal("hide");
                return;
            }
            // 发送ajax请求
            $.ajax({
                url:"menu/edit.json",
                type:"POST",
                data:{
                    "id":window.id,
                    "name":name,
                    "url":url,
                    "icon":icon
                },
                dataType:"json",
                success:function (response) {
                    var result = response.result;
                    if(result == "SUCCESS") {
                        layer.msg("操作成功");
                        generateTree();
                    }
                    if(result == "FAILED") {
                        layer.msg("操作失败:" + response.message);
                    }
                },
                error:function (response) {
                    layer.msg(response.status + " " + response.statusText);
                }
            })
            $("#menuEditModal").modal("hide");
        });
        $("#treeDemo").on("click",".removeBtn",function (){
            window.id = this.id;
            // 打开模态框
            $("#menuConfirmModal").modal("show");
            // 获取zTreeObj对象
            var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");
            var key = "id";
            var value = window.id;
            var currentNode = zTreeObj.getNodeByParam(key,value);
            $("#removeNodeSpan").html("<i class='"+ currentNode.icon +"'></i>" + currentNode.name);
            return false;
        });
        $("#confirmBtn").click(function (){
            $.ajax({
                url:"menu/remove.json",
                type:"POST",
                data:{
                    "id":window.id,
                },
                dataType:"json",
                success:function (response){
                    var result = response.result;
                    if(result == "SUCCESS") {
                        layer.msg("操作成功");
                        generateTree();
                    }
                    if(result == "FAILED") {
                        layer.msg("操作失败:" + response.message);
                    }
                },
                error:function (response) {
                    layer.msg(response.status + " " + response.statusText);
                }
            });
            $("#menuConfirmModal").modal("hide");
        });
    });
</script>
<script type="text/javascript">
    // 生成树形结构的函数
    function generateTree() {
        // 1.准备生成树形结构的JSON数据,数据来源是发送ajax请求得到
        $.ajax({
            url: "menu/get/whole/tree.json",
            type: "POST",
            dataType: "json",
            success: function (response) {
                var result = response.result;
                if (result == "SUCCESS") {
                    // 2.创建JSON对象用于存储对zTree所做的设置
                    var setting = {
                        "view": {
                            "addDiyDom": myAddDiyDom,
                            "addHoverDom": myAddHoverDom,
                            "removeHoverDom": myRemoveHoverDom
                        },
                        "data": {
                            "key": {
                                "url": "maomi"
                            }
                        }
                    };
                    // 3.从响应体中获取用来生成树形结构的json数据
                    var zNodes = response.data;
                    // 4.初始化树形结构
                    $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                }
                if (result == "FAILED") {
                    layer.msg(response.message);
                }
            }
        });
    }

    // 在鼠标移入节点范围时添加按钮组
    function myAddHoverDom(treeId, treeNode) {
        // 按钮组标签结构<span><a><i></i></a><a></a></span>
        // 按钮组出现的位置：节点中treeDemo_n_a超链接的后面
        // 为了在需要移除按钮组的时候，能够准确定位到按钮组所在的span，需要给span设置有规律的id
        var btnGroupId = treeNode.tId + "_btnGrp";
        // 判断以前是否已经添加了按钮组
        if ($("#" + btnGroupId).length > 0) {
            return;
        }
        // 准备各个html的标签
        var addBtn = "<a id='" + treeNode.id + "' class='btn btn-info dropdown-toggle btn-xs addBtn' style='margin-left:10px;padding-top:0px;' href='#' title='添加子节点'>&nbsp;&nbsp;<i class='fa fa-fw fa-plus rbg '></i></a>";
        var removeBtn = "<a id='" + treeNode.id + "' class='btn btn-info dropdown-toggle btn-xs removeBtn' style='margin-left:10px;padding-top:0px;' href='#' title='删除节点'>&nbsp;&nbsp;<i class='fa fa-fw fa-times rbg '></i></a>";
        var editBtn = "<a id='" + treeNode.id + "' class='btn btn-info dropdown-toggle btn-xs editBtn' style='margin-left:10px;padding-top:0px;' href='#' title='修改节点'>&nbsp;&nbsp;<i class='fa fa-fw fa-edit rbg'></i></a>";
        // 获取当前节点的级别
        var level = treeNode.level;
        // 声明变量存储拼装好的按钮代码
        var btnHTML = "";
        // 判断当前节点的级别
        // 级别为0是根节点，只能添加子节点
        if (level == 0) {
            btnHTML = addBtn;
        }
        // 级别为1是分支节点，可以添加子节点、修改
        if (level == 1) {
            btnHTML = addBtn + " " + editBtn;
            // 判断当前节点有无子节点
            // 如果没有子节点，可以删除
            if (treeNode.children.length == 0) {
                btnHTML = btnHTML + " " + removeBtn;
            }
        }
        // 级别为2是叶子节点，可以修改删除
        if (level == 2) {
            btnHTML = editBtn + " " + removeBtn;
        }
        // 找到附着按钮组的超链接
        var anchorId = treeNode.tId + "_a";
        // 执行在超链接后面附加span元素的操作
        $("#" + anchorId).after("<span id='" + btnGroupId + "'>" + btnHTML + "</span>");


    }

    // 在鼠标离开节点范围时删除按钮组
    function myRemoveHoverDom(treeId, treeNode) {
        // 拼接按钮组的id
        var btnGroupId = treeNode.tId + "_btnGrp";
        // 移除对应的元素
        $("#" + btnGroupId).remove();
    }

    function myAddDiyDom(treeId, treeNode) {
        // treeId是整个树形结构附着的ul标签的id
        console.log("treeId = " + treeId);
        // treeNode当前树形节点的全部数据，包含从后端查询得到的Menu对象的全部属性
        console.log(treeNode);
        // zTree生成id的规则
        // eg.treeDemo_7_ico
        // 解析：ul标签的id_当前节点的序号_功能
        // 提示："ul标签的id_当前节点的序号"部分可以通过访问treeNode的tId属性得到
        // 根据id的生成规则拼接出来span标签的id
        var spanId = treeNode.tId + "_ico";
        // 根据控制图标的span标签的id找到这个span标签
        // 删除旧的class
        // 添加新的class
        $("#" + spanId).removeClass().addClass(treeNode.icon);
    }
</script>
<body>
<%@include file="include-nav.jsp" %>
<div class="container-fluid">
    <div class="row">
        <%@include file="include-sidebar.jsp" %>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 权限菜单列表
                    <div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i
                            class="glyphicon glyphicon-question-sign"></i></div>
                </div>
                <div class="panel-body">
                    <%--这个ul标签是zTree动态生成的节点所依赖的静态节点--%>
                    <ul id="treeDemo" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<%@include file="modal-menu-add.jsp"%>
<%@include file="modal-menu-edit.jsp"%>
<%@include file="modal-menu-confirm.jsp"%>
</html>