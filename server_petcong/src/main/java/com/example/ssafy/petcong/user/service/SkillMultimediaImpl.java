package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.SkillMultimediaRecord;

import com.example.ssafy.petcong.user.model.entity.SkillMultimedia;
import com.example.ssafy.petcong.user.repository.SkillMultimediaRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class SkillMultimediaImpl implements SkillMultimediaService{
    private final SkillMultimediaRepository skillMultimediaRepository;

    @Override
    @Transactional
    public SkillMultimediaRecord uploadSkillMultimedia(int userId, String key, MultipartFile file) {
        String contentType = file.getContentType();
        long size = file.getSize();

        SkillMultimedia skillMultimedia = SkillMultimedia.builder()
                .user(userId)
                .bucketKey(key)
                .contentType(contentType)
                .length(size)
                .build();

        SkillMultimedia result = skillMultimediaRepository.save(skillMultimedia);

        return new SkillMultimediaRecord(result);
    }

    @Override
    @Transactional
    public int deleteSkillMultimediaByBucketKey(String bucketKey) {
        return skillMultimediaRepository.deleteByBucketKey(bucketKey);
    }
}
