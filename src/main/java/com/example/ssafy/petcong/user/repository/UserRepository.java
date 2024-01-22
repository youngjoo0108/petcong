package com.example.ssafy.petcong.user.repository;

import com.example.ssafy.petcong.user.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    User save(User user);
    User findById(int id);
}
