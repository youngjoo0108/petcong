package com.example.ssafy.petcong.member.model.entity;

import com.example.ssafy.petcong.member.model.dto.MemberInfoDto;
import com.example.ssafy.petcong.member.model.enums.Gender;
import com.example.ssafy.petcong.member.model.enums.Preference;
import com.example.ssafy.petcong.member.model.enums.Status;
import com.example.ssafy.petcong.member.model.dto.MemberRecord;

import jakarta.persistence.*;

import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Entity
@Getter
@Builder
@ToString
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Member {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private int memberId;

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

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "member")
    private List<MemberImg> memberImgList;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "member")
    private List<SkillMultimedia> skillMultimediaList;

    @OneToOne(mappedBy = "member", fetch = FetchType.LAZY)
    private Pet pet;

    public static Member fromMemberRecord(MemberRecord memberRecord) {
        return Member.builder()
                .memberId(memberRecord.memberId())
                .age(memberRecord.age())
                .callable(memberRecord.callable())
                .nickname(memberRecord.nickname())
                .email(memberRecord.email())
                .address(memberRecord.address())
                .uid(memberRecord.uid())
                .instagramId(memberRecord.instagramId())
                .kakaoId(memberRecord.kakaoId())
                .birthday(memberRecord.birthday())
                .gender(memberRecord.gender())
                .status(memberRecord.status())
                .preference(memberRecord.preference())
                .build();
    }

    public static Member fromMemberInfoDto(MemberInfoDto memberInfoDto) {
        return Member.builder()
                .age(memberInfoDto.getAge())
                .nickname(memberInfoDto.getNickname())
                .email(memberInfoDto.getEmail())
                .address(memberInfoDto.getAddress())
                .uid(memberInfoDto.getUid())
                .instagramId(memberInfoDto.getInstagramId())
                .kakaoId(memberInfoDto.getKakaoId())
                .birthday(memberInfoDto.getBirthday())
                .gender(memberInfoDto.getGender())
                .status(memberInfoDto.getStatus())
                .preference(memberInfoDto.getPreference())
                .build();
    }

    public void updateCallable(boolean callable) {
        this.callable = callable;
    }

    public void updateMemberId(int memberId) {
        this.memberId = memberId;
    }

    public void updateStatus(Status status) {
        this.status = status;
    }
}
