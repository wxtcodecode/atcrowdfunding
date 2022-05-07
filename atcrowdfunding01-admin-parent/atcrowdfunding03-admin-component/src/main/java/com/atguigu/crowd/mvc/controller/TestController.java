package com.atguigu.crowd.mvc.controller;


import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.ParamData;
import com.atguigu.crowd.entity.Student;
import com.atguigu.crowd.service.api.AdminService;
import com.atguigu.crowd.util.CrowdUtil;
import com.atguigu.crowd.util.ResultEntity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @author Wxt
 * @create 2022-04-02 9:36
 */
@Controller
public class TestController {
    @Autowired
    private AdminService adminService;
    private Logger logger = LoggerFactory.getLogger(TestController.class);

    @RequestMapping("/test/ssm.html")
    public String testSsm(Model model, HttpServletRequest request) {
        boolean judgeRequestType = CrowdUtil.judgeRequestType(request);
        logger.info("judgeRequestType = " + judgeRequestType);
        List<Admin> adminList = adminService.getAll();
        model.addAttribute("adminList", adminList);
        System.out.println(10 / 0);
        return "target";
    }

    @ResponseBody
    @RequestMapping("/send/array/one.html")
    public String testReceiveArrayOne(@RequestParam("array[]") List<Integer> array) {
        for (Integer number : array) {
            System.out.println("number = " + number);
        }
        return "success";
    }

    @ResponseBody
    @RequestMapping("/send/array/two.html")
    public String testReceiveArrayTwo(ParamData paramData) {
        List<Integer> array = paramData.getArray();
        for (Integer number : array) {
            System.out.println("number = " + number);
        }
        return "success";
    }

    @ResponseBody
    @RequestMapping("/send/array/three.html")
    public String testReceiveArrayThree(@RequestBody List<Integer> array) {

        for (Integer number : array) {
            logger.info("number:" + number);
        }
        return "success";
    }

    @ResponseBody
    @RequestMapping("/send/compose/object.json")
    public ResultEntity<Student> testReceiveComposeObject(@RequestBody Student student, HttpServletRequest request) {
        boolean judgeRequestType = CrowdUtil.judgeRequestType(request);
        logger.info("judgeRequestType = " + judgeRequestType);
        logger.info(student.toString());
        //将查询到的Student对象封装到ResultEntity中返回
        ResultEntity<Student> resultEntity = ResultEntity.successWithData(student);
        return resultEntity;
    }

    @ResponseBody
    @RequestMapping("/test/ajax/async.html")
    public String testAsync() throws InterruptedException {
        Thread.sleep(2000);
        return "success";
    }

    @ResponseBody
    @RequestMapping("/test/ajax/noAsync.html")
    public String testNoAsync() throws InterruptedException {
        Thread.sleep(2000);
        return "success";
    }
}
