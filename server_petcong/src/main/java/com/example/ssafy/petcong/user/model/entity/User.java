package com.example.ssafy.petcong.user.model.entity;

import com.example.ssafy.petcong.user.model.dto.UserInfoDto;
import com.example.ssafy.petcong.user.model.enums.Gender;
import com.example.ssafy.petcong.user.model.enums.Preference;
import com.example.ssafy.petcong.user.model.enums.Status;
import com.example.ssafy.petcong.user.model.dto.UserRecord;

import jakarta.persistence.*;

import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Builder
@ToString
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private int userId;

    private int age;

    /**
     *  @Builder will ignore the initializing expression entirely.
     *  If you want the initializing expression to serve as default, add @Builder.Default.
     *  If it is not supposed to be settable during building, make the field final.
     */
    @Builder.Default
    private boolean callable = false;

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

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "user")
    private List<UserImg> userImgList;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "user")
    private List<SkillMultimedia> skillMultimediaList;

    @OneToOne(mappedBy = "user", fetch = FetchType.LAZY)
    private Pet pet;

    public static User fromUserRecord(UserRecord userRecord) {
        return User.builder()
                .userId(userRecord.userId())
                .age(userRecord.age())
                .callable(userRecord.callable())
                .nickname(userRecord.nickname())
                .email(userRecord.email())
                .address(userRecord.address())
                .uid(userRecord.uid())
                .instagramId(userRecord.instagramId())
                .kakaoId(userRecord.kakaoId())
                .birthday(userRecord.birthday())
                .gender(userRecord.gender())
                .status(userRecord.status())
                .preference(userRecord.preference())
                .build();
    }

    public static User fromUserInfoDto(UserInfoDto userInfoDto) {
        return User.builder()
                .age(userInfoDto.getAge())
                .nickname(userInfoDto.getNickname())
                .email(userInfoDto.getEmail())
                .address(userInfoDto.getAddress())
                .uid(userInfoDto.getUid())
                .instagramId(userInfoDto.getInstagramId())
                .kakaoId(userInfoDto.getKakaoId())
                .birthday(userInfoDto.getBirthday())
                .gender(userInfoDto.getGender())
                .status(userInfoDto.getStatus())
                .preference(userInfoDto.getPreference())
                .build();
    }

    public void updateCallable(boolean callable) {
        this.callable = callable;
    }

    public void updateUserId(int userId) {
        this.userId = userId;
    }
}
