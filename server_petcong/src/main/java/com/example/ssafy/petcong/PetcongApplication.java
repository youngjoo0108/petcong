package com.example.ssafy.petcong;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
public class PetcongApplication {

    public static void main(String[] args) {
        SpringApplication.run(PetcongApplication.class, args);
    }

}
