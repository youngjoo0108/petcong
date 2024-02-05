package com.example.ssafy.petcong.user.model.entity;

import com.example.ssafy.petcong.user.model.dto.SkillMultimediaRecord;

import jakarta.persistence.*;

import lombok.*;

@Entity
@Table(name = "skill_multimedias")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class SkillMultimedia {
    @Id
    @Column(name = "multimedia_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int multimediaId;
    @Column(name = "user_id")
    private int userId;
    private int ordinal;

    private long length;

    @Column(name = "bucket_key")
    private String bucketKey;
    @Column(name = "content_type")
    private String contentType;

    @Builder
    public SkillMultimedia(int multimediaId, int user, String bucketKey, String contentType, long length, int ordinal) {
        this.multimediaId = multimediaId;
        this.userId = user;
        this.bucketKey = bucketKey;
        this.contentType = contentType;
        this.length = length;
        this.ordinal = ordinal;
    }

    public SkillMultimedia(SkillMultimediaRecord skillMultimediaRecord) {
        this.multimediaId = skillMultimediaRecord.multimediaId();
        this.userId = skillMultimediaRecord.userId();
        this.bucketKey = skillMultimediaRecord.bucketKey();
        this.contentType = skillMultimediaRecord.contentType();
        this.length = skillMultimediaRecord.length();
        this.ordinal = skillMultimediaRecord.ordinal();
    }
}
