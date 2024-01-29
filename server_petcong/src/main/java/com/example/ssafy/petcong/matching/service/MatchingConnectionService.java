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
    public Map<String, String> choice(ChoiceReq choiceReq, String requesterIp, int port){
        // DB에서 requestUserId, partnerUserId인 데이터 가져오기
        Matching matching = matchingRepository.findByUsersId(choiceReq.getPartnerUserId(), choiceReq.getRequestUserId());
        User fromUser = userRepository.findUserByUserId(choiceReq.getRequestUserId());
        User toUser = userRepository.findUserByUserId(choiceReq.getPartnerUserId());

        // invalid userId
        if (fromUser == null || toUser == null || fromUser.getUserId() == toUser.getUserId()) {
            System.out.println("invalid userId");
            throw new RuntimeException();
        }

        // to pending
        if (matching == null) {
            // DB에 pending 상태로 추가
            matchingRepository.save(new Matching(fromUser, toUser));
            return null;
        }
        // 이미 matched / rejected 이면
        if (matching.getCallStatus() != CallStatus.PENDING) {
            System.out.println("invalid status");
            throw new RuntimeException();
        }
        // to matched
        matching.setCallStatus(CallStatus.MATCHED);

        // update users to not callable
        fromUser.setCallable(false);
        toUser.setCallable(false);
        userRepository.save(fromUser);
        userRepository.save(toUser);

        Map<String, String> responseMap = new HashMap<>();
        responseMap.put("targetLink", "/queue/" + toUser.getUserId());

        return responseMap;
    }

    @Transactional
    public void changeToCallable(int userId) {
        User user = userRepository.findUserByUserId(userId);
        user.setCallable(true);
        userRepository.save(user);
    }
}
