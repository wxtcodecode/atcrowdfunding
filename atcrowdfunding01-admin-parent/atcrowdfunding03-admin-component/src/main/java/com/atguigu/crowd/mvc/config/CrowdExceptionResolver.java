package com.atguigu.crowd.mvc.config;

import com.atguigu.crowd.exception.AccessForbiddenException;
import com.atguigu.crowd.exception.LoginAcctAlreadyInUseException;
import com.atguigu.crowd.exception.LoginFailedException;
import com.atguigu.crowd.exception.RemoveMySelfException;
import com.atguigu.crowd.util.CrowdConstant;
import com.atguigu.crowd.util.CrowdUtil;
import com.atguigu.crowd.util.ResultEntity;
import com.google.gson.Gson;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * 基于注解的异常映射和基于XML的异常映射如果映射同一个异常类型
 * 那么基于注解的方案优先
 * @author Wxt
 * @create 2022-04-02 19:39
 */
//@ControllerAdvice:表示当前类是一个基于注解的异常处理器类
@ControllerAdvice
public class CrowdExceptionResolver {
    //@ExceptionHandler：将一个具体的异常类型和一个方法关联起来
    @ExceptionHandler(value = LoginFailedException.class)
    //NullPointerException exception:实际捕获到的异常类型
    public ModelAndView resolveLoginFailedException(LoginFailedException exception, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String viewName = "admin-login";
        return commonResolve(viewName,exception,request,response);
    }
    @ExceptionHandler(value = Exception.class)
    public ModelAndView Exception(Exception exception,HttpServletRequest request,HttpServletResponse response) throws IOException {
        String viewName = "admin-login";
        return commonResolve(viewName, exception, request, response);
    }
    @ExceptionHandler(value = RemoveMySelfException.class)
    public ModelAndView resolveRemoveMySelfException(RemoveMySelfException exception,HttpServletRequest request,HttpServletResponse response) throws IOException {
        String viewName = "admin-page";
        return commonResolve(viewName, exception, request, response);
    }
    @ExceptionHandler(value = LoginAcctAlreadyInUseException.class)
    public ModelAndView resolveLoginAcctAlreadyInUseException(LoginAcctAlreadyInUseException exception,HttpServletRequest request,HttpServletResponse response) throws IOException {
        String viewName = "admin-add";
        return commonResolve(viewName, exception, request, response);
    }
    private ModelAndView commonResolve(String viewName,Exception exception,HttpServletRequest request,HttpServletResponse response) throws IOException {
        //1.判断请求的类型
        boolean judgeRequestType = CrowdUtil.judgeRequestType(request);
        //2.如果是一个ajax请求
        if(judgeRequestType) {
            //3.创建ResultEntity对象
            ResultEntity<Object> resultEntity = ResultEntity.failed(exception.getMessage());
            //4.创建Gson对象
            Gson gson = new Gson();
            //5.将ResultEntity对象转化成json对象
            String json = gson.toJson(resultEntity);
            //6.将json字符串作为响应返回给浏览器
            response.getWriter().write(json);
            //7.由于上面已经通过原生的response对象返回了响应，所以不提供ModelAndView对象
            return null;
        }
        //8.如果不是ajax请求，创建ModelAndView对象
        ModelAndView modelAndView = new ModelAndView();
        //9.将Exception对象存入模型
        modelAndView.addObject(CrowdConstant.ATTR_NAME_EXCEPTION, exception);
        //10.设置对应的视图
        modelAndView.setViewName(viewName);
        return modelAndView;
    }
}
