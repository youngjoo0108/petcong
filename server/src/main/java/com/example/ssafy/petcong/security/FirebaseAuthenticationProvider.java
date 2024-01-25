//package com.example.ssafy.petcong.security;
//
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//
//import org.springframework.security.authentication.AuthenticationProvider;
//import org.springframework.security.authentication.BadCredentialsException;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.AuthenticationException;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.security.core.userdetails.UserDetailsService;
//import org.springframework.security.core.userdetails.UsernameNotFoundException;
//import org.springframework.stereotype.Component;
//
//@Component("firebaseAuthenticationProvider")
//@Slf4j
//@RequiredArgsConstructor
//public class FirebaseAuthenticationProvider implements AuthenticationProvider {
//    private final UserDetailsService firebaseUserDetailService;
//    @Override
//    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
//        if (authentication instanceof FirebaseAuthentication firebaseAuthentication) {
//            String idToken = firebaseAuthentication.getIdToken();
//            log.info("received token: " + idToken);
//            try {
//                UserDetails userDetails = firebaseUserDetailService.loadUserByUsername(idToken);
//                return new FirebaseAuthentication(userDetails, userDetails.getPassword(), userDetails.getAuthorities());
//            } catch (UsernameNotFoundException e) {
//                throw new BadCredentialsException(e.getLocalizedMessage());
//            }
//        } else {
//            throw new BadCredentialsException("authentication type must be FirebaseAuthentication.");
//        }
//    }
//
//    @Override
//    public boolean supports(Class<?> authentication) {
//        return authentication.equals(FirebaseAuthentication.class);
//    }
//}
