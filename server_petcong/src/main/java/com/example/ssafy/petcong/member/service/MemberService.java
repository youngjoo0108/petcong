package com.example.ssafy.petcong.member.service;

import com.example.ssafy.petcong.member.model.dto.*;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface MemberService {
    MemberRecord findMemberByUid(String uid);
    MemberRecord findMemberByMemberId(int memberId);
    MemberRecord save(MemberInfoDto memberInfo);
    SignupResponseDto signup(SignupRequestDto signupRequestDto);
    MemberRecord signin(int memberId, boolean state);
    ProfileDto getProfile(int memberId);
    MemberRecord updateMemberInfo(int memberId, MemberInfoDto memberInfo);
    List<MemberImgRecord> getMemberImageList(int memberId);
    List<SkillMultimediaRecord> getSkillMultimediaList(int memberId);
    List<MemberImgRecord> uploadMemberImage(int memberId, String uid, MultipartFile[] files);
    List<SkillMultimediaRecord> uploadSkillMultimedia(int memberId, String uid, MultipartFile[] files);
    List<MemberImgRecord> updateMemberImage(int memberId, String uid, MultipartFile[] files);
    List<SkillMultimediaRecord> updateSkillMultimedia(int memberId, String uid, MultipartFile[] files);
    int deleteMemberByMemberId(int memberId);
}
