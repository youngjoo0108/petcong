package com.example.ssafy.petcong.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class MatchingControllerAdvice {

    @ExceptionHandler({RuntimeException.class})
    public ResponseEntity<?> runtimeExceptionHandler(RuntimeException e) {
        return ResponseEntity
                .badRequest()
                .body(e.getMessage());
    }
}
