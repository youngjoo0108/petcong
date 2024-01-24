//package com.ssafy.api.controller;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import com.ssafy.api.request.UserRegisterPostReq;
//import com.ssafy.api.service.UserService;
//import com.ssafy.common.model.response.BaseResponseBody;
//import com.ssafy.db.entity.User;
//
//import io.swagger.annotations.Api;
//import io.swagger.annotations.ApiOperation;
//import io.swagger.annotations.ApiParam;
//import io.swagger.annotations.ApiResponse;
//import io.swagger.annotations.ApiResponses;
//
///**
// * 유저 관련 API 요청 처리를 위한 컨트롤러 정의.
// */
//@Api(value = "유저 API", tags = {"User"})
//@RestController
//@RequestMapping("/users")
//public class UserController {
//
//	@Autowired
//	UserService userService;
//
//	@PostMapping()
//	@ApiOperation(value = "회원 가입", notes = "<strong>아이디와 패스워드</strong>를 통해 회원가입 한다.")
//    @ApiResponses({
//        @ApiResponse(code = 200, message = "성공"),
//        @ApiResponse(code = 401, message = "인증 실패"),
//        @ApiResponse(code = 404, message = "사용자 없음"),
//        @ApiResponse(code = 500, message = "서버 오류")
//    })
//	public ResponseEntity<? extends BaseResponseBody> register(
//			@RequestBody @ApiParam(value="회원가입 정보", required = true) UserRegisterPostReq registerInfo) {
//
//		//임의로 리턴된 User 인스턴스. 현재 코드는 회원 가입 성공 여부만 판단하기 때문에 굳이 Insert 된 유저 정보를 응답하지 않음.
//		User user = userService.createUser(registerInfo);
//
//		return ResponseEntity.status(200).body(BaseResponseBody.of(200, "Success"));
//	}
//}
