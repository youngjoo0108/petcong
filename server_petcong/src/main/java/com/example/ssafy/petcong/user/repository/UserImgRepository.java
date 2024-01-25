package com.example.ssafy.petcong.user.repository;

import com.example.ssafy.petcong.user.model.entity.UserImg;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserImgRepository extends JpaRepository<UserImg, Integer> {
    UserImg save(UserImg userImg);
}
