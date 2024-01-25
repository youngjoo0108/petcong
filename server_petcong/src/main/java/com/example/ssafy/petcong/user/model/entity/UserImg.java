package com.example.ssafy.petcong.user.model.entity;

import com.example.ssafy.petcong.user.model.record.UserImgRecord;

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
    @Column(name = "user_id")
    private int userId;
    private int ordinal;

    private long length;

    private String url;
    @Column(name = "content_type")
    private String contentType;

    @Builder
    public UserImg(int imgId, int user, String url, String contentType, long length, int ordinal) {
        this.imgId = imgId;
        this.userId = user;
        this.url = url;
        this.contentType = contentType;
        this.length = length;
        this.ordinal = ordinal;
    }

    public UserImg(UserImgRecord userImgRecord) {
        this.imgId = userImgRecord.userId();
        this.userId = userImgRecord.userId();
        this.url = userImgRecord.url();
        this.contentType = userImgRecord.contentType();
        this.length = userImgRecord.length();
        this.ordinal = userImgRecord.ordinal();
    }
}
