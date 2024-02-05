package com.example.ssafy.petcong.filter;

import com.example.ssafy.petcong.properties.AllowedUrlProperties;
import com.example.ssafy.petcong.security.UserRole;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;

import org.springframework.boot.autoconfigure.security.servlet.AntPathRequestMatcherProvider;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Slf4j
@Component
public class ExclusiveFilter extends OncePerRequestFilter {
    private final List<String> allowedUrlList;
    private final List<String> allowedPatternList;

    public ExclusiveFilter(AllowedUrlProperties allowedUrlProperties) {
        this.allowedUrlList = allowedUrlProperties.getUrls();
        this.allowedPatternList = allowedUrlProperties.getPatterns();
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        setUserRoleToRequest(UserRole.UNAUTHENTICATED, request);
        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String requestUri = request.getRequestURI();
        if (allowedUrlList.contains(requestUri)) {
            setUserRoleToRequest(UserRole.ANONYMOUS, request);
            return true;
        }

        AntPathRequestMatcherProvider antPathRequestMatcherProvider = new AntPathRequestMatcherProvider(s -> s);
        if (allowedPatternList.stream().anyMatch(pattern -> antPathRequestMatcherProvider.getRequestMatcher(pattern).matches(request))) {
            setUserRoleToRequest(UserRole.ANONYMOUS, request);
            return true;
        }

        if (request.getHeader("tester") != null && request.getHeader("tester").equals("A603")) {
            setUserRoleToRequest(UserRole.ANONYMOUS, request);
            return true;
        } else {
            return false;
        }
    }

    private void setUserRoleToRequest(UserRole userRole, HttpServletRequest request) {
        request.setAttribute("role", userRole);
    }
}
