package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.entity.Matching;

import java.util.List;

public interface MatchingRepositorySupport {
    List<Matching> findPendingByFromUserId(int fromUserId);
}
