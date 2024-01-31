package com.example.ssafy.petcong.user.model.dto;

import com.example.ssafy.petcong.user.model.entity.UserImg;

import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import lombok.Builder;

@Builder
public record UserImgRecord(
        int imgId,
        int userId,
        @Size(max = 255)
        String url,
        @Size(max = 20)
        String contentType,
        @Positive
        long length,
        @Positive
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
