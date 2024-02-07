package com.example.ssafy.petcong.user.service;

import com.example.ssafy.petcong.user.model.dto.PetInfoDto;
import com.example.ssafy.petcong.user.model.dto.PetRecord;

public interface PetService {
    PetRecord findPetByUserId(int userId);
    PetRecord save(PetInfoDto petInfoDt, int userId);
}
