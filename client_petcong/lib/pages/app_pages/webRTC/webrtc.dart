import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:petcong/constants/style.dart';
import 'package:petcong/pages/homepage.dart';
import 'package:petcong/services/socket_service.dart';

class MainVideoCallWidget extends StatefulWidget {
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  RTCPeerConnection? pc;
  static late int quizIdx;

  MainVideoCallWidget({
    super.key,
    required this.localRenderer,
    required this.remoteRenderer,
    required this.pc,
  });

  @override
  _MainVideoCallWidgetState createState() => _MainVideoCallWidgetState();
}

class _MainVideoCallWidgetState extends State<MainVideoCallWidget> {
  late double videoWidth = MediaQuery.of(context).size.width;
  late double videoHeight = MediaQuery.of(context).size.height;
  late double scaleValue = 0.5;
  late double localRendererX = videoWidth * (6 / 7);
  late double localRendererY = videoHeight / 20;
  // late double test = 0;
  // icebreakings
  List<String> quizs = [
    "똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중똥싸는중",
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
    MainVideoCallWidget.quizIdx = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onIdxPlusBtnPressed() {
    setState(() {
      int maxIdx = quizs.length;
      if (MainVideoCallWidget.quizIdx >= maxIdx) {
        MainVideoCallWidget.quizIdx = maxIdx;
        print("===============index changed by me / max!!");
        return;
      }
      MainVideoCallWidget.quizIdx++;
      print(
          "===============index changed by me / index = ${MainVideoCallWidget.quizIdx}==");
      SocketService.sendMessage("idx", MainVideoCallWidget.quizIdx.toString());
    });
  }

  void onIdxMinusBtnPressed() {
    setState(() {
      if (MainVideoCallWidget.quizIdx <= 0) {
        MainVideoCallWidget.quizIdx = 0;
        print("===============index changed by me / max!!");
        return;
      }
      MainVideoCallWidget.quizIdx--;
      print(
          "===============index changed by me / index = ${MainVideoCallWidget.quizIdx}==");
      SocketService.sendMessage("idx", MainVideoCallWidget.quizIdx.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final TransformationController controller = TransformationController();
    controller.value = Matrix4.identity()
      ..scale(scaleValue)
      ..translate(localRendererX, localRendererY);
    return Scaffold(
      body: GestureDetector(
        onTapDown: (position) {
          print(position.globalPosition);
        },
        child: Stack(
          children: <Widget>[
            // 상대방 화면
            SizedBox.expand(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: RTCVideoView(
                  widget.remoteRenderer,
                  mirror: false,
                ),
              ),
            ),
            //  내 화면
            ClipRect(
              child: InteractiveViewer(
                transformationController: controller,
                minScale: 0.2,
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
                      widget.localRenderer,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      mirror: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: showMessage
                          ? MediaQuery.of(context).size.width - videoWidth / 3
                          : 0.0,
                      height: showMessage ? 50.0 : 0.0,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: showMessage
                          ? Container(
                              color: Colors.white.withOpacity(0.3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: onIdxMinusBtnPressed,
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded),
                                  ),
                                  Text(
                                    quizs.isNotEmpty &&
                                            MainVideoCallWidget.quizIdx >= 0 &&
                                            MainVideoCallWidget.quizIdx <
                                                quizs.length
                                        ? quizs[MainVideoCallWidget.quizIdx]
                                        : 'No quiz available',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
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
                    Opacity(
                      opacity: showMessage ? 1.0 : 0.2,
                      child: FloatingActionButton.small(
                        onPressed: _toggleMessageDialog,
                        heroTag: 'text',
                        child: const Icon(Icons.message),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 통화 종료 버튼
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () async {
                widget.localRenderer.srcObject!.getTracks().forEach((track) {
                  track.stop();
                });
                // disconnectCall 로직
                await widget.localRenderer.srcObject!.dispose();
                await widget.pc!.close();
                widget.pc = null;
                print(
                    "end btn.onPressed - localRederer.hashCode = ${widget.localRenderer.hashCode}");
                print(
                    "end btn.onPressed - remoteRenderer.hashCode = ${widget.remoteRenderer.hashCode}");
                await widget.localRenderer.dispose();
                await widget.remoteRenderer.dispose();
                // disconnect end
                SocketService().setCallPressed(false); // flag false로
                await Future.delayed(const Duration(seconds: 2));
                Get.offAll(const HomePage());
              },
              heroTag: 'stop_call_button',
              shape: const CircleBorder(),
              backgroundColor: MyColor.petCongColor4,
              elevation: 5,
              child: const Icon(Icons.call_end),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// floatingActionButton: Row(
//   children: [
//     FloatingActionButton(
//       onPressed: () async {
//         widget.localRenderer.srcObject!.getTracks().forEach((track) {
//           track.stop();
//         });
//         // disconnectCall 로직
//         await widget.localRenderer.srcObject!.dispose();
//         await widget.pc!.close();
//         widget.pc = null;
//         print(
//             "end btn.onPressed - localRederer.hashCode = ${widget.localRenderer.hashCode}");
//         print(
//             "end btn.onPressed - remoteRenderer.hashCode = ${widget.remoteRenderer.hashCode}");
//         await widget.localRenderer.dispose();
//         await widget.remoteRenderer.dispose();
//         // disconnect end
//         SocketService().setCallPressed(false); // flag false로
//         await Future.delayed(const Duration(seconds: 2));
//         Get.offAll(const HomePage());
//       },
//       heroTag: 'stop_call_button',
//       shape: const CircleBorder(eccentricity: 0),
//       backgroundColor: MyColor.petCongColor4,
//       child: const Icon(Icons.call_end),
//     ),
//     FloatingActionButton(
//       onPressed: onIdxbtnPressed,
//       shape: const CircleBorder(eccentricity: 0),
//       backgroundColor: Colors.blue,
//       heroTag: 'next_button',
//       child: const Icon(Icons.call_end),
//     ),
//   ],
// ),
// floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
