package com.example.ssafy.petcong.user.model.dto;

import com.example.ssafy.petcong.user.model.entity.UserImg;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(title = "프로필 사진 정보")
public record UserImgRecord(
        @Schema(title = "사진 ID")
        int imgId,
        @Schema(title = "유저 ID")
        int userId,
        @Schema(title = "URL", description = "S3 버킷에 저장된 객체를 접근할 수 있는 Key")
        String url,
        @Schema(title = "파일 컨텐츠 타입")
        String contentType,
        @Schema(title = "파일 크기")
        long length,
        @Schema(title = "순서", description = "여러 사진 중에서 나타낼 순서")
        int ordinal
) {
        public UserImgRecord(UserImg userImg) {
                this(
                        userImg.getImgId(),
                        userImg.getUserId(),
                        userImg.getUrl(),
                        userImg.getContentType(),
                        userImg.getLength(),
                        userImg.getOrdinal()
                );
        }
}
