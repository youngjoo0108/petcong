package com.example.ssafy.petcong.util;

import org.springframework.web.multipart.MultipartFile;

import java.nio.file.InvalidPathException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class S3KeyGenerator {
    public static String generateKey(String uid, MultipartFile file) {
        String fileName = file.getOriginalFilename();
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0) {
            return uid +
                    "/" +
                    DateTimeFormatter.ofPattern("yyyyMMdd-HHmmssSSS").format(LocalDateTime.now()) +
                    fileName.substring(lastDotIndex);
        } else {
            throw new InvalidPathException(fileName, "Path contains invalid character.");
        }
    }
}
