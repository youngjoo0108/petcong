import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class MainVideoCall extends GetxController {
  late final StompClient client;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? pc;

  late SharedPreferences prefs;
  String? uid;

  var targetId = 1;
  var subsPrefix = "/queue/";

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
  }

  Future<void> init() async {
    await initPrefs();

    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    await connectSocket();
    await joinRoom();
  }

  void _attemptReconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      connectSocket();
    });
  }

  Future<void> connectSocket() async {
    client = StompClient(
      config: StompConfig.sockJS(
        url: 'http://i10a603.p.ssafy.io:8081/websocket',
        webSocketConnectHeaders: {
          "transports": ["websocket"],
        },
        onConnect: onConnect,
        onWebSocketError: (dynamic error) {
          debugPrint(error.toString());
          _attemptReconnect();
        },
        onDisconnect: onDisconnect,
      ),
    );
    client.activate();
  }

  void onConnect(StompFrame frame) {
    debugPrint("----------------------------connected------------------------");
    if (client.connected) {
      client.subscribe(
        destination: subsPrefix + uid!,
        callback: (frame) {
          debugPrint(frame as String?);
          debugPrint("frame.body = ${frame.body!}");
          debugPrint("start callback");

          Map<String, dynamic> response = jsonDecode(frame.body!);
          print('type = ' + response['type']);

          String type = response['type'];
          if (type == 'answer') {
            debugPrint('------------------------answer!!-------------------');
            debugPrint(response['value']);
            debugPrint(jsonEncode(response['value']));
          }
          if (type == 'joined') {
            _sendOffer();
            return;
          }
          Map<String, dynamic> value = response['value'];
          debugPrint('valueMap = ${jsonEncode(value)}');
          debugPrint(
              "--------------------------------------subscribed----------------------------");

          if (type == 'offer') {
            _gotOffer(RTCSessionDescription(value['sdp'], value['type']));
            _sendAnswer();
          } else if (type == 'answer') {
            _gotAnswer(RTCSessionDescription(value['sdp'], value['type']));
          } else if (type == 'ice') {
            _gotIce(RTCIceCandidate(
                value['candidate'], value['sdpMid'], value['sdpMLineIndex']));
          }
        },
      );
      debugPrint("sended");
    } else {
      debugPrint("Stomp connection is not open.");
      _attemptReconnect();
    }
  }

  void onDisconnect(StompFrame frame) {
    client.send(
      destination: subsPrefix + uid!,
      headers: {
        "content-type": "application/json",
        "userId": uid.toString(),
        "info": "disconnect"
      },
      body: "",
    );
    _attemptReconnect();
  }

  Future joinRoom() async {
    final config = {
      // RTCPeerConnection 객체가 iceServers 배열에 등록된 객체들 중 STUN 서버를 통해 먼저 연결을 시도하고,
      // 불가능한 경우 TURN 서버로 시도한다.
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
      _sendIce(ice);
    };

    pc!.onAddStream = (stream) {
      _remoteRenderer.srcObject = stream;
    };

    client.send(
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "userId": uid.toString(),
          "info": "connect"
        },
        body: jsonEncode({"type": "joined", "value": ""}));
  }

  Future _sendOffer() async {
    debugPrint('send offer');
    var offer = await pc!.createOffer();
    pc!.setLocalDescription(offer);
    // socket.emit('offer', jsonEncode(offer.toMap()));
    var map = {"type": "offer", "value": offer.toMap()};
    client.send(
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "userId": uid.toString(),
          "info": "connect"
        },
        body: jsonEncode(map));
  }

  Future _gotOffer(RTCSessionDescription offer) async {
    debugPrint('got offer');
    pc!.setRemoteDescription(offer);
  }

  Future _sendAnswer() async {
    debugPrint('send answer');
    var answer = await pc!.createAnswer();
    pc!.setLocalDescription(answer);
    // socket.emit('answer', jsonEncode(answer.toMap()));
    var map = {"type": "answer", "value": answer.toMap()};
    debugPrint("before sendAnswer");
    debugPrint("map = ${jsonEncode(map)}");
    client.send(
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "userId": uid.toString(),
          "info": "connect"
        },
        body: jsonEncode(map));
  }

  Future _gotAnswer(RTCSessionDescription answer) async {
    debugPrint('got answer');
    update();
    pc!.setRemoteDescription(answer);
  }

  Future _sendIce(RTCIceCandidate ice) async {
    debugPrint("send ice");
    update();
    var map = {"type": "ice", "value": ice.toMap()};
    client.send(
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "userId": uid.toString(),
          "info": "connect"
        },
        body: jsonEncode(map));
  }

  Future _gotIce(RTCIceCandidate ice) async {
    debugPrint("got ice");
    pc!.addCandidate(ice);
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.dispose();
    pc?.close();
    client.deactivate();
    super.dispose();
  }

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;
}
