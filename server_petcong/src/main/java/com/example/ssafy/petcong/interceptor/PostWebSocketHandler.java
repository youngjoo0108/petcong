package com.example.ssafy.petcong.interceptor;

import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.record.UserRecord;
import com.example.ssafy.petcong.user.repository.UserRepository;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

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
        try {

            StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
            StompCommand command = accessor.getCommand();

            System.out.println("-----------------------------------------------------------------------------");
            System.out.println("\n\n\nmessage arrived / command = " + command + "\n\n\n");
            System.out.println("-----------------------------------------------------------------------------");

            if (command == SEND) {
                MessageHeaders headers = message.getHeaders();
//                for (String key : headers.keySet()) {
//                    System.out.println("key = " + key);
//                    System.out.println("value = " + headers.get(key));
//                }
                Map<String, Object> nativeHeaders = (Map<String, Object>) headers.get("nativeHeaders");
                // 파싱
                String connectInfo  = Arrays.asList(nativeHeaders.get("info")).get(0)
                        .toString();
                String userIdStr  = Arrays.asList(nativeHeaders.get("userId")).get(0)
                        .toString();

                connectInfo = connectInfo.substring(1, connectInfo.length() - 1); // [] 제거
                userIdStr = userIdStr.substring(1, userIdStr.length() - 1);

                boolean callable = connectInfo.equals("connect");
                int userId = Integer.parseInt(userIdStr);

                changeOnlineStatus(userId, callable);
                
                System.out.println("user changed to " + (callable ? "online" : "offline"));
                System.out.println("userId = " + userId);
            }

//        // if input userId = firebase uid
//        String uid = headers.get("userId", String.class);
//        UserRecord user = userRepository.findUserByUid(uid);
//        int userId = user.userId();
//        // end

//            if (command == DISCONNECT) {
//                // 유저 offline으로 변경
//                System.out.println("user " + "disconnected");
//            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Transactional
    public void changeOnlineStatus(int userId, boolean toStatus) {
        User user = userRepository.findUserByUserId(userId);
        user.setCallable(toStatus);
        userRepository.save(user);
    }
}
