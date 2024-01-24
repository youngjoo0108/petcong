package com.example.ssafy.petcong.user.controller;

import com.example.ssafy.petcong.user.model.record.UserRecord;
import com.example.ssafy.petcong.user.service.UserService;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import jakarta.validation.Valid;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@CrossOrigin("*")
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@Api("UserController API")
public class UserController {
    private final UserService userService;

    @ApiOperation(value = "회원가입", notes = "가입 기록이 없는 유저 정보 저장")
    @ApiResponses({
            @ApiResponse(code = 200, message = "회원가입 성공"),
            @ApiResponse(code = 400, message = "가입 시 필요한 유저 정보 누락")
    })
    @PostMapping("/signup")
    public ResponseEntity<UserRecord> signup(@Valid UserRecord user) {
        UserRecord savedUser = userService.save(user);

        return ResponseEntity
                .ok()
                .body(savedUser);
    }

    @ApiOperation(value = "로그인", notes = "로그인 상태를 변경")
    @ApiResponses({
            @ApiResponse(code = 200, message = "가입 기록 있음"),
            @ApiResponse(code = 202, message = "가입 기록 없음")
    })
    @PostMapping("/signin")
    public ResponseEntity<?> signin(String uid) {
        UserRecord user = userService.findUserByUid(uid);

        if (user != null) {
            UserRecord updatedUser = userService.updateCallable(user, true);
            return ResponseEntity
                    .ok()
                    .body(updatedUser);
        }
        else {
            return ResponseEntity
                    .accepted()
                    .body("No user founded.");
        }
    }

}
