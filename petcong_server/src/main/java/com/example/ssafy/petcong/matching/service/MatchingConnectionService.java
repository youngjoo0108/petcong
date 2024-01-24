package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.*;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.user.model.User;
import com.example.ssafy.petcong.user.repository.UserRepository;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
public class MatchingConnectionService {

    private final MatchingRepository matchingRepository;
    private final UserRepository userRepository;

    private final SimpMessageSendingOperations sendingOperations;
    private final int RANDOM_STR_LEN = 20;

    public MatchingConnectionService(MatchingRepository matchingRepository, UserRepository userRepository,
                                     SimpMessageSendingOperations sendingOperations) {
        this.matchingRepository = matchingRepository;
        this.userRepository = userRepository;
        this.sendingOperations = sendingOperations;
    }

    @Transactional
    public Map<String, String> choice(ChoiceReq choiceReq){
        // DB에서 requestUserId, partnerUserId인 데이터 가져오기
        Matching matching = matchingRepository.findByUsersId(choiceReq.getPartnerUserId(), choiceReq.getRequestUserId());
        User fromUser = userRepository.findById(choiceReq.getRequestUserId());
        User toUser = userRepository.findById(choiceReq.getPartnerUserId());

        // 기존 데이터 없으면
        if (matching == null) {
            // DB에 pending 상태로 추가
            matchingRepository.save(new Matching(fromUser, toUser));
            System.out.println("saved");
            return null;
        }
        // 이미 매치되었거나, reject상태이면
        if (matching.getCallStatus() != CallStatus.pending) {
            throw new RuntimeException();
        }
        // update to matched
        matching.setCallStatus(CallStatus.matched);
        // fromUser, toUser의 callable을 false로 변경
        fromUser.setCallable(false);
        toUser.setCallable(false);

        // 클라이언트끼리 연결할 링크를 반환
        Map<String, String> responseMap = new HashMap<>();
        Map<String, String> resMap2 = new HashMap<>();

        String link = RandomStringUtils.randomAlphanumeric(RANDOM_STR_LEN);
        responseMap.put("targetLink", "/ws/" + link);
        resMap2.put("selfLink", "/ws/" + link);

        sendingOperations.convertAndSend("/queue/" + toUser.getId(), resMap2);

        return responseMap;
    }

    @Transactional
    public void changeToCallable(int userId) {
        User user = userRepository.findById(userId);
        user.setCallable(true);
    }
}