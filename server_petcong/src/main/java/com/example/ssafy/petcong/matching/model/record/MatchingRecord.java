package com.example.ssafy.petcong.matching.model.record;

import com.example.ssafy.petcong.matching.model.CallStatus;
import jakarta.validation.constraints.NotNull;

public record MatchingRecord(
        @NotNull
        int matchingId,

        @NotNull
        int fromUserId,

        @NotNull
        int toUserId,

        CallStatus callStatus
) {
}
