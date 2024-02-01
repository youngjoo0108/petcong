package com.example.ssafy.petcong.user.repository;

import com.example.ssafy.petcong.user.model.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    User findUserByUserId(int userId);
    User findUserByUid(String uid);
    User save(User user);
    int deleteUserByUserId(int userId);
    int deleteUserByUid(String uid);
    List<User> findByCallableIsTrue();
}
