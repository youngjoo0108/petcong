package com.example.ssafy.petcong.member.service;

import com.example.ssafy.petcong.AWS.service.AWSService;
import com.example.ssafy.petcong.exception.NotRegisterdException;
import com.example.ssafy.petcong.member.model.dto.*;
import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.model.enums.Status;
import com.example.ssafy.petcong.member.repository.MemberRepository;
import com.example.ssafy.petcong.util.S3KeyGenerator;

import jakarta.transaction.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {
    private final AWSService awsService;
    private final PetService petService;
    private final MemberImgService memberImgService;
    private final SkillMultimediaService skillMultimediaService;

    private final MemberRepository memberRepository;

    @Override
    public MemberRecord findMemberByUid(String uid) {
        Member result = memberRepository.findMemberByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));

        return MemberRecord.fromMemberEntity(result);
    }

    @Override
    public MemberRecord findMemberByMemberId(int memberId) {
        Member result = memberRepository.findMemberByMemberId(memberId).orElseThrow(() -> new NoSuchElementException(String.valueOf(memberId)));

        return MemberRecord.fromMemberEntity(result);
    }

    @Override
    @Transactional
    public MemberRecord save(MemberInfoDto memberInfo) {
        Member siginupMember = Member.fromMemberInfoDto(memberInfo);

        Member result = memberRepository.save(siginupMember);

        return MemberRecord.fromMemberEntity(result);
    }

    @Override
    @Transactional
    public SignupResponseDto signup(String uid, SignupRequestDto signupRequestDto) {
        SignupMemberInfoDto signupMemberInfo = signupRequestDto.getSignupMemberInfo();
        PetInfoDto petInfo = signupRequestDto.getPetInfo();

        MemberInfoDto memberInfo = MemberInfoDto.fromSignupMemberInfo(signupMemberInfo);
        memberInfo.setUid(uid);
        memberInfo.setStatus(Status.ACTIVE);

        MemberRecord savedMember = save(memberInfo);

        PetRecord savedPet = petService.save(petInfo, savedMember.memberId());

        return new SignupResponseDto(savedMember, savedPet);
    }

    @Override
    @Transactional
    public MemberRecord signin(int memberId) {
        Member member = memberRepository.findMemberByMemberId(memberId).orElseThrow(() -> new NotRegisterdException(String.valueOf(memberId)));
        member.updateCallable(true);

        Member result = memberRepository.save(member);

        return MemberRecord.fromMemberEntity(result);
    }

    @Override
    @Transactional
    public boolean signout(int memberId) {
        Member member = memberRepository.findMemberByMemberId(memberId).orElseThrow(() -> new NoSuchElementException(String.valueOf(memberId)));
        member.updateCallable(false);

        Member result = memberRepository.save(member);

        if (result != null && !result.isCallable()) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    @Transactional
    public ProfileDto getProfile(int memberId) {
        MemberRecord memberRecord = findMemberByMemberId(memberId);
        MemberInfoDto memberInfo = MemberInfoDto.fromMemberRecord(memberRecord);
        List<MemberImgInfoDto> memberImgInfoList = getMemberImageList(memberId).stream()
                .map(MemberImgInfoDto::fromMemberImgRecord)
                .peek(memberImgInfoDto -> memberImgInfoDto.setBucketKey(awsService.createPresignedUrl(memberImgInfoDto.getBucketKey())))
                .toList();

        PetRecord petRecord = petService.findPetByMemberId(memberId);
        PetInfoDto petInfo = PetInfoDto.fromPetRecord(petRecord);
        List<SkillMultimediaInfoDto> skillMultimediaInfoList = getSkillMultimediaList(memberId).stream()
                .map(SkillMultimediaInfoDto::fromSkillMultimediaRecord)
                .peek(skillMultimediaInfoDto -> skillMultimediaInfoDto.setBucketKey(awsService.createPresignedUrl(skillMultimediaInfoDto.getBucketKey())))
                .toList();

        ProfileDto profileDto = ProfileDto.builder()
                .memberProfile(MemberProfileDto.builder()
                        .memberInfo(memberInfo)
                        .memberImgInfosList(memberImgInfoList).build())
                .petProfile(PetProfileDto.builder()
                        .petInfo(petInfo)
                        .skillMultimediaInfoList(skillMultimediaInfoList).build())
                .build();

        return profileDto;
    }

    @Override
    @Transactional
    public MemberRecord updateMemberInfo(int memberId, MemberInfoDto memberInfo) {
        Member memberEntity = Member.fromMemberInfoDto(memberInfo);
        memberEntity.updateMemberId(memberId);

        Member result = memberRepository.save(memberEntity);

        return MemberRecord.fromMemberEntity(result);
    }

    @Override
    public List<MemberImgRecord> getMemberImageList(int memberId) {
        return memberImgService.getMemberImageList(memberId);
    }

    @Override
    public List<SkillMultimediaRecord> getSkillMultimediaList(int memberId) {
        return skillMultimediaService.getSkillMultimediaList(memberId);
    }

    @Override
    @Transactional
    public List<MemberImgRecord> uploadMemberImage(int memberId, String uid, MultipartFile[] files) {
        List<MemberImgRecord> resultList = new ArrayList<>();
        for (MultipartFile file : files) {
            String key = S3KeyGenerator.generateKey(uid, file);
            resultList.add(memberImgService.uploadMemberImage(memberId, key, file));
            awsService.upload(key, file);
        }

        return resultList;
    }

    @Override
    @Transactional
    public List<SkillMultimediaRecord> uploadSkillMultimedia(int memberId, String uid, MultipartFile[] files) {
        List<SkillMultimediaRecord> resultList = new ArrayList<>();
        for (MultipartFile file : files) {
            String key = S3KeyGenerator.generateKey(uid, file);
            resultList.add(skillMultimediaService.uploadSkillMultimedia(memberId, key, file));
            awsService.upload(key, file);
        }

        return resultList;
    }

    @Override
    @Transactional
    public List<MemberImgRecord> updateMemberImage(int memberId, String uid, MultipartFile[] files) {
        return uploadMemberImage(memberId, uid, files);
    }

    @Override
    @Transactional
    public List<SkillMultimediaRecord> updateSkillMultimedia(int memberId, String uid, MultipartFile[] files) {
        return uploadSkillMultimedia(memberId, uid, files);
    }

    @Override
    @Transactional
    public void deleteMemberImage(String[] keys) {
        for (String key : keys) {
            memberImgService.deleteMemberImgByBucketKey(key);
            awsService.delete(key);
        }
    }

    @Override
    @Transactional
    public void deleteSkillMultimedia(String[] keys) {
        for (String key : keys) {
            skillMultimediaService.deleteSkillMultimediaByBucketKey(key);
            awsService.delete(key);
        }
    }

    @Override
    @Transactional
    public void deleteMemberByMemberId(int memberId) {
        Member member = memberRepository.findMemberByMemberId(memberId).orElseThrow(() -> new NoSuchElementException(String.valueOf(memberId)));
        if (Status.DELETED.equals(member.getStatus())) return;
        member.updateStatus(Status.DELETED);
        memberRepository.save(member);
    }
}
