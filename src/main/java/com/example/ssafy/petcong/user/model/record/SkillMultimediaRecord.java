package com.example.ssafy.petcong.user.model.record;

import com.example.ssafy.petcong.user.model.entity.SkillMultimedia;

public record SkillMultimediaRecord(
        int multimediaId,
        int userId,
        String url,
        String contentType,
        long length,
        int ordinal
) {
    public SkillMultimediaRecord(SkillMultimedia skillMultimedia) {
        this(
                skillMultimedia.getMultimediaId(),
                skillMultimedia.getUserId(),
                skillMultimedia.getUrl(),
                skillMultimedia.getContentType(),
                skillMultimedia.getLength(),
                skillMultimedia.getOrdinal()
        );
    }
}
