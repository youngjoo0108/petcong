package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.record.UserRecord;

public interface UserService {
    UserRecord findUserByUserId(int userId);
    UserRecord findUserByUid(String uid);
    UserRecord save(UserRecord userRecord);
    UserRecord updateCallable(UserRecord userRecord, boolean state);
}
