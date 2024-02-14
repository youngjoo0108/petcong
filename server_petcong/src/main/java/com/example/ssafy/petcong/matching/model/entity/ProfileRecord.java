package com.example.ssafy.petcong.matching.model.entity;

import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.model.entity.Pet;
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
        Gender gender,
        String petName,
        Gender petGender,
        int petAge,
        String kakaoId,
        String instagramId,
        String description,
        List<String> profileImageUrls
) {
    public ProfileRecord(Member member, Pet pet, List<String> profileImageUrls) {
        this(
                member.getMemberId(),
                member.getAge(),
                member.getNickname(),
                member.getGender(),
                pet.getName(),
                pet.getGender(),
                pet.getAge(),
                member.getKakaoId(),
                member.getInstagramId(),
                pet.getDescription(),
                profileImageUrls
        );
    }
}