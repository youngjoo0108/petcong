package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.model.entity.ProfileRecord;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.matching.service.util.OnlineUsersService;
import com.example.ssafy.petcong.matching.service.util.SeenTodayService;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.entity.UserImg;
import com.example.ssafy.petcong.user.repository.UserImgRepository;
import com.example.ssafy.petcong.user.repository.UserRepository;
import com.example.ssafy.petcong.user.service.UserService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.swing.text.html.Option;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MatchingProfileServiceImpl implements MatchingProfileService {

    private final OnlineUsersService onlineUsers;
    private final SeenTodayService seenToday;
    private final UserRepository userRepository;
    private final MatchingRepository matchingRepository;
    private final UserImgRepository userImgRepository;
    private final UserService userService;

    private final int NO_USER = -1;

    public List<String> pictures(int userId) {
        List<UserImg> imgList =  userImgRepository.findByUserId(userId);
        return imgList.stream()
                .map(UserImg::getUrl)
                .map(userService::createPresignedUrl)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public Optional<ProfileRecord> profile(String uid) {
        User requestingUser = userRepository.findUserByUid(uid);
        int requestingUserId = requestingUser.getUserId();
        int filteredUserId = NO_USER;
        for (int i = 0; i < onlineUsers.sizeOfQueue(); i++) {
            int potentialUserId = nextOnlineUser();
            if (potentialUserId == NO_USER) {
                break;
            } else if (isPotentialUser(requestingUserId, potentialUserId)) {
                filteredUserId = potentialUserId;
                break;
            }
        }
        if (filteredUserId == NO_USER) return Optional.empty();
        List<String> urls = pictures(filteredUserId);
        User filteredUser = userRepository.findUserByUserId(filteredUserId);

        return Optional.of(new ProfileRecord(filteredUser, urls));
    }

    private int nextOnlineUser() {
        // if linkedblockingqueue is empty, return "empty"
        if (onlineUsers.sizeOfQueue() == 0) {
            return NO_USER;
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

    @Override
    public List<Matching> findMatchingList(int fromUserId, int toUserId) {
        return matchingRepository.findMatchingByFromUser_UserIdOrToUser_UserIdAndCallStatus(fromUserId, toUserId, CallStatus.MATCHED);
    }
}