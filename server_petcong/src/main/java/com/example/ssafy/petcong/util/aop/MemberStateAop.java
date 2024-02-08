package com.example.ssafy.petcong.util.aop;

import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.repository.MemberRepository;

import com.example.ssafy.petcong.security.FirebaseUserDetails;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.util.NoSuchElementException;

@Aspect
@Component
public class MemberStateAop {

    private final MemberRepository memberRepository;

    public MemberStateAop(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }

    // MakeCallable 어노테이션을 달지 않는 모든 컨트롤러 메소드 전에 callable = false로 바꾸는 로직 추가
    @Before("execution(* com.example.ssafy.petcong.*.controller.*.*(..)) && !@annotation(com.example.ssafy.petcong.util.annotation.MakeCallable)")
    public void changeToNotCallable() {
        // signup() 시 에러 발생
        // changeCallable(false);
    }


    // MakeCallble을 단 메소드 전에 callable = true로 바꾸는 로직 추가
    @Before("execution(* com.example.ssafy.petcong.*.controller.*.*(..)) && @annotation(com.example.ssafy.petcong.util.annotation.MakeCallable)")
    public void changeToCallable() {
        changeCallable(true);
    }

    private void changeCallable(boolean callable) {
        FirebaseUserDetails userDetails = (FirebaseUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal(); // uid
        String uid = userDetails.getUid();
        Member member = memberRepository.findMemberByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));
        member.updateCallable(callable);
        memberRepository.save(member);
    }
}
