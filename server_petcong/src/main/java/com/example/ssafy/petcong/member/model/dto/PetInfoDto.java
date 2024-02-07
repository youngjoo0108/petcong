package com.example.ssafy.petcong.member.model.dto;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

import com.example.ssafy.petcong.member.model.enums.Gender;
import com.example.ssafy.petcong.member.model.enums.PetSize;

import io.swagger.v3.oas.annotations.media.Schema;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Schema(title = "반려동물 정보", description = "user_id와 pet_id 값은 저장하지 않음")
public class PetInfoDto {
    @Size(max = 25, message = "max length is 25")
    @NotBlank(message = "name is mandatory")
    @Schema(title = "이름")
    private String name;

    @Size(max = 25, message = "max length is 25")
    @NotBlank(message = "breed is mandatory")
    @Schema(title = "breed")
    private String breed;

    @Positive(message = "age should be greater than zero")
    @Schema(title = "나이", example = "1", minimum = "0", requiredMode = REQUIRED)
    private int age;

    @NotNull(message = "gender is mandatory")
    @Schema(implementation = Gender.class, title = "성별")
    private Gender gender;

    @Schema(title = "중성화 여부", example = "true", requiredMode = REQUIRED)
    private boolean neutered;

    @Schema(implementation = PetSize.class, title = "반려동물의 크기")
    private PetSize size;

    @Positive(message = "weight should be greater than zero")
    @Schema(title = "반려동물의 무게")
    private int weight;

    @Size(max = 255, message = "max length is 255")
    @Schema(title = "추가 설명")
    private String description;

    @Size(max = 4, message = "max length is 4")
    @Schema(title = "DBTI")
    private String dbti;

    @Size(max = 25, message = "max length is 25")
    @Schema(title = "취미")
    private String hobby;

    @Size(max = 25, message = "max length is 25")
    @Schema(title = "좋아하는 간식")
    private String snack;

    @Size(max = 25, message = "max length is 25")
    @Schema(title = "좋아하는 장난감")
    private String toy;

    public static PetInfoDto fromPetRecord(PetRecord petRecord) {
        return new PetInfoDto(
                petRecord.name(),
                petRecord.breed(),
                petRecord.age(),
                petRecord.gender(),
                petRecord.neutered(),
                petRecord.size(),
                petRecord.petId(),
                petRecord.description(),
                petRecord.dbti(),
                petRecord.hobby(),
                petRecord.snack(),
                petRecord.toy()
        );
    }
}
