package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.AWS.service.AWSService;
import com.example.ssafy.petcong.user.model.dto.UserInfoDto;
import com.example.ssafy.petcong.user.model.entity.SkillMultimedia;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.dto.SkillMultimediaRecord;
import com.example.ssafy.petcong.user.model.dto.UserImgRecord;
import com.example.ssafy.petcong.user.model.dto.UserRecord;
import com.example.ssafy.petcong.user.repository.SkillMultimediaRepository;
import com.example.ssafy.petcong.user.repository.UserRepository;

import jakarta.transaction.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final AWSService awsService;
    private final UserImgService userImgService;

    private final UserRepository userRepository;
    private final SkillMultimediaRepository skillMultimediaRepository;

    @Override
    public UserRecord findUserByUid(String uid) {
        User result = userRepository.findUserByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));

        return new UserRecord(result);
    }

    @Override
    @Transactional
    public UserRecord save(UserInfoDto userInfo) {
        User siginupUser = User.fromUserInfoDto(userInfo);

        User result = userRepository.save(siginupUser);

        return new UserRecord(result);
    }

    @Override
    @Transactional
    public UserRecord updateCallable(String uid, boolean state) {
        User user = userRepository.findUserByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));
        user.updateCallable(state);

        User result = userRepository.save(user);

        return new UserRecord(result);
    }

    @Override
    @Transactional
    public UserRecord updateUserInfo(String uid, UserInfoDto userInfo) {
        User userEntity = User.fromUserInfoDto(userInfo);

        int userId = userRepository.findUserByUid(uid).orElseThrow(() -> new NoSuchElementException(uid)).getUserId();
        userEntity.updateUserId(userId);

        User result = userRepository.save(userEntity);

        return new UserRecord(result);
    }

    @Override
    @Transactional
    public UserImgRecord uploadUserImage(UserRecord user, MultipartFile file) throws IOException {
        String key = UUID.fromString(user.uid() + file.getOriginalFilename()).toString();
        UserImgRecord result = userImgService.uploadUserImage(user.userId(), key, file);

        awsService.upload(key, file);

        return result;
    }

    @Override
    @Transactional
    public SkillMultimediaRecord uploadSkillMultimedia(UserRecord user, MultipartFile file) throws IOException {
        String key = UUID.fromString(user.uid() + file.getOriginalFilename()).toString();
        String contentType = file.getContentType();
        long size = file.getSize();

        SkillMultimedia skillMultimedia = SkillMultimedia.builder()
                .user(user.userId())
                .bucketKey(key)
                .contentType(contentType)
                .length(size)
                .build();

        SkillMultimedia result = skillMultimediaRepository.save(skillMultimedia);

        awsService.upload(key, file);

        return new SkillMultimediaRecord(result);
    }

    @Override
    @Transactional
    public List<UserImgRecord> updateUserImage(UserRecord user, MultipartFile[] files) throws IOException {
        List<UserImgRecord> userImgRecordList = new ArrayList<>();

        for (MultipartFile file : files) {
            String key = file.getName();

            if (key.isBlank()) { // delete previous image
                userImgService.deleteUserImgByBucketKey(key);
            }

            userImgRecordList.add(uploadUserImage(user, file));  // save new image
        }

        return userImgRecordList;
    }

    @Override
    public List<SkillMultimediaRecord> updateSkillMultimedia(UserRecord user, MultipartFile[] files) throws IOException {
        return null;
    }

    @Override
    @Transactional
    public int deleteUserByUid(String uid) {
        userRepository.findUserByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));
        return userRepository.deleteUserByUid(uid);
    }
}
