package com.example.ssafy.petcong.member.model.dto;

import com.example.ssafy.petcong.member.model.entity.Pet;
import com.example.ssafy.petcong.member.model.enums.Gender;
import com.example.ssafy.petcong.member.model.enums.PetSize;

import io.swagger.v3.oas.annotations.media.Schema;


@Schema(title = "반려동물 정보")
public record PetRecord(
        @Schema(title = "펫 아이디")
        int petId,
        @Schema(title = "유저 record")
        MemberRecord member,
        @Schema(title = "이름")
        String name,
        @Schema(title = "종")
        String breed,
        @Schema(title = "나이")
        int age,
        @Schema(title = "성별")
        Gender gender,
        @Schema(title = "중성화 여부")
        boolean neutered,
        @Schema(title = "크기")
        PetSize size,
        @Schema(title = "무게")
        int weight,
        @Schema(title = "설명")
        String description,
        @Schema(title = "DBTI")
        String dbti,
        @Schema(title = "취미")
        String hobby,
        @Schema(title = "좋아하는 간식")
        String snack,
        @Schema(title = "좋아하는 장난감")
        String toy
) {

    public static PetRecord fromPetEntity(Pet pet) {
        return new PetRecord(
                pet.getPetId(),
                MemberRecord.fromMemberEntity(pet.getMember()),
                pet.getName(),
                pet.getBreed(),
                pet.getAge(),
                pet.getGender(),
                pet.isNeutered(),
                pet.getSize(),
                pet.getWeight(),
                pet.getDescription(),
                pet.getDbti(),
                pet.getHobby(),
                pet.getSnack(),
                pet.getToy()
        );
    }
}
