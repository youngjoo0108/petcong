package com.example.ssafy.petcong.member.service;

import com.example.ssafy.petcong.member.model.dto.PetInfoDto;
import com.example.ssafy.petcong.member.model.dto.PetRecord;

public interface PetService {
    PetRecord findPetByMemberId(int memberId);
    PetRecord save(PetInfoDto petInfoDt, int memberId);
}
