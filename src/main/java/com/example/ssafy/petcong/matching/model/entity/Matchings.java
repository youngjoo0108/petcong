package com.example.ssafy.petcong.matching.model.entity;

import com.example.ssafy.petcong.matching.model.enums.CallStatus;
import com.example.ssafy.petcong.user.model.entity.Users;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "MATCHINGS")
@NoArgsConstructor
@Getter
public class Matchings {

    public Matchings(Users u1, Users u2) {
        this.fromUsers = u1;
        this.toUsers = u2;
        this.callStatus = CallStatus.PENDING;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "matching_id")
    private int id;

    @ManyToOne
    @JoinColumn(name = "from_user_id", referencedColumnName = "user_id")
    private Users fromUsers;

    @ManyToOne
    @JoinColumn(name = "to_user_id", referencedColumnName = "user_id")
    private Users toUsers;

    @Column(name = "call_status")
    private CallStatus callStatus;
}
