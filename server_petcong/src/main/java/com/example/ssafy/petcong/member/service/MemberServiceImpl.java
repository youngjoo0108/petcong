package com.example.ssafy.petcong.member.service;

import com.example.ssafy.petcong.AWS.service.AWSService;
import com.example.ssafy.petcong.exception.NotRegisterdException;
import com.example.ssafy.petcong.member.model.dto.*;
import com.example.ssafy.petcong.member.model.entity.Member;
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
    public SignupResponseDto signup(SignupRequestDto signupRequestDto) {
        MemberInfoDto memberInfo = signupRequestDto.getMemberInfo();
        PetInfoDto petInfo = signupRequestDto.getPetInfo();

        MemberRecord savedMember = save(memberInfo);

        PetRecord savedPet = petService.save(petInfo, savedMember.memberId());

        return new SignupResponseDto(savedMember, savedPet);
    }

    @Override
    @Transactional
    public MemberRecord signin(int memberId, boolean state) {
        Member member = memberRepository.findMemberByMemberId(memberId).orElseThrow(() -> new NotRegisterdException(String.valueOf(memberId)));
        member.updateCallable(state);

        Member result = memberRepository.save(member);

        return MemberRecord.fromMemberEntity(result);
    }

    @Override
    @Transactional
    public ProfileDto getProfile(int memberId) {
        MemberRecord memberRecord = findMemberByMemberId(memberId);
        MemberInfoDto memberInfo = MemberInfoDto.fromMemberRecord(memberRecord);
        List<MemberImgInfoDto> memberImgInfoList = getMemberImageList(memberId).stream()
                .map(MemberImgInfoDto::fromMemberImgRecord)
                .peek(MemberImg -> MemberImg.setBucketKey(awsService.createPresignedUrl(MemberImg.getBucketKey())))
                .toList();

        PetRecord petRecord = petService.findPetByMemberId(memberId);
        PetInfoDto petInfo = PetInfoDto.fromPetRecord(petRecord);
        List<SkillMultimediaInfoDto> skillMultimediaInfoList = getSkillMultimediaList(memberId).stream()
                .map(SkillMultimediaInfoDto::fromSkillMultimediaRecord)
                .peek(SkillMultimedia -> SkillMultimedia.setBucketKey(awsService.createPresignedUrl(SkillMultimedia.getBucketKey())))
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
        for (MultipartFile file : files) {
            String key = S3KeyGenerator.generateKey(uid, file);
            memberImgService.deleteMemberImgByBucketKey(key);
        }

        return uploadMemberImage(memberId, uid, files);
    }

    @Override
    @Transactional
    public List<SkillMultimediaRecord> updateSkillMultimedia(int memberId, String uid, MultipartFile[] files) {
        for (MultipartFile file : files) {
            String key = S3KeyGenerator.generateKey(uid, file);
            skillMultimediaService.deleteSkillMultimediaByBucketKey(key);
        }

        return uploadSkillMultimedia(memberId, uid, files);
    }

    @Override
    @Transactional
    public int deleteMemberByMemberId(int memberId) {
        memberRepository.findMemberByMemberId(memberId).orElseThrow(() -> new NoSuchElementException(String.valueOf(memberId)));

        return memberRepository.deleteMemberByMemberId(memberId);
    }
}
