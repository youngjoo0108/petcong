package com.example.ssafy.petcong.user.model;

import com.example.ssafy.petcong.matching.model.Matching;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Entity(name = "users")
@NoArgsConstructor
@Getter
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private int id;

    private String email;

    @Setter
    private boolean callable;

    @OneToMany(mappedBy = "fromUser")
    private List<Matching> matchingToMe;

    @OneToMany(mappedBy = "toUser")
    private List<Matching> matchingFromMe;

    @Enumerated(EnumType.STRING)
    private String gender;

    private int age;

    private String nickname;

    private String address;

    private LocalDateTime birthday;

    @Column(name = "social_url")
    private String socialUrl;

    @Enumerated(EnumType.STRING)
    private String preference;
}
