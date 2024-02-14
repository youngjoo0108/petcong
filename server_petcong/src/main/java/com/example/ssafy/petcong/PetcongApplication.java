package com.example.ssafy.petcong;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class PetcongApplication {

    public static void main(String[] args) {
        SpringApplication.run(PetcongApplication.class, args);
    }

}
