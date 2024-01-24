package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.entity.Matchings;
import com.example.ssafy.petcong.user.model.entity.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MatchingRepository extends JpaRepository<Matchings, Integer> {

    Matchings findByFromUsersAndToUsers(Users fromUsers, Users toUsers);
}
