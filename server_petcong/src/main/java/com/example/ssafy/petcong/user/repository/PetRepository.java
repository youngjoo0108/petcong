package com.example.ssafy.petcong.user.repository;

import com.example.ssafy.petcong.user.model.entity.Pet;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PetRepository extends JpaRepository<Pet, Integer> {
    Optional<Pet> findPetByUser_UserId(int userId);
    Pet save(Pet pet);
}
