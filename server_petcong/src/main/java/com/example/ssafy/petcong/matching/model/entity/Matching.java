package com.example.ssafy.petcong.matching.model.entity;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.member.model.entity.Member;

import jakarta.persistence.*;

import lombok.*;

@Entity
@ToString
@NoArgsConstructor
@Getter
public class Matching {

    public Matching(Member fromMember, Member toMember) {
        this.fromMember = fromMember;
        this.toMember = toMember;
        this.callStatus = CallStatus.PENDING;
    }

    public Matching(Member fromMember, Member toMember, CallStatus callStatus) {
        this.fromMember = fromMember;
        this.toMember = toMember;
        this.callStatus = callStatus;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "matching_id")
    private int id;

    @ManyToOne
    @JoinColumn(referencedColumnName = "member_id", name = "from_member_id")
    private Member fromMember;

    @ManyToOne
    @JoinColumn(referencedColumnName = "member_id", name = "to_member_id")
    private Member toMember;

    @Setter
    @Enumerated(EnumType.STRING)
    @Column(name = "call_status")
    private CallStatus callStatus;
}
