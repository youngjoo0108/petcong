package com.example.ssafy.petcong.config;

import com.example.ssafy.petcong.interceptor.PostWebSocketHandler;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    private PostWebSocketHandler postWebSocketHandler;

    public WebSocketConfig(PostWebSocketHandler postWebSocketHandler) {
        this.postWebSocketHandler = postWebSocketHandler;
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/websocket").setAllowedOriginPatterns("*").withSockJS();
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 모든 클라이언트는 앱 실행하는 동안 서버와의 1:1 연결을 유지
        // 실제 연결 url은 "/queue/{userId}" 등의 형태로 들어감
        registry.enableSimpleBroker("/queue");
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(postWebSocketHandler);
    }
}
