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

class SocketService extends GetxController {
  // Socket 변수
  StompClient? client;
  RxList<String> msgArr = <String>[].obs;
  String? uid;
  String? idToken;
  VoidCallback? onInitComplete;

  // RTC 변수
  // late MainVideoCall webrtc;
  RTCPeerConnection? pc;
  String targetId = 'kS95PNT8RUc78Qr7TQ4uRaJmbw23';
  String subsPrefix = "/queue/";
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;

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
      debugPrint('!!!!!!!!!!!!!!!!!!!!!I get IdToken$uid!!!!!!!!!!!!!!');
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
                  sendOffer(client!);
                  return;
                }
                Map<String, dynamic> value = response['value'];

                if (type == 'offer') {
                  gotOffer(value['sdp'], value['type']);
                  sendAnswer(client!);
                } else if (type == 'answer') {
                  gotAnswer(value['sdp'], value['type']);
                } else if (type == 'ice') {
                  gotIce(value['candidate'], value['sdpMid'],
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
  }

  Future<void> onCallPressed(call) async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    if (call == 'on') {
      await initSocket();
      await joinRoom();

      Get.to(
        MainVideoCallWidget(
          localRenderer: _localRenderer,
          remoteRenderer: _remoteRenderer,
        ),
      );
    } else {
      // // if (_localStream != null) {
      // //   print('here!!!!!!!!!!!!!!!!');
      // //   _localStream!.getTracks().forEach((track) {
      // //     track.stop();
      // //   });
      // // }

      // print(
      //     '??????????????????????????$_localStream, ${localRenderer.srcObject}');
      // print(_localStream?.getAudioTracks());
      // print(_localStream?.getVideoTracks());
      // await _localRenderer.dispose();
      // await _remoteRenderer.dispose();
      // Get.to(const HomePage());
    }
  }

  // Future<void> offCallPressed() async {}

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
      // dispose();
      client!.deactivate();
      debugPrint('연결끔');
      debugPrint('After deactivating: Is client active? ${client?.isActive}');
    } catch (e) {
      debugPrint('Error disposing socket: $e');
    }
  }

  // webRTC

  Future joinRoom() async {
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

    final mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user'}
    };

    _localStream = await Helper.openCamera(mediaConstraints);

    _localStream!.getTracks().forEach((track) {
      pc!.addTrack(track, _localStream!);
    });
    _localRenderer.srcObject = _localStream;

    pc!.onIceCandidate = (ice) {
      sendIce(ice, client!);
    };

    pc!.onAddStream = (stream) {
      _remoteRenderer.srcObject = stream;
    };

    client!.send(
        // destination: subsPrefix + targetId.toString(),
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "uid": uid!.toString(),
          "info": "connect"
        },
        body: jsonEncode({"type": "joined", "value": ""}));
  }

// --- webrtc - 메소드들 ---
  Future sendOffer(StompClient client) async {
    debugPrint('send offer');
    var offer = await pc!.createOffer();
    pc!.setLocalDescription(offer);
    var map = {"type": "offer", "value": offer.toMap()};
    client.send(
        destination: '/queue/$targetId',
        headers: {
          "content-type": "application/json",
          "uid": uid.toString(),
          "info": "connect"
        },
        body: jsonEncode(map));
  }

  Future gotOffer(String sdp, String type) async {
    RTCSessionDescription offer = RTCSessionDescription(sdp, type);
    debugPrint('got offer');
    pc!.setRemoteDescription(offer);
  }

  Future sendAnswer(StompClient client) async {
    debugPrint('send answer');
    var answer = await pc!.createAnswer();
    pc!.setLocalDescription(answer);
    var map = {"type": "answer", "value": answer.toMap()};
    debugPrint("before sendAnswer");
    debugPrint("map = ${jsonEncode(map)}");
    client.send(
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "uid": uid.toString(),
          "info": "connect"
        },
        body: jsonEncode(map));
  }

  Future gotAnswer(String sdp, String type) async {
    RTCSessionDescription answer = RTCSessionDescription(sdp, type);
    debugPrint('got answer');
    update();
    pc!.setRemoteDescription(answer);
  }

  Future sendIce(RTCIceCandidate ice, StompClient client) async {
    debugPrint("send ice");
    update();
    var map = {"type": "ice", "value": ice.toMap()};
    client.send(
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "uid": uid.toString(),
          "info": "connect"
        },
        body: jsonEncode(map));
  }

  Future gotIce(String candidate, String sdpMid, int sdpMLineIndex) async {
    RTCIceCandidate ice = RTCIceCandidate(candidate, sdpMid, sdpMLineIndex);
    debugPrint("got ice");
    pc!.addCandidate(ice);
  }

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;
}
