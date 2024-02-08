import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:petcong/pages/homepage.dart';

class MainVideoCallWidget extends StatefulWidget {
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  const MainVideoCallWidget(
      {super.key, required this.localRenderer, required this.remoteRenderer});

  @override
  _MainVideoCallWidgetState createState() => _MainVideoCallWidgetState();
}

class _MainVideoCallWidgetState extends State<MainVideoCallWidget> {
  double localVideoScale = 1;
  late double videoWidth = MediaQuery.of(context).size.width * localVideoScale;
  late double videoHeight =
      MediaQuery.of(context).size.height * localVideoScale;

  @override
  void initState() {
    super.initState();

    // Initialize RTCVideoRenderer
    widget.localRenderer.initialize();
    widget.remoteRenderer.initialize();
  }

  @override
  void dispose() {
    widget.localRenderer.dispose();
    widget.remoteRenderer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: RTCVideoView(
                  widget.remoteRenderer,
                  mirror: false,
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * (5 / 8),
            top: MediaQuery.of(context).size.height / 25,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 3,
              child: Positioned(
                left: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height / 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          widget.localRenderer.srcObject!.getTracks().forEach((track) {
            track.stop();
          });
          await Future.delayed(const Duration(seconds: 2));
          Get.offAll(const HomePage());
        },
        child: const Icon(Icons.call_end),
      ),
    );
  }
}
