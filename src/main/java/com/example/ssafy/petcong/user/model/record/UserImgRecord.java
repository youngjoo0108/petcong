package com.example.ssafy.petcong.user.model.record;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record UserImgRecord(
        @NotNull
        int imgId,
        @NotNull
        int userId,
        @NotNull
        @Size(max = 255)
        String url,
        @NotNull
        @Size(max = 20)
        String contentType,
        @NotNull
        @Positive
        int length,
        @NotNull
        @Positive
        int order
) {
}
