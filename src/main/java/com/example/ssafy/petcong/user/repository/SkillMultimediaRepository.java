package com.example.ssafy.petcong.user.repository;

import com.example.ssafy.petcong.user.model.entity.SkillMultimedia;

import org.springframework.data.jpa.repository.JpaRepository;

public interface SkillMultimediaRepository extends JpaRepository<SkillMultimedia, Integer> {
    SkillMultimedia save(SkillMultimedia skillMultimedia);
}
