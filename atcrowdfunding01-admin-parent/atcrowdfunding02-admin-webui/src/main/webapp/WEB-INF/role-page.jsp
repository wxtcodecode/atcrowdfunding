<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="include-head.jsp" %>
<link rel="stylesheet" href="css/pagination.css"/>
<script type="text/javascript" src="jquery/jquery.pagination.js"></script>
<link rel="stylesheet" href="ztree/zTreeStyle.css"/>
<script type="text/javascript" src="ztree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript">
    $(function () {
        // 1.为分页操作准备初始化数据
        window.pageNum = 1;
        window.pageSize = 5;
        window.keyword = "";
        // 2.调用执行分页的函数，显示页面效果
        generatePage();
        // 3.给查询按钮绑定单击事件
        $("#searchBtn").click(function () {
            // 获取关键词数据给对应的全局变量
            window.keyword = $("#keywordInput").val();
            // 调用分页函数刷新页面
            generatePage();
        });
        // 4.点击新增按钮打开模态框
        $("#showAddModalBtn").click(function () {
            $("#addModal").modal("show");
        });
        // 5.给新增模态框的保存按钮绑定单击事件
        $("#saveRoleBtn").click(function () {
            // 1) 获取用户在文本框中输入的角色名称
            var roleName = $("#addModal [name=roleName]").val().trim();
            if (roleName == null || roleName == undefined || roleName == "") {
                layer.msg("输入的用户名称不能为空");
                $("#addModal").modal("hide");
                return false;
            }
            if (roleName != "") {
                // 2) 发送ajax请求
                $.ajax({
                    url: "role/sava.json",
                    type: "POST",
                    data: {
                        "roleName": roleName
                    },
                    dataType: "json",
                    success: function (response) {
                        var result = response.result;
                        if (result == "SUCCESS") {
                            layer.msg("操作成功");
                            // 重新加载分页数据
                            window.pageNum = 1000000;
                            generatePage();
                        }
                        if (result == "FAILED") {
                            layer.msg("操作失败:" + response.message);
                        }
                    },
                    error: function (response) {
                        layer.msg(response.status + " " + response.statusText);
                    }
                });
                // 关闭模态框
                $("#addModal").modal("hide");
                // 清理模态框
                $("#addModal [name=roleName]").val("");
            }

        });
        // 6.给页面上的"铅笔"按钮绑定单击事件
        // 传统的事件绑定方式只能在第一个页面有效，翻页后就失效了
        // 使用jQuery对象的on()函数可以解决这个问题
        // 1)首先找到所有"动态生成"的元素所附着的"静态元素"
        // 2)on()函数的第一个参数是事件类型
        // 3)on()函数的第二个参数是找到真正要绑定事件的元素的选择器
        // 4)on()函数的第三个参数是事件的响应函数
        $("#rolePageBody").on("click", ".pencilBtn", function () {
            // ①.打开模态框
            $("#editModal").modal("show");
            // ②.获取表格中当前中的角色名称
            var roleName = $(this).parent().prev().text();
            // ③.获取当前角色的id
            // 为了让执行更新的按钮能够获取到roleId的值，把它放在全局变量上
            window.roleId = this.id;
            // ④.使用roleName的值设置模态框中的文本框
            $("#editModal [name=roleName]").val(roleName);
        });
        // 7.给更新的模态框绑定单击事件
        $("#updateRoleBtn").click(function () {
            var roleName = $("#editModal [name=roleName]").val();
            if (roleName == "" || roleName == null || roleName == undefined) {
                layer.msg("修改的用户名称不能为空");
                $("#editModal").modal("hide");
                return false;
            }
            if (roleName != "") {
                // 1) 发送ajax请求
                $.ajax({
                    url: "role/update.json",
                    type: "POST",
                    data: {
                        "id": window.roleId,
                        "name": roleName
                    },
                    dataType: "json",
                    success: function (response) {
                        var result = response.result;
                        if (result == "SUCCESS") {
                            layer.msg("修改成功");
                            generatePage();
                        }
                        if (result == "FAILED") {
                            layer.msg("修改失败:" + response.message);
                        }
                    },
                    error: function (response) {
                        layer.msg(response.status + " " + response.statusText);
                    }
                });
            }
            // 关闭模态框
            $("#editModal").modal("hide");
        });
        // 8.给删除按钮绑定单击事件
        $("#removeRoleBtn").click(function () {
            var requestBody = JSON.stringify(window.roleIdArray);
            $.ajax({
                url: "role/remove/by/id/array.json",
                type: "POST",
                data: requestBody,
                contentType: "application/json;charset=UTF-8",
                dataType: "json",
                success: function (response) {
                    var result = response.result;
                    if (result == "SUCCESS") {
                        layer.msg("操作成功");
                        generatePage();
                    }
                    if (result == "FAILED") {
                        layer.msg("操作失败:" + response.message);
                    }
                },
                error: function (response) {
                    layer.msg(response.status + " " + response.statusText);
                }
            });
            // 关闭模态框
            $("#confirmModal").modal("hide");
        });
        // 9.给单条按钮绑定单击函数
        $("#rolePageBody").on("click", ".removeBtn", function () {
            // 从当前按钮出发获取角色名称
            var roleName = $(this).parent().prev().text();
            // 创建role对象存入中数组
            var roleArray = [{
                roleId: this.id,
                roleName: roleName
            }];
            // 调用专门的函数打开模态框
            showConfirmModal(roleArray);
        });
        // 10.给总的checkbox绑定单击事件
        $("#summaryBox").click(function () {
            // 获取当前多选框自身状态
            var currentStatus = this.checked;
            // 用当前多选框状态设置其他多选框
            $(".itemBox").prop("checked", currentStatus)
        });
        // 11.全选全不选反向操作
        $("#rolePageBody").on("click", ".itemBox", function () {
            // 获取当前已经选中的.itemBox的数量
            var checkedBoxCount = $(".itemBox:checked").length;
            // 获取全部.itemBox的数量
            var totalBoxCount = $(".itemBox").length;
            // 使用二者的比较结果来设置总的checkBox
            $("#summaryBox").prop("checked", checkedBoxCount == totalBoxCount);
        });
        // 12.给批量删除的按钮绑定单击事件
        $("#batchRemoveBtn").click(function () {
            var roleArray = [];
            // 遍历当前选中的多选框
            $(".itemBox:checked").each(function () {
                // 使用this引用当前遍历得到的多选框
                var roleId = this.id;
                // 获取角色的名称
                var roleName = $(this).parent().next().text();
                roleArray.push({
                    "roleId": roleId,
                    "roleName": roleName
                });
            });
            // 检查roleArray的长度是否为0
            if (roleArray.length == 0) {
                layer.msg("请至少选择一个执行删除");
                return;
            }
            //调用专门的函数打开模态框
            showConfirmModal(roleArray);
        });
        // 13.给分配权限按钮绑定单击事件
        $("#rolePageBody").on("click", ".checkBtn", function () {
            // 把当前角色id存入到全局变量
            window.roleId = this.id;
            // 打开模态框
            $("#assignModal").modal("show");
            // 在模态框中装载Auth的树形结构和数据
            fillAuthTree();
        });
        // 14.给分配权限模态框中的"分配"按钮绑定单击事件
        $("#assignBtn").click(function (){
            // 收集树形结构的各个节点中被勾选的节点
            // 声明一个专门的数组存放id
            var authIdArray = [];
            // 获取zTreeObj对象
            var zTreeObj = $.fn.zTree.getZTreeObj("authTreeDemo");
            // 获取全部被勾选的节点
            var checkedNodes = zTreeObj.getCheckedNodes();
            // 遍历checkedNodes
            for (var i = 0; i < checkedNodes.length; i++) {
                var checkedNode = checkedNodes[i];
                var authId = checkedNode.id;
                authIdArray.push(authId);
            }
            // 发送ajax请求执行分配
            var requestBody = {
                "authIdArray":authIdArray,
                // 为了服务器端Controller方法能够统一使用List<Integer>方式接收数据，roleId也存入数组
                "roleId":[window.roleId]
            };
            requestBody = JSON.stringify(requestBody);
            $.ajax({
                "url":"assign/do/role/assign/auth.json",
                "type":"POST",
                "data":requestBody,
                "contentType":"application/json;charset=UTF-8",
                "dataType":"json",
                success:function (response) {
                    var result = response.result;
                    if(result == "SUCCESS") {
                        layer.msg("操作成功");
                    }
                    if(result == "FAILED") {
                        layer.msg("操作失败:" + response.message);
                    }
                },
                error:function (response) {
                    layer.msg(response.status + " " + response.statusText);
                }
            });
            $("#assignModal").modal("hide");
        });
    });
