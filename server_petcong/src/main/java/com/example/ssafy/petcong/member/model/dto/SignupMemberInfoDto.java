package com.example.ssafy.petcong.member.model.dto;

import com.example.ssafy.petcong.member.model.enums.Gender;
import com.example.ssafy.petcong.member.model.enums.Preference;

import io.swagger.v3.oas.annotations.media.Schema;

import jakarta.validation.constraints.*;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Schema(title = "회원가입 유저 정보", description = "member_id, uid, status, callable 값은 저장하지 않음")
public class SignupMemberInfoDto {
    @Positive(message = "age should be greater than zero")
    @Schema(title = "나이", example = "1", minimum = "0")
    private int age;

    @Size(max = 30, message = "max length is 30")
    @NotBlank(message = "nickname is mandatory")
    @Schema(title = "닉네임", maxLength = 30)
    private String nickname;

    @Email(message = "string is not well-formed email address")
    @Size(max = 50, message = "max length is 50")
    @Schema(title = "이메일", example = "test@petcong.com", maxLength = 50, description = "이메일 양식에 맞춰야함")
    private String email;

    @Size(max = 255, message = "max length is 255")
    @Schema(title = "주소", example = "서울특별시 강남구 역삼동 테헤란로 212, 1402호", maxLength = 255)
    private String address;

    @Size(max = 30, message = "max length is 30")
    @Schema(title = "인스타그램 아이디", nullable = true)
    private String instagramId;

    @Size(max = 30, message = "max length is 30")
    @Schema(title = "카카오 아이디", nullable = true)
    private String kakaoId;

    @Past(message = "birthday should be past")
    @Schema(implementation = LocalDate.class, title = "생일", nullable = true, description = "과거 날짜만 가능")
    private LocalDate birthday;

    @NotNull(message = "gender is mandatory")
    @Schema(implementation = Gender.class, title = "성별")
    private Gender gender;

    @NotNull(message = "preference is mandatory")
    @Schema(implementation = Preference.class, title = "선호 상대")
    private Preference preference;
}
