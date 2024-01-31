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

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static org.springframework.messaging.simp.stomp.StompCommand.SEND;
import static org.springframework.messaging.simp.stomp.StompCommand.SUBSCRIBE;

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

            if (!(command == SEND || command == SUBSCRIBE)) return;

            MessageHeaders headers = message.getHeaders();
            Map<String, Object> nativeHeaders = (Map<String, Object>) headers.get("nativeHeaders");
            // 파싱
            String uidStr = Arrays.asList(nativeHeaders.get("uid")).get(0)
                    .toString();
            String uid = uidStr.substring(1, uidStr.length() - 1); // [] 제거

            if (command == SUBSCRIBE) {
                changeOnlineStatus(uid, true);
                return;
            }
            List<Object> info = Arrays.asList(nativeHeaders.get("info"));

            if (info == null || info.isEmpty()) return; // disconnect 요청이 아닌 일반 메시지인 경우

            String connectInfo  = info.toString();
            connectInfo = connectInfo.substring(1, connectInfo.length() - 1);
            if (connectInfo.equals("disconnect")) {
                changeOnlineStatus(uid, false);
            }

        // end
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Transactional
    public void changeOnlineStatus(String uid, boolean toStatus) {
        User user = userRepository.findUserByUid(uid);
        user.setCallable(toStatus);
        userRepository.save(user);
    }
}
