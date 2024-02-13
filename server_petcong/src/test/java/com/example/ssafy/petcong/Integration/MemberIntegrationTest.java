package com.example.ssafy.petcong.Integration;

import static org.assertj.core.api.Assertions.assertThat;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.example.ssafy.petcong.member.model.dto.*;
import com.example.ssafy.petcong.member.model.enums.Gender;
import com.example.ssafy.petcong.member.model.enums.PetSize;
import com.example.ssafy.petcong.member.model.enums.Preference;
import com.example.ssafy.petcong.security.UserRole;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.transaction.Transactional;

import lombok.extern.slf4j.Slf4j;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.stream.Stream;

@Slf4j
@Transactional
@SpringBootTest
@AutoConfigureMockMvc
public class MemberIntegrationTest {
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private MockMvc mockMvc;

    static Stream<Arguments> provideDummySignUpMember() {
        SignupMemberInfoDto signupMemberInfoDto = new SignupMemberInfoDto();
        signupMemberInfoDto.setAge(10);
        signupMemberInfoDto.setNickname("nickname");
        signupMemberInfoDto.setEmail("signuptest@signuptest.com");
        signupMemberInfoDto.setAddress("korea");
        signupMemberInfoDto.setInstagramId("instatonid");
        signupMemberInfoDto.setKakaoId("kakaochocolate");
        signupMemberInfoDto.setBirthday(LocalDate.of(1997, 1, 29));
        signupMemberInfoDto.setGender(Gender.MALE);
        signupMemberInfoDto.setPreference(Preference.FEMALE);

        PetInfoDto petInfoDto = new PetInfoDto();
        petInfoDto.setAge(1);
        petInfoDto.setGender(Gender.FEMALE);
        petInfoDto.setDbti("INFP");
        petInfoDto.setHobby("산책");
        petInfoDto.setBreed("골드 리트리버");
        petInfoDto.setName("야옹이");
        petInfoDto.setSize(PetSize.LARGE);
        petInfoDto.setToy("원반");
        petInfoDto.setDescription("우리 개는 물어요.");
        petInfoDto.setNeutered(false);
        petInfoDto.setWeight(30);
        petInfoDto.setSnack("생닭다리");

        SignupRequestDto signupRequestDto = new SignupRequestDto(signupMemberInfoDto, petInfoDto);
        return Stream.of(Arguments.of(signupRequestDto));
    }

    @ParameterizedTest
    @MethodSource("provideDummySignUpMember")
    @DisplayName("SignUp Test")
    void testSignUp(SignupRequestDto signupRequestDto) throws Exception {
        //given
        String memberRecordJson = objectMapper.writeValueAsString(signupRequestDto);

        //when
        var request = MockMvcRequestBuilders
                .post("/members/signup")
                .header("tester", "A603")
                .content(memberRecordJson)
                .contentType(MediaType.APPLICATION_JSON);

        //then
        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(status().isCreated())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andReturn();

        String response = mvcResult.getResponse().getContentAsString(StandardCharsets.UTF_8);

        assertThat(response).isNotNull();

        log.info("SignUp Test: " + response);
    }

    @Test
    @DisplayName("Signin Test")
    void testSignin() throws Exception {
        //given

        //when
        var request = MockMvcRequestBuilders
                .post("/members/signin")
                .header("tester", "A603")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED);

        //then
        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andReturn();

        String response = mvcResult.getResponse().getContentAsString();

        assertThat(response).isNotNull();

