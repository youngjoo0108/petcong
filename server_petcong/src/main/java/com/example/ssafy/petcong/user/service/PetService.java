package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.PetInfoDto;
import com.example.ssafy.petcong.user.model.dto.PetRecord;

public interface PetService {
    PetRecord findPetByUid(String uid);
    PetRecord save(PetInfoDto petInfoDto);
}
