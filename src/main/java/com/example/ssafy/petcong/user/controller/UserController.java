package com.example.ssafy.petcong.user.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@CrossOrigin("*")
public class UserController {
    @PostMapping("/signin")
    public ResponseEntity<String> signin() {
        log.info("isAuthenticated ? : " + SecurityContextHolder.getContext().getAuthentication().isAuthenticated());
        return ResponseEntity.ok().body("success");
    }
}
