package com.example.ssafy.petcong.matching.service;

import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class MatchingProfileServiceImpl implements MatchingProfileService {

    public Map<String, Object> details(String userId) {
        int onlineUserCnt = 0;

        Map<String, Object> res = new HashMap<>();
        return res;
    }

    public String nextOnlineUser() {
        // if linkedblockingqueue is empty, return "empty"
        return "userid";
    }

}
