package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.record.UserImgRecord;
import com.example.ssafy.petcong.user.model.record.UserRecord;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface UserService {
    UserRecord findUserByUserId(int userId);
    UserRecord findUserByUid(String uid);
    UserRecord save(UserRecord userRecord);
    UserRecord updateCallable(UserRecord userRecord, boolean state);
    UserImgRecord uploadImage(UserImgRecord userImgRecord,  MultipartFile file) throws IOException;
}
