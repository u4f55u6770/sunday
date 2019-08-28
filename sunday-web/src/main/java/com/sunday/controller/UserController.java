package com.sunday.controller;

import com.sunday.bean.User;
import com.sunday.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @auther u4f55u6770
 * @date: 2019/8/28 09:12
 * @description: 骨架测试使用
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/query")
    public List<User> testQuery() {
        return userService.getAll();
    }
}
