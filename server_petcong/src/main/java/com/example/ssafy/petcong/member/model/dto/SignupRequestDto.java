package com.example.ssafy.petcong.member.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;

import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Schema(title = "회원가입 Request", description = "회원가입 요청 시 받는 Request")
public class SignupRequestDto {
    @Valid
    @NotNull
    @Schema(title = "회원가입 유저 정보")
    SignupMemberInfoDto  signupMemberInfo;
    @Valid
    @NotNull
    @Schema(title = "펫 정보")
    PetInfoDto petInfo;
}
