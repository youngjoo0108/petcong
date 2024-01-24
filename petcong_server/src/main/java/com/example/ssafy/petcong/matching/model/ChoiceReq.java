package com.example.ssafy.petcong.matching.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ChoiceReq {
    private int requestUserId;
    private int partnerUserId;
    private CallStatus callStatus;
}