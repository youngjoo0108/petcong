package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.Matching;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.matching.service.util.OnlineUsersService;
import com.example.ssafy.petcong.matching.service.util.SeenTodayService;
import com.example.ssafy.petcong.user.model.enums.Status;
import com.example.ssafy.petcong.user.model.record.UserRecord;
import com.example.ssafy.petcong.user.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
            int potentialUser = nextOnlineUser();
            if (potentialUser == -1) {
                break;
            } else if (isPotentialUser(userId, potentialUser)) {
                filteredUser = potentialUser;
                break;
            }
        }

        Map<String, Object> res = new HashMap<>();
        res.put("potentialUser", filteredUser);
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
    private boolean isPotentialUser(int requestingUser, int potentialUser) {
        // 1. 본인인지 확인
        if (requestingUser == potentialUser) return false;
        // 2. 온라인 유저인지 확인
        UserRecord potentialUserRecord = userRepository.findUserByUserId(potentialUser);
        if (!potentialUserRecord.isCallable()) return false;

        // 3. matching table에서 서로 매치한적 있는지 또는 거절 받은 유저인지 확인
        Matching matching1 = matchingRepository
                .findByFromUserIdAndToUserId(requestingUser, potentialUser);

        Matching matching2 = matchingRepository
                .findByFromUserIdAndToUserId(potentialUser, requestingUser);

        if (matching1 != null) return false;
        if (matching2 != null &&
                matching2.getCallStatus() != CallStatus.pending) return false;

        // 4. 오늘 본적 있는지
        if (!seenToday.hasSeen(requestingUser, potentialUser)) return false;
        seenToday.addSeen(requestingUser, potentialUser);

        return true;
    }

}
