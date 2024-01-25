package com.example.ssafy.petcong.user.model.record;

import com.example.ssafy.petcong.user.model.enums.Gender;
import com.example.ssafy.petcong.user.model.enums.Preference;
import com.example.ssafy.petcong.user.model.enums.Status;

import jakarta.annotation.Nullable;
import jakarta.validation.constraints.*;

import java.util.Date;

public record UserRecord(
        @NotNull
        int userId,

        @NotNull
        @Positive
        int age,

        @NotNull
        boolean callable,

        @NotNull
        @Size(max = 30)
        String nickname,

        @NotNull
        @Email
        @Size(max = 50)
        String email,

        @Nullable
        @Size(max = 50)
        String address,

        @Nullable
        @Size(max = 255)
        String socialUrl,

        @NotNull
        @Size(max = 30)
        String uid,

        @Nullable
        @Past
        Date birthday,

        Gender gender,

        Status status,

        Preference preference) {
}
