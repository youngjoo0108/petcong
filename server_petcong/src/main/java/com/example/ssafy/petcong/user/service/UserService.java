package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.record.SkillMultimediaRecord;
import com.example.ssafy.petcong.user.model.record.UserImgRecord;
import com.example.ssafy.petcong.user.model.record.UserRecord;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface UserService {
    int findUserIdByUid(String uid);
    UserRecord findUserByUid(String uid);
    UserRecord save(UserRecord userRecord);
    UserRecord updateCallable(UserRecord userRecord, boolean state);
    String createPresignedUrl(String key);
    UserImgRecord uploadUserImage(UserRecord user, MultipartFile file) throws IOException;
    SkillMultimediaRecord uploadSkillMultimedia(UserRecord user, MultipartFile file) throws IOException;
    int deleteUserByUserId(int userId);
}
