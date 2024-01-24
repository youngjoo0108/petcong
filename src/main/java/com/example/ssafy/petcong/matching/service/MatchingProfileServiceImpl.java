package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.entity.Matchings;
import com.example.ssafy.petcong.matching.model.enums.CallStatus;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.matching.service.util.OnlineUsersService;
import com.example.ssafy.petcong.matching.service.util.SeenTodayService;
import com.example.ssafy.petcong.user.model.entity.Users;
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
        // to-do: get next online user
        int userid = onlineUsers.removeUserFromQueue();

        return userid;
    }

    @Transactional
    public boolean isPotentialUser(int requestingUserId, int potentialUserId) {
        Optional<Users> optionalPotentialUser = userRepository.findById(potentialUserId);
        Optional<Users> optionalRequestingUser = userRepository.findById(potentialUserId);
        Users requestingUser = optionalRequestingUser.orElseThrow();
        Users potentialUser = optionalPotentialUser.orElseThrow();

        // 1. 본인인지 확인
        if (requestingUserId == potentialUserId) return false;
        // 2. 온라인 유저인지 확인
        if (!potentialUser.isCallable()) return false;

        // 3. matching table에서 서로 매치한적 있는지 또는 거절 받은 유저인지 확인
        Matchings matchingSentByRequesting = matchingRepository.findByFromUsersAndToUsers(requestingUser, potentialUser);
        if (matchingSentByRequesting != null) return false;
        Matchings matchingSentByPotential = matchingRepository.findByFromUsersAndToUsers(potentialUser, requestingUser);
        if (matchingSentByPotential != null && matchingSentByPotential.getCallStatus() != CallStatus.PENDING) return false;

        // 4. 오늘 본적 있는지
        if (!seenToday.hasSeen(requestingUserId, potentialUserId)) return false;
        seenToday.addSeen(requestingUserId, potentialUserId);

        return true;
    }

}
