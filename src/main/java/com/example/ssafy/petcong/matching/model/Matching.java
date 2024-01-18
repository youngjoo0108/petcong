package com.example.ssafy.petcong.matching.model;

public record Matching(
        int matchingId,
        int fromUserId,
        int toUserId,
        CallStatus callStatus
) {

    public enum CallStatus {
        PENDING, MATCHED, REJECTED
    }
}
