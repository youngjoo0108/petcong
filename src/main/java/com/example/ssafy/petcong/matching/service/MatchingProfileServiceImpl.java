package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.matching.service.util.OnlineUsersService;
import com.example.ssafy.petcong.matching.service.util.SeenTodayService;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class MatchingProfileServiceImpl implements MatchingProfileService {

    private final OnlineUsersService onlineUsers;
    private final SeenTodayService seenToday;
    private final UserRepository userRepository;
    private final MatchingRepository matchingRepository;

    public List<String> pictures(int userId) {
        ArrayList<String> urls = null;
        return urls;
    }

    public Map<String, Object> details(int userId) {
        int filteredUser = -1;
        for (int i = 0; i < onlineUsers.sizeOfQueue(); i++) {
            int potentialUserId = nextOnlineUser();
            if (potentialUserId == -1) {
                break;
            } else if (isPotentialUser(userId, potentialUserId)) {
                filteredUser = potentialUserId;
                break;
            }
        }

        Map<String, Object> res = new HashMap<>();
        res.put("potentialUserId", filteredUser);
        return res;
    }

    private int nextOnlineUser() {
        // if linkedblockingqueue is empty, return "empty"
        if (onlineUsers.sizeOfQueue() == 0) {
            return -1;
        }
        int userid = onlineUsers.removeUserIdFromQueue();
        onlineUsers.addUserIdToQueue(userid);

        return userid;
    }

    @Transactional
    protected boolean isPotentialUser(int requestingUserId, int potentialUserId) {
        Optional<User> optionalPotentialUser = userRepository.findById(potentialUserId);
        Optional<User> optionalRequestingUser = userRepository.findById(potentialUserId);
        User requestingUser = optionalRequestingUser.orElseThrow();
        User potentialUser = optionalPotentialUser.orElseThrow();

        // 1. 본인인지 확인
        if (requestingUserId == potentialUserId) return false;
        // 2. 온라인 유저인지 확인
        if (!potentialUser.isCallable()) return false;

        // 3. matching table에서 서로 매치한적 있는지 또는 거절 받은 유저인지 확인
        Matching matchingSentByRequesting = matchingRepository.findByFromUserAndToUser(requestingUser, potentialUser);
        if (matchingSentByRequesting != null) return false;
        Matching matchingSentByPotential = matchingRepository.findByFromUserAndToUser(potentialUser, requestingUser);
        if (matchingSentByPotential != null && matchingSentByPotential.getCallStatus() != CallStatus.PENDING) return false;

        // 4. 오늘 본적 있는지
        if (!seenToday.hasSeen(requestingUserId, potentialUserId)) return false;
        seenToday.addSeen(requestingUserId, potentialUserId);

        return true;
    }

}
