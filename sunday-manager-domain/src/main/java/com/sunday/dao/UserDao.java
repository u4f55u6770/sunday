package com.sunday.dao;

import com.sunday.bean.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * @auther u4f55u6770
 * @date: 2019/8/28 09:15
 * @description:
 */
@Mapper
public interface UserDao {

    @Select("select * from user")
    List<User> getAll();
}
