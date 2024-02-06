package com.example.ssafy.petcong.user.model.entity;

import com.example.ssafy.petcong.user.model.dto.UserImgRecord;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

import lombok.*;

@Entity
@Table(name = "user_imgs")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserImg {
    @Id
    @Column(name = "img_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int imgId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @ToString.Exclude
    @JsonBackReference
    private User user;

    private int ordinal;

    private long length;

    @Column(name = "bucket_key")
    private String bucketKey;

    @Column(name = "content_type")
    private String contentType;

    @Builder
    public UserImg(int imgId, User user, String bucketKey, String contentType, long length, int ordinal) {
        this.imgId = imgId;
        this.user = user;
        this.bucketKey = bucketKey;
        this.contentType = contentType;
        this.length = length;
        this.ordinal = ordinal;
    }

    public UserImg(UserImgRecord userImgRecord) {
        this.imgId = userImgRecord.imgId();
        this.user = User.fromUserRecord(userImgRecord.user());
        this.bucketKey = userImgRecord.bucketKey();
        this.contentType = userImgRecord.contentType();
        this.length = userImgRecord.length();
        this.ordinal = userImgRecord.ordinal();
    }
}
