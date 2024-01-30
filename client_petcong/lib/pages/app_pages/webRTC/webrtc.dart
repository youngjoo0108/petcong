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
  var myId = 2;
  var targetId = 1;
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

  // void onConnect(StompFrame frame) {
  //   print("----------------------------connected------------------------");
  //   client.subscribe(
  //       destination: subsPrefix + myId.toString(),
  //       callback: (frame) {
  //         print(frame);
  //         print("frame.body = ${frame.body!}");
  //         print("start callback");

  //         Map<String, dynamic> response = jsonDecode(frame.body!);
  //         print('type = ' + response['type']);

  //         // String value = response['value'] as String;
  //         // print('value = ' + value);

  //         String type = response['type'];
  //         if (type == 'answer') {
  //           print('------------------------answer!!-------------------');
  //           print(response['value']);
  //           print(jsonEncode(response['value']));
  //         }
  //         if (type == 'joined') {
  //           _sendOffer();
  //           return;
  //         }
  //         Map<String, dynamic> value = response['value'];
  //         print('valueMap = ${jsonEncode(value)}');
  //         print(
  //             "--------------------------------------subscribed----------------------------");

  //         if (type == 'offer') {
  //           _gotOffer(RTCSessionDescription(value['sdp'], value['type']));
  //           _sendAnswer();
  //         } else if (type == 'answer') {
  //           _gotAnswer(RTCSessionDescription(value['sdp'], value['type']));
  //         } else if (type == 'ice') {
  //           _gotIce(RTCIceCandidate(
  //               value['candidate'], value['sdpMid'], value['sdpMLineIndex']));
  //         }
  //       });
  //   // _sendOffer();
  //   print("sended");
  // }

  void onConnect(StompFrame frame) {
    print("----------------------------connected------------------------");
    if (client.connected) {
      // Stomp connection is open and ready
      client.subscribe(
        destination: subsPrefix + myId.toString(),
        callback: (frame) {
          print(frame);
          print("frame.body = ${frame.body!}");
          print("start callback");

          Map<String, dynamic> response = jsonDecode(frame.body!);
          print('type = ' + response['type']);

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
        },
      );
      print("sended");
    } else {
      print("Stomp connection is not open.");
      // Handle accordingly, perhaps attempt to reconnect
      _attemptReconnect();
    }
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
    _attemptReconnect();
  }

  // Future connectSocket() async {
  //   client = StompClient(
  //     config: StompConfig.sockJS(
  //       url: 'http://43.200.28.137:8080/websocket',
  //       webSocketConnectHeaders: {
  //         "transports": ["websocket"],
  //       },
  //       onConnect: onConnect,
  //       beforeConnect: () async {
  //         print('waiting to connect...');
  //         await Future.delayed(const Duration(milliseconds: 200));
  //         print('connecting...');
  //       },
  //       onWebSocketError: (dynamic error) => print(error.toString()),
  //       onDisconnect: onDisconnect,
  //     ),
  //   );
  //   client.activate();
  // }

  Future connectSocket() async {
    client = StompClient(
      config: StompConfig.sockJS(
        url: 'http://i10a603.p.ssafy.io:8080/websocket',
        webSocketConnectHeaders: {
          "transports": ["websocket"],
        },
        onConnect: onConnect,
        onWebSocketError: (dynamic error) {
          print(error.toString());
          // Handle WebSocket error, perhaps attempt to reconnect
          _attemptReconnect();
        },
        onDisconnect: onDisconnect,
      ),
    );
    client.activate();
  }

  void _attemptReconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      connectSocket();
    });
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
    setState(() {});
    pc!.setRemoteDescription(answer);
  }

  Future _sendIce(RTCIceCandidate ice) async {
    print("send ice");
    setState(() {});
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
  void dispose() {
    // Dispose of resources when the widget is disposed
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.dispose();
    pc?.close();
    client.deactivate();
    super.dispose();
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
