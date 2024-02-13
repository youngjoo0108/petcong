import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:petcong/constants/style.dart';
import 'package:petcong/pages/homepage.dart';
import 'package:petcong/services/socket_service.dart';
import 'package:stomp_dart_client/stomp.dart';

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
  // icebreakings
  List<String> quizs = ["sampleQuiz1", "sampleQuiz2", "sampleQuiz3"];
  @override
  void initState() {
    super.initState();
    MainVideoCallWidget.quizIdx = 0;
    // Initialize RTCVideoRenderer
    // widget.localRenderer.initialize();
    // widget.remoteRenderer.initialize();
    print("===============in webrtc page, renderers initialized");
  }

  @override
  void dispose() {
    // widget.localRenderer.dispose();
    // widget.remoteRenderer.dispose();
    print("===============in webrtc page, renderers disposed");

    super.dispose();
  }

  void onIdxbtnPressed() {
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
  }

  @override
  Widget build(BuildContext context) {
    final TransformationController controller = TransformationController();
    controller.value = Matrix4.identity()..scale(0.5);
    return Scaffold(
      body: Stack(
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
              minScale: 0.3,
              maxScale: 0.5,
              constrained: true,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              child: SizedBox(
                width: videoWidth,
                height: videoHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: RTCVideoView(
                    widget.localRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    mirror: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // 통화 종료 버튼
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
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
            shape: const CircleBorder(eccentricity: 0),
            backgroundColor: MyColor.petCongColor4,
            child: const Icon(Icons.call_end),
          ),
          FloatingActionButton(
            onPressed: onIdxbtnPressed,
            shape: const CircleBorder(eccentricity: 0),
            backgroundColor: Colors.blue,
            heroTag: 'next_button',
            child: const Icon(Icons.call_end),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
