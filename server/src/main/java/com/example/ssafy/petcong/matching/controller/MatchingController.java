package com.example.ssafy.petcong.matching.controller;

import com.example.ssafy.petcong.matching.model.ChoiceReq;
import com.example.ssafy.petcong.matching.service.MatchingConnectionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/matchings")
public class MatchingController {

    private final MatchingConnectionService matchingConnectionService;

    public MatchingController(MatchingConnectionService matchingConnectionService) {
        this.matchingConnectionService = matchingConnectionService;
    }

    /**
     * @param choiceReq
     * @return 200 & body x when pending
     * <br> 200 & ws link when matched
     * <br> 400 when matched, rejected
     */
    @PostMapping("/choice")
    public ResponseEntity<?> choice(@RequestBody ChoiceReq choiceReq) {
        return ResponseEntity
                .ok(matchingConnectionService.choice(choiceReq));
    }

    @PatchMapping("/callable/{userId}")
    public ResponseEntity<?> onCallEnd(@PathVariable int userId) {
        matchingConnectionService.changeToCallable(userId);
        return ResponseEntity
                .ok()
                .build();
    }
}
