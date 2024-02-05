//package com.example.ssafy.petcong.matching.controller;
//
//import lombok.extern.slf4j.Slf4j;
//import org.junit.jupiter.api.Disabled;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.http.MediaType;
//import org.springframework.test.web.servlet.MockMvc;
//import org.springframework.test.web.servlet.MvcResult;
//import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
//
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
//
//@Slf4j
//@SpringBootTest
//@AutoConfigureMockMvc
//public class ControllerUserUidTest {
//    @Autowired
//    private MockMvc mockMvc;
//
//    @Test
//    @Disabled
//    @DisplayName("Authentication Principal Test")
//    void apTest() throws Exception {
//        String uid = "this-is-test-uid";
//        var request = MockMvcRequestBuilders.get("/matchings/profile")
//                .header("tester", "A603")
//                .content(uid)
//                .contentType(MediaType.APPLICATION_FORM_URLENCODED);
//
//        MvcResult mvcResult = mockMvc
//                .perform(request)
//                .andExpect(status().is2xxSuccessful())
//                .andReturn();
//
//    }
//}