package com.ssafy.common.util;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import org.apache.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@RequiredArgsConstructor
public class FirebaseTokenFilter extends OncePerRequestFilter {

    private final UserDetailsService userDetailsService;
    private final FirebaseAuth firebaseAuth;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws IOException, ServletException {
        // 헤더에서 토큰 가져오기
        String tokenHeader = request.getHeader("Authorization");
        if (tokenHeader == null || !tokenHeader.startsWith("Bearer ")) {
            setUnauthorizedReseponse(response, "invalid token");
        }
        String token = tokenHeader.substring(7); // "Bearer " 빼고

        // 토큰 검증
        FirebaseToken decodedToken;
        try {
            decodedToken = firebaseAuth.verifyIdToken(token);
        } catch (FirebaseAuthException e) {
            setUnauthorizedReseponse(response, "invalid token");
            return;
        }

        // 유저정보 가져와서 SecurityContext에 저장
        try {
            UserDetails user = userDetailsService.loadUserByUsername(decodedToken.getUid()); // 확인 필요
            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                    user, null, user.getAuthorities());
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } catch (UsernameNotFoundException e) {
            setUnauthorizedReseponse(response, "user not found");
            return;
        }
        filterChain.doFilter(request, response);
    }

    private void setUnauthorizedReseponse(HttpServletResponse response, String msg) throws IOException {
        response.setStatus(HttpStatus.SC_UNAUTHORIZED);
        response.getWriter().write(msg);
    }
}
