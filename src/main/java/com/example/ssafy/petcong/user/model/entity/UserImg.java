package com.example.ssafy.petcong.user.model.entity;

import com.example.ssafy.petcong.user.model.record.UserImgRecord;
import jakarta.persistence.*;

import lombok.*;

@Entity
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserImg {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int imgId;
    @OneToOne
    @JoinColumn(name = "userId", referencedColumnName = "userId")
    private User user;
    private String url;
    private String contentType;
    private int length;
    private int order;

    @Builder
    public UserImg(int imgId, User user, String url, String contentType, int length, int order) {
        this.imgId = imgId;
        this.user = user;
        this.url = url;
        this.contentType = contentType;
        this.length = length;
        this.order = order;
    }

    public UserImg(UserImgRecord userImgRecord) {
        this.imgId = userImgRecord.userId();
        this.user = new User(userImgRecord.userId());
        this.url = userImgRecord.url();
        this.contentType = userImgRecord.contentType();
        this.length = userImgRecord.length();
        this.order = userImgRecord.order();
    }
}
