package com.example.ssafy.petcong.matching.controller;

import com.example.ssafy.petcong.matching.model.ChoiceReq;
import com.example.ssafy.petcong.matching.service.MatchingConnectionService;
import com.example.ssafy.petcong.util.annotation.MakeCallable;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/matchings")
public class MatchingController {

    private final MatchingConnectionService matchingConnectionService;

    public MatchingController(MatchingConnectionService matchingConnectionService) {
        this.matchingConnectionService = matchingConnectionService;
    }

    @GetMapping
    public ResponseEntity<?> testFeat() {
        return ResponseEntity
                .ok()
                .build();
    }

    /**
     * @param choiceReq
     * @return 200 & empty body when pending
     * <br> 200 & ws link when matched
     * <br> 400 when matched, rejected
     */
    @MakeCallable
    @PostMapping("/choice")
    public ResponseEntity<?> choice(@RequestBody ChoiceReq choiceReq, HttpServletRequest request) {
        System.out.println("실행은 되냐?");
        String src = request.getHeader("x-forwarded-for");
        String originIp = src != null ? src.split(",")[0] : request.getRemoteAddr();
        int port = request.getRemotePort();

        return ResponseEntity
                .ok(matchingConnectionService.choice(choiceReq, originIp, port));
    }

    @MakeCallable
    @PatchMapping("/callable/{userId}")
    public ResponseEntity<?> onCallEnd(@PathVariable int userId) {
        matchingConnectionService.changeToCallable(userId);
        return ResponseEntity
                .ok()
                .build();
    }
}
