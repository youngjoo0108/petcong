package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.member.model.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MatchingRepository extends JpaRepository<Matching, Integer>, MatchingRepositorySupport {

//    @Override
//    <S extends Matching> S save(S entity);
    Matching save(Matching matching);

    Matching findByFromMemberAndToMember(Member fromMembers, Member toMembers);

    List<Matching> findMatchingByFromMember_MemberIdOrToMember_MemberIdAndCallStatus(int fromMemberId, int toMemberId, CallStatus callStatus);
}
