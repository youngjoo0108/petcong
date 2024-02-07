package com.example.ssafy.petcong.member.service;

import com.example.ssafy.petcong.member.model.dto.MemberImgRecord;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface MemberImgService {
    List<MemberImgRecord> getMemberImageList(int memberId);
    MemberImgRecord uploadMemberImage(int memberId, String key, MultipartFile file);
    int deleteMemberImgByBucketKey(String bucketKey);
}
