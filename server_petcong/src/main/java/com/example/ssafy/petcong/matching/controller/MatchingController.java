package com.example.ssafy.petcong.matching.controller;

import com.example.ssafy.petcong.matching.model.ChoiceRes;
import com.example.ssafy.petcong.matching.model.entity.ChoiceReq;
import com.example.ssafy.petcong.matching.model.entity.ProfileRecord;
import com.example.ssafy.petcong.matching.service.MatchingRequestService;
import com.example.ssafy.petcong.matching.service.MatchingProfileService;
import com.example.ssafy.petcong.member.service.MemberService;
import com.example.ssafy.petcong.member.model.dto.MemberRecord;
import com.example.ssafy.petcong.security.userdetails.FirebaseUserDetails;
import com.example.ssafy.petcong.util.annotation.MakeCallable;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;

import lombok.RequiredArgsConstructor;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Slf4j
@Tag(name = "matchings", description = "매칭 API")
@RestController
@CrossOrigin("*")
@RequestMapping("/matchings")
@RequiredArgsConstructor
public class MatchingController {

    private final MemberService memberService;
    private final MatchingRequestService matchingRequestService;
    private final MatchingProfileService matchingProfileService;

    @Operation(summary = "매칭 요청", description = "상태에 따라 pending / matched 처리",
            responses = {
                @ApiResponse(responseCode = "200", description = "matched되었을 때, 상대 웹소켓 링크 반환"),
                @ApiResponse(responseCode = "204", description = "pending처리"),
                @ApiResponse(responseCode = "400", description = "이미 matched / rejected 상태 or 잘못된 uid/id")
    })
    @MakeCallable
    @PostMapping("/choice")
    public ResponseEntity<?> choice(@AuthenticationPrincipal(expression = FirebaseUserDetails.UID) String uid,
                                    @RequestBody ChoiceReq choiceReq) {
        ChoiceRes res = matchingRequestService.choice(uid, choiceReq.getPartnerUid());
        if (res != null) {
            return ResponseEntity.ok(res);
        } else {
            return ResponseEntity.noContent().build();
        }
    }

    @MakeCallable
    @GetMapping("/profile")
    public ResponseEntity<ProfileRecord> profile(@AuthenticationPrincipal(expression = FirebaseUserDetails.UID) String uid) {
        Optional<ProfileRecord> optionalProfile = matchingProfileService.profile(uid);
        return optionalProfile.map(profile -> ResponseEntity.ok().body(profile))
                .orElseGet(() -> ResponseEntity.noContent().build());
    }

    @GetMapping("/list")
    public ResponseEntity<?> matchingList(@AuthenticationPrincipal(expression = FirebaseUserDetails.UID) String uid) {
        MemberRecord member = memberService.findMemberByUid(uid);
        int myId = member.memberId();
        List<ProfileRecord> matchings = matchingProfileService.findMatchingList(myId);

        return ResponseEntity
                .ok()
                .body(matchings);
    }
}
