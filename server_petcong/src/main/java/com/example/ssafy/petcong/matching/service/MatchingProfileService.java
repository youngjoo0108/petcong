package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.model.entity.ProfileRecord;

import java.util.List;
import java.util.Optional;

public interface MatchingProfileService {
    List<String> pictures(int memberId);
    Optional<ProfileRecord> profile(String uid);
    List<ProfileRecord> findMatchingList(int myId);
}
