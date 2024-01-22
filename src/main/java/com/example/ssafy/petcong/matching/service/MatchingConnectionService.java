package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.*;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.matching.repository.UserRepository;
import io.openvidu.java.client.*;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.awt.*;
import java.math.MathContext;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class RtcConnectService {

    private final MatchingRepository matchingRepository;
    private final UserRepository userRepository;

    private final SimpleSend
    private final int RANDOM_STR_LEN = 20;

    public RtcConnectService(MatchingRepository matchingRepository, UserRepository userRepository) {
        this.matchingRepository = matchingRepository;
        this.userRepository = userRepository;
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

        Map<String, String> responseMap = new HashMap<>();
        // fromUser -> toUser로 ws 연결 요청할 링크 반환
//        responseMap.put("targetLink", "/queue/" + toUser.getId());
        String link = RandomStringUtils.randomAlphanumeric(RANDOM_STR_LEN);
        Map<String, String> resMap2 = new HashMap<>();
        responseMap.put("targetLink", link);
        resMap2.put("selfLink", link);




        return responseMap;
    }

    @Transactional
    public void changeToCallable(int userId) {
        User user = userRepository.findById(userId);
        user.setCallable(true);
    }
}
