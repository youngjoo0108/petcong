package com.example.ssafy.petcong.user.model.dto;

import com.example.ssafy.petcong.user.model.entity.UserImg;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(title = "프로필 사진 정보")
public record UserImgRecord(
        @Schema(title = "사진 ID")
        int imgId,
        @Schema(title = "유저 record")
        UserRecord user,
        @Schema(title = "S3 버킷 키", description = "S3 버킷에 저장된 객체를 접근할 수 있는 Key")
        String bucketKey,
        @Schema(title = "파일 컨텐츠 타입")
        String contentType,
        @Schema(title = "파일 크기")
        long length,
        @Schema(title = "순서", description = "여러 사진 중에서 나타낼 순서")
        int ordinal
) {
        public static UserImgRecord fromUserImgEntity(UserImg userImg) {
                return new UserImgRecord(
                        userImg.getImgId(),
                        UserRecord.fromUserEntity(userImg.getUser()),
                        userImg.getBucketKey(),
                        userImg.getContentType(),
                        userImg.getLength(),
                        userImg.getOrdinal()
                );
        }
}
