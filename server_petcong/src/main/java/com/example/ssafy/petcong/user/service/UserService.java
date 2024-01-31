package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.UserInfoDto;
import com.example.ssafy.petcong.user.model.dto.SkillMultimediaRecord;
import com.example.ssafy.petcong.user.model.dto.UserImgRecord;
import com.example.ssafy.petcong.user.model.dto.UserRecord;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.NoSuchElementException;

public interface UserService {
    UserRecord findUserByUid(String uid);
    UserRecord save(UserInfoDto userInfoDto);
    UserRecord updateCallable(String uid, boolean state);
    UserRecord updateUserInfo(String uid, UserInfoDto userInfo) throws NoSuchElementException;
    String createPresignedUrl(String key);
    UserImgRecord uploadUserImage(UserRecord user, MultipartFile file) throws IOException;
    SkillMultimediaRecord uploadSkillMultimedia(UserRecord user, MultipartFile file) throws IOException;
    int deleteUserByUid(String uid);
}
