package com.example.ssafy.petcong.matching.service.util;

import java.util.Set;

public interface SeenTodayService {
    void addSeen(int userId, int profileId);

    Set<Integer> getProfilesSeenByUser(int userId);

    boolean hasSeen(int userId, int profileId);
}
