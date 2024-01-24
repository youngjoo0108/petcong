package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.ChoiceReq;
import com.example.ssafy.petcong.matching.model.Matching;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MatchingRepository extends JpaRepository<Matching, Integer>, MatchingRepositorySupport {
    @Query("select m from matchings m where m.fromUser.id = :fromUserId and m.callStatus='pending'")
    List<Matching> findByFromUserId(@Param("fromUserId") int id);

    @Query("select m from matchings m where m.fromUser.id = :fromUserId and m.toUser.id = :toUserId")
    Matching findByUsersId(@Param("fromUserId") int fromUserId, @Param("toUserId") int toUserId);

//    @Override
//    <S extends Matching> S save(S entity);
    Matching save(Matching matching);
}
