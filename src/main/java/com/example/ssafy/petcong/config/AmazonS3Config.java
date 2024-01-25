package com.example.ssafy.petcong.config;

import software.amazon.awssdk.services.s3.model.Bucket;
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.auth.credentials.EnvironmentVariableCredentialsProvider;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.regions.Region;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@Configuration
public class AmazonS3Config {
    @Bean
    public Bucket bucket() {
        Bucket bucket = Bucket.builder()
                .name(System.getenv("S3_BUCKET_NAME"))
                .build();
        return bucket;
    }
    @Bean
    public AwsCredentialsProvider awsCredentialsProvider() {
        AwsCredentialsProvider awsCredentialsProvider = EnvironmentVariableCredentialsProvider.create();
        return awsCredentialsProvider;
    }
    @Bean
    public S3Client s3Client(AwsCredentialsProvider awsCredentialsProvider) {
        S3Client s3Client = S3Client.builder()
                .region(Region.AP_NORTHEAST_2)
                .credentialsProvider(awsCredentialsProvider)
                .build();
        return s3Client;
    }
    @Bean
    public S3Presigner s3Presigner(AwsCredentialsProvider awsCredentialsProvider) {
        S3Presigner s3Presigner = S3Presigner.builder()
                .region(Region.AP_NORTHEAST_2)
                .credentialsProvider(awsCredentialsProvider)
                .build();
        return s3Presigner;
    }
}
