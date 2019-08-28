package com.sunday.service.impl;

import com.sunday.bean.User;
import com.sunday.dao.UserDao;
import com.sunday.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @auther u4f55u6770
 * @date: 2019/8/28 09:16
 * @description:
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public List<User> getAll() {
        return userDao.getAll();
    }
}
