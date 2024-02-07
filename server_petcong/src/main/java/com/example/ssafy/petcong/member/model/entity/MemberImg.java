package com.example.ssafy.petcong.member.model.entity;

import com.example.ssafy.petcong.member.model.dto.MemberImgRecord;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

import lombok.*;

@Entity
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class MemberImg {
    @Id
    @Column(name = "img_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int imgId;

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
    public MemberImg(int imgId, Member member, String bucketKey, String contentType, long length, int ordinal) {
        this.imgId = imgId;
        this.member = member;
        this.bucketKey = bucketKey;
        this.contentType = contentType;
        this.length = length;
        this.ordinal = ordinal;
    }

    public MemberImg(MemberImgRecord memberImgRecord) {
        this.imgId = memberImgRecord.imgId();
        this.member = Member.fromMemberRecord(memberImgRecord.member());
        this.bucketKey = memberImgRecord.bucketKey();
        this.contentType = memberImgRecord.contentType();
        this.length = memberImgRecord.length();
        this.ordinal = memberImgRecord.ordinal();
    }
}
