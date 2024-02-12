import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:petcong/constants/style.dart';
import 'package:petcong/pages/homepage.dart';
import 'package:petcong/services/socket_service.dart';

class MainVideoCallWidget extends StatefulWidget {
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;

  const MainVideoCallWidget(
      {super.key, required this.localRenderer, required this.remoteRenderer});

  @override
  _MainVideoCallWidgetState createState() => _MainVideoCallWidgetState();
}

class _MainVideoCallWidgetState extends State<MainVideoCallWidget> {
  late double videoWidth = MediaQuery.of(context).size.width;
  late double videoHeight = MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    // Initialize RTCVideoRenderer
    widget.localRenderer.initialize();
    widget.remoteRenderer.initialize();
    print("===============in webrtc page, renderers initialized");
  }

  @override
  void dispose() {
    widget.localRenderer.dispose();
    widget.remoteRenderer.dispose();
    print("===============in webrtc page, renderers disposed");

    super.dispose();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          widget.localRenderer.srcObject!.getTracks().forEach((track) {
            track.stop();
          });
          await SocketService().disconnectCall();
          SocketService().setCallPressed(false); // flag false로
          await Future.delayed(const Duration(seconds: 2));
          Get.offAll(const HomePage());
        },
        shape: const CircleBorder(eccentricity: 0),
        backgroundColor: MyColor.petCongColor4,
        child: const Icon(Icons.call_end),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
