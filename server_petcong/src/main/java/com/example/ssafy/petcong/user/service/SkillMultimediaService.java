package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.SkillMultimediaRecord;

import org.springframework.web.multipart.MultipartFile;

public interface SkillMultimediaService {
    SkillMultimediaRecord uploadSkillMultimedia(int userId, String key, MultipartFile file);
    int deleteSkillMultimediaByBucketKey(String bucketKey);
}
