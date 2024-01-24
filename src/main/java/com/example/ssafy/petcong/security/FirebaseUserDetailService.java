//package com.example.ssafy.petcong.security;
//
//import com.google.firebase.auth.FirebaseAuth;
//import com.google.firebase.auth.FirebaseAuthException;
//import com.google.firebase.auth.FirebaseToken;
//
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//
//import org.springframework.security.core.userdetails.User;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.security.core.userdetails.UserDetailsService;
//import org.springframework.security.core.userdetails.UsernameNotFoundException;
//import org.springframework.stereotype.Service;
//
//@Slf4j
//@Service("firebaseUserDetailService")
//@RequiredArgsConstructor
//public class FirebaseUserDetailService implements UserDetailsService {
//    private final FirebaseAuth firebaseAuth;
//    @Override
//    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
//        try {
//            FirebaseToken decodedToken = firebaseAuth.verifyIdToken(username);
//            log.info("decoded Token: " + decodedToken.toString());
//            String password = decodedToken.getUid();
//            return User.withUsername(username).password(password).build();
//        } catch (FirebaseAuthException e) {
//            throw new UsernameNotFoundException(e.getLocalizedMessage());
//        }
//    }
//}
