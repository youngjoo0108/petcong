package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.UserImgRecord;

import org.springframework.web.multipart.MultipartFile;

public interface UserImgService {
    UserImgRecord uploadUserImage(int userId, String key, MultipartFile file);
    int deleteUserImgByBucketKey(String bucketKey);
}
