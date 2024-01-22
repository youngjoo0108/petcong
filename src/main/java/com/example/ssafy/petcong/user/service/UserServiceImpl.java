package com.example.ssafy.petcong.user.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.PutObjectResult;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.record.UserImgRecord;
import com.example.ssafy.petcong.user.model.record.UserRecord;
import com.example.ssafy.petcong.user.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final Bucket bucket;
    private final AmazonS3 s3Client;
    private final UserRepository userRepository;

    @Override
    public UserRecord findUserByUserId(int userId) {
        return userRepository.findUserByUserId(userId);
    }

    @Override
    public UserRecord findUserByUid(String uid) {
        return userRepository.findUserByUid(uid);
    }

    @Override
    public UserRecord save(UserRecord userRecord) {
        User userEntity = new User(userRecord);
        return userRepository.save(userEntity);
    }

    @Override
    public UserRecord updateCallable(UserRecord userRecord, boolean state) {
        User userEntity = new User(userRecord).updateCallable(state);
        return userRepository.save(userEntity);
    }

    @Override
    public UserImgRecord uploadImage(UserImgRecord userImgRecord, MultipartFile file) throws IOException {
        try (InputStream fileInputStream = file.getInputStream()) {
            String contentType = file.getContentType();
            String originalFileName = file.getOriginalFilename();
            Long size = file.getSize();
            log.info("ContentType: " + contentType);
            log.info("OriginalFileName: " + originalFileName);
            log.info("Size: " + size);

            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentType(contentType);
            metadata.setContentLength(size);

            PutObjectRequest putObjectRequest = new PutObjectRequest(bucket.getName(), originalFileName, fileInputStream, metadata);

            PutObjectResult putObjectResult = s3Client.putObject(putObjectRequest);
            boolean uploadResult = putObjectResult.getMetadata().getBucketKeyEnabled();
        }
        return null;
    }
}
