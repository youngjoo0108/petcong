package com.example.ssafy.petcong.member.model.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum Status {
    ACTIVE(true), DELETED(false);

    private final boolean status;
}
