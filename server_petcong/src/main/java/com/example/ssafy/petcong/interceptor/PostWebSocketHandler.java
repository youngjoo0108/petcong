package com.example.ssafy.petcong.interceptor;

import com.example.ssafy.petcong.member.model.entity.Member;
import com.example.ssafy.petcong.member.repository.MemberRepository;
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
import java.util.NoSuchElementException;

import static org.springframework.messaging.simp.stomp.StompCommand.*;

@Component
public class PostWebSocketHandler implements ChannelInterceptor {

    private final MemberRepository memberRepository;

    public PostWebSocketHandler(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }

    @Override
    @Transactional
    public void postSend(Message<?> message, MessageChannel channel, boolean sent) {
        try {
            StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
            StompCommand command = accessor.getCommand();
            if (command == DISCONNECT) {
                System.out.println("------------------------disconnected-----------------------");
            }
            if (!(command == SEND || command == SUBSCRIBE)) return;

            MessageHeaders headers = message.getHeaders();
            Map<String, Object> nativeHeaders = (Map<String, Object>) headers.get("nativeHeaders");

            System.out.println("----------------------------headers-----------------------");
            // test
            for (Map.Entry<String, Object> entry : nativeHeaders.entrySet()) {
                String key = entry.getKey();
                String value = nativeHeaders.get(key).toString();
                System.out.println("key = " + key);
                System.out.println("value = " + value);
            }

            // 파싱
            String uidStr = Arrays.asList(nativeHeaders.get("uid")).get(0)
                    .toString();
            String uid = uidStr.substring(1, uidStr.length() - 1); // [] 제거

            System.out.println("---------------" + command + "--------------");

            changeOnlineStatus(uid, true);

            List<Object> info = Arrays.asList(nativeHeaders.get("info"));

            if (command == SEND || info == null || info.isEmpty()) {
                String connectInfo  = info.toString();
                connectInfo = connectInfo.substring(1, connectInfo.length() - 1);
                if (connectInfo.equals("disconnect")) {
                System.out.println("---------------disconnecting message accepted--------------");
                    changeOnlineStatus(uid, false);
                }
            }
        // end
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Transactional
    public void changeOnlineStatus(String uid, boolean toStatus) {
        Member member = memberRepository.findMemberByUid(uid).orElseThrow(() -> new NoSuchElementException(uid));
        member.updateCallable(toStatus);
        memberRepository.save(member);
    }
}
