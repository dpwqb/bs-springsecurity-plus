package com.codermy.myspringsecurityplus.admin.service.impl;

import cn.hutool.core.util.ArrayUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.codermy.myspringsecurityplus.admin.annotation.DataPermission;
import com.codermy.myspringsecurityplus.admin.dao.RoleUserDao;
import com.codermy.myspringsecurityplus.admin.dao.UserDao;
import com.codermy.myspringsecurityplus.admin.dao.UserJobDao;

import com.codermy.myspringsecurityplus.admin.entity.MyRoleUser;
import com.codermy.myspringsecurityplus.admin.entity.MyUser;
import com.codermy.myspringsecurityplus.admin.entity.MyUserJob;
import com.codermy.myspringsecurityplus.admin.service.UserService;
import com.codermy.myspringsecurityplus.common.exceptionhandler.MyException;
import com.codermy.myspringsecurityplus.common.utils.Result;
import com.codermy.myspringsecurityplus.common.utils.ResultCode;
import com.codermy.myspringsecurityplus.common.utils.UserConstants;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.thymeleaf.util.ListUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * @author codermy
 * @createTime 2025/7/10
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;

    @Autowired
    private RoleUserDao roleUserDao;

    @Autowired
    private UserJobDao userJobDao;

    @Override
    @DataPermission(deptAlias = "d", userAlias = "u")
    public Result<MyUser> getAllUsersByPage(Integer offectPosition, Integer limit, MyUser myUser) {
        Page page = PageHelper.offsetPage(offectPosition,limit);
        List<MyUser> fuzzyUserByPage = userDao.getFuzzyUserByPage(myUser);
        return Result.ok().count(page.getTotal()).data(fuzzyUserByPage).code(ResultCode.TABLE_SUCCESS);
    }

    @Override
    public MyUser getUserById(Integer userId) {
        return userDao.getUserById(userId);
    }

    @Override
    public void checkUserAllowed(MyUser user) {
        if (!StringUtils.isEmpty(user.getUserId()) && user.isAdmin())
        {
            throw new MyException(ResultCode.ERROR,"不允许操作超级管理员用户");
        }
    }

    @Override
    public String checkPhoneUnique(MyUser myUser) {
        Integer userId = ObjectUtil.isEmpty(myUser.getUserId()) ? -1: myUser.getUserId();
        MyUser info = userDao.checkPhoneUnique(myUser.getPhone());
        if (ObjectUtil.isNotEmpty(info) && !info.getUserId().equals(userId))
        {
            return UserConstants.USER_PHONE_NOT_UNIQUE;
        }
        return UserConstants.USER_PHONE_UNIQUE;
    }

    @Override
    public String checkUserNameUnique(MyUser myUser) {
        Integer userId = ObjectUtil.isEmpty(myUser.getUserId()) ? -1: myUser.getUserId();
        MyUser info = userDao.checkUsernameUnique(myUser.getUserName());
        if (ObjectUtil.isNotEmpty(info) && !info.getUserId().equals(userId))
        {
            return UserConstants.USER_NAME_NOT_UNIQUE;
        }
        return UserConstants.USER_NAME_UNIQUE;
    }

    @Override
    public Result<MyUser> updateUser(MyUser myUser, Integer roleId) {
        if (roleId!=null){
            userDao.updateUser(myUser);
            MyRoleUser myRoleUser = new MyRoleUser();
            myRoleUser.setUserId(myUser.getUserId());
            myRoleUser.setRoleId(roleId);
            if(roleUserDao.getRoleUserByUserId(myUser.getUserId())!=null){
                roleUserDao.updateMyRoleUser(myRoleUser);
            }else {
                roleUserDao.save(myRoleUser);
            }
            userJobDao.deleteUserJobByUserId(myUser.getUserId());
            insertUserPost(myUser);
            return Result.ok().message("更新成功");
        }else {
            return Result.error().message("更新失败");
        }
    }

    @Override
    public int changeStatus(MyUser user) {
        return userDao.updateUser(user);
    }

    @Override
    public Result<MyUser> save(MyUser myUser, Integer roleId) {
        if(roleId!= null){
            userDao.save(myUser);
            MyRoleUser myRoleUser = new MyRoleUser();
            myRoleUser.setRoleId(roleId);
            myRoleUser.setUserId(myUser.getUserId().intValue());
            roleUserDao.save(myRoleUser);
            insertUserPost(myUser);
            return Result.ok().message("添加成功，初始密码123456");
        }

        return Result.error().message("添加失败");
    }

    @Override
    public int deleteUser(Integer userId) {
        checkUserAllowed(new MyUser(userId));
        roleUserDao.deleteRoleUserByUserId(userId);
        userJobDao.deleteUserJobByUserId(userId);
        return userDao.deleteUserById(userId);
    }

    @Override
    public MyUser getUserByName(String userName) {
        return userDao.getUser(userName);
    }

    @Override
    public String checkEmailUnique(String email) {
        MyUser info = userDao.checkEmailUnique(email);
        if (ObjectUtil.isNotEmpty(info)) {
            return UserConstants.USER_EMAIL_NOT_UNIQUE;
        }
        return UserConstants.USER_EMAIL_UNIQUE;
    }

    @Override
    public Result<MyUser> registerUser(String username, String email, String password) {
        // 参数校验
        if (StrUtil.isEmpty(username) || StrUtil.isEmpty(email) || StrUtil.isEmpty(password)) {
            return Result.error().message("用户名、邮箱、密码不能为空");
        }

        // 检查用户名长度
        if (username.length() < 3 || username.length() > 20) {
            return Result.error().message("用户名长度在3-20个字符");
        }

        // 检查密码长度
        if (password.length() < 6 || password.length() > 20) {
            return Result.error().message("密码长度在6-20个字符");
        }

        // 检查邮箱格式
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return Result.error().message("邮箱格式不正确");
        }

        // 检查用户名是否已存在
        MyUser checkUser = new MyUser();
        checkUser.setUserName(username);
        if (UserConstants.USER_NAME_NOT_UNIQUE.equals(checkUserNameUnique(checkUser))) {
            return Result.error().message("用户名已存在");
        }

        // 检查邮箱是否已存在
        if (UserConstants.USER_EMAIL_NOT_UNIQUE.equals(checkEmailUnique(email))) {
            return Result.error().message("邮箱已存在");
        }

        // 创建用户
        MyUser newUser = new MyUser();
        newUser.setUserName(username);
        newUser.setNickName(username); // 默认昵称为用户名
        newUser.setEmail(email);
        newUser.setPhone(null); // 注册时不收集手机号
        newUser.setDeptId(null); // 注册用户不分配部门
        newUser.setStatus(MyUser.Status.VALID); // 默认有效状态

        // 密码加密
        org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder passwordEncoder =
            new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();
        newUser.setPassword(passwordEncoder.encode(password));

        // 保存用户（默认角色为普通用户 roleId=2）
        Result<MyUser> result = save(newUser, 2);
        if (result.getSuccess()) {
            return Result.ok().message("注册成功");
        } else {
            return Result.error().message("注册失败");
        }
    }


    /**
     * 新增用户岗位信息
     *
     * @param user 用户对象
     */
    public void insertUserPost(MyUser user)
    {
        Integer[] jobs = user.getJobIds();

        if (ArrayUtil.isNotEmpty(jobs))
        {
            // 新增用户与岗位管理
            List<MyUserJob> list = new ArrayList<MyUserJob>();
            for (Integer jobId : jobs)
            {
                MyUserJob up = new MyUserJob();
                up.setUserId(user.getUserId());
                up.setJobId(jobId);
                list.add(up);
            }
            if (list.size() > 0)
            {
                userJobDao.batchUserJob(list);
            }
        }
        return;
    }
}
