package com.example.ssafy.petcong.interceptor;

import com.example.ssafy.petcong.user.model.entity.User;
import com.example.ssafy.petcong.user.model.record.UserRecord;
import com.example.ssafy.petcong.user.repository.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.module.paramnames.ParameterNamesModule;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.messaging.converter.MappingJackson2MessageConverter;
import org.springframework.messaging.simp.stomp.StompHeaders;
import org.springframework.messaging.simp.stomp.StompSession;
import org.springframework.messaging.simp.stomp.StompSessionHandler;
import org.springframework.messaging.simp.stomp.StompSessionHandlerAdapter;
import org.springframework.web.socket.WebSocketHttpHeaders;
import org.springframework.web.socket.client.standard.StandardWebSocketClient;
import org.springframework.web.socket.messaging.WebSocketStompClient;
import org.springframework.web.socket.sockjs.client.SockJsClient;
import org.springframework.web.socket.sockjs.client.WebSocketTransport;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class PostWebSocketHandlerTest {

    UserRepository userRepository;
    WebSocketStompClient stompClient;

    @Autowired
    public PostWebSocketHandlerTest(UserRepository userRepository) {
        this.userRepository = userRepository;
        stompClient =
                new WebSocketStompClient(
                        new SockJsClient(List.of(
                                new WebSocketTransport(
                                        new StandardWebSocketClient()
                                )
                            )
                        )
                );
        stompClient.setMessageConverter(new MappingJackson2MessageConverter());
        MappingJackson2MessageConverter messageConverter = new MappingJackson2MessageConverter();
        ObjectMapper objectMapper = messageConverter.getObjectMapper();
        objectMapper.registerModules(new ParameterNamesModule());
        stompClient.setMessageConverter(messageConverter);
    }

    // 1. 연결
    @Test
    @DisplayName("웹소켓 연결")
    void connectTest() throws ExecutionException, InterruptedException, TimeoutException {
        StompSession stompSession = connect();
        stompSession.disconnect();
    }


    // 2. 구독 후 유저상태 체크
    @Test
    @DisplayName("구독 후 유저 online상태로 변환")
    void subscribeTest() throws ExecutionException, InterruptedException, TimeoutException {
        StompSession stompSession = connect();
        int userId = 1;
        setCallable(1, false);
        StompHeaders headers = makeHeaders(userId);

        // when subscribe,
        stompSession.subscribe(headers, new StompSessionHandlerAdapter() {});

        // change callable to true
        UserRecord updatedUser = userRepository.findUserByUserId(userId);

        stompSession.disconnect();
        assertThat(updatedUser.isCallable()).isTrue();

    }


    // 3. disconnect 후 유저상태 체크
    @Test
    @DisplayName("disconnect 후 유저 offline상태로 변환")
    void disconnectTest() throws ExecutionException, InterruptedException, TimeoutException {
        StompSession stompSession = connect();
        int userId = 1;
        // subscribe된 상태로 가정
        setCallable(1, true);
        StompHeaders headers = makeHeaders(userId);

        // when disconnect,
        stompSession.disconnect(headers);

        // change callable to false;
        UserRecord user = userRepository.findUserByUserId(userId);
        assertThat(user.isCallable()).isFalse();
    }

    // 4. 메시지 제대로 가는지
    @Test
    @DisplayName("메시지 송/수신 테스트")
    void communicate() throws ExecutionException, InterruptedException, TimeoutException {
        StompSession session = connect();

        CompletableFuture<String> receivedMessageFuture = new CompletableFuture<>();
        StompSession stompSession = stompClient
                .connectAsync("ws://localhost:8080/websocket", new StompSessionHandlerAdapter() {
                    @Override
                    public void afterConnected(StompSession session, StompHeaders connectedHeaders) {
                        // 연결이 성공하면 해당 메소드가 호출됨
                        session.subscribe("/queue/1", this);
                        session.send("/queue/1", "sampleMessage");
                    }

                    @Override
                    public void handleFrame(StompHeaders headers, Object payload) {
                        // 메시지 수신 시 해당 메소드가 호출됨
                        receivedMessageFuture.complete((String) payload);
                    }
                })
                .get(); // 연결이 완료될 때까지 대기

        // 메시지가 정상적으로 수신되었는지 검증
        String receivedMessage = receivedMessageFuture.get();

        stompSession.disconnect();
        assertThat(receivedMessage).isEqualTo("sampleMessage");

    }

    private StompHeaders makeHeaders(int userId) {
        StompHeaders headers = new StompHeaders();
        headers.setDestination("/queue/" + userId);
        headers.set("userId", String.valueOf(userId));
        return headers;
    }

    private void setCallable(int userId, boolean callable) {
        User user = new User(userRepository.findUserByUserId(userId));
        user.setCallable(callable);
        userRepository.save(user);
    }


    private StompSession connect() throws ExecutionException, InterruptedException, TimeoutException {
        // 연결
        String url = "ws://localhost:8080/websocket";

        // stompClient.connect()가 완료되고 stompSession를 반환할 때까지 기다린다. 단, 2초가 지나면 TimeOutException이 발생한다.
        StompSession stompSession = stompClient.connectAsync(url, new WebSocketHttpHeaders(), new StompSessionHandlerAdapter() {
        }).get(2, TimeUnit.SECONDS);

        return stompSession;
    }
}