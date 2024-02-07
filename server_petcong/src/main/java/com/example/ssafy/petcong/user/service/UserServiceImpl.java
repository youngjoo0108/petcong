package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.AWS.service.AWSService;
import com.example.ssafy.petcong.exception.NotRegisterdException;
import com.example.ssafy.petcong.user.model.dto.*;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.repository.UserRepository;

import jakarta.transaction.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final AWSService awsService;
    private final PetService petService;
    private final UserImgService userImgService;
    private final SkillMultimediaService skillMultimediaService;

    private final UserRepository userRepository;

    @Override
    public UserRecord findUserByUid(String uid) {
        User result = userRepository.findUserByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));

        return new UserRecord(result);
    }

    @Override
    public UserRecord findUserByUserId(int userId) {
        User result = userRepository.findUserByUserId(userId).orElseThrow(() -> new NoSuchElementException(String.valueOf(userId)));
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
    public SignupResponseDto signup(SignupRequestDto signupRequestDto) {
        UserInfoDto userInfo = signupRequestDto.getUserInfo();
        PetInfoDto petInfo = signupRequestDto.getPetInfo();

        UserRecord savedUser = save(userInfo);
        PetRecord savedPet = petService.save(petInfo, savedUser.userId());

        return new SignupResponseDto(savedUser, savedPet);
    }

    @Override
    @Transactional
    public UserRecord signin(int userId, boolean state) {
        User user = userRepository.findUserByUserId(userId).orElseThrow(() -> new NotRegisterdException(String.valueOf(userId)));
        user.updateCallable(state);

        User result = userRepository.save(user);

        return new UserRecord(result);
    }

    @Override
    @Transactional
    public UserRecord updateUserInfo(int userId, UserInfoDto userInfo) {
        User userEntity = User.fromUserInfoDto(userInfo);
        userEntity.updateUserId(userId);

        User result = userRepository.save(userEntity);

        return new UserRecord(result);
    }

    @Override
    @Transactional
    public UserImgRecord uploadUserImage(int userId, String uid, MultipartFile file) {
//        String key = UUID.fromString(uid + file.getOriginalFilename()).toString();
        String key = uid +"/" + file.getOriginalFilename();
        UserImgRecord result = userImgService.uploadUserImage(userId, key, file);

        awsService.upload(key, file);

        return result;
    }

    @Override
    @Transactional
    public SkillMultimediaRecord uploadSkillMultimedia(int userId, String uid, MultipartFile file) {
//        String key = UUID.fromString(uid + file.getOriginalFilename()).toString();
        String key = uid +"/" + file.getOriginalFilename();
        SkillMultimediaRecord result = skillMultimediaService.uploadSkillMultimedia(userId, key, file);

        awsService.upload(key, file);

        return result;
    }

    @Override
    @Transactional
    public List<UserImgRecord> updateUserImage(int userId, String uid, MultipartFile[] files) {
        UserRecord user = findUserByUserId(userId);
        return Arrays.stream(files)
                .peek(file -> userImgService.deleteUserImgByBucketKey(file.getName()))
                .map(file -> uploadUserImage(user.userId(), uid, file))
                .toList();
    }

    @Override
    @Transactional
    public List<SkillMultimediaRecord> updateSkillMultimedia(int userId, String uid, MultipartFile[] files) {
        UserRecord user = findUserByUserId(userId);
        return Arrays.stream(files)
                .peek(file -> skillMultimediaService.deleteSkillMultimediaByBucketKey(file.getName()))
                .map(file -> uploadSkillMultimedia(user.userId(), uid, file))
                .toList();
    }

    @Override
    @Transactional
    public int deleteUserByUserId(int userId) {
        userRepository.findUserByUserId(userId).orElseThrow(() -> new NoSuchElementException(String.valueOf(userId)));
        return userRepository.deleteUserByUserId(userId);
    }
}
