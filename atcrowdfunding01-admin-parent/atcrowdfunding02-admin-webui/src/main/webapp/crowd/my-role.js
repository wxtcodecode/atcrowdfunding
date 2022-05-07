/*执行分页，生成页面效果，任何时候调用这个函数都会重新加载页面*/
function generatePage() {
    // 1.获取分页数据
    var pageInfo = getPageInfoRemote();
    // 2.填充表格
    fillTableBody(pageInfo);
}

/*远程访问服务器端程序获取pageInfo数据*/
function getPageInfoRemote() {
    // 调用$.ajax()函数发送请求并接收$.ajax()函数的返回值
    var ajaxResult = $.ajax({
        url:"role/get/page/info.json",
        type:"POST",
        data:{
            "pageNum":window.pageNum,
            "pageSize":window.pageSize,
            "keyword":window.keyword
        },
        async:false,
        dataType:"json"
    });

    // 判断当前响应码是否为200
    var statusCode = ajaxResult.status;
    // 如果当前响应码不是200，说明发生了错误或其他情况，显示提示消息，让当前函数停止执行
    if(statusCode != 200) {
        layer.msg("响应状态码=" + statusCode + ",说明信息=" + ajaxResult.statusText);
        return null;
    }
    // 获取pageInfo
    var resultEntity = ajaxResult.responseJSON;
    // 从resultEntity中获取result属性
    var result = resultEntity.result;
    // 判断result是否成功
    if(result == "FAILED") {
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
    // 判断pageInfo是否有效
    if(pageInfo == null || pageInfo == undefined || pageInfo.list.length == 0) {
        $("#rolePageBody").append("<tr><td colspan='4'>抱歉，没有查询到您搜索的数据</td></tr>");
        return;
    }
    // 使用pageInfo填充tbody
    for (var i = 0; i < pageInfo.list.length; i++) {
        var role = pageInfo.list[i];
        var roleId = role.id;
        var roleName = role.name;
        var numberTd = "<td>" + (i + 1) + "</td>";
        var checkboxId = "<td><input type='checkbox'></td>";
        var roleNameTd = "<td>" + roleName + "</td>";
        var checkBtn = "<button type='button' class='btn btn-success btn-xs'><i class=' glyphicon glyphicon-check'></i></button>";
        var pencilBtn = "<button type='button' class='btn btn-primary btn-xs'><i class=' glyphicon glyphicon-pencil'></i></button>";
        var removeBtn = "<button type='button' class='btn btn-danger btn-xs'><i class=' glyphicon glyphicon-remove'></i></button>";
        var buttonTd = "<td>" + checkBtn + " " + pencilBtn + " " + removeBtn + "</td>";
        var tr = "<tr>" + numberTd + checkboxId + roleNameTd + buttonTd + "</tr>";
        $("#rolePageBody").append(tr);
        generaterNavigator(pageInfo);
    }

}

/*生成分页页码导航条*/
function generaterNavigator(pageInfo) {
    // 获取总记录数
    var totalRecord = pageInfo.total;
    // 声明相关属性
    var properties = {
        num_edge_entries: 3,
        num_display_entries: 5,
        callback:paginationCallBack,
        items_per_page: pageInfo.pageSize,
        current_page:pageInfo.pageNum - 1,
        prev_text:"上一页",
        next_text:"下一页"
    }
    // 调用pagination()函数
    $("#Pagination").pagination(totalRecord,properties);
}

/*翻页时的回调函数*/
function paginationCallBack(pageIndex,jQuery) {
    // 计算pageNum
    window.pageNum = pageIndex + 1;
    // 调用分页函数
    generatePage();
    // 取消页码超链接的默认行为
    return false;

}
