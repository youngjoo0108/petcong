import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// stomp client
import 'package:stomp_dart_client/parser.dart';
import 'package:stomp_dart_client/sock_js/sock_js_parser.dart';
import 'package:stomp_dart_client/sock_js/sock_js_utils.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_exception.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';
import 'package:stomp_dart_client/stomp_parser.dart';

class MainVideoCall extends StatefulWidget {
  const MainVideoCall({Key? key}) : super(key: key);

  @override
  State<MainVideoCall> createState() => _MainVideoCallState();
}

class _MainVideoCallState extends State<MainVideoCall> {
  late final StompClient client;
  // late final IO.Socket socket;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? pc;
  // test
  var myId = 1;
  var targetId = 2;
  var subsPrefix = "/queue/";

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    await connectSocket();
    await joinRoom();
  }

  void onConnect(StompFrame frame) {
    print("----------------------------connected------------------------");
    client.subscribe(
        destination: subsPrefix + myId.toString(),
        callback: (frame) {
          print(frame);
          print("frame.body = ${frame.body!}");
          print("start callback");

          Map<String, dynamic> response = jsonDecode(frame.body!);
          print('type = ' + response['type']);

          // String value = response['value'] as String;
          // print('value = ' + value);

          String type = response['type'];
          if (type == 'answer') {
            print('------------------------answer!!-------------------');
            print(response['value']);
            print(jsonEncode(response['value']));
          }
          if (type == 'joined') {
            _sendOffer();
            return;
          }
          Map<String, dynamic> value = response['value'];
          print('valueMap = ${jsonEncode(value)}');
          print(
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
        });
    // _sendOffer();
    print("sended");
  }

  void onDisconnect(StompFrame frame) {
    client.send(
        destination: subsPrefix + myId.toString(),
        headers: {
          "content-type": "application/json",
          "userId": myId.toString(),
          "info": "disconnect"
        },
        body: "");
  }

  Future connectSocket() async {
    client = StompClient(
      config: StompConfig.sockJS(
        url: 'http://43.200.28.137:8080/websocket',
        webSocketConnectHeaders: {
          "transports": ["websocket"],
        },
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        onDisconnect: onDisconnect,
      ),
    );
    client.activate();
  }

  Future joinRoom() async {
    final config = {
      'iceServers': [
        {"url": "stun:stun.l.google.com:19302"},
      ]
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
          "userId": myId.toString(),
          "info": "connect"
        },
        body: jsonEncode({"type": "joined", "value": ""}));
  }

  Future _sendOffer() async {
    print('send offer');
    var offer = await pc!.createOffer();
    pc!.setLocalDescription(offer);
    // socket.emit('offer', jsonEncode(offer.toMap()));
    var map = {"type": "offer", "value": offer.toMap()};
    client.send(
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "userId": myId.toString(),
          "info": "connect"
        },
        body: jsonEncode(map));
  }

  Future _gotOffer(RTCSessionDescription offer) async {
    print('got offer');
    pc!.setRemoteDescription(offer);
  }

  Future _sendAnswer() async {
    print('send answer');
    var answer = await pc!.createAnswer();
    pc!.setLocalDescription(answer);
    // socket.emit('answer', jsonEncode(answer.toMap()));
    var map = {"type": "answer", "value": answer.toMap()};
    print("before sendAnswer");
    print("map = ${jsonEncode(map)}");
    client.send(
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "userId": myId.toString(),
          "info": "connect"
        },
        body: jsonEncode(map));
  }

  Future _gotAnswer(RTCSessionDescription answer) async {
    print('got answer');
    pc!.setRemoteDescription(answer);
  }

  Future _sendIce(RTCIceCandidate ice) async {
    print("send ice");
    var map = {"type": "ice", "value": ice.toMap()};
    client.send(
        destination: subsPrefix + targetId.toString(),
        headers: {
          "content-type": "application/json",
          "userId": myId.toString(),
          "info": "connect"
        },
        body: jsonEncode(map));
  }

  Future _gotIce(RTCIceCandidate ice) async {
    print("got ice");
    pc!.addCandidate(ice);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Row(
        children: [
          Expanded(child: RTCVideoView(_localRenderer)),
          Expanded(child: RTCVideoView(_remoteRenderer)),
        ],
      ),
    );
  }
}
