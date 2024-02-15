package com.example.ssafy.petcong.member.repository;

import com.example.ssafy.petcong.member.model.entity.Member;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, Integer> {
    Optional<Member> findMemberByMemberId(int memberId);
    Optional<Member> findMemberByUid(String uid);
    Member save(Member member);
    List<Member> findByCallableIsTrue();
}
