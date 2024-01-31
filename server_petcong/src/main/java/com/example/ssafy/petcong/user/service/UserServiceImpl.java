package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.UserInfoDto;
import com.example.ssafy.petcong.user.model.entity.SkillMultimedia;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.entity.UserImg;
import com.example.ssafy.petcong.user.model.dto.SkillMultimediaRecord;
import com.example.ssafy.petcong.user.model.dto.UserImgRecord;
import com.example.ssafy.petcong.user.model.dto.UserRecord;
import com.example.ssafy.petcong.user.repository.SkillMultimediaRepository;
import com.example.ssafy.petcong.user.repository.UserImgRepository;
import com.example.ssafy.petcong.user.repository.UserRepository;

import jakarta.transaction.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.Bucket;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.GetObjectPresignRequest;
import software.amazon.awssdk.services.s3.presigner.model.PresignedGetObjectRequest;

import java.io.IOException;
import java.io.InputStream;
import java.time.Duration;
import java.util.NoSuchElementException;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final Bucket bucket;
    private final S3Client s3Client;
    private final S3Presigner s3Presigner;
    private final UserRepository userRepository;
    private final UserImgRepository userImgRepository;
    private final SkillMultimediaRepository skillMultimediaRepository;

    private void uploadMediaToS3(InputStream fileInputStream, long size, PutObjectRequest putObjectRequest) {
        RequestBody requestBody = RequestBody.fromInputStream(fileInputStream, size);
        s3Client.putObject(putObjectRequest, requestBody);
    }

    @Override
    public UserRecord findUserByUid(String uid) {
        User result = userRepository.findUserByUid(uid);
        return new UserRecord(result);
    }

    @Override
    @Transactional
    public UserRecord save(UserInfoDto userInfoDto) {
        User siginupUser = new User(userInfoDto);
        User result = userRepository.save(siginupUser);
        return new UserRecord(result);
    }

    @Override
    @Transactional
    public UserRecord updateCallable(String uid, boolean state) {
        User user = userRepository.findUserByUid(uid);
        if (user != null) {
            user.setCallable(state);
            User result = userRepository.save(user);
            return new UserRecord(result);
        } else {
            throw new NoSuchElementException("There is no user.");
        }
    }

    @Override
    @Transactional
    public UserRecord updateUserInfo(String uid, UserInfoDto userInfo) {
        User user;
        if ((user = userRepository.findUserByUid(uid)) != null) {
            int userId = user.getUserId();
            User userEntity = new User(userInfo);
            User result = userRepository.updateUserByUserId(userEntity, userId);
            return new UserRecord(result);
        } else {
            throw new NoSuchElementException("There is no user.");
        }
    }

    @Override
    public String createPresignedUrl(String key) {
        GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                .bucket(bucket.name())
                .key(key)
                .build();

        GetObjectPresignRequest presignRequest = GetObjectPresignRequest.builder()
                .getObjectRequest(getObjectRequest)
                .signatureDuration(Duration.ofMinutes(10))
                .build();

        PresignedGetObjectRequest presignedRequest = s3Presigner.presignGetObject(presignRequest);

        return presignedRequest.url().toString();
    }

    @Override
    @Transactional
    public UserImgRecord uploadUserImage(UserRecord user, MultipartFile file) throws IOException {
        try (InputStream fileInputStream = file.getInputStream()) {
            String uid = user.uid();
            String key = new StringBuilder(uid)
                    .append("-")
                    .append(file.getOriginalFilename())
                    .toString();
            String contentType = file.getContentType();
            long size = file.getSize();

            UserImg userImg = UserImg.builder()
                    .user(user.userId())
                    .url(key)
                    .contentType(contentType)
                    .length(size)
                    .build();

            UserImg result = userImgRepository.save(userImg);

            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucket.name())
                    .key(result.getUrl())
                    .contentType(result.getContentType())
                    .contentLength(result.getLength())
                    .build();

            uploadMediaToS3(fileInputStream, result.getLength(), putObjectRequest);

            return new UserImgRecord(result);
        }
    }

    @Override
    @Transactional
    public SkillMultimediaRecord uploadSkillMultimedia(UserRecord user, MultipartFile file) throws IOException {
        try(InputStream fileInputStream = file.getInputStream()) {
            String uid = user.uid();
            String key = new StringBuilder(uid)
                    .append("-")
                    .append(file.getOriginalFilename())
                    .toString();
            String contentType = file.getContentType();
            long size = file.getSize();

            SkillMultimedia skillMultimedia = SkillMultimedia.builder()
                    .user(user.userId())
                    .url(key)
                    .contentType(contentType)
                    .length(size)
                    .build();

            SkillMultimedia result = skillMultimediaRepository.save(skillMultimedia);

            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucket.name())
                    .key(result.getUrl())
                    .contentType(result.getContentType())
                    .contentLength(result.getLength())
                    .build();

            uploadMediaToS3(fileInputStream, result.getLength(), putObjectRequest);

            return new SkillMultimediaRecord(result);
        }
    }

    @Override
    @Transactional
    public int deleteUserByUid(String uid) {
        if (userRepository.findUserByUid(uid) != null) {
            return userRepository.deleteUserByUid(uid);
        } else {
            return 0;
        }
    }
}
