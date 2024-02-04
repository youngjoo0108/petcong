package com.example.ssafy.petcong.user.model.entity;

import com.example.ssafy.petcong.user.model.dto.PetInfoDto;
import com.example.ssafy.petcong.user.model.dto.PetRecord;
import com.example.ssafy.petcong.user.model.enums.Gender;
import com.example.ssafy.petcong.user.model.enums.PetSize;

import jakarta.persistence.*;

import lombok.*;

@Entity
@Table(name = "pets")
@Getter
@ToString
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Pet {
    @Id
    @Column(name = "pet_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int petId;
    @Column(name = "user_id")
    int userId;
    String name;
    String breed;
    int age;
    @Enumerated(EnumType.STRING)
    Gender gender;
    boolean neutered;
    @Enumerated(EnumType.STRING)
    PetSize size;
    int weight;
    String description;
    String dbti;
    String hobby;
    String snack;
    String toy;

    public static Pet fromPetRecord(PetRecord petRecord) {
        return Pet.builder()
                .petId(petRecord.petId())
                .userId(petRecord.userId())
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

    public void updateUserId(int userId) {
        this.userId = userId;
    }
}
