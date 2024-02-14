package com.example.ssafy.petcong.member.controller;

import com.example.ssafy.petcong.AWS.service.AWSService;
import com.example.ssafy.petcong.member.service.MemberService;
import com.example.ssafy.petcong.security.userdetails.FirebaseUserDetails;
import com.example.ssafy.petcong.member.model.dto.*;
import com.example.ssafy.petcong.security.userdetails.SignupUserDetails;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
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

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
@Tag(name = "UserController API")
public class MemberController {
    private final AWSService awsService;
    private final MemberService memberService;

    @Operation(summary = "회원가입", description = "가입 기록이 없는 유저 정보 저장",
            parameters = @Parameter(schema = @Schema(implementation = SignupRequestDto.class)),
            responses = {
                @ApiResponse(responseCode = "201", description = "회원가입 성공",
                        content = @Content(schema = @Schema(implementation = SignupResponseDto.class))),
                @ApiResponse(responseCode = "400", description = "가입 시 필요한 유저 정보 누락")
    })
    @PostMapping("/signup")
    public ResponseEntity<?> signup(
            @AuthenticationPrincipal(expression = SignupUserDetails.UID) String uid,
            @RequestBody @Valid SignupRequestDto signupRequestDto) {

        SignupResponseDto signupResponseDto = memberService.signup(uid, signupRequestDto);

        return ResponseEntity
                .created(null)
                .body(signupResponseDto);
    }

    @Operation(summary = "로그인", description = "로그인으로 상태를 변경",
            responses = {
                    @ApiResponse(responseCode = "200", description = "가입 기록 있음",
                            content = @Content(schema = @Schema(implementation = MemberRecord.class))),
                    @ApiResponse(responseCode = "202", description = "가입 기록 없음")
    })
    @PostMapping("/signin")
    public ResponseEntity<?> signin(@AuthenticationPrincipal(expression = FirebaseUserDetails.MEMBER_ID) int memberId) {
        MemberRecord updatedUser = memberService.signin(memberId, true);

        return ResponseEntity
                .ok()
                .body(updatedUser);
    }

    @Operation(summary = "로그아웃", description = "로그아웃으로 상태를 변경",
            responses = @ApiResponse(responseCode = "200", description = "로그아웃 성공")
    )
    @PostMapping("/signout")
    public ResponseEntity<?> signout(@AuthenticationPrincipal(expression = FirebaseUserDetails.MEMBER_ID) int memberId) {
        boolean isSignouted = memberService.signout(memberId);

        return ResponseEntity
                .accepted()
                .body(isSignouted);
    };

    @Operation(summary = "회원 상세 정보 조회",
            responses = @ApiResponse(responseCode = "200", description = "조회 성공",
                    content = @Content(schema = @Schema(implementation = ProfileDto.class)))
    )
    @GetMapping("/info")
    public ResponseEntity<?> getUserInfo(@AuthenticationPrincipal(expression = FirebaseUserDetails.MEMBER_ID) int memberId) {
        return getUserInfoByMemberId(memberId);
    }

    @Operation(summary = "Member Id로 회원 상세 정보 조회",
            responses = @ApiResponse(responseCode = "200", description = "조회 성공",
                    content = @Content(schema = @Schema(implementation = ProfileDto.class)))
    )
    @GetMapping("/info/{memberId}")
    public ResponseEntity<?> getUserInfoByMemberId(@PathVariable int memberId) {
        ProfileDto profile = memberService.getProfile(memberId);

        return ResponseEntity
                .ok()
                .body(profile);
    }

    @Operation(summary = "회원 정보 수정",
            parameters = @Parameter(schema = @Schema(implementation = MemberInfoDto.class)),
            responses = @ApiResponse(responseCode = "200", description = "수정 성공",
                    content = @Content(schema = @Schema(implementation = MemberRecord.class)))
    )
    @PatchMapping("/update")
    public ResponseEntity<?> updateUserInfo(
            @AuthenticationPrincipal(expression = FirebaseUserDetails.MEMBER_ID) int memberId,
            @RequestBody @Valid MemberInfoDto memberInfo) {

        MemberRecord updatedUser = memberService.updateMemberInfo(memberId, memberInfo);

        return ResponseEntity
                .ok()
                .body(updatedUser);
    }

    @Operation(summary = "회원탈퇴", description = "소프트 삭제 필요",
            responses = {
                    @ApiResponse(responseCode = "200", description = "탈퇴 성공"),
                    @ApiResponse(responseCode = "202", description = "이미 탈퇴")
            })
    @DeleteMapping("/withdraw")
    public ResponseEntity<?> deleteUser(@AuthenticationPrincipal(expression = FirebaseUserDetails.MEMBER_ID) int memberId) {
        if (memberService.deleteMemberByMemberId(memberId) == 1) {
            return ResponseEntity
                    .ok()
                    .build();
        } else {
            return ResponseEntity
                    .accepted()
                    .build();
        }
    }

