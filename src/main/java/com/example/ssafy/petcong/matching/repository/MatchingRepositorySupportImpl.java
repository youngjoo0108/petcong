package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.Matching;
import com.example.ssafy.petcong.matching.model.QMatching;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

//@Repository
@RequiredArgsConstructor
public class MatchingRepositorySupportImpl implements MatchingRepositorySupport {

    private final JPAQueryFactory jpaQueryFactory;

    @Override
    public List<Matching> findPendingByFromUserId(int fromUserId) {
        QMatching matching = QMatching.matching;
        System.out.println("querydsl 실행됨");
        return jpaQueryFactory.select(matching)
                .from(matching)
                .where(matching.fromUser.id.eq(fromUserId)
                        .and((matching.callStatus.eq(CallStatus.pending)))
                ).fetch();
    }
}
