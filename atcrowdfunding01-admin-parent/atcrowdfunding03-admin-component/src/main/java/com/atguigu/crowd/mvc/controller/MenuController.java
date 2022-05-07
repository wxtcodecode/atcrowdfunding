package com.atguigu.crowd.mvc.controller;

import com.atguigu.crowd.entity.Menu;
import com.atguigu.crowd.service.api.MenuService;
import com.atguigu.crowd.util.ResultEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author Wxt
 * @create 2022-04-06 10:43
 */
@RestController
public class MenuController {
    @Autowired
    private MenuService menuService;
    @RequestMapping("/menu/remove.json")
    public ResultEntity<String> removeMenu(@RequestParam("id") Integer id) {
        menuService.deleteMenuById(id);
        return ResultEntity.successWithoutData();
    }
    @RequestMapping("/menu/edit.json")
    public ResultEntity<String> updateMenu(Menu menu) {
        menuService.updateMenu(menu);
        return ResultEntity.successWithoutData();
    }
    @RequestMapping("/menu/save.json")
    public ResultEntity<String> saveMenu(Menu menu) {
        menuService.saveMenu(menu);
        return ResultEntity.successWithoutData();
    }
    @RequestMapping("/menu/get/whole/tree.json")
    public ResultEntity<Menu> getWholeTreeNew(){
        // 1.查询全部的Menu对象
        List<Menu> menuList = menuService.getAll();
        // 2.声明一个变量用来存储找到的根节点
        Menu root = null;
        // 3.创建一个Map对象用来存储id和Menu对象的对应关系便于查找父节点
        Map<Integer,Menu> menuMap = new HashMap<>();
        // 4.遍历menuList来填充menuMap
        for (Menu menu : menuList) {
            Integer id = menu.getId();
            menuMap.put(id, menu);
        }
        // 5.再次遍历menuList查找根节点，组装父子结点
        for (Menu menu : menuList) {
            // 6.获取当前menu对象的pid属性
            Integer pid = menu.getPid();
            // 7.如果pid为null，判定为根节点
            if(pid == null) {
                root = menu;
                continue;
            }
            // 8.如果pid不为null，说明当前节点有父节点，那么可以根据pid查找到menuMap中对应的Menu对象
            Menu father = menuMap.get(pid);
            // 9. 将当前节点存入父节点的children集合
            father.getChildren().add(menu);
        }
        // 10.经过上面的运算，根节点就包含了整个树形结构，返回根节点就是返回整个树
        return ResultEntity.successWithData(root);
    }
    public ResultEntity<Menu> getWholeTreeOld() {
        // 1.查询全部的Menu对象
        List<Menu> menuList = menuService.getAll();
        // 2.声明一个变量用来存储找到的根节点
        Menu root = null;
        // 3.遍历menuList
        for (Menu menu : menuList) {
            // 4.获取当前menu对象的pid属性
            Integer pid = menu.getPid();
            // 5.检查pid是否为null
            if(pid == null) {
                // 6.把当前正在遍历的这个menu对象赋值给root
                root = menu;
                // 7.停止本次循环，继续执行下一次循环
                continue;
            }
            // 8.如果pid不为null，说明当前节点有父节点，找到父节点就可以进行组装，建立父子关系
            for (Menu maybeFather : menuList) {
                // 9.获取maybeFather的id属性
                Integer id = maybeFather.getId();
                // 10.将子节点的pid和疑似父节点的id进行比较
                if(Objects.equals(pid, id)) {
                    // 11.将子节点存入父节点的children集合
                    maybeFather.getChildren().add(menu);
                    // 12.找到即可停止运行循环
                    break;
                }
            }
        }
        // 13.将组装好的树形结构(也就是根节点对象)，返回给浏览器
        return ResultEntity.successWithData(root);
    }

}
