package com.example.ssafy.petcong.matching.model.entity;

import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.model.enums.Gender;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;
import java.util.List;

public record ProfileRecord(
        int memberId,
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
    public ProfileRecord(Member member, List<String> profileImageUrls) {
        this(
                member.getMemberId(),
                member.getAge(),
                member.getNickname(),
                member.getAddress(),
                member.getBirthday(),
                member.getGender(),
                profileImageUrls
        );
    }
}