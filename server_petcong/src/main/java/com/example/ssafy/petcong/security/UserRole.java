package com.example.ssafy.petcong.security;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum UserRole {
    ANONYMOUS("4", "SA7q9H4r0WfIkvdah6OSIW7Y6XQ2", true),
    UNAUTHENTICATED("-1", "UNAUTH", false);

    private final String memberId;
    private final String uid;
    private final boolean status;
}
