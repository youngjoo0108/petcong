package com.example.ssafy.petcong.security;

import com.example.ssafy.petcong.user.model.dto.UserRecord;
import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Slf4j
@Service("firebaseUserDetailService")
@RequiredArgsConstructor
public class FirebaseUserDetailService implements UserDetailsService {
    private final UserRepository userRepository;
    @Override
    public UserDetails loadUserByUsername(String uid) throws UsernameNotFoundException {
        User user = userRepository.findUserByUid(uid).orElseThrow(() -> new UsernameNotFoundException(uid));
        UserRecord userRecord = new UserRecord(user);
        String presentedUid = userRecord.uid();
        String presentedUserId = String.valueOf(userRecord.userId());
        boolean presentedStatus = userRecord.status().isStatus();
        return new FirebaseUserDetails(presentedUid, presentedUserId, presentedStatus);
    }
}
