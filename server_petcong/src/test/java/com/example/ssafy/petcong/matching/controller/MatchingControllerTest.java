//package com.example.ssafy.petcong.matching.controller;
//
//import com.example.ssafy.petcong.matching.model.CallStatus;
//import com.example.ssafy.petcong.matching.model.ChoiceReq;
//import com.example.ssafy.petcong.matching.model.entity.Matching;
//import com.example.ssafy.petcong.matching.repository.MatchingRepository;
//import com.example.ssafy.petcong.user.repository.UserRepository;
//import com.fasterxml.jackson.databind.ObjectMapper;
////import org.checkerframework.checker.units.qual.C;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
//import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
//import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.http.MediaType;
//import org.springframework.test.web.servlet.MockMvc;
//import org.springframework.test.web.servlet.MvcResult;
//import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
//import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
//import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
//import org.springframework.transaction.annotation.Transactional;
//
//import static org.assertj.core.api.Assertions.assertThat;
//
//@SpringBootTest
//@AutoConfigureMockMvc
////@DataJpaTest
////@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
//class MatchingControllerTest {
//
//    MatchingRepository matchingRepository;
//    UserRepository userRepository;
//    MockMvc mockMvc;
//
//    ObjectMapper objectMapper;
//
//    @Autowired
//    public MatchingControllerTest(MatchingRepository matchingRepository, UserRepository userRepository, MockMvc mockMvc, ObjectMapper objectMapper) {
//        this.matchingRepository = matchingRepository;
//        this.userRepository = userRepository;
//        this.mockMvc = mockMvc;
//        this.objectMapper = objectMapper;
//    }
//
//
//    /*
//        choice
//    */
//    // 1. 정상 요청 - pending
//    @Test
//    @DisplayName("choice / 정상 / pending처리")
//    @Transactional
//    void choice_pending() throws Exception {
//        int fromUserId = 1;
//        int toUserId = 2;
//        ChoiceReq choiceReq = new ChoiceReq(fromUserId, toUserId);
//
//        MockHttpServletRequestBuilder request = MockMvcRequestBuilders
//                .post("/matchings/choice")
//                .content(objectMapper.writeValueAsString(choiceReq))
//                .contentType(MediaType.APPLICATION_JSON);
//
//        // 응답 상태코드 체크
//        MvcResult result = mockMvc.perform(request)
//                .andExpect(MockMvcResultMatchers.status().isOk())
//                .andReturn();
//        // 응답값 체크
//        String resultMsg = result.getResponse().getContentAsString();
//
//        assertThat(resultMsg.isBlank()).isTrue();
//
//        // DB 입력 체크
//        Matching matching = matchingRepository.findByUsersId(fromUserId, toUserId);
//        assertThat(matching.getCallStatus()).isEqualTo(CallStatus.PENDING);
//    }
//
//    // 2. 정상 요청 - matched
//    @Test
//    @DisplayName("choice / 정상 / matched")
//    @Transactional
//    void choice_matched() {
//        // make pending
//        Matching matching = matchingRepository.findPendingByFromUserId(1).get(0);
//        matching.setCallStatus(CallStatus.PENDING);
//        matchingRepository.save(matching);
//
//        // do request
//    }
//
//
//    // 3. 비정상 요청 - rejected
//
//    // 4. 비정상 요청 - 이미 matched
//
//    // 5. 비정상 요청 - from me to me
//
//    // 6. 비정상 요청 - toUserId == null
//
//    /*
//    onCallEnd
//     */
//
//}