//package com.example.ssafy.petcong.user.controller;
//
//import static org.assertj.core.api.Assertions.assertThat;
//
//import lombok.extern.slf4j.Slf4j;
//
//import org.hamcrest.CoreMatchers;
//
//import org.junit.jupiter.api.Disabled;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.http.MediaType;
//import org.springframework.test.web.servlet.MockMvc;
//import org.springframework.test.web.servlet.MvcResult;
//import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
//import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
//
//@Slf4j
//@SpringBootTest
//@AutoConfigureMockMvc
//public class UserControllerTest {
//    @Autowired
//    private MockMvc mockMvc;
//    @Test
//    @DisplayName("SignUp Test")
//    void testSignUp() throws Exception {
//        var request = MockMvcRequestBuilders
//                .post("/users/signup")
//                .param("gmail", "your email")
//                .contentType(MediaType.APPLICATION_JSON);
//
//        MvcResult mvcResult = mockMvc
//                .perform(request)
//                .andExpect(MockMvcResultMatchers.status().isOk())
//                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
//                .andReturn();
//
//        String response = mvcResult.getResponse().getContentAsString();
//
//        assertThat(response).isNotNull();
//
//        log.info(response);
//    }
//    @Test
//    @DisplayName("SignIn Test")
//    @Disabled
//    void testSignIn() throws Exception {
//        String UID = "";
//
//        var request = MockMvcRequestBuilders
//                .post("/users/signin")
//                .content("this is test token")
//                .contentType(MediaType.APPLICATION_JSON);
//
//        MvcResult mvcResult = mockMvc
//                .perform(request)
//                .andExpect(MockMvcResultMatchers.status().isOk())
//                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.uid", CoreMatchers.is(UID)))
//                .andReturn();
//
//        String response = mvcResult.getResponse().getContentAsString();
//
//        assertThat(response).isNotNull();
//
//        log.info(response);
//    }
//}
