package com.example.ssafy.petcong.Integration;

import static org.assertj.core.api.Assertions.assertThat;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;

import com.example.ssafy.petcong.security.UserRole;

import jakarta.transaction.Transactional;

import lombok.extern.slf4j.Slf4j;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import java.nio.charset.StandardCharsets;

@Slf4j
@Transactional
@SpringBootTest
@AutoConfigureMockMvc
public class MatchingIntegrationTest {
    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("MatchingList Test")
    void testMatchingList() throws Exception {
        //given
        String uid = UserRole.ANONYMOUS.getUid();

        //when
        var request = MockMvcRequestBuilders
                .get("/matchings/list")
                .header("tester", "A603");

        //then
        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andReturn();

        String response = mvcResult.getResponse().getContentAsString(StandardCharsets.UTF_8);

        assertThat(response).isNotNull();

        log.info("MatchingList Test: " + response);
    }

}
