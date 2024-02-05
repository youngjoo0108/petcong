package com.example.ssafy.petcong.properties;

import lombok.Getter;
import lombok.Setter;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.List;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "allowed-url")
public class AllowedUrlProperties {
    private List<String> urls;
    private List<String> patterns;
}
