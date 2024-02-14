package com.example.ssafy.petcong.security.provider;

import com.example.ssafy.petcong.security.token.SignupAuthenticationToken;
import com.example.ssafy.petcong.security.userdetails.SignupUserDetails;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import lombok.RequiredArgsConstructor;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

@Slf4j
@Component("signupAuthenticationProvider")
@RequiredArgsConstructor
public class SignupAuthenticationProvider implements AuthenticationProvider {
    private final FirebaseAuth firebaseAuth;
    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        Assert.isInstanceOf(SignupAuthenticationToken.class, authentication, "Require SignupAuthenticationToken type instance.");

        SignupAuthenticationToken signupAuthenticationToken = (SignupAuthenticationToken) authentication;
        try {
            String idToken = signupAuthenticationToken.getIdToken();
            FirebaseToken decodedToken = firebaseAuth.verifyIdToken(idToken);
            String uid = decodedToken.getUid();
            SignupUserDetails signupUserDetails = new SignupUserDetails(uid);
            AbstractAuthenticationToken authenticated = SignupAuthenticationToken.authenticated(signupUserDetails, signupUserDetails.getPassword(), signupUserDetails.getAuthorities());
            return authenticated;
        } catch (FirebaseAuthException e) {
            throw new BadCredentialsException(e.getMessage());
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(SignupAuthenticationToken.class);
    }
}
