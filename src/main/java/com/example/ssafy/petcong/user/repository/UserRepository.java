package com.example.ssafy.petcong.user.repository;

import com.example.ssafy.petcong.user.model.entity.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<Users, Integer> {

}
