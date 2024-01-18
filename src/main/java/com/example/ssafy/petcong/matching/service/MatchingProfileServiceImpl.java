package com.example.ssafy.petcong.matching.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class MatchingProfileServiceImpl implements MatchingProfileService {

    private final OnlineUsersService onlineUsers;

    @Autowired
    public MatchingProfileServiceImpl(OnlineUsersService onlineUsers) {
        this.onlineUsers = onlineUsers;
    }

    public Map<String, Object> details(String userId) {
        String filteredUser = null;
        for (int i = 0; i < onlineUsers.sizeOfQueue(); i++) {
            String potentialUser = nextOnlineUser();
            if (potentialUser.equals("empty")) {
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

    private String nextOnlineUser() {
        // if linkedblockingqueue is empty, return "empty"
        if (onlineUsers.sizeOfQueue() == 0) {
            return "empty";
        }
        // to-do: get next online user
        return "userid";
    }

    private boolean isPotentialUser(String toUser, String recUser) {
        // implement filter to find if potential user is available
        return true;
    }

}
