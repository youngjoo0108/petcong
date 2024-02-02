package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.PetInfoDto;
import com.example.ssafy.petcong.user.model.dto.PetRecord;
import com.example.ssafy.petcong.user.model.entity.Pet;
import com.example.ssafy.petcong.user.repository.PetRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class PetServiceImpl implements PetService{
    private final PetRepository petRepository;
    @Override
    public PetRecord findPetByUid(String uid) {
        Pet pet = petRepository.findPetByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));
        return new PetRecord(pet);
    }

    @Override
    public PetRecord save(PetInfoDto petInfoDto) {
        Pet pet = Pet.fromPetInfoDto(petInfoDto);
        Pet savedPet = petRepository.save(pet);
        return new PetRecord(savedPet);
    }
}
