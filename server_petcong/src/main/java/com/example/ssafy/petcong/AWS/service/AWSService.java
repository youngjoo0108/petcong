package com.example.ssafy.petcong.AWS.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.Duration;

public interface AWSService {
    String upload(String key, MultipartFile file) throws IOException;
    String createPresignedUrl(String key);
    String createPresignedUrl(String key, Duration duration);
}
