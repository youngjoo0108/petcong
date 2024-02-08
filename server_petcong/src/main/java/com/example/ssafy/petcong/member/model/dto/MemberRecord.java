package com.example.ssafy.petcong.member.model.dto;

import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.model.enums.Gender;
import com.example.ssafy.petcong.member.model.enums.Preference;
import com.example.ssafy.petcong.member.model.enums.Status;

import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDate;

@Schema(title = "회원 정보")
public record MemberRecord(
        @Schema(title = "유저 아이디")
        int memberId,
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

        public static MemberRecord fromMemberEntity(Member member) {
                return new MemberRecord(
                        member.getMemberId(),
                        member.getAge(),
                        member.isCallable(),
                        member.getNickname(),
                        member.getEmail(),
                        member.getAddress(),
                        member.getUid(),
                        member.getInstagramId(),
                        member.getKakaoId(),
                        member.getBirthday(),
                        member.getGender(),
                        member.getStatus(),
                        member.getPreference()
                );
        }
}
