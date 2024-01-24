package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.entity.Matchings;
import com.example.ssafy.petcong.user.model.entity.Users;
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

    private Matchings matchings1;
    private Matchings matchings2;

    private Users users1, users2, users3, users4;


    @BeforeEach
    public void setupTestData() {
        Calendar calendar1 = Calendar.getInstance();
        calendar1.set(1990, Calendar.JANUARY, 1);
        users1 = Users.builder()
                .userId(1)
                .age(25)
                .callable(true)
                .nickname("JohnDoe")
                .email("john.doe@example.com")
                .address("123 Main St, City")
                .socialUrl("https://www.facebook.com/johndoe")
                .uid("abcd1234")
                .birthday(calendar1.getTime())
                .gender(Gender.MALE)
                .status(Status.ACTIVE)
                .preference(Preference.BOTH)
                .build();

        Calendar calendar2 = Calendar.getInstance();
        calendar2.set(1995, Calendar.MARCH, 15);
        users2 = Users.builder()
                .userId(2)
                .age(30)
                .callable(false)
                .nickname("AliceSmith")
                .email("alice.smith@example.com")
                .address("456 Oak St, Town")
                .socialUrl("https://www.twitter.com/alicesmith")
                .uid("efgh5678")
                .birthday(calendar2.getTime())
                .gender(Gender.FEMALE)
                .status(Status.ACTIVE)
                .preference(Preference.BOTH)
                .build();

        Calendar calendar3 = Calendar.getInstance();
        calendar3.set(1993, Calendar.JULY, 10);
        users3 = Users.builder()
                .userId(3)
                .age(28)
                .callable(true)
                .nickname("BobJohnson")
                .email("bob.johnson@example.com")
                .address("789 Pine St, Village")
                .socialUrl("https://www.instagram.com/bobjohnson")
                .uid("ijkl9012")
                .birthday(calendar3.getTime())
                .gender(Gender.MALE)
                .status(Status.ACTIVE)
                .preference(Preference.BOTH)
                .build();

        Calendar calendar4 = Calendar.getInstance();
        calendar4.set(2000, Calendar.FEBRUARY, 20);
        users4 = Users.builder()
                .userId(4)
                .age(22)
                .callable(false)
                .nickname("EveWilliams")
                .email("eve.williams@example.com")
                .address("101 Cedar St, Hamlet")
                .socialUrl("https://www.linkedin.com/evewilliams")
                .uid("mnop3456")
                .birthday(calendar4.getTime())
                .gender(Gender.FEMALE)
                .status(Status.ACTIVE)
                .preference(Preference.BOTH)
                .build();

        matchings1 = new Matchings(users1, users2);
        matchings2 = new Matchings(users3, users4);

    }

    @Test
    @DisplayName("JUnit test for save matching operation")
    public void givenMatchingObject_whenSave_thenReturnSaveMatching() {

        userRepository.save(users1);
        userRepository.save(users2);
        userRepository.save(users3);
        userRepository.save(users4);

        matchingRepository.save(matchings1);
        matchingRepository.save(matchings2);

        Matchings getMatchings = matchingRepository.findByFromUsersAndToUsers(users1, users2);
        Matchings getMatchings2 = matchingRepository.findByFromUsersAndToUsers(users3, users4);

        assertThat(getMatchings).isNotNull();
        assertThat(getMatchings2).isNotNull();
    }


}
