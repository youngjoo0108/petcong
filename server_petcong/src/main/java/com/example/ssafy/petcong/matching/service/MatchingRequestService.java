package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.ChoiceRes;
import com.example.ssafy.petcong.matching.model.entity.Icebreaking;
import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.repository.IcebreakingRepository;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.repository.MemberRepository;
import org.springframework.messaging.simp.SimpMessageSendingOperations;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

@Service
public class MatchingRequestService {

    private final MatchingRepository matchingRepository;
    private final IcebreakingRepository icebreakingRepository;
    private final SimpMessageSendingOperations sendingOperations;
    private final MemberRepository memberRepository;

    public MatchingRequestService(MatchingRepository matchingRepository, IcebreakingRepository icebreakingRepository, MemberRepository memberRepository, SimpMessageSendingOperations sendingOperations) {
        this.matchingRepository = matchingRepository;
        this.icebreakingRepository = icebreakingRepository;
        this.sendingOperations = sendingOperations;
        this.memberRepository = memberRepository;
    }

    @Transactional
    public ChoiceRes choice(String uid, int partnerMemberId){
        Member fromMember = memberRepository.findMemberByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));
        // DB에서 requestMemberId, partnerMemberId인 데이터 가져오기
        Member toMember = memberRepository.findMemberByMemberId(partnerMemberId).orElseThrow(() -> new NoSuchElementException(String.valueOf(partnerMemberId)));
        // 상대가 나에게 보낸 요청이 있는지 찾기
        Matching matching = matchingRepository.findPendingByMembers(toMember, fromMember);

        // invalid memberId
        if (fromMember == null || toMember == null || fromMember.getMemberId() == toMember.getMemberId()) {
            System.out.println("invalid memberId");
            throw new RuntimeException();
        }

        // to pending
        if (matching == null) {
            // DB에 pending 상태로 추가
            matchingRepository.save(new Matching(fromMember, toMember));
            return null;
        }
        // 이미 matched / rejected 이면
        if (matching.getCallStatus() != CallStatus.PENDING) {
            System.out.println("invalid status");
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

        Map<String, String> responseMap = new HashMap<>();
        responseMap.put("targetLink", "/queue/" + toMember.getUid());

        // 상대쪽에도 전송
        Map<String, Object> responseMap2 = new HashMap<>();
        responseMap2.put("type", "matched");
        ChoiceRes choiceRes = ChoiceRes.builder()
                                .targetUid(fromMember.getUid())
                                .profile(null) // 상대 프로필? 넣기
                                .icebreakingList(icebreakingList) // 질문 리스트 넣기
                                .build();
        responseMap2.put("value", choiceRes);

        sendingOperations.convertAndSend("/queue/" + toMember.getUid(), responseMap2);

        return ChoiceRes.builder()
                .targetUid(toMember.getUid())
                .icebreakingList(icebreakingList)
                .build();
    }

    @Transactional
    public void changeToCallable(int memberId) {
        Member member = memberRepository.findMemberByMemberId(memberId).orElseThrow(() -> new NoSuchElementException(String.valueOf(memberId)));
        member.updateCallable(true);
        memberRepository.save(member);
    }
}
