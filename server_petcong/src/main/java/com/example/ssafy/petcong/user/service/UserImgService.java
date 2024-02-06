package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.UserImgRecord;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface UserImgService {

    List<UserImgRecord> getUserImageList(int userId);
    UserImgRecord uploadUserImage(int userId, String key, MultipartFile file);
    int deleteUserImgByBucketKey(String bucketKey);
}
