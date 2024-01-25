//package com.example.ssafy.petcong.exception;
//
//import lombok.extern.slf4j.Slf4j;
//
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.MethodArgumentNotValidException;
//import org.springframework.web.bind.annotation.ExceptionHandler;
//import org.springframework.web.bind.annotation.RestControllerAdvice;
//import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;
//
//@Slf4j
//@RestControllerAdvice
//public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {
//    @ExceptionHandler(MethodArgumentNotValidException.class)
//    public ResponseEntity<String> handleMethodArgumentNotValidException(MethodArgumentNotValidException methodArgumentNotValidException) {
//        log.warn(methodArgumentNotValidException.getMessage());
//        return ResponseEntity
//                .status(HttpStatus.BAD_REQUEST)
//                .body(methodArgumentNotValidException.getMessage());
//    }
//}
