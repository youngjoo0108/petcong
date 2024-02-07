package com.example.ssafy.petcong.member.service;

import com.example.ssafy.petcong.member.model.dto.MemberImgRecord;
import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.model.entity.MemberImg;
import com.example.ssafy.petcong.member.repository.MemberImgRepository;

import jakarta.transaction.Transactional;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MemberImgServiceImpl implements MemberImgService{
    private final MemberImgRepository memberImgRepository;

    @Override
    public List<MemberImgRecord> getMemberImageList(int memberId) {
        return memberImgRepository
                .findMemberImgByMember_MemberId(memberId).stream()
                .map(MemberImgRecord::fromMemberImgEntity)
                .toList();
    }

    @Override
    @Transactional
    public MemberImgRecord uploadMemberImage(int memberId, String key, MultipartFile file) {
        String fileName = file.getOriginalFilename();
        String contentType = fileName.substring(fileName.lastIndexOf('.') + 1);
        long size = file.getSize();

        MemberImg memberImg = MemberImg.builder()
                .member(Member.builder().memberId(memberId).build())
                .bucketKey(key)
                .contentType(contentType)
                .length(size)
                .build();

        MemberImg result = memberImgRepository.save(memberImg);

        return MemberImgRecord.fromMemberImgEntity(result);
    }

    @Override
    @Transactional
    public int deleteMemberImgByBucketKey(String bucketKey) {
        return memberImgRepository.deleteMemberImgByBucketKey(bucketKey);
    }
}
