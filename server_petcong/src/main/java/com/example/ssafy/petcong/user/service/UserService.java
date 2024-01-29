package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.record.SkillMultimediaRecord;
import com.example.ssafy.petcong.user.model.record.UserImgRecord;
import com.example.ssafy.petcong.user.model.record.UserRecord;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.NoSuchElementException;

public interface UserService {
    UserRecord findUserByUid(String uid);
    UserRecord save(UserRecord userRecord);
    UserRecord updateCallable(String uid, boolean state);
    UserRecord updateUserInfo(String uid, UserRecord userRecord) throws NoSuchElementException;
    String createPresignedUrl(String key);
    UserImgRecord uploadUserImage(UserRecord user, MultipartFile file) throws IOException;
    SkillMultimediaRecord uploadSkillMultimedia(UserRecord user, MultipartFile file) throws IOException;
    int deleteUserByUid(String uid);
}
