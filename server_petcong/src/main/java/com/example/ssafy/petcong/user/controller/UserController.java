package com.example.ssafy.petcong.user.controller;

import com.example.ssafy.petcong.AWS.service.AWSService;
import com.example.ssafy.petcong.user.model.dto.*;
import com.example.ssafy.petcong.user.service.PetService;
import com.example.ssafy.petcong.user.service.UserImgService;
import com.example.ssafy.petcong.user.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.headers.Header;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;

import jakarta.validation.Valid;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URI;
import java.util.List;
import java.util.NoSuchElementException;

@Slf4j
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@Tag(name = "UserController API")
public class UserController {
    private final UserService userService;
    private final UserImgService userImgService;
    private final PetService petService;
    private final AWSService awsService;

    @Operation(summary = "회원가입", description = "가입 기록이 없는 유저 정보 저장",
            parameters = @Parameter(schema = @Schema(implementation = SignupRequestDto.class)),
            responses = {
                @ApiResponse(responseCode = "201", description = "회원가입 성공",
                        content = @Content(schema = @Schema(implementation = SignupResponseDto.class))),
                @ApiResponse(responseCode = "400", description = "가입 시 필요한 유저 정보 누락")
    })
    @PostMapping("/signup")
    public ResponseEntity<?> signup(
        @RequestBody @Valid SignupRequestDto signupRequestDto) {

        UserInfoDto userInfo = signupRequestDto.getUserInfo();
        PetInfoDto petInfo = signupRequestDto.getPetInfo();

        UserRecord savedUser = userService.save(userInfo);
        PetRecord savedPet = petService.save(petInfo);
        SignupResponseDto signupResponseDto = new SignupResponseDto(savedUser, savedPet);

        return ResponseEntity
                .created(URI.create(String.valueOf(savedUser.userId())))
                .body(signupResponseDto);
    }

    @Operation(summary = "로그인", description = "로그인 상태를 변경",
            responses = {
                    @ApiResponse(responseCode = "200", description = "가입 기록 있음",
                            content = @Content(schema = @Schema(implementation = UserRecord.class))),
                    @ApiResponse(responseCode = "202", description = "가입 기록 없음")
    })
    @PostMapping("/signin")
    public ResponseEntity<?> signin(
        @AuthenticationPrincipal(expression = "password") String uid) {

        try {
            UserRecord updatedUser = userService.updateCallable(uid, true);
            return ResponseEntity
                    .ok()
                    .body(updatedUser);
        } catch (NoSuchElementException e) {
            return ResponseEntity
                    .accepted()
                    .build();
        }
    }

    @Operation(summary = "회원 상세 정보 조회",
            responses =
            @ApiResponse(responseCode = "200", description = "조회 성공",
                    content = @Content(schema = @Schema(implementation = UserRecord.class)))
    )
    @GetMapping("/info")
    public ResponseEntity<?> getUserInfo(@AuthenticationPrincipal(expression = "password") String uid) {
        UserRecord user = userService.findUserByUid(uid);

        return ResponseEntity
                .ok()
                .body(user);
    }

    @Operation(summary = "회원 정보 수정",
            responses =
            @ApiResponse(responseCode = "200", description = "수정 성공",
                    content = @Content(schema = @Schema(implementation = UserRecord.class)))
    )
    @PatchMapping("/update")
    public ResponseEntity<?> updateUserInfo(
        @AuthenticationPrincipal(expression = "password") String uid,
        @RequestBody @Valid UserInfoDto userInfo) {

        UserRecord updatedUser = userService.updateUserInfo(uid, userInfo);

        return ResponseEntity
                .ok()
                .body(updatedUser);
    }

    @Operation(summary = "멀티미디어 다운로드 url 얻기", description = "생성된 presigned url 다운로드 링크 제공",
            responses =
            @ApiResponse(responseCode = "200", description = "url 생성 성공")
    )
    @GetMapping({"/picture", "/trick"})
    public ResponseEntity<?> getMediaUrl(String key) {
        String createdUrl = awsService.createPresignedUrl(key);

        return ResponseEntity
                .ok()
                .body(createdUrl);
    }

    @Operation(summary = "프로필 이미지 업로드", description = "이미지 파일은 S3, 메타데이터는 MySQL에 업로드",
            responses = {
                @ApiResponse(responseCode = "200", description = "업로드 성공",
                        headers = @Header(name = "S3 Bucket Key"),
                        content = @Content(schema = @Schema(implementation = UserImgRecord.class)))
    })
    @PostMapping("/picture")
    public ResponseEntity<?> postProfileImage(
        @AuthenticationPrincipal(expression = "password") String uid,
        @RequestParam("file") MultipartFile file) throws IOException {

        UserRecord user = userService.findUserByUid(uid);

        UserImgRecord userImgRecord = userService.uploadUserImage(user, file);

        return ResponseEntity
                .created(URI.create(userImgRecord.bucketKey()))
                .body(userImgRecord);
    }

    @Operation(summary = "개 인기 업로드", description = "멀티미디어 파일은 S3, 메타데이터는 MySQL에 업로드",
            responses = {
                    @ApiResponse(responseCode = "200", description = "업로드 성공",
                            headers = @Header(name = "S3 Bucket Key"),
                            content = @Content(schema = @Schema(implementation = SkillMultimediaRecord.class)))
    })
    @PostMapping("/trick")
    public ResponseEntity<?> postDogTrick(
        @AuthenticationPrincipal(expression = "password") String uid,
        @RequestParam("file") MultipartFile file) throws IOException {

        UserRecord user = userService.findUserByUid(uid);

        SkillMultimediaRecord skillMultimediaRecord = userService.uploadSkillMultimedia(user, file);

        return ResponseEntity
                .created(URI.create(skillMultimediaRecord.bucketKey()))
                .body(skillMultimediaRecord);
    }

    @Operation(summary = "프로필 이미지 수정", description = "이미지 파일은 S3, 메타데이터는 MySQL에 업로드",
            responses =
            @ApiResponse(responseCode = "200", description = "수정 성공")
    )
    @PatchMapping({"/picture", "/trick"})
    public ResponseEntity<?> patchProfileImage(
            @AuthenticationPrincipal(expression = "password") String uid,
            @RequestParam MultipartFile[] files) throws IOException {
        UserRecord user = userService.findUserByUid(uid);

        List<UserImgRecord> userImgRecordList = userService.updateUserImage(user, files);

        return ResponseEntity
                .ok()
                .body(userImgRecordList);
    }

    @Operation(summary = "회원탈퇴", description = "소프트 삭제 필요",
            responses = {
                @ApiResponse(responseCode = "200", description = "탈퇴 성공"),
                @ApiResponse(responseCode = "202", description = "이미 탈퇴")
    })
    @DeleteMapping("/withdraw")
    public ResponseEntity<?> deleteUser(@AuthenticationPrincipal(expression = "password") String uid) {
        if (userService.deleteUserByUid(uid) == 1) {
            return ResponseEntity
                    .ok()
                    .build();
        } else {
            return ResponseEntity
                    .accepted()
                    .build();
        }
    }
}
