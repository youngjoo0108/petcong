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

import java.util.NoSuchElementException;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final UserImgRepository userImgRepository;
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
        int userId = userRepository.findUserByUid(uid).orElseThrow(() -> new NoSuchElementException(uid)).getUserId();
        User userEntity = User.fromUserInfoDto(userInfo);
        userEntity.updateUserId(userId);

        User result = userRepository.save(userEntity);

        return new UserRecord(result);
    }

    @Override
    @Transactional
    public UserImgRecord uploadUserImage(UserRecord user, String key, MultipartFile file) {
        String contentType = file.getContentType();
        long size = file.getSize();

        UserImg userImg = UserImg.builder()
                .user(user.userId())
                .url(key)
                .contentType(contentType)
                .length(size)
                .build();

        UserImg result = userImgRepository.save(userImg);

        return new UserImgRecord(result);
    }

    @Override
    @Transactional
    public SkillMultimediaRecord uploadSkillMultimedia(UserRecord user, String key, MultipartFile file) {
        String contentType = file.getContentType();
        long size = file.getSize();

        SkillMultimedia skillMultimedia = SkillMultimedia.builder()
                .user(user.userId())
                .url(key)
                .contentType(contentType)
                .length(size)
                .build();

        SkillMultimedia result = skillMultimediaRepository.save(skillMultimedia);

        return new SkillMultimediaRecord(result);
    }

    @Override
    @Transactional
    public int deleteUserByUid(String uid) {
        userRepository.findUserByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));
        return userRepository.deleteUserByUid(uid);
    }
}
