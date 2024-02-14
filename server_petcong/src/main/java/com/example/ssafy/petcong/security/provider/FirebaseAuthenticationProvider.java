package com.example.ssafy.petcong.security.provider;

import com.example.ssafy.petcong.security.token.FirebaseAuthenticationToken;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

@Slf4j
@Component("firebaseAuthenticationProvider")
@RequiredArgsConstructor
public class FirebaseAuthenticationProvider implements AuthenticationProvider {
    private final FirebaseAuth firebaseAuth;
    private final UserDetailsService firebaseUserDetailService;

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        Assert.isInstanceOf(FirebaseAuthenticationToken.class, authentication, "Require FirebaseAuthenticationToken type instance.");

        FirebaseAuthenticationToken firebaseAuthenticationToken = (FirebaseAuthenticationToken) authentication;
        try {
            String idToken = firebaseAuthenticationToken.getIdToken();
            FirebaseToken decodedToken = firebaseAuth.verifyIdToken(idToken);
            String uid = decodedToken.getUid();
            UserDetails userDetails = firebaseUserDetailService.loadUserByUsername(uid);
            AbstractAuthenticationToken authenticated = FirebaseAuthenticationToken.authenticated(userDetails, userDetails.getPassword(), userDetails.getAuthorities());
            authenticated.setDetails(userDetails);
            return authenticated;
        } catch (IllegalArgumentException | UsernameNotFoundException | FirebaseAuthException e) {
            throw new BadCredentialsException(e.getMessage());
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(FirebaseAuthenticationToken.class);
    }
}
