package com.example.ssafy.petcong.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ApplicationConfig {
    @Bean
    public JavaTimeModule javaTimeModule() {
        JavaTimeModule javaTimeModule = new JavaTimeModule();
        return javaTimeModule;
    }
    @Bean
    public ObjectMapper objectMapper(JavaTimeModule javaTimeModule) {
        ObjectMapper objectMapper = new ObjectMapper().registerModule(javaTimeModule);
        return objectMapper;
    }
}
