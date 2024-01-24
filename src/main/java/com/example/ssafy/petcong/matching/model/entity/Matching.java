package com.example.ssafy.petcong.matching.model.entity;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.user.model.entity.User;
import jakarta.persistence.*;
import lombok.*;

@ToString // 테스트용
@Entity(name = "matchings")
@NoArgsConstructor
@Getter
public class Matching {

    public Matching(User fromUser, User toUser) {
        this.fromUser = fromUser;
        this.toUser = toUser;
        this.callStatus = CallStatus.PENDING;
    }

    public Matching(User fromUser, User toUser, CallStatus callStatus) {
        this.fromUser = fromUser;
        this.toUser = toUser;
        this.callStatus = callStatus;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "matching_id")
    private int id;

    @ManyToOne
    @JoinColumn(referencedColumnName = "user_id", name = "from_user_id")
    private User fromUser;

    @ManyToOne
    @JoinColumn(referencedColumnName = "user_id", name = "to_user_id")
    private User toUser;

    @Setter
    @Enumerated(EnumType.STRING)
    @Column(name = "call_status")
    private CallStatus callStatus;
}
