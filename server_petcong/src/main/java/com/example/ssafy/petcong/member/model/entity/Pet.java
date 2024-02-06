package com.example.ssafy.petcong.member.model.entity;

import com.example.ssafy.petcong.member.model.dto.PetInfoDto;
import com.example.ssafy.petcong.member.model.dto.PetRecord;
import com.example.ssafy.petcong.member.model.enums.Gender;
import com.example.ssafy.petcong.member.model.enums.PetSize;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.*;

import lombok.*;

@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Pet {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "pet_id")
    private int petId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    @ToString.Exclude
    @JsonBackReference
    private Member member;

    private String name;

    private String breed;

    private int age;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    private boolean neutered;

    @Enumerated(EnumType.STRING)
    private PetSize size;

    private int weight;

    private String description;

    private String dbti;

    private String hobby;

    private String snack;

    private String toy;

    public static Pet fromPetRecord(PetRecord petRecord) {
        return Pet.builder()
                .petId(petRecord.petId())
                .member(Member.fromMemberRecord(petRecord.member()))
                .name(petRecord.name())
                .breed(petRecord.breed())
                .age(petRecord.age())
                .gender(petRecord.gender())
                .neutered(petRecord.neutered())
                .size(petRecord.size())
                .weight(petRecord.weight())
                .description(petRecord.description())
                .dbti(petRecord.dbti())
                .hobby(petRecord.hobby())
                .snack(petRecord.snack())
                .toy(petRecord.toy())
                .build();
    }

    public static Pet fromPetInfoDto(PetInfoDto petInfoDto) {
        return Pet.builder()
                .name(petInfoDto.getName())
                .breed(petInfoDto.getBreed())
                .age(petInfoDto.getAge())
                .gender(petInfoDto.getGender())
                .neutered(petInfoDto.isNeutered())
                .size(petInfoDto.getSize())
                .weight(petInfoDto.getWeight())
                .description(petInfoDto.getDescription())
                .dbti(petInfoDto.getDbti())
                .hobby(petInfoDto.getHobby())
                .snack(petInfoDto.getSnack())
                .toy(petInfoDto.getToy())
                .build();
    }

    public void updateMember(Member member) {
        this.member = member;
    }
}
