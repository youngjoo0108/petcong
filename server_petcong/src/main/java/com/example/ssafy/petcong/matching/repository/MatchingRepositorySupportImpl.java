package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.model.entity.QMatching;
import com.example.ssafy.petcong.member.model.entity.Member;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;

import java.util.List;

//@Repository
@RequiredArgsConstructor
public class MatchingRepositorySupportImpl implements MatchingRepositorySupport {

    private final JPAQueryFactory jpaQueryFactory;

    @Override
    public Matching findPendingByMembers(Member fromMember, Member toMember) {
        QMatching matching = QMatching.matching;
        List<Matching> pendings = jpaQueryFactory.select(matching)
                .from(matching)
                .where(matching.fromMember.memberId.eq(fromMember.getMemberId())
                        .and(matching.toMember.memberId.eq(toMember.getMemberId()))
                        .and((matching.callStatus.eq(CallStatus.PENDING)))
                ).fetch();

        return pendings.isEmpty() ? null : pendings.get(0);
    }
}
