package com.wsa.controller;

import com.wsa.model.*;
import com.wsa.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/getLoginUserInfo")
    public ResultVO<UserInfo> getLoginUserInfo(@RequestBody UserRequest request) {
        UserInfo userInfo = userService.getUserInfoByUsername(request.getUsername());
        if (userInfo != null) {
            return ResultVO.success(userInfo);
        } else {
            return ResultVO.failure("getLoginUserInfo : not found!");
        }
    }
    @GetMapping("/admin/user/getUserList")
    public ResultVO<UserListRes> getUserList() {
        List<UserInfo> userInfos = userService.getAllUsers();
        if (userInfos != null) {
            UserListRes userListRes = new UserListRes();
            userListRes.setCount(Long.valueOf(userInfos.size()));
            userListRes.setList(userInfos);
            return ResultVO.success(userListRes);
        } else {
            return ResultVO.failure("getUserList : not found!");
        }
    }
    @PostMapping("/admin/user/getUserById")
    public ResultVO<UserInfo> getUserById(@RequestBody UserRequest request) {
        UserInfo userInfo = userService.getUserInfoById(request.getId());
        if (userInfo != null) {
            return ResultVO.success(userInfo);
        } else {
            return ResultVO.failure("getUserById : not found!");
        }
    }

    @PostMapping("/admin/user/addUser")
    public ResultVO<String> addUser(@RequestBody UserReq request) {
        userService.addUser(request);
        return ResultVO.success("add success");
    }

    @PostMapping("/admin/user/updateUser")
    public ResultVO<String> updateUser(@RequestBody UserReq request) {
        userService.updateUser(request);
        return ResultVO.success("update success");
    }

    @PostMapping("/admin/user/deleteUser")
    public ResultVO<String> deleteUser(@RequestBody UserReq request) {
        userService.deleteUser(request);
        return ResultVO.success("delete success");
    }
}