package com.example.ssafy.petcong.interceptor;

import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.record.UserRecord;
import com.example.ssafy.petcong.user.repository.UserRepository;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.messaging.simp.stomp.StompCommand.*;

@Component
public class PostWebSocketHandler implements ChannelInterceptor {

    private final UserRepository userRepository;

    public PostWebSocketHandler(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public void postSend(Message<?> message, MessageChannel channel, boolean sent) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        StompCommand command = accessor.getCommand();
        MessageHeaders headers = message.getHeaders();

        // 처리 대상 요청이 아니면 return
        if (!(command == DISCONNECT || command == SEND)) {
            return;
        }

        String userIdStr = headers.get("userId", String.class);
        int userId = Integer.parseInt(userIdStr);
        if (command == SEND) {
            changeOnlineStatus(userId, true);
            System.out.println(message);
            System.out.println("user changed to online");
        }

//        // if input userId = firebase uid
//        String uid = headers.get("userId", String.class);
//        UserRecord user = userRepository.findUserByUid(uid);
//        int userId = user.userId();
//        // end

        if (command == DISCONNECT) {
            // 유저 offline으로 변경
            changeOnlineStatus(userId, false);

            System.out.println("user " + userId + "disconnected");
        }
    }

    @Transactional
    public void changeOnlineStatus(int userId, boolean toStatus) {
        User user = userRepository.findUserByUserId(userId);
        user.setCallable(toStatus);
        userRepository.save(user);
    }
}
