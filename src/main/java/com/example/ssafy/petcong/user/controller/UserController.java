package com.example.ssafy.petcong.user.controller;

import com.example.ssafy.petcong.user.model.record.SkillMultimediaRecord;
import com.example.ssafy.petcong.user.model.record.UserImgRecord;
import com.example.ssafy.petcong.user.model.record.UserRecord;
import com.example.ssafy.petcong.user.service.UserService;

import io.swagger.annotations.*;

import jakarta.validation.Valid;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

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
    public ResponseEntity<UserRecord> signup(@RequestBody @Valid UserRecord user) {
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
    public ResponseEntity<?> signin(@RequestBody String uid) {
        log.info("input: " + uid);
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

    @ApiOperation(value = "프로필 이미지 url 얻기", notes = "생성된 presigned url 다운로드 링크 제공")
    @ApiResponses({
            @ApiResponse(code = 200, message = "url 생성 성공")
    })
    @GetMapping({"/picture", "/trick"})
    public ResponseEntity<?> getMediaUrl(String key) {
        String url = userService.createPresignedUrl(key);
        return ResponseEntity
                .ok()
                .body(url);
    }

    @ApiOperation(value = "프로필 이미지 업로드", notes = "이미지 파일은 S3, 메타데이터는 MySQL에 업로드")
    @ApiResponses({
            @ApiResponse(code = 200, message = "업로드 성공")
    })
    @PostMapping("/picture")
    public ResponseEntity<?> postProfileImage(@RequestBody String uid, @RequestParam("file")MultipartFile file) throws IOException {
        //String uid = (String) SecurityContextHolder.getContext().getAuthentication().getCredentials();

        UserRecord user = userService.findUserByUid(uid);

        UserImgRecord userImgRecord = userService.uploadUserImage(user, file);

        return ResponseEntity
                .ok()
                .body(userImgRecord);
    }

    @ApiOperation(value = "개 인기 업로드", notes = "멀티미디어 파일은 S3, 메타데이터는 MySQL에 업로드")
    @ApiResponses({
            @ApiResponse(code = 200, message = "업로드 성공")
    })
    @PostMapping("/trick")
    public ResponseEntity<?> postDogTrick(@RequestBody String uid, @RequestParam("file")MultipartFile file) throws IOException {
        UserRecord user = userService.findUserByUid(uid);

        SkillMultimediaRecord skillMultimediaRecord = userService.uploadSkillMultimedia(user, file);

        return ResponseEntity
                .ok()
                .body(skillMultimediaRecord);
    }

    @ApiOperation(value = "회원탈퇴", notes = "회원탈퇴")
    @ApiResponses({
            @ApiResponse(code = 200, message = "탈퇴 성공"),
            @ApiResponse(code = 202, message = "이미 탈퇴"),
            @ApiResponse(code = 500, message = "탈퇴 실패")
    })
    @DeleteMapping("/withdraw")
    public ResponseEntity<?> deleteUser(@RequestBody int userId) {
        int deletedCount = userService.deleteUserByUserId(userId);

        if (deletedCount == 1) {
            return ResponseEntity
                    .ok()
                    .body("Successfully withdraw");
        } else if (deletedCount == 0) {
            return ResponseEntity
                    .accepted()
                    .body("Already withdraw");
        }
        else {
            return ResponseEntity
                    .internalServerError()
                    .body("Not withdraw");
        }
    }
}
