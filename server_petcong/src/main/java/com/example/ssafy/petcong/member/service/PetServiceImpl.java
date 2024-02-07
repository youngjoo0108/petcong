package com.example.ssafy.petcong.member.service;

import com.example.ssafy.petcong.member.model.dto.PetInfoDto;
import com.example.ssafy.petcong.member.model.dto.PetRecord;
import com.example.ssafy.petcong.member.model.entity.Pet;
import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.repository.PetRepository;
import com.example.ssafy.petcong.member.repository.MemberRepository;

import jakarta.transaction.Transactional;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class PetServiceImpl implements PetService{
    private final PetRepository petRepository;
    private final MemberRepository memberRepository;

    @Override
    @Transactional
    public PetRecord findPetByMemberId(int memberId) {
        Pet pet = petRepository.findPetByMember_MemberId(memberId).orElseThrow(() -> new NoSuchElementException(String.valueOf(memberId)));

        return PetRecord.fromPetEntity(pet);
    }

    @Override
    @Transactional
    public PetRecord save(PetInfoDto petInfoDto, int memberId) {
        Member member = memberRepository.findMemberByMemberId(memberId).orElseThrow(() -> new NoSuchElementException(String.valueOf(memberId)));
        Pet pet = Pet.fromPetInfoDto(petInfoDto);
        pet.updateMember(member);

        Pet savedPet = petRepository.save(pet);
        return PetRecord.fromPetEntity(savedPet);
    }
}
