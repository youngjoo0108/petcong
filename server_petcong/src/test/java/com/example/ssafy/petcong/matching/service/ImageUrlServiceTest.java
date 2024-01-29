package com.example.ssafy.petcong.matching.service;


import com.example.ssafy.petcong.user.model.entity.UserImg;
import com.example.ssafy.petcong.user.repository.UserImgRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class ImageUrlServiceTest {
    @Mock
    private UserImgRepository imageRepository;

    @InjectMocks
    private MatchingProfileServiceImpl profileService;

    @Test
    public void testGetUrlsById() {

        int userId = 1;
        List<UserImg> userImgList = Arrays.asList(
                UserImg.builder().imgId(1).user(userId).url("url1").build(),
                UserImg.builder().imgId(2).user(userId).url("url2").build(),
                UserImg.builder().imgId(3).user(userId).url("url3").build()
        );

        when(imageRepository.findByUserId(userId)).thenReturn(userImgList);

        List<String> urls = profileService.pictures(userId);
        List<String> expectedUrls = Arrays.asList("url1", "url2", "url3");

        assertEquals(expectedUrls, urls);
    }
}
