package com.example.ssafy.petcong.member.model.entity;

import com.example.ssafy.petcong.member.model.dto.SkillMultimediaRecord;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class SkillMultimedia {
    @Id
    @Column(name = "multimedia_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int multimediaId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    @ToString.Exclude
    @JsonBackReference
    private Member member;

    private int ordinal;

    private long length;

    @Column(name = "bucket_key")
    private String bucketKey;

    @Column(name = "content_type")
    private String contentType;

    @Builder
    public SkillMultimedia(int multimediaId, Member member, String bucketKey, String contentType, long length, int ordinal) {
        this.multimediaId = multimediaId;
        this.member = member;
        this.bucketKey = bucketKey;
        this.contentType = contentType;
        this.length = length;
        this.ordinal = ordinal;
    }

    public SkillMultimedia(SkillMultimediaRecord skillMultimediaRecord) {
        this.multimediaId = skillMultimediaRecord.multimediaId();
        this.member = Member.fromMemberRecord(skillMultimediaRecord.member());
        this.bucketKey = skillMultimediaRecord.bucketKey();
        this.contentType = skillMultimediaRecord.contentType();
        this.length = skillMultimediaRecord.length();
        this.ordinal = skillMultimediaRecord.ordinal();
    }
}
