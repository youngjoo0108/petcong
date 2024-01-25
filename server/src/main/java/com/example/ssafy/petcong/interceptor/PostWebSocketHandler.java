package com.example.ssafy.petcong.interceptor;

import com.example.ssafy.petcong.user.model.entity.User;
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

        if (command == SUBSCRIBE) {
            // userId 가져오기
//            String destination = headers.get("simpDestination", String.class);
//            System.out.println("destination = " + destination);
//            String userIdStr = destination.substring(destination.lastIndexOf("/") + 1);
//            System.out.println("userId = " + userIdStr);
//            int userId = Integer.parseInt(userIdStr);

            int userId = Integer.parseInt(
                    headers.get("userId", String.class)
            );

            // 유저 online상태로 변경
            changeOnlineStatus(userId, true);

            // 완료 처리
            System.out.println("user " + userId + "connected");
        } else if (command == DISCONNECT) {
            // 클라이언트에서 disconnect 메시지 보낼 때 커스텀 헤더 설정 가능.
            String userIdStr = headers.get("userId", String.class);
            System.out.println("userId = " + userIdStr);
            int userId = Integer.parseInt(userIdStr);

            // 유저 offline으로 변경
            changeOnlineStatus(userId, false);

            System.out.println("user " + userId + "disconnected");
        }
    }

    @Transactional
    public void changeOnlineStatus(int userId, boolean toStatus) {
        User user = new User(userRepository.findUserByUserId(userId));
        user.setCallable(toStatus);
    }
}
