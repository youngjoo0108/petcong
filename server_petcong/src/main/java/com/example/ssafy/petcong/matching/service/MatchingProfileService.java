package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.model.entity.ProfileRecord;

import java.util.List;
import java.util.Optional;

public interface MatchingProfileService {
    Optional<ProfileRecord> profile(String uid);
    List<Matching> findMatchingList(int fromMemberId, int toMemberId);
}
