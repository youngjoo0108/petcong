package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.*;
import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.record.UserRecord;
import com.example.ssafy.petcong.user.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
public class MatchingConnectionService {

    private final MatchingRepository matchingRepository;
    private final UserRepository userRepository;

    public MatchingConnectionService(MatchingRepository matchingRepository, UserRepository userRepository) {
        this.matchingRepository = matchingRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public Map<String, String> choice(ChoiceReq choiceReq){
        // DB에서 requestUserId, partnerUserId인 데이터 가져오기
        Matching matching = matchingRepository.findByUsersId(choiceReq.getPartnerUserId(), choiceReq.getRequestUserId());
        UserRecord fromUserRecord = userRepository.findUserByUserId(choiceReq.getRequestUserId());
        UserRecord toUserRecord = userRepository.findUserByUserId(choiceReq.getPartnerUserId());

        // userId가 잘못된 값이면
        if (fromUserRecord == null || toUserRecord == null) {
            throw new RuntimeException();
        }

        User fromUser = new User(fromUserRecord);
        User toUser = new User(toUserRecord);

        // 기존 데이터 없으면
        if (matching == null) {
            // DB에 pending 상태로 추가
            matchingRepository.save(new Matching(fromUser, toUser));
            System.out.println("saved");
            return null;
        }
        // 이미 매치되었거나, reject상태이면
        if (matching.getCallStatus() != CallStatus.PENDING) {
            throw new RuntimeException();
        }
        // update to matched
        matching.setCallStatus(CallStatus.MATCHED);
        // fromUser, toUser의 callable을 false로 변경
        fromUser.setCallable(false);
        toUser.setCallable(false);

        // 클라이언트끼리 연결할 링크를 반환
        Map<String, String> responseMap = new HashMap<>();

        responseMap.put("targetLink", "/websocket/" + toUser.getUserId());

        return responseMap;
    }

    @Transactional
    public void changeToCallable(int userId) {
        User user = new User(userRepository.findUserByUserId(userId));
        user.setCallable(true);
    }
}
