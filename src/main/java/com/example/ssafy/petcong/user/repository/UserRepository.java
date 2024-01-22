package com.example.ssafy.petcong.user.repository;

import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.record.UserRecord;

import org.springframework.data.repository.Repository;

public interface UserRepository extends Repository<User, String> {
    UserRecord findUserByUserId(int userId);
    UserRecord findUserByUid(String uid);
    UserRecord save(User user);
}
