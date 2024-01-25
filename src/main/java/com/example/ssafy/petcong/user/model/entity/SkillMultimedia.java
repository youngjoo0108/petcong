package com.example.ssafy.petcong.user.model.entity;

import com.example.ssafy.petcong.user.model.record.SkillMultimediaRecord;

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

    private String url;
    @Column(name = "content_type")
    private String contentType;

    @Builder
    public SkillMultimedia(int multimediaId, int user, String url, String contentType, long length, int ordinal) {
        this.multimediaId = multimediaId;
        this.userId = user;
        this.url = url;
        this.contentType = contentType;
        this.length = length;
        this.ordinal = ordinal;
    }

    public SkillMultimedia(SkillMultimediaRecord skillMultimediaRecord) {
        this.multimediaId = skillMultimediaRecord.multimediaId();
        this.userId = skillMultimediaRecord.userId();
        this.url = skillMultimediaRecord.url();
        this.contentType = skillMultimediaRecord.contentType();
        this.length = skillMultimediaRecord.length();
        this.ordinal = skillMultimediaRecord.ordinal();
    }
}
