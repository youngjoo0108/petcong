package com.example.ssafy.petcong.matching.model.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.bind.annotation.GetMapping;

@Getter
@Setter
@NoArgsConstructor
public class ChoiceReq {
    private String partnerUid;
}
