package com.atguigu.crowd.mvc.controller;

import com.atguigu.crowd.service.api.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author Wxt
 * @create 2022-04-07 15:17
 */
@Controller
public class AuthController {
    @Autowired
    private AuthService authService;
}
