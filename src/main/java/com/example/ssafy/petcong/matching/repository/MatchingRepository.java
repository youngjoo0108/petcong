package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.entity.Matching;
import com.example.ssafy.petcong.matching.model.ChoiceReq;
import com.example.ssafy.petcong.user.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MatchingRepository extends JpaRepository<Matching, Integer>, MatchingRepositorySupport {
    @Query("select m from matchings m where m.fromUser.userId = :fromUserId and m.callStatus='pending'")
    List<Matching> findByFromUserId(@Param("fromUserId") int userId);

    @Query("select m from matchings m where m.fromUser.userId = :fromUserId and m.toUser.userId = :toUserId")
    Matching findByUsersId(@Param("fromUserId") int fromUserId, @Param("toUserId") int toUserId);

//    @Override
//    <S extends Matching> S save(S entity);
    Matching save(Matching matching);

    Matching findByFromUserAndToUser(User fromUsers, User toUsers);
}
