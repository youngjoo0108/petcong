package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.SkillMultimediaRecord;
import com.example.ssafy.petcong.user.model.dto.UserRecord;
import org.springframework.web.multipart.MultipartFile;

public interface SkillMultimediaService {
    SkillMultimediaRecord uploadSkillMultimedia(UserRecord user, String key, MultipartFile file);
}
