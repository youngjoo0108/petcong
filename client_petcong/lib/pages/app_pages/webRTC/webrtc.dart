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
    return SafeArea(
      child: Scaffold(
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

              SizedBox(
                // width: MediaQuery.of(context).size.width * localVideoScale,
                // height: MediaQuery.of(context).size.height * localVideoScale,
                child: InteractiveViewer(
                  // width: videoWidth,
                  // height: videoHeight,
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  minScale: 0.3,
                  maxScale: 0.5,
                  scaleEnabled: true,
                  onInteractionUpdate: (details) {
                    setState(() {
                      localVideoLeft = details.localFocalPoint.dx;
                      localVideoTop = details.localFocalPoint.dy;
                      videoWidth =
                          MediaQuery.of(context).size.width * localVideoScale;

                      videoHeight =
                          MediaQuery.of(context).size.height * localVideoScale;
                      localVideoScale = details.scale;
                    });
                  },

                  // width: videoWidth,
                  // height: videoHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: RTCVideoView(
                      widget.localRenderer,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      mirror: true,
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
      ),
    );
  }
}
