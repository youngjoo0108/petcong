package com.example.ssafy.petcong.user.model.entity;

import com.example.ssafy.petcong.user.model.dto.SkillMultimediaRecord;

import jakarta.persistence.*;

import lombok.*;

@Entity
@Table(name = "skill_multimedias")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class SkillMultimedia {
    @Id
    @Column(name = "multimedia_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int multimediaId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private int ordinal;

    private long length;

    @Column(name = "bucket_key")
    private String bucketKey;

    @Column(name = "content_type")
    private String contentType;

    @Builder
    public SkillMultimedia(int multimediaId, User user, String bucketKey, String contentType, long length, int ordinal) {
        this.multimediaId = multimediaId;
        this.user = user;
        this.bucketKey = bucketKey;
        this.contentType = contentType;
        this.length = length;
        this.ordinal = ordinal;
    }

    public SkillMultimedia(SkillMultimediaRecord skillMultimediaRecord) {
        this.multimediaId = skillMultimediaRecord.multimediaId();
        this.user = User.fromUserRecord(skillMultimediaRecord.user());
        this.bucketKey = skillMultimediaRecord.bucketKey();
        this.contentType = skillMultimediaRecord.contentType();
        this.length = skillMultimediaRecord.length();
        this.ordinal = skillMultimediaRecord.ordinal();
    }
}
