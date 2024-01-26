import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MainVideoCall extends StatefulWidget {
  const MainVideoCall({super.key});

  @override
  State<MainVideoCall> createState() => _MainVideoCallState();
}

class _MainVideoCallState extends State<MainVideoCall> {
  late final IO.Socket socket;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? pc;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    await connectSocket();
    // await joinRoom();
  }

  Future connectSocket() async {
    socket = IO.io('http://i10a603.p.ssafy.io:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((data) => debugPrint('연결 완료 !'));

    socket.on('joined', (data) {
      _sendOffer();
    });

    socket.on('offer', (data) async {
      data = jsonDecode(data);
      await _gotOffer(RTCSessionDescription(data['sdp'], data['type']));

      await _sendAnswer();
    });

    socket.on('answer', (data) {
      data = jsonDecode(data);
      _gotAnswer(RTCSessionDescription(data['sdp'], data['type']));
    });

    socket.on('ice', (data) {
      data = jsonDecode(data);
      _gotIce(RTCIceCandidate(
          data['candidate'], data['sdpMid'], data['sdpMLineIndex']));
    });
  }

  // Future joinRoom() async {
  //   final config = {
  //     'iceServers': [
  //       {"url": "stun:stun.l.google.com:19302"},
  //     ]
  //   };

  //   final sdpConstraints = {
  //     'mandatory': {
  //       'OfferToReceiveAudio': true,
  //       'OfferToReceiveVideo': true,
  //     },
  //     'optional': []
  //   };

  //   pc = await createPeerConnection(config, sdpConstraints);

  //   final mediaConstraints = {
  //     'audio': true,
  //     'video': {'facingMode': 'user'}
  //   };

  //   _localStream = await Helper.openCamera(mediaConstraints);

  //   _localStream!.getTracks().forEach((track) {
  //     pc!.addTrack(track, _localStream!);
  //   });

  //   _localRenderer.srcObject = _localStream;

  //   pc!.onIceCandidate = (ice) {
  //     _sendIce(ice);
  //   };

  //   pc!.onAddStream = (stream) {
  //     _remoteRenderer.srcObject = stream;
  //   };

  //   socket.emit('join');
  // }

  Future _sendOffer() async {
    debugPrint('send offer');
    var offer = await pc!.createOffer();
    pc!.setLocalDescription(offer);
    socket.emit('offer', jsonEncode(offer.toMap()));
  }

  Future _gotOffer(RTCSessionDescription offer) async {
    debugPrint('got offer');
    pc!.setRemoteDescription(offer);
  }

  Future _sendAnswer() async {
    debugPrint('send answer');
    var answer = await pc!.createAnswer();
    pc!.setLocalDescription(answer);
    socket.emit('answer', jsonEncode(answer.toMap()));
  }

  Future _gotAnswer(RTCSessionDescription answer) async {
    debugPrint('got answer');
    pc!.setRemoteDescription(answer);
  }

  Future _sendIce(RTCIceCandidate ice) async {
    socket.emit('ice', jsonEncode(ice.toMap()));
  }

  Future _gotIce(RTCIceCandidate ice) async {
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
