import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:petcong/constants/style.dart';
import 'package:petcong/pages/homepage.dart';
import 'package:petcong/services/socket_service.dart';

class MainVideoCallWidget extends StatefulWidget {
  // rtc 관련 변수들은, 한번 할당된 후 페이지가 있는 동안 바뀔 일 없음
  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? _remoteRenderer;
  RTCPeerConnection? _pc;
  MediaStream? _localStream;
  List<RTCIceCandidate>? _iceCandidates;
  RxInt? quizIdx = RxInt(0);

  MainVideoCallWidget({
    super.key,
  });

  Future<void> init() async {
    await initPeerConnection();
  }

  List<RTCIceCandidate> getIceCandidates() {
    return _iceCandidates!;
  }

  void addCandidate(RTCIceCandidate ice) {
    _pc!.addCandidate(ice);
  }

  Future<void> initPeerConnection() async {
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

    _pc = await createPeerConnection(config, sdpConstraints);
  }

  Future<RTCSessionDescription> createOffer() async {
    return _pc!.createOffer();
  }

  Future<RTCSessionDescription> createAnswer() async {
    return _pc!.createAnswer({});
  }

  Future<void> setLocalDescription(RTCSessionDescription description) async {
    _pc!.setLocalDescription(description);
  }

  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    _pc!.setRemoteDescription(description);
  }

  Future joinRoom() async {
    _iceCandidates = [];
    try {
      _pc!.onIceCandidate = (ice) {
        _iceCandidates!.add(ice);
      };

      // _remoteRenderer 세팅
      _remoteRenderer = RTCVideoRenderer();
      try {
        await _remoteRenderer!.initialize();
      } catch (exception) {
        print("exception = $exception");
      }

      _pc!.onAddStream = (stream) {
        _remoteRenderer!.srcObject = stream;
      };

      // _localRenderer 세팅
      _localRenderer = RTCVideoRenderer();
      await _localRenderer!.initialize();

      final mediaConstraints = {
        'audio': false,
        'video': {'facingMode': 'user'}
      };

      _localStream = await Helper.openCamera(mediaConstraints);

      // (화면에 띄울) _localRenderer의 데이터 소스를 내 _localStream으로 설정
      _localRenderer!.srcObject = _localStream;

      // 스트림의 트랙(카메라 정보가 들어오는 연결)을 peerConnection(정보를 전송할 connection)에 추가
      _localStream!.getTracks().forEach((track) {
        _pc!.addTrack(track, _localStream!);
      });

      await Future.delayed(const Duration(seconds: 1));
    } catch (exception) {
      print(exception);
    }
  }

  @override
  _MainVideoCallWidgetState createState() => _MainVideoCallWidgetState();
}

class _MainVideoCallWidgetState extends State<MainVideoCallWidget> {
  late double videoWidth = MediaQuery.of(context).size.width;
  late double videoHeight = MediaQuery.of(context).size.height;
  late double scaleValue = 0.5;
  late double localRendererX = videoWidth * (6 / 7);
  late double localRendererY = videoHeight / 20;

  // icebreakings
  List<String> quizs = [
    // "똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중",
    '1',
    "sampleQuiz2",
    "sampleQuiz3"
  ];
  bool showMessage = false;

  void _toggleMessageDialog() {
    setState(() {
      showMessage = !showMessage;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.quizIdx);
    print(widget.quizIdx!.value);
    widget.quizIdx!.value = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> disconnectCall() async {
    widget._localRenderer!.srcObject!.getTracks().forEach((track) {
      track.stop();
    });
    widget._remoteRenderer!.srcObject!.getTracks().forEach((track) {
      track.stop();
    });

    widget._localRenderer!.srcObject = null;
    widget._remoteRenderer!.srcObject = null;
    widget._pc!.close();

    widget._localRenderer = null;
    widget._remoteRenderer = null;
    // disconnect end
    SocketService().setCallPressed(false); // flag false로
    SocketService().disposeSocket(SocketService.uid);
    await Future.delayed(const Duration(seconds: 2));
  }

  void onIdxPlusBtnPressed() {
    setState(() {
      int maxIdx = quizs.length;
      if (widget.quizIdx!.value >= maxIdx) {
        widget.quizIdx!.value = maxIdx;
        print("===============index changed by me / max!!");
        return;
      }
      widget.quizIdx!.value++;
      print(
          "===============index changed by me / index = ${widget.quizIdx!.value}==");
      SocketService.sendMessage("idx", widget.quizIdx!.value.toString());
    });
  }

  void onIdxMinusBtnPressed() {
    setState(() {
      if (widget.quizIdx!.value <= 0) {
        widget.quizIdx!.value = 0;
        print("===============index changed by me / max!!");
        return;
      }
      widget.quizIdx!.value--;
      print(
          "===============index changed by me / index = ${widget.quizIdx!.value}==");
      SocketService.sendMessage("idx", widget.quizIdx!.value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final TransformationController controller = TransformationController();
    controller.value = Matrix4.identity()
      ..scale(scaleValue)
      ..translate(localRendererX, localRendererY);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 상대방 화면
          SizedBox.expand(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: RTCVideoView(
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                widget._remoteRenderer!,
                mirror: false,
              ),
            ),
          ),
          //  내 화면
          ClipRect(
            child: InteractiveViewer(
              transformationController: controller,
              minScale: 0.3,
              maxScale: 1,
              constrained: true,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              onInteractionStart: (details) {},
              onInteractionUpdate: (details) {
                scaleValue = controller.value.getMaxScaleOnAxis();
                localRendererX =
                    controller.value.getTranslation().x / scaleValue;
                localRendererY =
                    controller.value.getTranslation().y / scaleValue;
              },
              child: SizedBox(
                width: videoWidth,
                height: videoHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: RTCVideoView(
                    widget._localRenderer!,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    mirror: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: AnimatedContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      duration: const Duration(milliseconds: 200),
                      width: showMessage
                          ? MediaQuery.of(context).size.width - videoWidth / 3
                          : 0.0,
                      // height: showMessage ? 50.0 : 0.0,
                      child: showMessage
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.3),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: onIdxMinusBtnPressed,
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      quizs.isNotEmpty &&
                                              widget.quizIdx!.value >= 0 &&
                                              widget.quizIdx!.value <
                                                  quizs.length
                                          ? quizs[widget.quizIdx!.value]
                                          : 'No quiz available',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: onIdxPlusBtnPressed,
                                    icon: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ],
                              ),
                            )
                          : null,
                    ),
                  ),
                  Opacity(
                    opacity: showMessage ? 1.0 : 0.2,
                    child: FloatingActionButton(
                      onPressed: _toggleMessageDialog,
                      heroTag: 'text',
                      backgroundColor: Colors.transparent, // 배경색을 투명으로 설정합니다.
                      elevation: 5,
                      child: Image.asset(
                        'assets/src/petcong_c_logo.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ), // 그림자의 높이를 0으로 설정하여 그림자를 없앱니다.
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            // 통화 종료 버튼
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: () async {
                  await disconnectCall(); // 다 꺼지면 이동
                  Get.offAll(const HomePage());
                },
                heroTag: 'stop_call_button',
                shape: const CircleBorder(),
                backgroundColor: MyColor.petCongColor4,
                elevation: 3,
                child: const Icon(Icons.call_end),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
