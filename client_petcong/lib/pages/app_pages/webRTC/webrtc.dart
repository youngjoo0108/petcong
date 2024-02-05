import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
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
  double localVideoLeft = 200.0;
  double localVideoTop = 50.0;
  double localVideoScale = 0.5;

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
      body: Center(
        child: Stack(
          children: [
            // Remote Video
            Positioned.fill(
              child: RTCVideoView(
                widget.remoteRenderer,
                mirror: false,
              ),
            ),
            // Local Video
            Positioned(
              // left: localVideoLeft,
              // top: localVideoTop,
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(double.infinity),
                minScale: 0.3,
                maxScale: 0.5,
                scaleEnabled: true,
                onInteractionUpdate: (details) {
                  setState(() {
                    localVideoLeft = details.localFocalPoint.dx;
                    localVideoTop = details.localFocalPoint.dy;
                    localVideoScale = details.scale;
                  });
                },
                child: SizedBox(
                  width: 200 * localVideoScale,
                  height: 400 * localVideoScale,
                  child: Positioned(
                    left: localVideoLeft,
                    top: localVideoTop,
                    child: RTCVideoView(
                      widget.localRenderer,
                      mirror: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
