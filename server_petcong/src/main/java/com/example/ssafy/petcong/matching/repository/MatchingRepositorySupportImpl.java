package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.model.entity.QMatching;
import com.example.ssafy.petcong.user.model.entity.User;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;

import java.util.List;

//@Repository
@RequiredArgsConstructor
public class MatchingRepositorySupportImpl implements MatchingRepositorySupport {

    private final JPAQueryFactory jpaQueryFactory;

    @Override
    public Matching findPendingByUsers(User fromUser, User toUser) {
        QMatching matching = QMatching.matching;
        return jpaQueryFactory.select(matching)
                .from(matching)
                .where(matching.fromUser.userId.eq(fromUser.getUserId())
                        .and(matching.toUser.userId.eq(toUser.getUserId()))
                        .and((matching.callStatus.eq(CallStatus.PENDING)))
                ).fetchOne();
    }
}
