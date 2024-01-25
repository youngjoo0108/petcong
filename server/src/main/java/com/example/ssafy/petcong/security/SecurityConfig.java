//package com.example.ssafy.petcong.security;
//
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.http.HttpStatus;
//import org.springframework.security.authentication.AuthenticationManager;
//import org.springframework.security.authentication.AuthenticationProvider;
//import org.springframework.security.authentication.ProviderManager;
//import org.springframework.security.config.Customizer;
//import org.springframework.security.config.annotation.web.builders.HttpSecurity;
//import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
//import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
//import org.springframework.security.web.SecurityFilterChain;
//import org.springframework.security.web.authentication.HttpStatusEntryPoint;
//import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
//
//@Configuration
//@EnableWebSecurity
//public class SecurityConfig {
//    @Bean
//    public AuthenticationManager firebaseAuthenticationManager(AuthenticationProvider firebaseAuthenticationProvider) {
//        return new ProviderManager(firebaseAuthenticationProvider);
//    }
//    @Bean
//    public SecurityFilterChain securityFilterChain(HttpSecurity http, AuthenticationManager firebaseAuthenticationManager) throws Exception {
//        http
//            .csrf(AbstractHttpConfigurer::disable)
//            .addFilterBefore(new FirebaseAuthenticationFilter(firebaseAuthenticationManager), UsernamePasswordAuthenticationFilter.class)
//            .authorizeHttpRequests(requests -> requests
//                    .anyRequest().authenticated())
//            .exceptionHandling(configurer -> configurer
//                    .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED)));
//        return http.build();
//    }
//}
