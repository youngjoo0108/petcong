package com.example.ssafy.petcong.matching.model.entity;

import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.enums.Gender;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;
import java.util.List;

public record ProfileRecord(
        int userId,
        @Positive
        int age,
        @Size(max = 30)
        String nickname,
        @Size(max = 50)
        String address,
        @Past
        LocalDate birthday,
        Gender gender,
        List<String> profileImageUrls
) {
    public ProfileRecord(User user, List<String> profileImageUrls) {
        this(
                user.getUserId(),
                user.getAge(),
                user.getNickname(),
                user.getAddress(),
                user.getBirthday(),
                user.getGender(),
                profileImageUrls
        );
    }
}