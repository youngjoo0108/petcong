package com.example.ssafy.petcong.matching.controller;

import com.example.ssafy.petcong.matching.model.CallStatus;
import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.repository.MatchingRepository;
import com.example.ssafy.petcong.user.repository.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
class MatchingControllerTest {

    MatchingRepository matchingRepository;
    UserRepository userRepository;
    MockMvc mockMvc;

    public MatchingControllerTest(MatchingRepository matchingRepository, UserRepository userRepository, MockMvc mockMvc) {
        this.matchingRepository = matchingRepository;
        this.userRepository = userRepository;
        this.mockMvc = mockMvc;
    }

    /*
        choice
    */
    // 1. 정상 요청 - pending
    @Test
    @DisplayName("choice / 정상 / pending처리")
    void choice_pending() throws Exception {
        int fromUserId = 1;
        int toUserId = 2;
        MockHttpServletRequestBuilder request = MockMvcRequestBuilders
                .post("/matchings/choice")
                .param("requestUserId", String.valueOf(fromUserId))
                .param("partnerUserId", String.valueOf(toUserId))
                .contentType(MediaType.APPLICATION_JSON);

        // 응답 상태코드 체크
        MvcResult result = mockMvc.perform(request)
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andReturn();
        // 응답값 체크
        String resultMsg = result.getResponse().getContentAsString();

        assertThat(resultMsg.isBlank()).isTrue();

        // DB 입력 체크
        Matching matching = matchingRepository.findByUsersId(fromUserId, toUserId);
        assertThat(matching.getCallStatus()).isEqualTo(CallStatus.pending);
    }

    // 2. 정상 요청 - matched

    // 3. 비정상 요청 - rejected

    // 4. 비정상 요청 - 이미 matched

    // 5. 비정상 요청 - from me to me

    // 6. 비정상 요청 - toUserId == null

    /*
    onCallEnd
     */

}