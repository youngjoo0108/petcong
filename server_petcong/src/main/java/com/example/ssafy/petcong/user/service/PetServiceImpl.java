package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.PetInfoDto;
import com.example.ssafy.petcong.user.model.dto.PetRecord;
import com.example.ssafy.petcong.user.model.entity.Pet;
import com.example.ssafy.petcong.user.repository.PetRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class PetServiceImpl implements PetService{
    private final PetRepository petRepository;
    @Override
    @Transactional
    public PetRecord findPetByUserId(int userId) {
        Pet pet = petRepository.findPetByUserId(userId).orElseThrow(() -> new NoSuchElementException(String.valueOf(userId)));

        return new PetRecord(pet);
    }

    @Override
    @Transactional
    public PetRecord save(PetInfoDto petInfoDto, int userId) {
        Pet pet = Pet.fromPetInfoDto(petInfoDto);
        pet.updateUserId(userId);

        Pet savedPet = petRepository.save(pet);
        return new PetRecord(savedPet);
    }
}
