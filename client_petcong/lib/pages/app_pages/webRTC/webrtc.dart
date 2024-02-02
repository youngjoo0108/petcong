import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp.dart';

class MainVideoCall extends GetxController {
  StompClient? client;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? pc;

  late SharedPreferences prefs;
  String? uid;

  String targetId = 'kS95PNT8RUc78Qr7TQ4uRaJmbw23';
  String subsPrefix = "/queue/";

  MainVideoCall(this.client);

  @override
  Future<void> onInit() async {
    print('start webrtc');
    super.onInit();
    // init();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
  }

  Future<void> init() async {
    print('start webrtc');
    await initPrefs();
    client;
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    await joinRoom();
  }

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
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "userId": uid.toString(),
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
          "userId": uid.toString(),
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
          "userId": uid.toString(),
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
          "userId": uid.toString(),
          "info": "connect"
        },
        body: jsonEncode(map));
  }

  Future gotIce(String candidate, String sdpMid, int sdpMLineIndex) async {
    RTCIceCandidate ice = RTCIceCandidate(candidate, sdpMid, sdpMLineIndex);
    debugPrint("got ice");
    pc!.addCandidate(ice);
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.dispose();
    pc?.close();
    client!.deactivate();
    super.dispose();
  }

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;
}

class MainVideoCallWidget extends StatefulWidget {
  const MainVideoCallWidget({Key? key}) : super(key: key);

  @override
  _MainVideoCallWidgetState createState() => _MainVideoCallWidgetState();
}

class _MainVideoCallWidgetState extends State<MainVideoCallWidget> {
  final MainVideoCall controller = Get.put(MainVideoCall(null));

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: RTCVideoView(controller.localRenderer)),
          Expanded(child: RTCVideoView(controller.remoteRenderer)),
        ],
      ),
    );
  }
}
