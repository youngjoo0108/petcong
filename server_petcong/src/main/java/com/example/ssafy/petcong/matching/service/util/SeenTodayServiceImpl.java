package com.example.ssafy.petcong.matching.service.util;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentSkipListSet;

@Service
public class SeenTodayServiceImpl implements  SeenTodayService {
    private final ConcurrentHashMap<Integer, Set<Integer>> memberProfileMap = new ConcurrentHashMap<>();

    // Method to track a profile seen by a member
    @Override
    public void addSeen(int memberId, int profileId) {
        // Using computeIfAbsent to ensure that the set is created if it doesn't exist
        memberProfileMap.computeIfAbsent(memberId, k -> new ConcurrentSkipListSet<>()).add(profileId);
    }

    // Method to get profiles seen by a member
    @Override
    public Set<Integer> getProfilesSeenByMember(int memberId) {
        return memberProfileMap.getOrDefault(memberId, new ConcurrentSkipListSet<>());
    }

    @Override
    public boolean hasSeen(int memberId, int profileId) {
        return memberProfileMap.getOrDefault(memberId, new ConcurrentSkipListSet<>()).contains(profileId);
    }

    // Method to clear the map every 24 hours
    @Scheduled(fixedRate = 1000 * 60 * 60 * 24)
    public void clearMap() {
        memberProfileMap.clear();
    }

}
