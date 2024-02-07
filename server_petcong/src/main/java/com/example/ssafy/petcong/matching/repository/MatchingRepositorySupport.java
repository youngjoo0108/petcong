package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.member.model.entity.Member;

public interface MatchingRepositorySupport {
    Matching findPendingByMembers(Member fromMember, Member toMember);
}
