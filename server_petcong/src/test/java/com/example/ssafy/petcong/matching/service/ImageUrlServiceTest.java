package com.example.ssafy.petcong.matching.service;


import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.model.entity.MemberImg;
import com.example.ssafy.petcong.member.repository.MemberImgRepository;

import org.junit.jupiter.api.Disabled;
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
    private MemberImgRepository imageRepository;

    @InjectMocks
    private MatchingProfileServiceImpl profileService;

    @Disabled
    @Test
    public void testGetUrlsById() {

        int memberId = 1;
        Member member = Member.builder().memberId(memberId).build();
        List<MemberImg> memberImgList = Arrays.asList(
                MemberImg.builder().imgId(1).member(member).bucketKey("url1").build(),
                MemberImg.builder().imgId(2).member(member).bucketKey("url2").build(),
                MemberImg.builder().imgId(3).member(member).bucketKey("url3").build()
        );

        when(imageRepository.findMemberImgByMember_MemberId(memberId)).thenReturn(memberImgList);

        List<String> urls = profileService.pictures(memberId);
        List<String> expectedUrls = Arrays.asList("url1", "url2", "url3");

        assertEquals(expectedUrls, urls);
    }
}
