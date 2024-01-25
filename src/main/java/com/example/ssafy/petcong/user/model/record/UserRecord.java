package com.example.ssafy.petcong.user.model.record;

import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.enums.Gender;
import com.example.ssafy.petcong.user.model.enums.Preference;
import com.example.ssafy.petcong.user.model.enums.Status;

import jakarta.validation.constraints.*;

import java.time.LocalDate;

public record UserRecord(
        int userId,

        @Positive
        int age,

        boolean callable,

        @Size(max = 30)
        String nickname,

        @Email
        @Size(max = 50)
        String email,

        @Size(max = 50)
        String address,

        @Size(max = 255)
        String socialUrl,

        @Size(max = 30)
        String uid,

        @Past
        LocalDate birthday,

        Gender gender,

        Status status,

        Preference preference) {
        public UserRecord(User user) {
                this(
                        user.getUserId(),
                        user.getAge(),
                        user.isCallable(),
                        user.getNickname(),
                        user.getEmail(),
                        user.getAddress(),
                        user.getSocialUrl(),
                        user.getUid(),
                        user.getBirthday(),
                        user.getGender(),
                        user.getStatus(),
                        user.getPreference()
                );
        }
}
