package com.example.ssafy.petcong.member.repository;

import com.example.ssafy.petcong.member.model.entity.MemberImg;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MemberImgRepository extends JpaRepository<MemberImg, Integer> {
    MemberImg save(MemberImg memberImg);
    List<MemberImg> findMemberImgByMember_MemberId(int memberId);
    int deleteMemberImgByBucketKey(String bucketKey);
}
