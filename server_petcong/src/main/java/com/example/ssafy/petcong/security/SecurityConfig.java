package com.example.ssafy.petcong.security;

import com.example.ssafy.petcong.filter.FirebaseAuthenticationFilter;
import com.example.ssafy.petcong.Properties.AllowedUrlProperties;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandlerImpl;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;

import java.time.Duration;
import java.util.Collections;
import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    private final String[] allowedUrls;
    private final String[] allowedPatterns;
    public SecurityConfig(AllowedUrlProperties allowedUrlProperties) {
        assert allowedUrlProperties.getUrls() != null;
        assert allowedUrlProperties.getPatterns() != null;
        this.allowedUrls = allowedUrlProperties.getUrls().toArray(new String[0]);
        this.allowedPatterns = allowedUrlProperties.getPatterns().toArray(new String[0]);
    }
    @Bean
    public AuthenticationManager firebaseAuthenticationManager(AuthenticationProvider firebaseAuthenticationProvider) {
        return new ProviderManager(firebaseAuthenticationProvider);
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
    public SecurityFilterChain securityFilterChain(HttpSecurity http, FirebaseAuthenticationFilter firebaseAuthenticationFilter, AuthenticationManager firebaseAuthenticationManager) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)
            .cors(Customizer.withDefaults())
            .authenticationManager(firebaseAuthenticationManager)
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .addFilterAt(firebaseAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(requests -> requests
                    .requestMatchers(allowedUrls).permitAll()
                    .requestMatchers(allowedPatterns).permitAll()
                    .anyRequest().authenticated())
            .exceptionHandling(configurer -> configurer
                    .accessDeniedHandler(new AccessDeniedHandlerImpl())
                    .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED)));
        return http.build();
    }
}
