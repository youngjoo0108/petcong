package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.record.UserRecord;
import com.example.ssafy.petcong.user.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;

    @Override
    public UserRecord findUserByUserId(int userId) {
        return userRepository.findUserByUserId(userId);
    }

    @Override
    public UserRecord findUserByUid(String uid) {
        return userRepository.findUserByUid(uid);
    }

    @Override
    public UserRecord save(UserRecord userRecord) {
        User userEntity = new User(userRecord);
        return userRepository.save(userEntity);
    }

    @Override
    public UserRecord updateCallable(UserRecord userRecord, boolean state) {
        User userEntity = new User(userRecord).updateCallable(state);
        return userRepository.save(userEntity);
    }
}
