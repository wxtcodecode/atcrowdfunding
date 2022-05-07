<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="include-head.jsp" %>
<script type="text/javascript">
    $(function (){
       $("#toRightBtn").click(function (){
           // select标签选择器
           // :eq(0)表示选择页面的第一个
           // >表示选择子元素
           // :selected表示选择"被选中的"option
           // append()能够将jQuery对象追加到指定位置
           $("select:eq(0)>option:selected").appendTo("select:eq(1)");
       });
       $("#toLeftBtn").click(function (){
           $("select:eq(1)>option:selected").appendTo("select:eq(0)");
       });
       $("#submitBtn").click(function () {
           // 在提交表单前把已分配部分的option全部选中
          $("select:eq(1)>option").prop("selected","selected");
       });
    });
</script>
<body>
<%@include file="include-nav.jsp" %>
<div class="container-fluid">
    <div class="row">
        <%@include file="include-sidebar.jsp" %>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <ol class="breadcrumb">
                <li><a href="admin/to/main/page.html">首页</a></li>
                <li><a href="admin/to/login/page.html">数据列表</a></li>
                <li class="active">分配角色</li>
            </ol>
            <div class="panel panel-default">
                <div class="panel-body">
                    <form action="assign/do/role/assign.html" method="post" role="form" class="form-inline">
                        <input type="hidden" name="adminId" value="${param.adminId}"/>
                        <input type="hidden" name="pageNum" value="${param.pageNum}"/>
                        <input type="hidden" name="keyword" value="${param.keyword}"/>
                        <div class="form-group">
                            <label>未分配角色列表</label><br>
                            <select class="form-control" multiple="" size="10" style="width:100px;overflow-y:auto;">
                                <%--
                                    value属性的值：将来在提交表单时一起发送给Controller的值
                                    标签体的内容：在浏览器上让用户看到的数据
                                    实际显示角色信息时，value属性值为角色的id
                                    标签体的内容：角色的名称
                                 --%>
                                <c:forEach items="${requestScope.unAssignedRoleList}" var="role">
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <ul>
                                <li id="toRightBtn" class="btn btn-default glyphicon glyphicon-chevron-right"></li>
                                <br>
                                <li id="toLeftBtn" class="btn btn-default glyphicon glyphicon-chevron-left" style="margin-top:20px;"></li>
                            </ul>
                        </div>
                        <div class="form-group" style="margin-left:40px;">
                            <label>已分配角色列表</label><br>
                            <select name="roleIdList" class="form-control" multiple="multiple" size="10" style="width:100px;overflow-y:auto;">
                                <c:forEach items="${requestScope.assignedRoleList}" var="role">
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <button id="submitBtn" type="submit" style="width: 150px;height: 40px;margin-top: 10px;margin-left: 100px"  class="btn btn-lg btn-success btn-block">提交</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>