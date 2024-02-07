package com.example.ssafy.petcong.member.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@Setter
@ToString
@Builder
@Schema(title = "유저 프로필 정보", description = "유저 프로필 사진은 여러장 일 수 있음")
public class MemberProfileDto {
    MemberInfoDto memberInfo;
    List<MemberImgInfoDto> memberImgInfosList;
}
