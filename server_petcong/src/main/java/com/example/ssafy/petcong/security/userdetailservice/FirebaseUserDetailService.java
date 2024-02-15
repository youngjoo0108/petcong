package com.example.ssafy.petcong.security.userdetailservice;

import com.example.ssafy.petcong.member.model.dto.MemberRecord;
import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.model.enums.Status;
import com.example.ssafy.petcong.member.repository.MemberRepository;

import com.example.ssafy.petcong.security.userdetails.FirebaseUserDetails;
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
    private final MemberRepository memberRepository;
    @Override
    public UserDetails loadUserByUsername(String uid) throws UsernameNotFoundException {
        Member member = memberRepository.findMemberByUidAndStatus(uid, Status.ACTIVE).orElseThrow(() -> new UsernameNotFoundException(uid));
        MemberRecord memberRecord = MemberRecord.fromMemberEntity(member);
        String presentedUid = memberRecord.uid();
        String presentedMemberId = String.valueOf(memberRecord.memberId());
        boolean presentedStatus = memberRecord.status().isStatus();
        return new FirebaseUserDetails(presentedUid, presentedMemberId, presentedStatus);
    }
}
