package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.PetInfoDto;
import com.example.ssafy.petcong.user.model.dto.PetRecord;
import com.example.ssafy.petcong.user.model.entity.Pet;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.repository.PetRepository;
import com.example.ssafy.petcong.user.repository.UserRepository;

import jakarta.transaction.Transactional;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class PetServiceImpl implements PetService{
    private final PetRepository petRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public PetRecord findPetByUserId(int userId) {
        Pet pet = petRepository.findPetByUser_UserId(userId).orElseThrow(() -> new NoSuchElementException(String.valueOf(userId)));

        return PetRecord.fromPetEntity(pet);
    }

    @Override
    @Transactional
    public PetRecord save(PetInfoDto petInfoDto, int userId) {
        User user = userRepository.findUserByUserId(userId).orElseThrow(() -> new NoSuchElementException(String.valueOf(userId)));
        Pet pet = Pet.fromPetInfoDto(petInfoDto);
        pet.updateUser(user);

        Pet savedPet = petRepository.save(pet);
        return PetRecord.fromPetEntity(savedPet);
    }
}
