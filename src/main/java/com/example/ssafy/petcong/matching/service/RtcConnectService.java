package com.example.ssafy.petcong.matching.service;

import com.example.ssafy.petcong.matching.model.Matching;
import io.openvidu.java.client.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class RtcConnectService {

    private final String OPENVIDU_URL;
    private final String OPENVIDU_SECRET;
    private OpenVidu openVidu;

    public RtcConnectService(@Value("${openvidu.url}") String opeviduUrl,
                             @Value("${openvidu.secret}") String openviduSecret) {
        this.OPENVIDU_URL = opeviduUrl;
        this.OPENVIDU_SECRET = openviduSecret;
        this.openVidu = new OpenVidu(OPENVIDU_URL, OPENVIDU_SECRET);
        // matchingRepository 추가
    }

    public Map<String, String> choice(int requestUserId, int partnerUserId) throws OpenViduJavaClientException, OpenViduHttpException {
        // DB에서 requestUserId, partnerUserId인 데이터 가져오기
        Matching matching = null;

        // 기존 데이터 없으면
        if (matching == null) {
            // DB에 pending 상태로 추가
            return null;
        }
        // 이미 매치되었거나, reject상태이면
        if (matching.callStatus() != Matching.CallStatus.PENDING) {
            throw new RuntimeException();
        }
        // 양쪽 다 like면, 매칭 생성
        SessionProperties sessionProperties = new SessionProperties.Builder().build();
        Session session = openVidu.createSession(sessionProperties);

        Map<String, String> responseMap = new HashMap<>();
        responseMap.put("sessionId", session.getSessionId());
        return responseMap;
    }

    public Map<String, String> call(String sessionId) throws OpenViduJavaClientException, OpenViduHttpException {
        Session session = openVidu.getActiveSession(sessionId);
        // 잘못된 sessionId일 때
        if (session == null) throw new RuntimeException();

        // 커넥션 생성
        ConnectionProperties properties = new ConnectionProperties.Builder()
                .type(ConnectionType.WEBRTC)
                .role(session.getConnections().isEmpty() ?
                        OpenViduRole.PUBLISHER : OpenViduRole.SUBSCRIBER)
                .data("sampleUserInfo")
                .build();
        Connection conn = session.createConnection(properties);
        // 토큰 얻기 & 반환
        Map<String, String> responseMap = new HashMap<>();
        responseMap.put("sessionToken", conn.getToken());
        return responseMap;
    }
}
