package com.example.ssafy.petcong.matching.controller;

import com.example.ssafy.petcong.matching.model.ChoiceReq;
import com.example.ssafy.petcong.matching.model.entity.ProfileRecord;
import com.example.ssafy.petcong.matching.service.MatchingRequestService;
import com.example.ssafy.petcong.matching.service.MatchingProfileService;
import com.example.ssafy.petcong.util.annotation.MakeCallable;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@CrossOrigin("*")
@RequestMapping("/matchings")
public class MatchingController {

    private final MatchingRequestService matchingRequestService;
    private final MatchingProfileService matchingProfileService;

    @Autowired
    public MatchingController(MatchingRequestService matchingRequestService, MatchingProfileService matchingProfileService) {        this.matchingRequestService = matchingRequestService;
        this.matchingProfileService = matchingProfileService;
    }

    /**
     * @return 200 & empty body when pending
     * <br> 200 & ws link when matched
     * <br> 400 when matched, rejected
     */
    @MakeCallable
    @PostMapping("/choice")
    public ResponseEntity<?> choice(@AuthenticationPrincipal(expression = "password") String uid,
                                    @RequestBody ChoiceReq choiceReq) {
        return ResponseEntity
                .ok(matchingRequestService.choice(uid, choiceReq.getPartnerUserId()));
    }

    @MakeCallable
    @PatchMapping("/callable/{userId}")
    public ResponseEntity<?> onCallEnd(@PathVariable int userId) {
        matchingRequestService.changeToCallable(userId);
        return ResponseEntity
                .ok()
                .build();
    }

    @MakeCallable
    @GetMapping("/profile")
    public ResponseEntity<ProfileRecord> profile(@AuthenticationPrincipal(expression = "password") String uid) {
        Optional<ProfileRecord> optionalProfile = matchingProfileService.profile(uid);
        return optionalProfile.map(profile -> ResponseEntity.ok().body(profile))
                .orElseGet(() -> ResponseEntity.noContent().build());
    }
}
