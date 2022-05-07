<%--
  Created by IntelliJ IDEA.
  User: wangxiaotong
  Date: 2022/4/2
  Time: 9:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%--
        注意点：
            端口号前面的冒号不能省略
            contextPath前面不能写"/"
            contextPath后面必须写"/"
            页面上参照base标签都必须放在base标签的后面
            页面上所有参照base标签都不能以"/"开头
    --%>
    <%--http://localhost:8080/atcrowdfunding02_admin_webui/test/ssm.html--%>
    <script type="text/javascript" src="jquery/jquery-2.1.1.min.js"></script>
    <base href="http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
    <script type="text/javascript" src="layer/layer.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#btn05").click(function () {
                layer.msg("Layer弹框");
            })
            $("#btn04").click(function () {
               //准备好要发送的数据
               var student = {
                 "stuId":5,
                 "stuName":"Tom",
                 "address":{
                     "province":"广东",
                     "city":"深圳",
                     "street":"后瑞"
                 },
                 "subjectList":[
                     {
                         "subjectName":"JavaSE",
                         "subjectScore":"99"
                     }
                 ],
                 "map":{
                     "k1":"v1",
                     "k2":"v2"
                 }
               };
               //将JSON对象转化成JSON字符串
                var requestBody = JSON.stringify(student);
                $.ajax({
                    url:"send/compose/object.json",
                    type:"POST",
                    data:requestBody,
                    contentType:"application/json;charset=UTF-8",
                    dataType:"json",
                    success:function (response){
                       console.log(response);
                    },
                    success:function (response) {
                        console.log(response);
                    }
                })
            });
            $("#btn03").click(function () {
                //准备好要发送到服务器端的数组
                var array = [5,8,12];
                //将json数组转换为JSON的字符串
                var requestBody = JSON.stringify(array);
                $.ajax({
                    url:"send/array/three.html", //请求目标资源的地址
                    type:"POST",               //请求方式
                    data:requestBody,          //请求体
                    contentType:"application/json;charset=UTF-8", //设置请求体的内容类型，告诉服务器端本次请求体是JSON数据
                    dataType:"text",           //如何对待服务器端的数据
                    success:function (response) { //服务器端成功处理请求后调用的回调函数
                        alert(response);
                    },
                    error:function (response) { //服务器端处理请求失败后调用的回调函数
                        alert(response);
                    }
                });
            });
            $("#btn02").click(function () {
                $.ajax({
                    url:"send/array/two.html",
                    type:"POST",
                    data:{
                        "array[0]":5,
                        "array[1]":8,
                        "array[2]":12
                    },
                    dataType:"text",
                    success:function (response) {
                        alert(response);
                    },
                    error:function (response) {
                        alert(response);
                    }
                });
            });
            $("#btn01").click(function () {
                /*方式1缺陷：controller接收数据时需要在请求参数名称后面多写一组[]*/
                $.ajax({
                    url:"send/array/one.html",
                    type:"POST",
                    data:{
                        "array":[5,8,12]
                    },
                    dataType:"text",
                    success:function (response) {
                        alert(response);
                    },
                    error:function (response) {
                        alert(response);
                    }
                });
            });
        });
    </script>
</head>
<body>
<a href="test/ssm.html">测试SSM整合环境</a> <br>
<button id="btn01">Send [5,8,12] One</button> <br>
<button id="btn02">Send [5,8,12] Two</button> <br>
<button id="btn03">Send [5,8,12] Three</button> <br>
<button id="btn04">Send Compose Object</button> <br>
<button id="btn05">点我弹框</button>
</body>
</html>
