package com.example.ssafy.petcong.security.role;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum UserRole {
    ANONYMOUS("-1", null, false),
    TESTER("4", "SA7q9H4r0WfIkvdah6OSIW7Y6XQ2", true),
    UNAUTHENTICATED("-1", "UNAUTH", false),
    SIGNUP("-1", "SIGNUP", false);

    private final String memberId;
    private final String uid;
    private final boolean status;
}
