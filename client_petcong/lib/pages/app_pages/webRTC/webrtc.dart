import 'package:flutter/foundation.dart';
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
  RxInt? quizIdx = 0.obs;

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

  Future<void> closePeerConnection() async {
    await _pc!.close();
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
        if (kDebugMode) {
          print("exception = $exception");
        }
      }

      _pc!.onAddStream = (stream) {
        _remoteRenderer!.srcObject = stream;
      };

      // _localRenderer 세팅
      _localRenderer = RTCVideoRenderer();
      await _localRenderer!.initialize();

      final mediaConstraints = {
        'audio': true,
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
      if (kDebugMode) {
        print(exception);
      }
    }
  }

  @override
  MainVideoCallWidgetState createState() => MainVideoCallWidgetState();
}

class MainVideoCallWidgetState extends State<MainVideoCallWidget> {
  late double videoWidth = MediaQuery.of(context).size.width;
  late double videoHeight = MediaQuery.of(context).size.height;
  late double scaleValue = 0.5;
  late double localRendererX = videoWidth * (6 / 7);
  late double localRendererY = videoHeight / 20;
  RxBool showMessage = false.obs;
  RxBool isIdxChanged = false.obs;

  @override
  void initState() {
    super.initState();

    widget.quizIdx!.listen((_) {
      setState(() {
        if (!showMessage.value) {
          isIdxChanged.value = true;
        } else {
          isIdxChanged.value = false;
        }
      });
    });
  }
  // widget.quizIdx!.value = 0;}

  @override
  void dispose() {
    super.dispose();
  }

  // icebreakings
  List<String> quizs = [
    "당신의 반려견의 이름은 무엇인가요? 그 이름을 선택한 이유가 있나요?",
    '개인기 할 줄 아는거 있어요?',
    "당신의 반려견과 함께하는 평소의 하루는 어떻게 보내시나요? 특별한 루틴이 있나요?",
    "이름이 뭐에요? 왜 그렇게 지었어요?"
  ];

  void toggleMessageDialog() {
    if (showMessage.value == true) {
      showMessage.value = false;
    } else {
      isIdxChanged.value = false;
      showMessage.value = true;
    }
  }

  Future<void> disconnectCall() async {
    widget._localRenderer!.srcObject!.getTracks().forEach((track) {
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
        if (kDebugMode) {}
        return;
      }
      widget.quizIdx!.value++;
      if (kDebugMode) {}
      SocketService.sendMessage("idx", widget.quizIdx!.value.toString());
    });
  }

  void onIdxMinusBtnPressed() {
    setState(() {
      if (widget.quizIdx!.value <= 0) {
        widget.quizIdx!.value = 0;
        return;
      }
      widget.quizIdx!.value--;
      SocketService.sendMessage("idx", widget.quizIdx!.value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MainVideoCallWidget());
    Get.put(MainVideoCallWidgetState());
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
              minScale: 0.25,
              maxScale: 0.5,
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
                    child: Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        width: showMessage.value
                            ? MediaQuery.of(context).size.width
                            : 0.0,
                        child: showMessage.value
                            ? Container(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
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
                                        Icons.arrow_back_ios_new_rounded,
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Obx(
                                        () => Text(
                                          quizs.isNotEmpty &&
                                                  widget.quizIdx!.value >= 0 &&
                                                  widget.quizIdx!.value <
                                                      quizs.length
                                              ? quizs[widget.quizIdx!.value]
                                              : '질문이 끝났어요!',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Cafe24',
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: onIdxPlusBtnPressed,
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Obx(
                        () => Opacity(
                          opacity: showMessage.value ? 1.0 : 0.5,
                          child: FloatingActionButton(
                            onPressed: toggleMessageDialog,
                            heroTag: 'text',
                            backgroundColor: Colors.transparent,
                            // elevation: 2,
                            child: Image.asset(
                              'assets/src/petcong_c_logo.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Align(
                          alignment: Alignment.bottomRight,
                          child: Opacity(
                            opacity: isIdxChanged.value ? 1.0 : 0.0,
                            child: const Icon(
                              Icons.circle,
                              color: MyColor.petCongColor4,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // 통화 종료 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
