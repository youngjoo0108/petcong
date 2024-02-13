package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.AWS.service.AWSService;
import com.example.ssafy.petcong.AWS.service.AWSServiceImpl;
import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.ChoiceRes;
import com.example.ssafy.petcong.matching.model.entity.Icebreaking;
import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.repository.IcebreakingRepository;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.model.entity.MemberImg;
import com.example.ssafy.petcong.member.model.entity.SkillMultimedia;
import com.example.ssafy.petcong.member.repository.MemberRepository;
import com.example.ssafy.petcong.member.repository.SkillMultimediaRepository;
import org.springframework.messaging.simp.SimpMessageSendingOperations;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.*;

@Service
public class MatchingRequestService {

    private final MatchingRepository matchingRepository;
    private final IcebreakingRepository icebreakingRepository;
    private final MemberRepository memberRepository;
    private final SkillMultimediaRepository skillRepository;
    private final AWSService awsService;
    private final SimpMessageSendingOperations sendingOperations;

    public MatchingRequestService(MatchingRepository matchingRepository, IcebreakingRepository icebreakingRepository, MemberRepository memberRepository, SkillMultimediaRepository skillRepository, AWSService awsService, SimpMessageSendingOperations sendingOperations) {
        this.matchingRepository = matchingRepository;
        this.icebreakingRepository = icebreakingRepository;
        this.skillRepository = skillRepository;
        this.awsService = awsService;
        this.sendingOperations = sendingOperations;
        this.memberRepository = memberRepository;
    }

    @Transactional
    public ChoiceRes choice(String uid, String partnerUid){
        Member fromMember = memberRepository.findMemberByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));
        // DB에서 requestMemberId, partnerMemberId인 데이터 가져오기
        Member toMember = memberRepository.findMemberByUid(partnerUid).orElseThrow(() -> new NoSuchElementException(partnerUid));

        // invalid memberId
        if (fromMember == null || toMember == null || fromMember.getMemberId() == toMember.getMemberId()) {
            throw new RuntimeException();
        }

        // 이전에 이미 요청을 보냈던 상태라면, 에러 반환 (pending이든, matched든, rejected든)
        Matching prevMatching = matchingRepository.findByFromMemberAndToMember(fromMember, toMember);
        if (prevMatching != null) {
            throw new RuntimeException();
        }

        // 상대가 나에게 보낸 요청이 있는지 찾기
        Matching matching = matchingRepository.findByFromMemberAndToMember(toMember, fromMember);

        // to pending
        if (matching == null) {
            // DB에 pending 상태로 추가
            matchingRepository.save(new Matching(fromMember, toMember));
            return null;
        }
        // 이미 matched / rejected 이면
        if (matching.getCallStatus() != CallStatus.PENDING) {
            throw new RuntimeException();
        }
        // to matched
        matching.setCallStatus(CallStatus.MATCHED);

        // update members to not callable
        fromMember.updateCallable(false);
        toMember.updateCallable(false);
        memberRepository.save(fromMember);
        memberRepository.save(toMember);


        // 퀴즈, 미션 가져오기
        List<Icebreaking> icebreakingList = icebreakingRepository.findAll();

        // 응답 객체 생성
        ChoiceRes fromMemberRes = makeMatchedResponse(toMember, icebreakingList); // 요청자
        ChoiceRes toMemberRes = makeMatchedResponse(fromMember, icebreakingList); // 상대방

        // 상대쪽에 전송
        Map<String, Object> responseMap2 = new HashMap<>();
        responseMap2.put("type", "matched");
        responseMap2.put("value", toMemberRes);

        sendingOperations.convertAndSend("/queue/" + toMember.getUid(), responseMap2);

        return fromMemberRes;
    }

    private ChoiceRes makeMatchedResponse(Member partnerMember, List<Icebreaking> icebreakingList) {
        List<SkillMultimedia> skillList = partnerMember.getSkillMultimediaList();
        List<String> skillUrlList = new ArrayList<>(skillList.size());

        if (!skillList.isEmpty()) {
            skillList.forEach((skill) -> {
                skillUrlList.add(awsService.createPresignedUrl(skill.getBucketKey(), Duration.ofMinutes(15)));
            });
            return ChoiceRes.builder()
                    .targetUid(partnerMember.getUid())
                    .icebreakingList(icebreakingList)
                    .skillUrlList(skillUrlList)
                    .build();
        } else {
            List<MemberImg> memberImgList = partnerMember.getMemberImgList();
            List<String> profileImgUrlList = new ArrayList<>(memberImgList.size());
            memberImgList.forEach((img) -> {
                profileImgUrlList.add(awsService.createPresignedUrl(img.getBucketKey(), Duration.ofMinutes(15)));
            });
            return ChoiceRes.builder()
                    .targetUid(partnerMember.getUid())
                    .icebreakingList(icebreakingList)
                    .profileImgUrlList(profileImgUrlList)
                    .build();
        }
    }

    @Transactional
    public void changeToCallable(int memberId) {
        Member member = memberRepository.findMemberByMemberId(memberId).orElseThrow(() -> new NoSuchElementException(String.valueOf(memberId)));
        member.updateCallable(true);
        memberRepository.save(member);
    }
}
