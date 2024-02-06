package com.example.ssafy.petcong.matching.service.util;

import java.util.Set;

public interface SeenTodayService {
    void addSeen(int memberId, int profileId);

    Set<Integer> getProfilesSeenByMember(int memberId);

    boolean hasSeen(int memberId, int profileId);
}
