package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.AWS.service.AWSService;
import com.example.ssafy.petcong.exception.NotRegisterdException;
import com.example.ssafy.petcong.user.model.dto.*;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.repository.UserRepository;

import com.example.ssafy.petcong.util.S3KeyGenerator;
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

        return UserRecord.fromUserEntity(result);
    }

    @Override
    public UserRecord findUserByUserId(int userId) {
        User result = userRepository.findUserByUserId(userId).orElseThrow(() -> new NoSuchElementException(String.valueOf(userId)));

        return UserRecord.fromUserEntity(result);
    }

    @Override
    @Transactional
    public UserRecord save(UserInfoDto userInfo) {
        User siginupUser = User.fromUserInfoDto(userInfo);

        User result = userRepository.save(siginupUser);

        return UserRecord.fromUserEntity(result);
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

        return UserRecord.fromUserEntity(result);
    }

    @Override
    @Transactional
    public ProfileDto getProfile(int userId) {
        UserRecord userRecord = findUserByUserId(userId);
        UserInfoDto userInfo = UserInfoDto.fromUserRecord(userRecord);
        List<UserImgInfoDto> userImgInfoList = getUserImageList(userId)
                .stream()
                .map(UserImgInfoDto::fromUserImgRecord)
                .peek(UserImg -> UserImg.setBucketKey(awsService.createPresignedUrl(UserImg.getBucketKey())))
                .toList();

        PetRecord petRecord = petService.findPetByUserId(userId);
        PetInfoDto petInfo = PetInfoDto.fromPetRecord(petRecord);
        List<SkillMultimediaInfoDto> skillMultimediaInfoList = getSkillMultimediaList(userId)
                .stream()
                .map(SkillMultimediaInfoDto::fromSkillMultimediaRecord)
                .peek(SkillMultimedia -> SkillMultimedia.setBucketKey(awsService.createPresignedUrl(SkillMultimedia.getBucketKey())))
                .toList();

        ProfileDto profileDto = ProfileDto.builder()
                .userProfile(UserProfileDto.builder()
                        .userInfo(userInfo)
                        .userImgInfosList(userImgInfoList).build())
                .petProfile(PetProfileDto.builder()
                        .petInfo(petInfo)
                        .skillMultimediaInfoList(skillMultimediaInfoList).build())
                .build();

        return profileDto;
    }

    @Override
    @Transactional
    public UserRecord updateUserInfo(int userId, UserInfoDto userInfo) {
        User userEntity = User.fromUserInfoDto(userInfo);
        userEntity.updateUserId(userId);

        User result = userRepository.save(userEntity);

        return UserRecord.fromUserEntity(result);
    }

    @Override
    public List<UserImgRecord> getUserImageList(int userId) {
        return userImgService.getUserImageList(userId);
    }

    @Override
    public List<SkillMultimediaRecord> getSkillMultimediaList(int userId) {
        return skillMultimediaService.getSkillMultimediaList(userId);
    }

    @Override
    @Transactional
    public List<UserImgRecord> uploadUserImage(int userId, String uid, MultipartFile[] files) {
        List<UserImgRecord> resultList = new ArrayList<>();
        for (MultipartFile file : files) {
            String key = S3KeyGenerator.generate(uid, file);
            resultList.add(userImgService.uploadUserImage(userId, key, file));
            awsService.upload(key, file);
        }

        return resultList;
    }

    @Override
    @Transactional
    public List<SkillMultimediaRecord> uploadSkillMultimedia(int userId, String uid, MultipartFile[] files) {
        List<SkillMultimediaRecord> resultList = new ArrayList<>();
        for (MultipartFile file : files) {
            String key = S3KeyGenerator.generate(uid, file);
            resultList.add(skillMultimediaService.uploadSkillMultimedia(userId, key, file));
            awsService.upload(key, file);
        }

        return resultList;
    }

    @Override
    @Transactional
    public List<UserImgRecord> updateUserImage(int userId, String uid, MultipartFile[] files) {
        Arrays.stream(files).forEach(file -> userImgService.deleteUserImgByBucketKey(file.getName()));

        return uploadUserImage(userId, uid, files);
    }

    @Override
    @Transactional
    public List<SkillMultimediaRecord> updateSkillMultimedia(int userId, String uid, MultipartFile[] files) {
        Arrays.stream(files).forEach(file -> skillMultimediaService.deleteSkillMultimediaByBucketKey(file.getName()));

        return uploadSkillMultimedia(userId, uid, files);
    }

    @Override
    @Transactional
    public int deleteUserByUserId(int userId) {
        userRepository.findUserByUserId(userId).orElseThrow(() -> new NoSuchElementException(String.valueOf(userId)));

        return userRepository.deleteUserByUserId(userId);
    }
}
