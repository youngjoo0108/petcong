package com.example.ssafy.petcong.user.model;

import java.util.Date;

public record User(
        int userId,
        Enum gender,
        int age,
        String nickname,
        String email,
        String region,
        Date birthday,
        Enum status,
        String social_url,
        boolean isCallable,
        Enum preference) {
}
