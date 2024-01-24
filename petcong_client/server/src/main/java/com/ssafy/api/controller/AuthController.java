package com.ssafy.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.api.response.UserLoginPostRes;
import com.ssafy.api.service.UserService;
import com.ssafy.common.model.response.BaseResponseBody;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.ApiResponse;

import javax.servlet.http.HttpServletRequest;

/**
 * 인증 관련 API 요청 처리를 위한 컨트롤러 정의.
 */
@Api(value = "인증 API", tags = {"Auth."})
@RestController
@RequestMapping("/auth")
public class AuthController {
	private final UserService userService;

	public AuthController(UserService userService) {
		this.userService = userService;
	}

	@PostMapping("/login")
	@ApiOperation(value = "로그인", notes = "<strong>아이디와 패스워드</strong>를 통해 로그인 한다.")
    @ApiResponses({
        @ApiResponse(code = 200, message = "success"),
        @ApiResponse(code = 401, message = "invalid token", response = ResponseEntity.class),
        @ApiResponse(code = 500, message = "서버 오류", response = ResponseEntity.class)
    })
	public ResponseEntity<?> login(HttpServletRequest request) {
		try {
			String accessToken = request.getHeader("Authorization");
			userService.login(accessToken);
		} catch (Exception e) { // 토큰이 없는 경우도 포함됨
			return ResponseEntity.status(401).body("invalid token");
		}
		return ResponseEntity.status(200).build();
	}
}
