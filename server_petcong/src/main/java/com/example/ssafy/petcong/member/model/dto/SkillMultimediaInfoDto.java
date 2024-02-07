package com.example.ssafy.petcong.member.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
@Schema(title = "펫 프로필 사진 정보", description = "img_id 와 user 값은 저장하지 않음")
public class SkillMultimediaInfoDto {
    @Schema(title = "S3 버킷 키", description = "S3 버킷에 저장된 객체를 접근할 수 있는 Key")
    String bucketKey;

    @Schema(title = "파일 컨텐츠 타입")
    String contentType;

    @Schema(title = "파일 크기")
    long length;

    @Schema(title = "순서", description = "여러 개 인기 중에서 나타낼 순서")
    int ordinal;

    public static SkillMultimediaInfoDto fromSkillMultimediaRecord(SkillMultimediaRecord skillMultimediaRecord) {
        return new SkillMultimediaInfoDto(
                skillMultimediaRecord.bucketKey(),
                skillMultimediaRecord.contentType(),
                skillMultimediaRecord.length(),
                skillMultimediaRecord.ordinal()
        );
    }
}