        log.info("Signin Test: " + response);
    }

    @Test
    @DisplayName("Signout Test")
    void testSignout() throws Exception {
        //given

        //when
        var request = MockMvcRequestBuilders
                .post("/members/signout")
                .header("tester", "A603")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED);

        //then
        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(status().isAccepted())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andReturn();

        String response = mvcResult.getResponse().getContentAsString();

        boolean isSignouted = Boolean.parseBoolean(response);

        assertThat(isSignouted).isTrue();

        log.info("Signout Test: " + isSignouted);
    }

    @Test
    @DisplayName("PostProfileImage Test")
    void testPostProfileImage() throws Exception {
        try(FileInputStream fileInputStream = new FileInputStream("C:\\Users\\SSAFY\\Downloads\\anya.jpg")) {
            //given
            byte[] bytes = fileInputStream.readAllBytes();
            MockMultipartFile multipartFile = new MockMultipartFile(
                    "files",
                    "anya.jpg",
                    MediaType.MULTIPART_FORM_DATA_VALUE,
                    bytes);

            //when
            var request = MockMvcRequestBuilders
                    .multipart(HttpMethod.POST, "/members/picture")
                    .file(multipartFile)
                    .header("tester", "A603")
                    .contentType(MediaType.APPLICATION_FORM_URLENCODED);

            //then
            MvcResult mvcResult = mockMvc
                    .perform(request)
                    .andExpect(status().isCreated())
                    .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                    .andReturn();

            String response = mvcResult.getResponse().getContentAsString();

            assertThat(response).isNotNull();

            log.info("PostProfileImage Test: " + response);
        }
    }

    @Test
    @DisplayName("PostDogTrick Test")
    void testPostDogTrick() throws Exception {
        try(FileInputStream fileInputStream = new FileInputStream("C:\\Users\\SSAFY\\Downloads\\video_sample.mp4")) {
            //given
            byte[] bytes = fileInputStream.readAllBytes();
            MockMultipartFile multipartFile = new MockMultipartFile(
                    "files",
                    "video_sample.mp4",
                    MediaType.MULTIPART_FORM_DATA_VALUE,
                    bytes);

            //when
            var request = MockMvcRequestBuilders
                    .multipart(HttpMethod.POST, "/members/trick")
                    .file(multipartFile)
                    .header("tester", "A603")
                    .contentType(MediaType.APPLICATION_FORM_URLENCODED);

            //then
            MvcResult mvcResult = mockMvc
                    .perform(request)
                    .andExpect(status().isCreated())
                    .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                    .andReturn();

            String response = mvcResult.getResponse().getContentAsString();

            assertThat(response).isNotNull();

            log.info("PostDogTrick Test: " + response);
        }
    }

    @Test
    @DisplayName("GetMediaUrl Test")
    void testGetMediaUrl() throws Exception {
        //given
//        String key = MemberRole.ANONYMOUS.getUid() + "/" + "anya.jpg";
        String key = UserRole.ANONYMOUS.getUid() + "/" + "video_sample.mp4";

        //when
        var request = MockMvcRequestBuilders
                .get("/members/trick")
                .header("tester", "A603")
                .param("key", key);

        //then
        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(status().isOk())
                .andExpect(content().contentType(new MediaType(MediaType.TEXT_PLAIN, StandardCharsets.UTF_8)))
                .andReturn();

        String response = mvcResult.getResponse().getContentAsString();

        assertThat(response).isNotNull();

        log.info("GetMediaUrl Test: " + response);
    }

    @Test
    @DisplayName("DeleteMember Test")
    void testDeleteMember() throws Exception {
        //given
        int memberId = 8;

        //when
        var request = MockMvcRequestBuilders
                .delete("/members/withdraw")
                .header("tester", "A603")
                .content(String.valueOf(memberId));

        //then
        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(status().isOk())
                .andReturn();

        log.info("DeleteMember Test: PASS");
    }

    @Test
    @DisplayName("GetMemberInfo Test")
    void testGetMemberInfo() throws Exception {
        //given

        //when
        var request = MockMvcRequestBuilders
                .get("/members/info")
                .header("tester", "A603");

        //then
        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andReturn();

        String response = mvcResult.getResponse().getContentAsString(StandardCharsets.UTF_8);

        assertThat(response).isNotNull();

        log.info("GetMemberInfo Test: " + response);
    }
}
