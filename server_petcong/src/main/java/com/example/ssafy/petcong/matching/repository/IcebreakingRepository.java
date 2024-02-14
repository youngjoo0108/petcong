package com.example.ssafy.petcong.matching.repository;

import com.example.ssafy.petcong.matching.model.entity.Icebreaking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IcebreakingRepository extends JpaRepository<Icebreaking, Integer> {

    List<Icebreaking> findAll();
}
