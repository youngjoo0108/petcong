package com.example.ssafy.petcong.user.model.entity;

import com.example.ssafy.petcong.user.model.enums.Gender;
import com.example.ssafy.petcong.user.model.enums.Preference;
import com.example.ssafy.petcong.user.model.enums.Status;
import com.example.ssafy.petcong.user.model.record.UserRecord;

import jakarta.persistence.*;

import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "users")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User {
    @Id
    @Column(name = "user_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int userId;

    private int age;

    @Setter
    private boolean callable;

    private String nickname;
    private String email;
    private String address;
    @Column(name = "instagram_id")
    private String instagramId;
    @Column(name = "kakao_id")
    private String kakaoId;
    private String uid;

    private LocalDate birthday;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    @Enumerated(EnumType.STRING)
    private Status status;

    @Enumerated(EnumType.STRING)
    private Preference preference;

    @Builder
    public User(
            int userId,
            int age,
            boolean callable,
            String nickname,
            String email,
            String address,
            String instagramId,
            String kakaoId,
            String uid,
            LocalDate birthday,
            Gender gender,
            Status status,
            Preference preference) {
        this.userId = userId;
        this.age = age;
        this.callable = callable;
        this.nickname = nickname;
        this.email = email;
        this.address = address;
        this.instagramId = instagramId;
        this.kakaoId = kakaoId;
        this.uid = uid;
        this.birthday = birthday;
        this.gender = gender;
        this.status = status;
        this.preference = preference;
    }

    public User(UserRecord userRecord) {
        this.userId = userRecord.userId();
        this.age = userRecord.age();
        this.callable = userRecord.callable();
        this.nickname = userRecord.nickname();
        this.email = userRecord.email();
        this.address = userRecord.address();
        this.uid = userRecord.uid();
        this.instagramId = userRecord.instagramId();
        this.kakaoId = userRecord.kakaoId();
        this.birthday = userRecord.birthday();
        this.gender = userRecord.gender();
        this.status = userRecord.status();
        this.preference = userRecord.preference();
    }
    public User(int userId) {
        this.userId = userId;
    }
    public User updateCallable(boolean callable) {
        this.callable = callable;
        return this;
    }


}
