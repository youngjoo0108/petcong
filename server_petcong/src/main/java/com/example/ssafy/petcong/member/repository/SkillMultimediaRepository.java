package com.example.ssafy.petcong.member.repository;

import com.example.ssafy.petcong.member.model.entity.SkillMultimedia;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SkillMultimediaRepository extends JpaRepository<SkillMultimedia, Integer> {
    SkillMultimedia save(SkillMultimedia skillMultimedia);
    List<SkillMultimedia> findSkillMultimediaByMember_MemberId(Integer memberId);
    int deleteByBucketKey(String bucketKey);
}
