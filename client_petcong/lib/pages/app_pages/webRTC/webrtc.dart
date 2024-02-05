import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();

    // Initialize RTCVideoRenderer
    widget.localRenderer.initialize();
    widget.remoteRenderer.initialize();
  }

  @override
  void dispose() {
    // Dispose RTCVideoRenderer
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
              left: localVideoLeft,
              top: localVideoTop,
              child: GestureDetector(
                onPanUpdate: (info) {
                  setState(() {
                    localVideoLeft += info.delta.dx;
                    localVideoTop += info.delta.dy;
                  });
                },
                child: SizedBox(
                  width: 200,
                  height: 150,
                  child: RTCVideoView(
                    widget.localRenderer,
                    mirror: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SocketService().onCallPressed('off');
        },
        child: const Icon(Icons.call_end),
      ),
    );
  }
}
