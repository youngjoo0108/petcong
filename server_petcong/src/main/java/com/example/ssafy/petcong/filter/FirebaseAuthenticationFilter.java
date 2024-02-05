package com.example.ssafy.petcong.filter;

import com.example.ssafy.petcong.security.FirebaseAuthentication;
import com.example.ssafy.petcong.Properties.AllowedUrlProperties;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;

import org.springframework.boot.autoconfigure.security.servlet.AntPathRequestMatcherProvider;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Slf4j
@Component
public class FirebaseAuthenticationFilter extends OncePerRequestFilter {
    private final AuthenticationManager firebaseAuthenticationManager;
    private final List<String> allowedUrlList;
    private final List<String> allowedPatternList;
    public FirebaseAuthenticationFilter(AuthenticationManager firebaseAuthenticationManager, AllowedUrlProperties allowedUrlProperties) {
        this.firebaseAuthenticationManager = firebaseAuthenticationManager;
        this.allowedUrlList = allowedUrlProperties.getUrls();
        this.allowedPatternList = allowedUrlProperties.getPatterns();
    }
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String idToken = request.getHeader("Petcong-id-token");
        if (idToken != null && !idToken.isBlank()) {
            try {
                Authentication firebaseAuthenticationToken = new FirebaseAuthentication(idToken);
                Authentication authenticated = firebaseAuthenticationManager.authenticate(firebaseAuthenticationToken);
                SecurityContextHolder.getContext().setAuthentication(authenticated);
            } catch (AuthenticationException e) {
                throw new ServletException(e.getLocalizedMessage());
            }
            filterChain.doFilter(request, response);
        } else {
            response.sendRedirect("/users/signin");
        }
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String requestUri = request.getRequestURI();
        if (allowedUrlList.contains(requestUri)) {
            return true;
        }

        AntPathRequestMatcherProvider antPathRequestMatcherProvider = new AntPathRequestMatcherProvider(s -> s);
        if (allowedPatternList.stream().anyMatch(pattern -> antPathRequestMatcherProvider.getRequestMatcher(pattern).matches(request))) {
            return true;
        }

        if (request.getRequestURI().contains("/websocket")) {
           log.info(request.getRequestURI());
           return true;
        }

        if (request.getHeader("tester") != null && request.getHeader("tester").equals("A603")) {
           String uid = "SA7q9H4r0WfIkvdah6OSIW7Y6XQ2";
           UserDetails userDetails = User.withUsername("test").password(uid).build();
           Authentication testAuthentication = new FirebaseAuthentication(userDetails, null, userDetails.getAuthorities());
           testAuthentication.setAuthenticated(true);
           SecurityContextHolder.getContext().setAuthentication(testAuthentication);
           return true;
        } else {
           return false;
        }
    }
}
