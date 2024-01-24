package com.ssafy.api.service;

import com.google.firebase.auth.FirebaseAuthException;
import com.ssafy.api.request.UserRegisterPostReq;
import com.ssafy.db.entity.User;

/**
 *	유저 관련 비즈니스 로직 처리를 위한 서비스 인터페이스 정의.
 */
public interface UserService {
	User createUser(UserRegisterPostReq userRegisterInfo);
	User getUserByUserId(String userId);
	void modifyUser(User user);
	void login(String accessToken) throws FirebaseAuthException;
}