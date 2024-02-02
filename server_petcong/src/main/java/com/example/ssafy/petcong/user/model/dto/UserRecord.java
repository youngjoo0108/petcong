package com.example.ssafy.petcong.user.model.dto;

import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.enums.Gender;
import com.example.ssafy.petcong.user.model.enums.Preference;
import com.example.ssafy.petcong.user.model.enums.Status;

import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDate;

@Schema(title = "회원 정보")
public record UserRecord(
        @Schema(title = "유저 아이디")
        int userId,
        @Schema(title = "나이")
        int age,
        @Schema(title = "온라인 상태")
        boolean callable,
        @Schema(title = "닉네임")
        String nickname,
        @Schema(title = "이메일")
        String email,
        @Schema(title = "주소")
        String address,
        @Schema(title = "firebase uid")
        String uid,
        @Schema(title = "인스타그램 ID")
        String instagramId,
        @Schema(title = "카카오 ID")
        String kakaoId,
        @Schema(title = "생일")
        LocalDate birthday,
        @Schema(title = "성별")
        Gender gender,
        @Schema(title = "활성 상태")
        Status status,
        @Schema(title = "선호")
        Preference preference) {
        public UserRecord(User user) {
                this(
                        user.getUserId(),
                        user.getAge(),
                        user.isCallable(),
                        user.getNickname(),
                        user.getEmail(),
                        user.getAddress(),
                        user.getUid(),
                        user.getInstagramId(),
                        user.getKakaoId(),
                        user.getBirthday(),
                        user.getGender(),
                        user.getStatus(),
                        user.getPreference()
                );
        }
}
