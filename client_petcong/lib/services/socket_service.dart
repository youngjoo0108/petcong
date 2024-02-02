import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:petcong/pages/app_pages/webRTC/webrtc.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

// stomp client
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService extends GetxService {
  StompClient? client;
  RxList<String> msgArr = <String>[].obs;
  String? uid;
  String? idToken;
  VoidCallback? onInitComplete;
  late MainVideoCall webrtc;
  RTCPeerConnection? pc;
  String targetId = 'kS95PNT8RUc78Qr7TQ4uRaJmbw23';
  String subsPrefix = "/queue/";
  // final _localRenderer = RTCVideoRenderer();
  // final _remoteRenderer = RTCVideoRenderer();
  // MediaStream? _localStream;

  Future<void> initPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      idToken = prefs.getString('idToken');
    } catch (e) {
      debugPrint('Error retrieving values from SharedPreferences: $e');
    }
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
      debugPrint('!!!!!!!!!!!!!!!!!!!!!I get IdToken!!!!!!!!!!!!!!');
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  Future<StompClient> initSocket() async {
    initPrefs();
    if (client == null) {
      client = StompClient(
        config: StompConfig.sockJS(
          url: 'http://i10a603.p.ssafy.io:8081/websocket',
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
              callback: (frame) {
                msgArr.add(frame.body!);
                Map<String, dynamic> response = jsonDecode(frame.body!);

                String type = response['type'];
                print('type = $type');
                if (type == 'joined') {
                  webrtc.sendOffer(client!);
                  return;
                }
                Map<String, dynamic> value = response['value'];

                if (type == 'offer') {
                  webrtc.gotOffer(value['sdp'], value['type']);
                  webrtc.sendAnswer(client!);
                } else if (type == 'answer') {
                  webrtc.gotAnswer(value['sdp'], value['type']);
                } else if (type == 'ice') {
                  webrtc.gotIce(value['candidate'], value['sdpMid'],
                      value['sdpMLineIndex']);
                }
              },
            );
          },
          onWebSocketError: (dynamic error) =>
              debugPrint('websocketerror : $error'),
        ),
      );
      await activateSocket(client!);
      await Future.delayed(const Duration(milliseconds: 250));
    }
    return client!;
  }

  Future<void> activateSocket(StompClient client) async {
    client.activate();
    webrtc = MainVideoCall(client);
    webrtc.init();
  }

  Future<void> disposeSocket(myuid) async {
    await initSocket();
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
      webrtc.dispose();
      client!.deactivate();
      debugPrint('연결끔');
      debugPrint('After deactivating: Is client active? ${client?.isActive}');
    } catch (e) {
      debugPrint('Error disposing socket: $e');
    }
  }
}
