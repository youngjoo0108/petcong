package com.example.ssafy.petcong.member.service;

import com.example.ssafy.petcong.member.model.dto.SkillMultimediaRecord;

import com.example.ssafy.petcong.member.model.entity.SkillMultimedia;
import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.repository.SkillMultimediaRepository;
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
    public List<SkillMultimediaRecord> getSkillMultimediaList(int memberId) {
        return skillMultimediaRepository
                .findSkillMultimediaByMember_MemberId(memberId).stream()
                .map(SkillMultimediaRecord::fromSkillMultimediaEntity)
                .toList();
    }

    @Override
    @Transactional
    public SkillMultimediaRecord uploadSkillMultimedia(int memberId, String key, MultipartFile file) {
        String fileName = file.getOriginalFilename();
        String contentType = fileName.substring(fileName.lastIndexOf('.') + 1);
        long size = file.getSize();

        SkillMultimedia skillMultimedia = SkillMultimedia.builder()
                .member(Member.builder().memberId(memberId).build())
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
