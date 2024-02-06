package com.example.ssafy.petcong.member.repository;

import com.example.ssafy.petcong.member.model.entity.Pet;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PetRepository extends JpaRepository<Pet, Integer> {
    Optional<Pet> findPetByMember_MemberId(int memberId);
    Pet save(Pet pet);
}
