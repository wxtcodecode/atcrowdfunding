<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="WEB-INF/include-head.jsp" %>
<script type="text/javascript">
    $(function () {
        console.log("ajax函数之前")
        // 异步ajax请求(默认)
        $("#asyncBtn").click(function (){
            $.ajax({
                url:"test/ajax/async.html",
                type:"POST",
                dataType:"text",
                success:function (response) {
                    // success是接收服务器端响应后执行
                    console.log("ajax函数内部的success函数:" + response);
                }
            });
            setTimeout(function () {
                // 在$.ajax()执行完成之后执行，不等待success()函数
                console.log("ajax函数之后");
            },5000)
        });
    });
</script>
<script type="text/javascript">
    $(function () {
        console.log("ajax函数之前")
        // 异步ajax请求(默认)
        $("#asyncBtn").click(function (){
            $.ajax({
                url:"test/ajax/noAsync.html",
                type:"POST",
                dataType:"text",
                async:false, // 关闭异步工作模型，使用同步方式工作,此时所有操作在同一个线程内按顺序完成
                success:function (response) {
                    // success是接收服务器端响应后执行
                    console.log("ajax函数内部的success函数:" + response);
                }
            });
            setTimeout(function () {
                // 在$.ajax()执行完成之后执行，不等待success()函数
                console.log("ajax函数之后");
            },5000)
        });
    });
</script>
<body>
<button id="asyncBtn">发送异步Ajax请求</button>
<button id="noAsyncBtn">发送同步Ajax请求</button>
</body>
</html>