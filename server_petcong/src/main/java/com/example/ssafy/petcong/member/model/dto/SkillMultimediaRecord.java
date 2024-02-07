package com.example.ssafy.petcong.member.model.dto;

import com.example.ssafy.petcong.member.model.entity.SkillMultimedia;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(title = "개 인기 정보")
public record SkillMultimediaRecord(
        @Schema(title = "개 인기 ID")
        int multimediaId,
        @Schema(title = "유저 record")
        MemberRecord member,
        @Schema(title = "S3 버킷 키", description = "S3 버킷에 저장된 객체를 접근할 수 있는 Key")
        String bucketKey,
        @Schema(title = "파일 컨텐츠 타입")
        String contentType,
        @Schema(title = "파일 크기")
        long length,
        @Schema(title = "순서", description = "여러 개 인기 중에서 나타낼 순서")
        int ordinal
) {
    public static SkillMultimediaRecord fromSkillMultimediaEntity(SkillMultimedia skillMultimedia) {
        return new SkillMultimediaRecord(
            skillMultimedia.getMultimediaId(),
            MemberRecord.fromMemberEntity(skillMultimedia.getMember()),
            skillMultimedia.getBucketKey(),
            skillMultimedia.getContentType(),
            skillMultimedia.getLength(),
            skillMultimedia.getOrdinal()
        );
    }
}
