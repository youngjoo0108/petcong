package com.example.ssafy.petcong.user.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class SignupResponseDto {
    @Schema(title = "유저 정보")
    UserRecord userRecord;
    @Schema(title = "펫 정보")
    PetRecord petRecord;
}
