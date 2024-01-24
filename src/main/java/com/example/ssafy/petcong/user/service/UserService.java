package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.record.UserImgRecord;
import com.example.ssafy.petcong.user.model.record.UserRecord;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface UserService {
    UserRecord findUserByUid(String uid);
    UserRecord save(UserRecord userRecord);
    UserRecord updateCallable(UserRecord userRecord, boolean state);
    String createPresignedUrlForGetImage(String key);
    UserImgRecord uploadImage(UserRecord user, MultipartFile file) throws IOException;
}
