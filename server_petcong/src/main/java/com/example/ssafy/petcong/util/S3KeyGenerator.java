package com.example.ssafy.petcong.util;

import org.springframework.web.multipart.MultipartFile;

public class S3KeyGenerator {
    public static String generate(String uid, MultipartFile file) {
        return uid + "/" + file.getOriginalFilename();
    }
}
