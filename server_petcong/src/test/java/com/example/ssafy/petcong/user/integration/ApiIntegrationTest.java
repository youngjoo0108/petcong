//package com.example.ssafy.petcong.user.integration;
//
//import static org.assertj.core.api.Assertions.assertThat;
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
//
//import com.example.ssafy.petcong.user.model.enums.Gender;
//import com.example.ssafy.petcong.user.model.enums.Preference;
//import com.example.ssafy.petcong.user.model.enums.Status;
//import com.example.ssafy.petcong.user.model.record.UserRecord;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//
//import jakarta.transaction.Transactional;
//
//import lombok.extern.slf4j.Slf4j;
//
//import org.junit.jupiter.api.Disabled;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.params.ParameterizedTest;
//import org.junit.jupiter.params.provider.Arguments;
//import org.junit.jupiter.params.provider.MethodSource;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.http.HttpMethod;
//import org.springframework.http.MediaType;
//import org.springframework.mock.web.MockMultipartFile;
//import org.springframework.test.web.servlet.MockMvc;
//import org.springframework.test.web.servlet.MvcResult;
//import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
//
//import java.io.*;
//import java.nio.charset.StandardCharsets;
//import java.time.LocalDate;
//import java.util.stream.Stream;
//
//@Slf4j
//@SpringBootTest
//@AutoConfigureMockMvc
//public class ApiIntegrationTest {
//    @Autowired
//    private ObjectMapper objectMapper;
//    @Autowired
//    private MockMvc mockMvc;
//
//    static Stream<Arguments> provideDummySignUpUser() {
//        UserRecord userRecord = new UserRecord(
//                1,
//                1,
//                false,
//                "nickname",
//                "smy@petcong.com",
//                "Korea",
//                "nope",
//                "1",
//                LocalDate.of(1997, 1, 29),
//                Gender.MALE,
//                Status.ACTIVE,
//                Preference.FEMALE);
//        return Stream.of(Arguments.of(userRecord));
//    }
//
//    @Disabled
//    @ParameterizedTest
//    @MethodSource("provideDummySignUpUser")
//    @Transactional
//    @DisplayName("SignUp Test")
//    void testSignUp(UserRecord userRecord) throws Exception {
//        //given
//        String userRecordJson = objectMapper.writeValueAsString(userRecord);
//
//        //when
//        var request = MockMvcRequestBuilders
//                .post("/users/signup")
//                .header("tester", "A603")
//                .content(userRecordJson)
//                .contentType(MediaType.APPLICATION_JSON);
//
//        //then
//        MvcResult mvcResult = mockMvc
//                .perform(request)
//                .andExpect(status().isOk())
//                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
//                .andReturn();
//
//        String response = mvcResult.getResponse().getContentAsString();
//
//        assertThat(response).isNotNull();
//
//        log.info(response);
//    }
//
//    @Disabled
//    @Test
//    @Transactional
//    @DisplayName("Signin Test")
//    void testSignin() throws Exception {
//        //given
//        int uid = 1;
//
//        //when
//        var request = MockMvcRequestBuilders
//                .post("/users/signin")
//                .header("tester", "A603")
//                .content(String.valueOf(uid))
//                .contentType(MediaType.APPLICATION_FORM_URLENCODED);
//
//        //then
//        MvcResult mvcResult = mockMvc
//                .perform(request)
//                .andExpect(status().isOk())
//                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
//                .andReturn();
//
//        String response = mvcResult.getResponse().getContentAsString();
//
//        assertThat(response).isNotNull();
//
//        log.info(response);
//    }
//
//    @Disabled
//    @Test
//    @DisplayName("PostProfileImage Test")
//    void testPostProfileImage() throws Exception {
//        //given
//        FileInputStream fileInputStream = new FileInputStream("C:\\Users\\SSAFY\\Downloads\\anya.jpg");
//        byte[] bytes = fileInputStream.readAllBytes();
//        MockMultipartFile multipartFile = new MockMultipartFile(
//                "file",
//                "anya.jpg",
//                MediaType.MULTIPART_FORM_DATA_VALUE,
//                bytes);
//
//        //when
//        var request = MockMvcRequestBuilders
//                .multipart(HttpMethod.POST, "/users/picture")
//                .file(multipartFile)
//                .header("tester", "A603")
//                .content("1")
//                .contentType(MediaType.APPLICATION_FORM_URLENCODED);
//
//        //then
//        MvcResult mvcResult = mockMvc
//                .perform(request)
//                .andExpect(status().isOk())
//                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
//                .andReturn();
//
//        String response = mvcResult.getResponse().getContentAsString();
//
//        assertThat(response).isNotNull();
//
//        log.info(response);
//    }
//
//    @Disabled
//    @Test
//    @DisplayName("PostDogTrick Test")
//    void testPostDogTrick() throws Exception {
//        //given
//        FileInputStream fileInputStream = new FileInputStream("C:\\Users\\SSAFY\\Downloads\\video_sample.mp4");
//        byte[] bytes = fileInputStream.readAllBytes();
//        MockMultipartFile multipartFile = new MockMultipartFile(
//                "file",
//                "video_sample.mp4",
//                MediaType.MULTIPART_FORM_DATA_VALUE,
//                bytes);
//
//        //when
//        var request = MockMvcRequestBuilders
//                .multipart(HttpMethod.POST, "/users/trick")
//                .file(multipartFile)
//                .header("tester", "A603")
//                .content("1")
//                .contentType(MediaType.APPLICATION_FORM_URLENCODED);
//
//        //then
//        MvcResult mvcResult = mockMvc
//                .perform(request)
//                .andExpect(status().isOk())
//                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
//                .andReturn();
//
//        String response = mvcResult.getResponse().getContentAsString();
//
//        assertThat(response).isNotNull();
//
//        log.info(response);
//    }
//
//    @Disabled
//    @Test
//    @DisplayName("GetMediaUrl Test")
//    void testGetMediaUrl() throws Exception {
//        //given
//        //String key = "1-anya.jpg";
//        String key = "1-video_sample.mp4";
//
//        //when
//        var request = MockMvcRequestBuilders
//                .get("/users/trick")
//                .header("tester", "A603")
//                .param("key", key);
//
//        //then
//        MvcResult mvcResult = mockMvc
//                .perform(request)
//                .andExpect(status().isOk())
//                .andExpect(content().contentType(new MediaType(MediaType.TEXT_PLAIN, StandardCharsets.UTF_8)))
//                .andReturn();
//
//        String response = mvcResult.getResponse().getContentAsString();
//
//        assertThat(response).isNotNull();
//
//        log.info(response);
//    }
//
//    @Disabled
//    @Test
//    @Transactional
//    @DisplayName("DeleteUser Test")
//    void testDeleteUser() throws Exception {
//        //given
//        int userId = 4;
//
//        //when
//        var request = MockMvcRequestBuilders
//                .delete("/users/withdraw")
//                .header("tester", "A603")
//                .content(String.valueOf(userId));
//
//        //then
//        MvcResult mvcResult = mockMvc
//                .perform(request)
//                .andExpect(status().isOk())
//                .andExpect(content().contentType(new MediaType(MediaType.TEXT_PLAIN, StandardCharsets.UTF_8)))
//                .andReturn();
//
//        String response = mvcResult.getResponse().getContentAsString();
//
//        assertThat(response).isNotNull();
//
//        log.info(response);
//    }
//
//    @Disabled
//    @Test
//    @DisplayName("GetUserInfo Test")
//    void testGetUserInfo() throws Exception {
//        //given
//
//        //when
//        var request = MockMvcRequestBuilders
//                .get("/users/info")
//                .header("tester", "A603");
//
//        //then
//        MvcResult mvcResult = mockMvc
//                .perform(request)
//                .andExpect(status().isOk())
//                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
//                .andReturn();
//
//        String response = mvcResult.getResponse().getContentAsString();
//
//        assertThat(response).isNotNull();
//
//        log.info(response);
//    }
//
//}
