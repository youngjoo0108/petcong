package com.example.ssafy.petcong.security.config;

import com.example.ssafy.petcong.security.authenticationentrypoint.UnauthorizedEntryPoint;
import com.example.ssafy.petcong.security.filter.ExclusiveFilter;
import com.example.ssafy.petcong.security.filter.FirebaseAuthenticationFilter;
import com.example.ssafy.petcong.properties.AllowedUrlProperties;

import com.mysema.commons.lang.Assert;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.*;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.time.Duration;
import java.util.Collections;
import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    private final String[] allowedUrls;
    private final String[] allowedPatterns;

    public SecurityConfig(AllowedUrlProperties allowedUrlProperties) {
        Assert.notNull(allowedUrlProperties, "allowedUrlProperties must not be null");
        Assert.notNull(allowedUrlProperties.getUrls(), "urls must not be null");
        Assert.notNull(allowedUrlProperties.getPatterns(), "patterns must not be null");

        this.allowedUrls = allowedUrlProperties.getUrls().toArray(new String[0]);
        this.allowedPatterns = allowedUrlProperties.getPatterns().toArray(new String[0]);
    }

    @Bean
    public CorsConfiguration corsConfiguration() {
        CorsConfiguration corsConfiguration = new CorsConfiguration();
        corsConfiguration.setAllowedOrigins(Collections.singletonList("*"));
        corsConfiguration.setAllowedMethods(List.of("OPTIONS", "GET", "POST", "PATCH", "DELETE"));
        corsConfiguration.setMaxAge(Duration.ofMinutes(30));
        return corsConfiguration;
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource(CorsConfiguration corsConfiguration) {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfiguration);
        return source;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationProvider... authenticationProvider) {
       return new ProviderManager(authenticationProvider);
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   CorsConfigurationSource corsConfigurationSource,
                                                   ExclusiveFilter exclusiveFilter,
                                                   FirebaseAuthenticationFilter firebaseAuthenticationFilter,
                                                   UnauthorizedEntryPoint unauthorizedEntryPoint) throws Exception {

        return http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(cors -> cors.configurationSource(corsConfigurationSource))
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .addFilterBefore(exclusiveFilter, UsernamePasswordAuthenticationFilter.class)
                .addFilterAt(firebaseAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .authorizeHttpRequests(requests -> requests
                        .requestMatchers(allowedUrls).permitAll()
                        .requestMatchers(allowedPatterns).permitAll()
                        .anyRequest().authenticated())
                .exceptionHandling(configurer -> configurer
                        .authenticationEntryPoint(unauthorizedEntryPoint))
                .build();
    }
}