</script>
<script type="text/javascript">
    // 声明专门的函数用来分配Auth的模态框中显示Auth的树形结构数据
    function fillAuthTree() {
        // 1.发送ajax请求，查询Auth数据
        var ajaxReturn = $.ajax({
            url: "assign/get/all/auth.json",
            type: "POST",
            async: false,
            dataType: "json"
        });
        if (ajaxReturn.status != 200) {
            layer.msg(ajaxReturn.status + " " + ajaxReturn.statusText);
            return;
        }
        // 2.从响应结果中获取Auth的JSON数据
        // 从服务器端查询到的list不需要组装成树形结构，这里我们交给zTree组装
        var authList = ajaxReturn.responseJSON.data
        // 3.准备对zTree进行设置的json对象
        var setting = {
            "data": {
                "simpleData": {
                    "enable": true,
                    // 使用categoryId属性关联父节点，不再使用默认的pid关联父节点
                    "pIdKey": "categoryId"
                },
                "key": {
                    // 使用title属性显示节点名称,不再使用默认的name作为属性名了
                    "name": "title"
                }
            },
            "check": {
                "enable": true
            }
        };
        // 4.生成树形结构
        $.fn.zTree.init($("#authTreeDemo"), setting, authList);
        // 调用zTreeObj对象的方法，把节点展开
        var zTreeObj = $.fn.zTree.getZTreeObj("authTreeDemo");
        zTreeObj.expandAll(true);
        // 5.查询已分配的Auth的id组成的数组
        ajaxReturn = $.ajax({
            "url": "assign/get/assigned/auth/id/by/role/id.json",
            "type": "POST",
            "data": {
                "roleId": window.roleId
            },
            "async": false,
            "dataType": "json"
        });
        if (ajaxReturn.status != 200) {
            layer.msg(ajaxReturn.status + " " + ajaxReturn.statusText);
            return;
        }
        // 从响应结果中获取authIdArray
        var authIdArray = ajaxReturn.responseJSON.data
        // 6.根据authIdArray树形结构中对应的节点勾选上
        // 遍历authIdArray
        for (var i = 0; i < authIdArray.length; i++) {
            var authId = authIdArray[i];
            // 根据id查询树形结构中对应的节点
            var treeNode = zTreeObj.getNodeByParam("id",authId);
            // 将treeNode设置为被勾选
            // checked设置为true，表示节点被勾选
            var checked = true;
            // checkTypeFlag设置为false，表示不联动，为了避免把不该勾选的勾选上
            var checkTypeFlag = false;
            zTreeObj.checkNode(treeNode,checked,checkTypeFlag);
        }
    }

    // 声明专门的函数显示确认模态框
    function showConfirmModal(roleArray) {
        // 1.打开模态框
        $("#confirmModal").modal("show");
        // 清除旧的数据
        $("#roleNameDiv").empty();
        window.roleIdArray = [];
        // 2.遍历roleArray数组
        for (var i = 0; i < roleArray.length; i++) {
            var role = roleArray[i];
            var roleName = role.roleName;
            $("#roleNameDiv").append(roleName + "<br/>");
            var roleId = role.roleId;
            // 调用数组对象的push()方法存入新元素
            window.roleIdArray.push(roleId);
        }
    }

    /*执行分页，生成页面效果，任何时候调用这个函数都会重新加载页面*/
    function generatePage() {
        $("#summaryBox").prop("checked", false);
        // 1.获取分页数据
        var pageInfo = getPageInfoRemote();
        // 2.填充表格
        fillTableBody(pageInfo);
    }

    /*远程访问服务器端程序获取pageInfo数据*/
    function getPageInfoRemote() {
        // 调用$.ajax()函数发送请求并接收$.ajax()函数的返回值
        var ajaxResult = $.ajax({
            url: "role/get/page/info.json",
            type: "POST",
            data: {
                "pageNum": window.pageNum,
                "pageSize": window.pageSize,
                "keyword": window.keyword
            },
            async: false,
            dataType: "json"
        });

        // 判断当前响应码是否为200
        var statusCode = ajaxResult.status;
        // 如果当前响应码不是200，说明发生了错误或其他情况，显示提示消息，让当前函数停止执行
        if (statusCode != 200) {
            layer.msg("响应状态码=" + statusCode + ",说明信息=" + ajaxResult.statusText);
            return null;
        }
        // 获取pageInfo
        var resultEntity = ajaxResult.responseJSON;
        // 从resultEntity中获取result属性
        var result = resultEntity.result;
        // 判断result是否成功
        if (result == "FAILED") {
            layer.msg(resultEntity.message);
            return null;
        }
        // 确认result为成功后获取pageInfo
        var pageInfo = resultEntity.data;
        // 返回pageInfo
        return pageInfo;
    }

    /*填充表格*/
    function fillTableBody(pageInfo) {
        // 消除tBody中的旧的数据
        $("#rolePageBody").empty();
        // 这里清空是为了让没有搜索结果时不显示页码导航条
        $("#Pagination").empty();
        // 判断pageInfo是否有效
        if (pageInfo == null || pageInfo == undefined || pageInfo.list.length == 0) {
            $("#rolePageBody").append("<tr><td colspan='4'>抱歉，没有查询到您搜索的数据</td></tr>");
            return;
        }
        // 使用pageInfo填充tbody
        for (var i = 0; i < pageInfo.list.length; i++) {
            var role = pageInfo.list[i];
            var roleId = role.id;
            var roleName = role.name;
            var numberTd = "<td>" + (i + 1) + "</td>";
            var checkboxId = "<td><input id='" + roleId + "' class='itemBox' type='checkbox'></td>";
            var roleNameTd = "<td>" + roleName + "</td>";
            var checkBtn = "<button id='" + roleId + "' type='button' class='btn btn-success btn-xs checkBtn'><i class=' glyphicon glyphicon-check'></i></button>";
            // 通过button标签的id属性把roleId值传递到button按钮的单击响应函数中，再单击响应函数中使用this.id
            var pencilBtn = "<button id='" + roleId + "' type='button' class='btn btn-primary btn-xs pencilBtn'><i class=' glyphicon glyphicon-pencil'></i></button>";
            var removeBtn = "<button id='" + roleId + "' type='button' class='btn btn-danger btn-xs removeBtn'><i class=' glyphicon glyphicon-remove'></i></button>";
            var buttonTd = "<td>" + checkBtn + " " + pencilBtn + " " + removeBtn + "</td>";
            var tr = "<tr>" + numberTd + checkboxId + roleNameTd + buttonTd + "</tr>";
            $("#rolePageBody").append(tr);
            generateNavigator(pageInfo);
        }

    }

    /*生成分页页码导航条*/
    function generateNavigator(pageInfo) {
        // 获取总记录数
        var totalRecord = pageInfo.total;
        // 声明相关属性
        var properties = {
            num_edge_entries: 3,
            num_display_entries: 5,
            callback: paginationCallBack,
            items_per_page: pageInfo.pageSize,
            current_page: pageInfo.pageNum - 1,
            prev_text: "上一页",
            next_text: "下一页"
        }
        // 调用pagination()函数
        $("#Pagination").pagination(totalRecord, properties);
    }

    /*翻页时的回调函数*/
    function paginationCallBack(pageIndex, jQuery) {
        // 计算pageNum
        window.pageNum = pageIndex + 1;
        // 调用分页函数
        generatePage();
        // 取消页码超链接的默认行为
        return false;
    }

</script>
<body>
<%@include file="include-nav.jsp" %>
<div class="container-fluid">
    <div class="row">
        <%@include file="include-sidebar.jsp" %>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input id="keywordInput" name="keyword" class="form-control has-success" type="text"
                                       placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="searchBtn" type="button" class="btn btn-warning"><i
                                class="glyphicon glyphicon-search"></i> 查询
                        </button>
                    </form>
                    <button type="button" id="batchRemoveBtn" class="btn btn-danger"
                            style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除
                    </button>
                    <button type="button" id="showAddModalBtn" class="btn btn-primary" style="float:right;"><i
                            class="glyphicon glyphicon-plus"></i> 新增
                    </button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr>
                                <th width="30">#</th>
                                <th width="30"><input id="summaryBox" type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody id="rolePageBody">

                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="6" align="center">
                                    <div id="Pagination" class="pagination">

                                    </div>
                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="modal-role-add.jsp" %>
<%@include file="modal-role-edit.jsp" %>
<%@include file="modal-role-confirm.jsp" %>
<%@include file="modal-role-assign-auth.jsp" %>
</body>
</html>