package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.UserImgRecord;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.entity.UserImg;
import com.example.ssafy.petcong.user.repository.UserImgRepository;

import jakarta.transaction.Transactional;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserImgServiceImpl implements UserImgService{
    private final UserImgRepository userImgRepository;

    @Override
    public List<UserImgRecord> getUserImageList(int userId) {
        return userImgRepository
                .findUserImgByUser_UserId(userId).stream()
                .map(UserImgRecord::fromUserImgEntity)
                .toList();
    }

    @Override
    @Transactional
    public UserImgRecord uploadUserImage(int userId, String key, MultipartFile file) {
        String contentType = file.getContentType();
        long size = file.getSize();

        UserImg userImg = UserImg.builder()
                .user(User.builder().userId(userId).build())
                .bucketKey(key)
                .contentType(contentType)
                .length(size)
                .build();

        UserImg result = userImgRepository.save(userImg);

        return UserImgRecord.fromUserImgEntity(result);
    }

    @Override
    @Transactional
    public int deleteUserImgByBucketKey(String bucketKey) {
        return userImgRepository.deleteUserImgByBucketKey(bucketKey);
    }
}
