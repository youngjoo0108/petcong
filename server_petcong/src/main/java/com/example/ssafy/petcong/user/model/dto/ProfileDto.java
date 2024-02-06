package com.example.ssafy.petcong.user.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Builder
@Schema(title = "프로필 정보", description = "프로필 정보는 유저 프로필과 펫 프로필로 구분할 수 있음")
public class ProfileDto {
    UserProfileDto userProfile;
    PetProfileDto petProfile;
}
