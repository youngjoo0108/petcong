package com.example.ssafy.petcong.util.aop;

import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.repository.UserRepository;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
//import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class UserStateAop {

    private final UserRepository userRepository;

    public UserStateAop(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // MakeCallable 어노테이션을 달지 않는 모든 컨트롤러 메소드 전에 callable = false로 바꾸는 로직 추가
    @Before("execution(* com.example.ssafy.petcong.*.controller.*.*(..)) && !@annotation(com.example.ssafy.petcong.util.annotation.MakeCallable)")
    public void changeToNotCallable() {
        changeCallable(false);
    }


    // MakeCallble을 단 메소드 전에 callable = true로 바꾸는 로직 추가
    @Before("execution(* com.example.ssafy.petcong.*.controller.*.*(..)) && @annotation(com.example.ssafy.petcong.util.annotation.MakeCallable)")
    public void changeToCallable() {
        changeCallable(true);
    }

    private void changeCallable(boolean callable) {
        String uid = SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString(); // uid
        User user = userRepository.findUserByUid(uid);
        if (user != null) {
            user.setCallable(callable);
            userRepository.save(user);
        }
    }
}
