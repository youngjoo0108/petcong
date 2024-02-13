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
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.stream.Stream;

@Slf4j
@Transactional
@SpringBootTest
@AutoConfigureMockMvc
@Disabled
public class MemberIntegrationTest {
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private MockMvc mockMvc;

    private static final int SIZE = 100;

    private static final String[] hobbies = {
            "산책", "원반던지기", "수영", "뒹굴기", "아무것도 안하기", "개껌 씹기"
    };

    private static final String[] kinds = {
            "골든 리트리버", "치와와", "도베르만", "진돗개", "시츄", "삽살개", "닥스훈트", "보더콜리", "허스키", "셰퍼드"
    };

    private static final String[] names = {
            "뽀삐",
            "멍멍이",
            "야옹이",
            "멈뭄미",
            "초코",
            "보리",
            "엘살바도르",
            "제우스",
            "토르",
            "라미엘",
            "울라리",
            "제라드",
            "훔바훔바",
            "우유",
            "개호주",
            "페리시치",
            "손흥민",
            "김민재",
            "이강인",
            "메시",
            "호날두",
            "즐라탄",
            "페이커",
            "구마유시",
            "대상혁",
            "아르키메데스",
            "플라톤",
            "니체",
            "루돌프",
            "이소룡",
            "딸기",
            "아기",
            "묠니르",
            "티모",
            "오딘",
            "알아키르",
            "피즈",
            "럼블",
            "호랑이",
            "늑대",
            "사자",
            "재규어",
            "치타",
            "표범"
    };

    private static final PetSize[] sizes = {
            PetSize.SMALL, PetSize.MEDIUM, PetSize.LARGE
    };

    private static final String[] toys = {
            "개껌", "원반", "쥐방울", "공", "포인터"
    };

    private static final String[] descriptions = {
            "저희 개는 안물어요",
            "개팔자가 상팔자",
            "세상에 나쁜 개는 없다",
            "산책 안가면 죽는 병에 걸림",
            "개를 위한 나라는 없다",
            "바르개 살자",
            "빠지는 털로 목도리를 짤 수 있습니다",
            "배를 만져주면 좋아합니다",
            "혼낼 때 세상 억울한 표정 지음",
            "개들을 풀어라"
    };

    private static final String[] snacks = {
            "생닭",
            "참치캔",
            "스팸",
            "닭가슴살",
            "츄르",
            "오리목뼈",
            "족발",
            "소세지",
            "수육",
            "스테이크",
            "토마호크",
            "케비아",
            "사과",
            "바나나",
            "고구마",
            "육포",
            "먹태",
            "햄"
    };

    private static final String[] maleMemberIds = {
            "55",
            "56",
            "61",
            "62",
            "63",
            "64",
            "68",
            "70",
            "76",
            "77"
    };

    private static final String[] maleUids = {
            "1688243545",
            "1725438773",
            "1914170172",
            "1357726327",
            "1317023809",
            "1042723726",
            "1406943403",
            "1703118096",
            "1013166148",
            "1571038721"
    };

    private static final String[] femaleMemberIds = {
            "57",
            "58",
            "59",
            "60",
            "65",
            "66",
            "67",
            "69",
            "71",
            "72"
    };

    private static final String[] femaleUids = {
            "1921871951",
            "1346315578",
            "1688037785",
            "1449846434",
            "1424076814",
            "1819550433",
            "1138967991",
            "1845507684",
            "1085276906",
            "1638320385"
    };

    static Stream<Arguments> provideDummySignUpMember() {
        List<SignupRequestDto> signupRequestDtos = new ArrayList<>();
        for (int i = 0; i < SIZE; i++) {
            SignupMemberInfoDto signupMemberInfoDto = new SignupMemberInfoDto();
            signupMemberInfoDto.setAge(new Random().nextInt(20, 31));
            signupMemberInfoDto.setNickname("닉네임" + new Random().nextInt(0, Integer.MAX_VALUE));
            signupMemberInfoDto.setEmail("test" + new Random().nextInt(0, 10_000) +"@petcong.com");
            signupMemberInfoDto.setAddress("서울시 강남구");
            signupMemberInfoDto.setInstagramId("insta_" + new Random().nextInt(0, Integer.MAX_VALUE));
            signupMemberInfoDto.setKakaoId("kakako_" + new Random().nextInt(0, Integer.MAX_VALUE));
            signupMemberInfoDto.setBirthday(LocalDate.of(new Random().nextInt(1990, 2000), new Random().nextInt(1, 12), new Random().nextInt(1, 29)));
            signupMemberInfoDto.setGender(new Random().nextBoolean() ? Gender.MALE : Gender.FEMALE);
            signupMemberInfoDto.setPreference(new Random().nextBoolean() ? Preference.MALE : Preference.FEMALE);

            PetInfoDto petInfoDto = new PetInfoDto();
            petInfoDto.setAge(new Random().nextInt(1, 20));
            petInfoDto.setGender(new Random().nextBoolean() ? Gender.MALE : Gender.FEMALE);
            petInfoDto.setDbti((new Random().nextBoolean() ? "E" : "I") +
                    (new Random().nextBoolean() ? "N" : "S") +
                    (new Random().nextBoolean() ? "F" : "T") +
                    (new Random().nextBoolean() ? "P" : "J"));
            petInfoDto.setHobby(hobbies[new Random().nextInt(hobbies.length)]);
            petInfoDto.setBreed(kinds[new Random().nextInt(kinds.length)]);
            petInfoDto.setName(names[new Random().nextInt(names.length)]);
            petInfoDto.setSize(sizes[new Random().nextInt(sizes.length)]);
            petInfoDto.setToy(toys[new Random().nextInt(toys.length)]);
            petInfoDto.setDescription(descriptions[new Random().nextInt(descriptions.length)]);
            petInfoDto.setNeutered(new Random().nextBoolean());
            petInfoDto.setWeight(new Random().nextInt(9, 20));
            petInfoDto.setSnack(snacks[new Random().nextInt(snacks.length)]);

            signupRequestDtos.add(new SignupRequestDto(signupMemberInfoDto, petInfoDto));
        }

        return Stream.of(Arguments.of(signupRequestDtos));
    }

    @ParameterizedTest
    @MethodSource("provideDummySignUpMember")
    @DisplayName("SignUp Test")
    void testSignUp(List<SignupRequestDto> signupRequestDtos) throws Exception {
        for (SignupRequestDto signupRequestDto : signupRequestDtos) {
            //given
            String memberRecordJson = objectMapper.writeValueAsString(signupRequestDto);

            //when
            var request = MockMvcRequestBuilders
                    .post("/members/signup")
                    .content(memberRecordJson)
                    .param("uid", String.valueOf(new Random().nextInt(1_000_000_000, 2_000_000_001)))
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
        for (int i = 1; i <= 10; i++) {
            String memberId = maleMemberIds[i - 1];
            String uid = maleUids[i - 1];

            try(FileInputStream fileInputStream = new FileInputStream("C:\\Users\\SSAFY\\Downloads\\male\\" + i + ".jpg")) {
                //given
                byte[] bytes = fileInputStream.readAllBytes();
                MockMultipartFile multipartFile = new MockMultipartFile(
                        "files",
                        i + ".jpg",
                        MediaType.MULTIPART_FORM_DATA_VALUE,
                        bytes);

                //when
                var request = MockMvcRequestBuilders
                        .multipart(HttpMethod.POST, "/members/picture")
                        .file(multipartFile)
                        .param("memberId", memberId)
                        .param("uid", uid)
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
