package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.SkillMultimediaRecord;

import com.example.ssafy.petcong.user.model.entity.SkillMultimedia;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.repository.SkillMultimediaRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SkillMultimediaServiceImpl implements SkillMultimediaService{
    private final SkillMultimediaRepository skillMultimediaRepository;

    @Override
    public List<SkillMultimediaRecord> getSkillMultimediaList(int userId) {
        return skillMultimediaRepository
                .findSkillMultimediaByUser_UserId(userId).stream()
                .map(SkillMultimediaRecord::fromSkillMultimediaEntity)
                .toList();
    }

    @Override
    @Transactional
    public SkillMultimediaRecord uploadSkillMultimedia(int userId, String key, MultipartFile file) {
        String contentType = file.getContentType();
        long size = file.getSize();

        SkillMultimedia skillMultimedia = SkillMultimedia.builder()
                .user(User.builder().userId(userId).build())
                .bucketKey(key)
                .contentType(contentType)
                .length(size)
                .build();

        SkillMultimedia result = skillMultimediaRepository.save(skillMultimedia);

        return SkillMultimediaRecord.fromSkillMultimediaEntity(result);
    }

    @Override
    @Transactional
    public int deleteSkillMultimediaByBucketKey(String bucketKey) {
        return skillMultimediaRepository.deleteByBucketKey(bucketKey);
    }
}
