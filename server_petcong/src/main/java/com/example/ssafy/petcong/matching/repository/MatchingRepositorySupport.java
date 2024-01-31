package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.user.model.entity.User;

import java.util.List;

public interface MatchingRepositorySupport {
    Matching findPendingByUsers(User fromUser, User toUser);
}
