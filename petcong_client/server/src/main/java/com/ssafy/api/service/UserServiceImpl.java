package com.ssafy.api.service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.ssafy.api.request.UserRegisterPostReq;
import com.ssafy.db.entity.User;
import com.ssafy.db.repository.UserRepository;
import com.ssafy.db.repository.UserRepositorySupport;

import javax.transaction.Transactional;
import java.util.Optional;

/**
 *	유저 관련 비즈니스 로직 처리를 위한 서비스 구현 정의.
 */
@Service("userService")
public class UserServiceImpl implements UserService {
	@Autowired
	UserRepository userRepository;
	
	@Autowired
	UserRepositorySupport userRepositorySupport;
	
	@Autowired
	PasswordEncoder passwordEncoder;

	@Autowired
	FirebaseAuth firebaseAuth;

	@Override
	public void login(String accessToken) throws FirebaseAuthException{
		firebaseAuth.verifyIdToken(accessToken);
	}
	
	@Override
	public User createUser(UserRegisterPostReq userRegisterInfo) {
		User user = new User();
		user.setUserId(userRegisterInfo.getId());
		// 보안을 위해서 유저 패스워드 암호화 하여 디비에 저장.
		user.setPassword(passwordEncoder.encode(userRegisterInfo.getPassword()));
		//
		user.setDepartment(userRegisterInfo.getDepartment());
		user.setName(userRegisterInfo.getName());
		user.setPosition(userRegisterInfo.getPosition());
		return userRepository.save(user);
	}

	@Override
	public User getUserByUserId(String userId) {
		// 디비에 유저 정보 조회 (userId 를 통한 조회).
		Optional<User> optionalUser = userRepositorySupport.findUserByUserId(userId);
		return optionalUser.orElse(null);
	}

	@Override
	@Transactional
	public void modifyUser(User user) {
		userRepositorySupport.modifyUser(user);
	}
}
