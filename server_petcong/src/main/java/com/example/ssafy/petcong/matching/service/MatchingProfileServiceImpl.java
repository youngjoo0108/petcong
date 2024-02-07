package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.AWS.service.AWSService;
import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.model.entity.ProfileRecord;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.matching.service.util.OnlineMembersService;
import com.example.ssafy.petcong.matching.service.util.SeenTodayService;
import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.model.entity.MemberImg;
import com.example.ssafy.petcong.member.repository.MemberImgRepository;
import com.example.ssafy.petcong.member.repository.MemberRepository;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.entity.UserImg;
import com.example.ssafy.petcong.user.model.enums.Gender;
import com.example.ssafy.petcong.user.model.enums.Preference;
import com.example.ssafy.petcong.user.repository.UserImgRepository;
import com.example.ssafy.petcong.user.repository.UserRepository;

import jakarta.transaction.Transactional;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MatchingProfileServiceImpl implements MatchingProfileService {
    private final OnlineMembersService onlineMembers;
    private final SeenTodayService seenToday;
    private final MemberRepository memberRepository;
    private final MatchingRepository matchingRepository;
    private final MemberImgRepository memberImgRepository;
    private final AWSService awsService;

    private final int NO_MEMBER = -1;

    public List<String> pictures(int memberId) {
        List<MemberImg> imgList =  memberImgRepository.findMemberImgByMember_MemberId(memberId);
        return imgList.stream()
                .map(MemberImg::getBucketKey)
                .map(awsService::createPresignedUrl)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public Optional<ProfileRecord> profile(String uid) {
        Member requestingMember = memberRepository.findMemberByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));
        int requestingMemberId = requestingMember.getMemberId();
        int filteredMemberId = NO_MEMBER;
        for (int i = 0; i < onlineMembers.sizeOfQueue(); i++) {
            int potentialMemberId = nextOnlineMember();
            if (potentialMemberId == NO_MEMBER) {
                break;
            } else if (isPotentialMember(requestingMemberId, potentialMemberId)) {
                filteredMemberId = potentialMemberId;
                break;
            }
        }
        if (filteredMemberId == NO_MEMBER) return Optional.empty();
        List<String> urls = pictures(filteredMemberId);
        int finalFilteredMemberId = filteredMemberId;
        Member filteredMember = memberRepository.findMemberByMemberId(filteredMemberId).orElseThrow(() -> new NoSuchElementException(String.valueOf(finalFilteredMemberId)));

        return Optional.of(new ProfileRecord(filteredMember, urls));
    }

    private int nextOnlineMember() {
        // if linkedblockingqueue is empty, return "empty"
        if (onlineMembers.sizeOfQueue() == 0) {
            return NO_MEMBER;
        }
        int memberid = onlineMembers.removeMemberIdFromQueue();
        onlineMembers.addMemberIdToQueue(memberid);

        return memberid;
    }

    private boolean isPreferred(User requestingUser, User potentialUser) {
        Preference requestingUserPreference = requestingUser.getPreference();
        Gender potentialUserGender = potentialUser.getGender();

        return requestingUserPreference == Preference.BOTH
                || requestingUserPreference == Preference.MALE && potentialUserGender == Gender.MALE
                || requestingUserPreference == Preference.FEMALE && potentialUserGender == Gender.FEMALE;
    }

    @Transactional
    protected boolean isPotentialMember(int requestingMemberId, int potentialMemberId) {
        Optional<Member> optionalPotentialMember = memberRepository.findById(potentialMemberId);
        Optional<Member> optionalRequestingMember = memberRepository.findById(potentialMemberId);
        Member requestingMember = optionalRequestingMember.orElseThrow();
        Member potentialMember = optionalPotentialMember.orElseThrow();

        // 1. 본인인지 확인
        if (requestingMemberId == potentialMemberId) return false;
        // 2. 온라인 유저인지 확인
        if (!potentialMember.isCallable()) return false;

        // 2.5. 선호 상대 확인
        if (!isPreferred(requestingUser, potentialUser)) return false;

        // 3. matching table에서 서로 매치한적 있는지 또는 거절 받은 유저인지 확인
        Matching matchingSentByRequesting = matchingRepository.findByFromMemberAndToMember(requestingMember, potentialMember);
        if (matchingSentByRequesting != null) return false;
        Matching matchingSentByPotential = matchingRepository.findByFromMemberAndToMember(potentialMember, requestingMember);
        if (matchingSentByPotential != null && matchingSentByPotential.getCallStatus() != CallStatus.PENDING) return false;

        // 4. 오늘 본적 있는지
        if (!seenToday.hasSeen(requestingMemberId, potentialMemberId)) return false;
        seenToday.addSeen(requestingMemberId, potentialMemberId);

        return true;
    }

    @Override
    public List<Matching> findMatchingList(int fromMemberId, int toMemberId) {
        return matchingRepository.findMatchingByFromMember_MemberIdOrToMember_MemberIdAndCallStatus(fromMemberId, toMemberId, CallStatus.MATCHED);
    }
}