//package com.example.ssafy.petcong.interceptor;
//
//
////import com.example.ssafy.petcong.user.repository.UserRepository;
////import org.junit.jupiter.api.AfterEach;
////import org.junit.jupiter.api.BeforeEach;
////import org.junit.jupiter.api.Test;
////import org.springframework.beans.factory.annotation.Autowired;
////import org.springframework.boot.test.context.SpringBootTest;
////import org.springframework.messaging.converter.MappingJackson2MessageConverter;
////import org.springframework.messaging.simp.stomp.*;
////import org.springframework.scheduling.concurrent.ConcurrentTaskScheduler;
////import org.springframework.web.socket.WebSocketHttpHeaders;
////import org.springframework.web.socket.client.standard.StandardWebSocketClient;
////import org.springframework.web.socket.messaging.WebSocketStompClient;
////
////import java.lang.reflect.Type;
////import java.net.URI;
////import java.util.concurrent.CountDownLatch;
////import java.util.concurrent.ExecutionException;
////import java.util.concurrent.TimeUnit;
////import java.util.concurrent.TimeoutException;
////
////import static org.junit.jupiter.api.Assertions.assertEquals;
//////import static org.junit.jupiter.api.Assertions.assertTrue;
////
//////@SpringBootTest
////public class StompClientTest {
////
////    @Autowired
////    private UserRepository userRepository;
////
////    private WebSocketStompClient stompClient;
////    private CountDownLatch latch;
////
//////    @Autowired
//////    public StompClientTest(UserRepository userRepository) {
//////        this.userRepository = userRepository;
//////    }
////
////    @BeforeEach
////    public void setup() {
////        stompClient = new WebSocketStompClient(new StandardWebSocketClient());
////        stompClient.setMessageConverter(new MappingJackson2MessageConverter());
////        latch = new CountDownLatch(1);
////    }
////
////    @AfterEach
////    public void shutdown() throws Exception {
////        // 클라이언트 종료 등의 정리 작업이 필요하다면 여기에서 수행
////    }
////
////    @Test
////    public void testWebSocketConnection() throws Exception {
////        URI uri = new URI("ws://localhost:8080/websocket");
////        WebSocketHttpHeaders headers = new WebSocketHttpHeaders();
////
////        StompSession session = stompClient.connectAsync(uri.toString(), headers, new TestStompSessionHandler()).get(3, TimeUnit.SECONDS);
//////        assertTrue(latch.await(5, TimeUnit.SECONDS));
//////        latch.await(5, TimeUnit.SECONDS);
////        System.out.println("connected");
////
////        // subscribe
////        StompHeaders headers2 = new StompHeaders();
////        headers2.setDestination("/queue/1");
////        session.subscribe(headers2, new TestStompSessionHandler());
////        System.out.println("subscribed");
////
////        headers2.set("userId", "1");
////        session.send(headers2, "testMessage from client");
////        System.out.println("sended");
////    }
////
////    static class TestStompSessionHandler extends StompSessionHandlerAdapter {
////        @Override
////        public void afterConnected(StompSession session, StompHeaders connectedHeaders) {
////            System.out.println("Connected to WebSocket");
////            // 원하는 동작 추가 가능
//////            latch.countDown();
//////            StompHeaders headers = new StompHeaders();
//////            headers.setDestination("/queue/1");
//////            headers.set("userId", "1");
//////            session.send(headers, "testMessage from client");
////        }
////    }
////}
//
//import org.junit.jupiter.api.BeforeEach;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.springframework.messaging.converter.MappingJackson2MessageConverter;
//import org.springframework.messaging.simp.stomp.StompHeaders;
//import org.springframework.messaging.simp.stomp.StompSession;
//import org.springframework.messaging.simp.stomp.StompSessionHandlerAdapter;
//import org.springframework.test.context.junit.jupiter.SpringExtension;
//import org.springframework.test.context.junit4.SpringRunner;
//import org.springframework.web.socket.WebSocketHttpHeaders;
//import org.springframework.web.socket.client.standard.StandardWebSocketClient;
//import org.springframework.web.socket.messaging.WebSocketStompClient;
//import org.springframework.web.socket.sockjs.client.SockJsClient;
//import org.springframework.web.socket.sockjs.client.Transport;
//import org.springframework.web.socket.sockjs.client.WebSocketTransport;
//
//import java.util.ArrayList;
//import java.util.List;
//import java.util.concurrent.CountDownLatch;
//import java.util.concurrent.ExecutionException;
//import java.util.concurrent.TimeUnit;
//import java.util.concurrent.TimeoutException;
//
//@ExtendWith(SpringExtension.class)
//public class StompClientTest {
//    String uri = "ws://localhost:8080/websocket";
//
//    CountDownLatch latch = new CountDownLatch(2);
//
//    WebSocketStompClient stompClient;
//    StompSession stompSession;
//
//    private List<Transport> createTransportClient() {
//        List<Transport> transports = new ArrayList<>(1);
//        transports.add(new WebSocketTransport(new StandardWebSocketClient()));
//        return transports;
//    }
//
//    @BeforeEach
//    public void setup() throws InterruptedException {
//        stompClient = new WebSocketStompClient(new SockJsClient(createTransportClient()));
//
//        stompClient.setMessageConverter(new MappingJackson2MessageConverter());
//    }
////tprtm =>
//    @Test
//    public void contextLoads() throws InterruptedException, ExecutionException, TimeoutException {
//        String userId = "1";
//        WebSocketHttpHeaders handshakeHeaders = new WebSocketHttpHeaders();
//
//        StompHeaders headers = new StompHeaders();
//        headers.add("userId", userId);
//
//        stompSession = stompClient.connectAsync(uri, handshakeHeaders, headers, new StompSessionHandlerAdapter(){}).get(2, TimeUnit.SECONDS);
//
//
//    }
//}
