package com.example.ssafy.petcong.user.repository;

import com.example.ssafy.petcong.user.model.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Integer> {
    User findUserByUid(String uid);
    User save(User user);
}
