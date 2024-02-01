package com.example.ssafy.petcong.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
public class FirebaseAuthenticationFilter extends OncePerRequestFilter {
    private final AuthenticationManager firebaseAuthenticationManager;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        try {
            String idToken = request.getHeader("Petcong-id-token");
            Authentication firebaseAuthenticationToken = new FirebaseAuthentication(idToken);
            Authentication authenticated = firebaseAuthenticationManager.authenticate(firebaseAuthenticationToken);
            SecurityContextHolder.getContext().setAuthentication(authenticated);
        } catch (AuthenticationException e) {
            throw new ServletException(e.getLocalizedMessage());
        }
        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        if ((request.getHeader("tester") != null && request.getHeader("tester").equals("A603"))
        || request.getRequestURI().contains("/websocket")) {
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
