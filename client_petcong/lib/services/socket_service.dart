import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:petcong/pages/app_pages/matching/call_waiting_page.dart';
import 'package:petcong/pages/app_pages/webRTC/webrtc.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

// stomp client
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService extends GetxController {
  // Socket 변수
  static StompClient? client;
  RxList<String> msgArr = <String>[].obs;
  static String?
      uid; // initPrefs()에서 late init 된 후, 바뀌지 않을 값 / static 함수에서 사용함.
  String? idToken;
  User user = FirebaseAuth.instance.currentUser!;
  VoidCallback? onInitComplete;
  // RTC 변수
  // late MainVideoCall webrtc;
  RTCPeerConnection? pc;
  static late String targetUid; // matched 메시지 받았을 때 초기화됨. static 함수에서 사용함.
  String subsPrefix = "/queue/";
  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? _remoteRenderer;
  MediaStream? _localStream;
  static bool callPressed = false;
  List<RTCIceCandidate>? iceCandidates;

  Future<void> initPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      await user.getIdToken().then((result) {
        idToken = result;
      });
    } catch (e) {
      debugPrint('Error retrieving values from SharedPreferences: $e');
    }
  }

  void setCallPressed(bool flag) {
    callPressed = flag;
  }

  Future<void> init() async {
    try {
      await initPrefs();
      if (idToken == null) {
        debugPrint('idToken is null');
        return;
      }
      if (onInitComplete != null) {
        onInitComplete!();
      }
      debugPrint('!!!!!!!!!!!!!!!!!!!!!I get IdToken$uid!!!!!!!!!!!!!!');
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  Future<StompClient> initSocket() async {
    if (client != null) {
      return client!;
    }

    initPrefs();
    if (client == null) {
      client = StompClient(
        config: StompConfig.sockJS(
          url: 'https://i10a603.p.ssafy.io/websocket',
          webSocketConnectHeaders: {
            // "Petcong-id-token": idToken,
            "transports": ["websocket"],
          },
          onConnect: (StompFrame frame) {
            debugPrint("연결됨");
            client!.subscribe(
              destination: '/queue/$uid',
              headers: {
                "uid": uid!,
              },
              callback: (frame) async {
                if (frame.body!.isNotEmpty) {
                  msgArr.add(frame.body!);
                  Map<String, dynamic> response = jsonDecode(frame.body!);

                  String type = response['type'];
                  print('type = $type');

                  switch (type) {
                    case 'matched':
                      Map<String, dynamic> value = response['value'];
                      // 전화 오는 화면으로 이동만. rtc 연결은 요청했던 쪽의 sendOffer로 시작해서 진행됨.
                      targetUid = value['targetUid'];
                      await makeCall(targetUid);
                      break;
                    case 'offer':
                      Map<String, dynamic> value =
                          jsonDecode(response['value']);
                      print(
                          "gotOffer============client ====================================${client.hashCode}");
                      value.forEach((key, value) {
                        print('Key: $key, Value: $value');
                      });
                      await gotOffer(value['sdp'], value['type']);
                      await sendAnswer();
                      await Future.delayed(const Duration(milliseconds: 300));
                      for (var ice in iceCandidates!) {
                        sendIce(ice);
                      }
                      break;
                    case 'answer':
                      Map<String, dynamic> value =
                          jsonDecode(response['value']);
                      print(
                          "gotAnswer============client ====================================${client.hashCode}");
                      await gotAnswer(value['sdp'], value['type']);
                      for (var ice in iceCandidates!) {
                        sendIce(ice);
                      }
                      break;
                    case 'ice':
                      Map<String, dynamic> value =
                          jsonDecode(response['value']);
                      print(
                          "gotIce============client ====================================${client.hashCode}");
                      gotIce(value['candidate'], value['sdpMid'],
                          value['sdpMLineIndex']);
                      break;
                    case 'block':
                      print("sendOffer blocked!");
                      callPressed = true;
                      break;
                    case 'idx':
                      int newIdx = int.parse(response['value']);
                      MainVideoCallWidget.quizIdx = newIdx;
                      print(
                          "===============index changed by partner / index = ${MainVideoCallWidget.quizIdx}==");
                      break;
                  }
                }
              },
            );
          },
          onWebSocketError: (dynamic error) =>
              debugPrint('websocketerror : $error'),
        ),
      );
      await activateSocket(client!);
      print('activating socket');
      await Future.delayed(const Duration(milliseconds: 300));
    }
    print(
        "========================in socketService.initSocket, client.hashCode() = ${client.hashCode}");
    print("SocketService.client 할당 됨");
    return client!;
  }

  Future<void> makeCall(String targetUidParam) async {
    final config = {
      'iceServers': [
        {"url": "stun:stun.l.google.com:19302"},
        {
          "url": "turn:i10a603.p.ssafy.io:3478",
          "username": "ehigh",
          "credential": "1234",
        },
      ],
    };

    final sdpConstraints = {
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': []
    };

    pc = await createPeerConnection(config, sdpConstraints);
    print("=======================makeCall start");
    print("localRenderer is null = ${_localRenderer == null}");
    print("remoteRenderer is null = ${_remoteRenderer == null}");
    targetUid = targetUidParam;
    // matched
    // 전화 오는 화면으로
    Get.to(CallWaiting(this));
    // rtc 연결 & 화면 띄우기 합쳐서 onCallPressed로 옮김
    // // 화면 띄워주면서, rtc 연결 시작
    // // 화면 띄워주면서, rtc 연결 시작
    // await joinRoom();
    print("=======================makeCall end");
  }

  Future<void> activateSocket(StompClient client) async {
    client.activate();
  }

  Future<void> onCallPressed(call) async {
    print("=======================onCallPressed start");
    if (call == 'on') {
      await sendOffer(targetUid);
      await Future.delayed(const Duration(seconds: 5));

      Get.to(
        MainVideoCallWidget(
          localRenderer: _localRenderer!,
          remoteRenderer: _remoteRenderer!,
          pc: pc!,
        ),
      );
    }
    print("=======================onCallPressed end");
  }

  Future<void> disposeSocket(myuid) async {
    // await initSocket();
    String stringUid = myuid as String;
    try {
      if (client!.isActive == true) {
        debugPrint('Before sending message: Socket is active');
        client!.send(
          destination: '/queue/$stringUid',
          headers: {
            "content-type": "application/json",
            "uid": stringUid,
            "info": "disconnect",
          },
          body: "",
        );
        debugPrint('Message sent to server');
      } else {
        debugPrint('Before sending message: Socket is not active');
      }
      // dispose();
      client!.deactivate();
      client = null;
      debugPrint('연결끔');
      debugPrint('After deactivating: Is client active? ${client?.isActive}');
    } catch (e) {
      debugPrint('Error disposing socket: $e');
    }
  }

  Future joinRoom() async {
    iceCandidates = [];
    print("=======================joinRoom start");
    try {
      pc!.onIceCandidate = (ice) {
        iceCandidates!.add(ice);
      };

      // remoteRenderer 세팅
      _remoteRenderer = RTCVideoRenderer();
      try {
        await _remoteRenderer!.initialize();
      } catch (exception) {
        print("exception = $exception");
      }

      pc!.onAddStream = (stream) {
        _remoteRenderer!.srcObject = stream;
      };

      // localRenderer 세팅
      _localRenderer = RTCVideoRenderer();
      await _localRenderer!.initialize();
      final mediaConstraints = {
        'audio': true,
        'video': {'facingMode': 'user'}
      };

      _localStream = await Helper.openCamera(mediaConstraints);

      // (화면에 띄울) localRenderer의 데이터 소스를 내 localStream으로 설정
      _localRenderer!.srcObject = _localStream;

      // 스트림의 트랙(카메라 정보가 들어오는 연결)을 peerConnection(정보를 전송할 connection)에 추가
      _localStream!.getTracks().forEach((track) {
        pc!.addTrack(track, _localStream!);
      });

      await Future.delayed(const Duration(seconds: 1));
    } catch (exception) {
      print(exception);
    }
    print("=======================joinRoom end");
  }

  static void sendMessage(String type, String value) {
    client!.send(
        destination: '/queue/$targetUid',
        headers: {
          "content-type": "application/json",
          "uid": uid.toString(),
          "info": "connect"
        },
        body: jsonEncode({"type": type, "value": value}));
  }

// --- webrtc - 메소드들 ---
  Future sendOffer(String targetUidLocal) async {
    if (callPressed) {
      // 상대방이 call버튼을 먼저 눌러서 gotOffer를 받았다면, 중복 send 방지
      return;
    }
    callPressed = true;
    // block target's sendOffer
    sendMessage("block", ".");
    await joinRoom();
    await Future.delayed(const Duration(milliseconds: 500));

    targetUid = targetUidLocal;

    await Future.delayed(const Duration(milliseconds: 1000));

    var offer = await pc!.createOffer();
    pc!.setLocalDescription(offer);
    sendMessage("offer", jsonEncode(offer.toMap()));
  }

  Future gotOffer(String sdp, String type) async {
    update();
    await joinRoom();
    await Future.delayed(const Duration(milliseconds: 500));
    // await joinRoom(); // 받는 쪽은 gotOffer()에서
    RTCSessionDescription offer = RTCSessionDescription(sdp, type);
    pc!.setRemoteDescription(offer);
    callPressed = true;
  }

  Future sendAnswer() async {
    var answer = await pc!.createAnswer({});
    pc!.setLocalDescription(answer);
    sendMessage("answer", jsonEncode(answer.toMap()));
  }

  Future gotAnswer(String sdp, String type) async {
    update();
    RTCSessionDescription answer = RTCSessionDescription(sdp, type);
    pc!.setRemoteDescription(answer);
  }

  Future sendIce(RTCIceCandidate ice) async {
    update();
    sendMessage("ice", jsonEncode(ice.toMap()));
  }

  Future gotIce(String candidate, String sdpMid, int sdpMLineIndex) async {
    update();
    RTCIceCandidate ice = RTCIceCandidate(candidate, sdpMid, sdpMLineIndex);
    pc!.addCandidate(ice);
  }

  RTCVideoRenderer get localRenderer => _localRenderer!;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer!;
}
