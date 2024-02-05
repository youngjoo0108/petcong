package com.example.ssafy.petcong.AWS.service;

import org.springframework.web.multipart.MultipartFile;

import java.time.Duration;

public interface AWSService {
    void upload(String key, MultipartFile file);
    String createPresignedUrl(String key);
    String createPresignedUrl(String key, Duration duration);
}
