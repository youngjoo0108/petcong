package com.example.ssafy.petcong.user.repository;

import com.example.ssafy.petcong.user.model.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRepository extends JpaRepository<User, Integer> {
    User findUserByUserId(int userId);
    User findUserByUid(String uid);
    User save(User user);
    int deleteUserByUserId(int userId);
    int deleteUserByUid(String uid);

    List<User> findByCallableIsTrue();
}
