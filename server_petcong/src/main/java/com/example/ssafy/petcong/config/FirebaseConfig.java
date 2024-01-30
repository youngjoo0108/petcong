package com.example.ssafy.petcong.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;

@Configuration
public class FirebaseConfig {
    @Bean
    public FirebaseOptions firebaseOptions() throws IOException {
        return FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.getApplicationDefault())
                .build();
    }
    @Bean
    public FirebaseApp firebaseApp(FirebaseOptions firebaseOptions) {
        return FirebaseApp.initializeApp(firebaseOptions);
    }
    @Bean
    public FirebaseAuth firebaseAuth(FirebaseApp firebaseApp) {
        return FirebaseAuth.getInstance(firebaseApp);
    }
}
