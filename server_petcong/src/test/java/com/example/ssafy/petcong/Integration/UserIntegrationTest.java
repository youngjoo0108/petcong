package com.example.ssafy.petcong.Integration;

import static org.assertj.core.api.Assertions.assertThat;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.example.ssafy.petcong.security.UserRole;
import com.example.ssafy.petcong.user.model.dto.*;
import com.example.ssafy.petcong.user.model.enums.Gender;
import com.example.ssafy.petcong.user.model.enums.PetSize;
import com.example.ssafy.petcong.user.model.enums.Preference;
import com.example.ssafy.petcong.user.model.enums.Status;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

import org.junit.jupiter.api.Disabled;
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
//@Transactional
@SpringBootTest
@AutoConfigureMockMvc
public class UserIntegrationTest {
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private MockMvc mockMvc;

    static Stream<Arguments> provideDummySignUpUser() {
        UserInfoDto userInfoDto = new UserInfoDto();
        userInfoDto.setAge(10);
        userInfoDto.setNickname("nickname");
        userInfoDto.setEmail("signuptest@signuptest.com");
        userInfoDto.setAddress("korea");
        userInfoDto.setUid("signuptest");
        userInfoDto.setInstagramId("instatonid");
        userInfoDto.setKakaoId("kakaochocolate");
        userInfoDto.setBirthday(LocalDate.of(1997, 1, 29));
        userInfoDto.setGender(Gender.MALE);
        userInfoDto.setStatus(Status.ACTIVE);
        userInfoDto.setPreference(Preference.FEMALE);

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

        SignupRequestDto signupRequestDto = new SignupRequestDto(userInfoDto, petInfoDto);
        return Stream.of(Arguments.of(signupRequestDto));
    }

    @ParameterizedTest
    @MethodSource("provideDummySignUpUser")
    @DisplayName("SignUp Test")
    void testSignUp(SignupRequestDto signupRequestDto) throws Exception {
        //given
        String userRecordJson = objectMapper.writeValueAsString(signupRequestDto);

        //when
        var request = MockMvcRequestBuilders
                .post("/users/signup")
                .header("tester", "A603")
                .content(userRecordJson)
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
                .post("/users/signin")
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
                    .multipart(HttpMethod.POST, "/users/picture")
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
                    .multipart(HttpMethod.POST, "/users/trick")
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
//        String key = UserRole.ANONYMOUS.getUid() + "/" + "anya.jpg";
        String key = UserRole.ANONYMOUS.getUid() + "/" + "video_sample.mp4";

        //when
        var request = MockMvcRequestBuilders
                .get("/users/trick")
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
    @DisplayName("DeleteUser Test")
    void testDeleteUser() throws Exception {
        //given
        int userId = 8;

        //when
        var request = MockMvcRequestBuilders
                .delete("/users/withdraw")
                .header("tester", "A603")
                .content(String.valueOf(userId));

        //then
        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(status().isOk())
                .andReturn();

        log.info("DeleteUser Test: PASS");
    }

    @Test
    @DisplayName("GetUserInfo Test")
    void testGetUserInfo() throws Exception {
        //given

        //when
        var request = MockMvcRequestBuilders
                .get("/users/info")
                .header("tester", "A603");

        //then
        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andReturn();

        String response = mvcResult.getResponse().getContentAsString(StandardCharsets.UTF_8);

        assertThat(response).isNotNull();

        log.info("GetUserInfo Test: " + response);
    }
}
