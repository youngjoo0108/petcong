package com.example.ssafy.petcong.security.filter;

import com.example.ssafy.petcong.security.token.FirebaseAuthenticationToken;
import com.example.ssafy.petcong.security.userdetails.FirebaseUserDetails;
import com.example.ssafy.petcong.security.token.SignupAuthenticationToken;
import com.example.ssafy.petcong.security.role.UserRole;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class FirebaseAuthenticationFilter extends OncePerRequestFilter {
    private static final String TOKEN = "Petcong-id-token";
    private final AuthenticationManager authenticationManager;
    private HttpServletRequest httpServletRequest;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        Assert.isInstanceOf(UserRole.class, request.getAttribute("role"), "Require UserRole type instance in request's attributes.");

        this.httpServletRequest = request;

        UserRole role = (UserRole) request.getAttribute("role");

        Authentication authenticated = attemptAuthenticate(role);

        saveAuthentication(authenticated);

        filterChain.doFilter(request, response);
    }

    protected Authentication attemptAuthenticate(UserRole role) {
        switch (role) {
            case UNAUTHENTICATED -> {
                String idToken = getTokenFromHeader();
                Authentication authentication = FirebaseAuthenticationToken.unauthenticated(idToken);
                return authenticationManager.authenticate(authentication);
            }
            case SIGNUP -> {
                String idToken = getTokenFromHeader();
                Authentication authentication = SignupAuthenticationToken.unauthenticated(idToken);
                return authenticationManager.authenticate(authentication);
            }
            case TESTER -> {
                UserDetails anonymousUserDetails = new FirebaseUserDetails(role.getUid(), role.getMemberId(), role.isStatus());
                AbstractAuthenticationToken authenticatedToken = FirebaseAuthenticationToken.authenticated(anonymousUserDetails, anonymousUserDetails.getPassword(), null);
                authenticatedToken.setDetails(anonymousUserDetails);
                return authenticatedToken;
            }
            case ANONYMOUS -> {
                return null;
            }
            default -> throw new AuthenticationServiceException("Can not process " + role.getClass() + " type.");
        }
    }

    private void saveAuthentication(Authentication authentication) {
        SecurityContextHolder.getContext().setAuthentication(authentication);
    }

    private String getTokenFromHeader() {
        Assert.notNull(httpServletRequest, "HttpServletRequest must not be null.");
        String idToken = httpServletRequest.getHeader(TOKEN);
        idToken = (idToken != null) ? idToken.trim() : "";
        return idToken;
    }

}
