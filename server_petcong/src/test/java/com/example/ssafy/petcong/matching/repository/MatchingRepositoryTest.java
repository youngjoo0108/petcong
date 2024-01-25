package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.enums.Gender;
import com.example.ssafy.petcong.user.model.enums.Preference;
import com.example.ssafy.petcong.user.model.enums.Status;
import com.example.ssafy.petcong.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.util.Calendar;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
public class MatchingRepositoryTest {
    @Autowired
    MatchingRepository matchingRepository;

    @Autowired
    UserRepository userRepository;

    private Matching matching1;
    private Matching matching2;

    private User user1, user2, user3, user4;


    @BeforeEach
    public void setupTestData() {
        Calendar calendar1 = Calendar.getInstance();
        calendar1.set(1990, Calendar.JANUARY, 1);
        user1 = User.builder()
                .userId(1)
                .age(25)
                .callable(true)
                .nickname("JohnDoe")
                .email("john.doe@example.com")
                .address("123 Main St, City")
                .socialUrl("https://www.facebook.com/johndoe")
                .uid("abcd1234")
                .gender(Gender.MALE)
                .status(Status.ACTIVE)
                .preference(Preference.BOTH)
                .build();

        Calendar calendar2 = Calendar.getInstance();
        calendar2.set(1995, Calendar.MARCH, 15);
        user2 = User.builder()
                .userId(2)
                .age(30)
                .callable(false)
                .nickname("AliceSmith")
                .email("alice.smith@example.com")
                .address("456 Oak St, Town")
                .socialUrl("https://www.twitter.com/alicesmith")
                .gender(Gender.FEMALE)
                .status(Status.ACTIVE)
                .preference(Preference.BOTH)
                .build();

        Calendar calendar3 = Calendar.getInstance();
        calendar3.set(1993, Calendar.JULY, 10);
        user3 = User.builder()
                .userId(3)
                .age(28)
                .callable(true)
                .nickname("BobJohnson")
                .email("bob.johnson@example.com")
                .address("789 Pine St, Village")
                .socialUrl("https://www.instagram.com/bobjohnson")
                .uid("ijkl9012")
                .gender(Gender.MALE)
                .status(Status.ACTIVE)
                .preference(Preference.BOTH)
                .build();

        Calendar calendar4 = Calendar.getInstance();
        calendar4.set(2000, Calendar.FEBRUARY, 20);
        user4 = User.builder()
                .userId(4)
                .age(22)
                .callable(false)
                .nickname("EveWilliams")
                .email("eve.williams@example.com")
                .address("101 Cedar St, Hamlet")
                .socialUrl("https://www.linkedin.com/evewilliams")
                .uid("mnop3456")
                .gender(Gender.FEMALE)
                .status(Status.ACTIVE)
                .preference(Preference.BOTH)
                .build();

        matching1 = new Matching(user1, user2);
        matching2 = new Matching(user3, user4);

    }

    @Test
    @DisplayName("JUnit test for save matching operation")
    public void givenMatchingObject_whenSave_thenReturnSaveMatching() {

        userRepository.save(user1);
        userRepository.save(user2);
        userRepository.save(user3);
        userRepository.save(user4);

        matchingRepository.save(matching1);
        matchingRepository.save(matching2);

        Matching getMatching = matchingRepository.findByFromUserAndToUser(user1, user2);
        Matching getMatching2 = matchingRepository.findByFromUserAndToUser(user3, user4);

        assertThat(getMatching).isNotNull();
        assertThat(getMatching2).isNotNull();
    }


}
