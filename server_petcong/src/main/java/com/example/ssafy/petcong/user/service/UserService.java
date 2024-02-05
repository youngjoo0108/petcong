package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.*;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface UserService {
    UserRecord findUserByUid(String uid);
    UserRecord findUserByUserId(int userId);
    UserRecord save(UserInfoDto userInfo);
    SignupResponseDto signup(SignupRequestDto signupRequestDto);
    UserRecord signin(int userId, boolean state);
    UserRecord updateUserInfo(int userId, UserInfoDto userInfo);
    UserImgRecord uploadUserImage(int userId, String uid, MultipartFile file);
    SkillMultimediaRecord uploadSkillMultimedia(int userId, String uid, MultipartFile file);
    List<UserImgRecord> updateUserImage(int userId, String uid, MultipartFile[] files);
    List<SkillMultimediaRecord> updateSkillMultimedia(int userId, String uid, MultipartFile[] files);
    int deleteUserByUserId(int userId);
}
