package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.UserInfoDto;
import com.example.ssafy.petcong.user.model.dto.SkillMultimediaRecord;
import com.example.ssafy.petcong.user.model.dto.UserImgRecord;
import com.example.ssafy.petcong.user.model.dto.UserRecord;

import org.springframework.web.multipart.MultipartFile;

import java.util.NoSuchElementException;

public interface UserService {
    UserRecord findUserByUid(String uid);
    UserRecord save(UserInfoDto userInfo);
    UserRecord updateCallable(String uid, boolean state);
    UserRecord updateUserInfo(String uid, UserInfoDto userInfo) throws NoSuchElementException;
    UserImgRecord uploadUserImage(UserRecord user, String key, MultipartFile file);
    SkillMultimediaRecord uploadSkillMultimedia(UserRecord user, String key, MultipartFile file);
    int deleteUserByUid(String uid);
}
