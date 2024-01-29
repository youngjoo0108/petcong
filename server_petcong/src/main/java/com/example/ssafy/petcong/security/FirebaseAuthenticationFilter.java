//package com.example.ssafy.petcong.security;
//
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//
//import org.springframework.security.authentication.AuthenticationManager;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.AuthenticationException;
//import org.springframework.security.core.context.SecurityContextHolder;
//import org.springframework.web.filter.OncePerRequestFilter;
//
//import java.io.IOException;
//
//@Slf4j
//@RequiredArgsConstructor
//public class FirebaseAuthenticationFilter extends OncePerRequestFilter {
//    private final AuthenticationManager firebaseAuthenticationManager;
//
//    @Override
//    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
//        try {
//            String idToken = request.getHeader("Petcong-id-token");
//            log.info("received token: " + idToken);
//            Authentication firebaseAuthenticationToken = new FirebaseAuthentication(idToken);
//            Authentication authenticated = firebaseAuthenticationManager.authenticate(firebaseAuthenticationToken);
//            log.info("authenticated!!!");
//            SecurityContextHolder.getContext().setAuthentication(authenticated);
//            log.info("setAuthentication()");
//        } catch (AuthenticationException e) {
//            throw new ServletException(e.getLocalizedMessage());
//        }
//        filterChain.doFilter(request, response);
//    }
//
//    @Override
//    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
//        if (request.getHeader("tester") != null && request.getHeader("tester").equals("A603")) {
//            return true;
//        }
//        else {
//            return false;
//        }
//    }
//}