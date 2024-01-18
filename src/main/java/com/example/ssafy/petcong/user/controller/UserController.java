package com.example.ssafy.petcong.user.controller;

import com.google.firebase.FirebaseApp;
import com.google.firebase.auth.*;
import com.google.firebase.auth.internal.FirebaseCustomAuthToken;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {
    private final FirebaseAuth firebaseAuth;

    @PostMapping("/signup")
    public ResponseEntity<?> signup(String gmail) throws FirebaseAuthException {
        UserRecord userRecord = firebaseAuth.getUserByEmail(gmail);
        return ResponseEntity.ok().body(userRecord);
    }
    @PostMapping("/signin")
    public ResponseEntity<String> signin(String userUid, String idToken) throws FirebaseAuthException {
        FirebaseToken decodedToken = firebaseAuth.verifyIdToken(idToken);

        if (userUid != null && decodedToken != null) {
            if (userUid.equals(decodedToken.getUid())) {
                return ResponseEntity.ok().body("ok");
            }
        }
        
        return ResponseEntity.badRequest().body("this is test response");
    }
}