    @Operation(summary = "멀티미디어 다운로드 url 얻기", description = "생성된 presigned url 다운로드 링크 제공",
            parameters = @Parameter(description = "S3 버킷 키"),
            responses = @ApiResponse(responseCode = "200", description = "url 생성 성공")
    )
    @GetMapping({"/picture", "/trick"})
    public ResponseEntity<?> getMediaUrl(String key) {
        String createdUrl = awsService.createPresignedUrl(key);

        return ResponseEntity
                .ok()
                .body(createdUrl);
    }

    @Operation(summary = "프로필 이미지 업로드", description = "이미지 파일은 S3, 메타데이터는 MySQL에 업로드",
            responses = @ApiResponse(responseCode = "200", description = "업로드 성공",
                    content = @Content(schema = @Schema(implementation = MemberImgRecord.class)))
    )
    @PostMapping("/picture")
    public ResponseEntity<?> postProfileImage(
            @AuthenticationPrincipal(expression = FirebaseUserDetails.MEMBER_ID) int memberId,
            @AuthenticationPrincipal(expression = FirebaseUserDetails.UID) String uid,
            @RequestParam MultipartFile[] files) {

        List<MemberImgRecord> memberImgRecordList = memberService.uploadMemberImage(memberId, uid, files);

        return ResponseEntity
                .created(null)
                .body(memberImgRecordList);
    }

    @Operation(summary = "개 인기 업로드", description = "멀티미디어 파일은 S3, 메타데이터는 MySQL에 업로드",
            responses = @ApiResponse(responseCode = "200", description = "업로드 성공",
                    content = @Content(schema = @Schema(implementation = SkillMultimediaRecord.class)))
    )
    @PostMapping("/trick")
    public ResponseEntity<?> postDogTrick(
            @AuthenticationPrincipal(expression = FirebaseUserDetails.MEMBER_ID) int memberId,
            @AuthenticationPrincipal(expression = FirebaseUserDetails.UID) String uid,
            @RequestParam MultipartFile[] files) {

        List<SkillMultimediaRecord> skillMultimediaRecordList = memberService.uploadSkillMultimedia(memberId, uid, files);

        return ResponseEntity
                .created(null)
                .body(skillMultimediaRecordList);
    }

    @Operation(summary = "프로필 이미지 수정", description = "이미지 파일은 S3, 메타데이터는 MySQL에 업로드",
            responses = @ApiResponse(responseCode = "200", description = "수정 성공",
                    content = @Content(schema = @Schema(implementation = MemberImgRecord.class)))
    )
    @PatchMapping({"/picture", "/trick"})
    public ResponseEntity<?> patchProfileImage(
            @AuthenticationPrincipal(expression = FirebaseUserDetails.MEMBER_ID) int memberId,
            @AuthenticationPrincipal(expression = FirebaseUserDetails.UID) String uid,
            @RequestParam MultipartFile[] files) {

        List<MemberImgRecord> memberImgRecordList = memberService.updateMemberImage(memberId, uid, files);

        return ResponseEntity
                .ok()
                .body(memberImgRecordList);
    }

    @Operation(summary = "개 인기 수정", description = "멀티미디어 파일은 S3, 메타데이터는 MySQL에 업로드",
            responses = @ApiResponse(responseCode = "200", description = "수정 성공",
                    content = @Content(schema = @Schema(implementation = SkillMultimediaRecord.class)))
    )
    @PatchMapping("/trick")
    public ResponseEntity<?> patchDogTrick(
            @AuthenticationPrincipal(expression = FirebaseUserDetails.MEMBER_ID) int memberId,
            @AuthenticationPrincipal(expression = FirebaseUserDetails.UID) String uid,
            @RequestParam MultipartFile[] files) {

        List<SkillMultimediaRecord> skillMultimediaRecordList = memberService.updateSkillMultimedia(memberId, uid, files);

        return ResponseEntity
                .ok()
                .body(skillMultimediaRecordList);
    }

    @Operation(summary = "프로필 이미지 삭제", description = "업로드 된 프로필 이미지 사진 삭제",
            parameters = @Parameter(description = "삭제할 파일의 S3 버킷 키"),
            responses = @ApiResponse(responseCode = "200", description = "삭제 성공")
    )
    @DeleteMapping("/picture")
    public ResponseEntity<?> deleteProfileImage(String[] keys) {
        memberService.deleteMemberImage(keys);

        return ResponseEntity
                .ok()
                .body(null);
    }

    @Operation(summary = "개 인기 삭제", description = "업로드 된 개 인기 삭제",
            parameters = @Parameter(description = "삭제할 파일의 S3 버킷 키"),
            responses = @ApiResponse(responseCode = "200", description = "삭제 성공")
    )
    @DeleteMapping("/trick")
    public ResponseEntity<?> deleteDogTrick(String[] keys) {
        memberService.deleteSkillMultimedia(keys);

        return ResponseEntity
                .ok()
                .body(null);
    }
}
