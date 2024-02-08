package com.example.ssafy.petcong.member.service;

import com.example.ssafy.petcong.member.model.dto.SkillMultimediaRecord;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface SkillMultimediaService {
    List<SkillMultimediaRecord> getSkillMultimediaList(int userId);
    SkillMultimediaRecord uploadSkillMultimedia(int userId, String key, MultipartFile file);
    int deleteSkillMultimediaByBucketKey(String bucketKey);
}
