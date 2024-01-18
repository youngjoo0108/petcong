package com.example.ssafy.petcong.matching.controller;

import com.example.ssafy.petcong.matching.model.ChoiceReq;
import com.example.ssafy.petcong.matching.service.RtcConnectService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/matchings")
public class MatchingController {

    private final RtcConnectService rtcConnectService;

    public MatchingController(RtcConnectService rtcConnectService) {
        this.rtcConnectService = rtcConnectService;
    }

    @PostMapping("/choice")
    public ResponseEntity<?> choice(@RequestBody ChoiceReq choiceReq) {
        Map<String, String> responseMap = null;

        try {
            responseMap = rtcConnectService.choice(choiceReq.getRequestUserId(), choiceReq.getPartnerUserId());
        } catch (RuntimeException e) {
            return ResponseEntity
                    .badRequest()
                    .build();
        } catch (Exception e) {
            // openvidu 관련 에러
            // 이후 controllerAdvice에 작성할 로직
        }
        return ResponseEntity
                .ok(responseMap); // 매칭됨 -> sessionId, pending됨 -> 200 / 바디 x
    }

    @GetMapping("/call/{sessionId}")
    public ResponseEntity<?> createConnection(@PathVariable(value = "sessionId") String sessionId) {
        Map<String, String> responseMap = null;

        try {
            responseMap = rtcConnectService.call(sessionId);
        } catch (RuntimeException e) {
            return ResponseEntity
                    .badRequest() // invalid token일 때
                    .build();
        } catch (Exception e) {
            // openvidu 관련 에러 -> 이후 ControllerAdvice에 작성
        }
        return ResponseEntity
                .ok(responseMap);
    }
}
