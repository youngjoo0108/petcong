import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/constants/style.dart';
import 'package:petcong/controller/call_wait_controller.dart';
import 'package:petcong/pages/app_pages/webRTC/webrtc.dart';
import 'package:petcong/pages/homepage.dart';
import 'package:petcong/services/socket_service.dart';
import 'package:slidable_button/slidable_button.dart';

class CallWaiting extends StatelessWidget {
  final SocketService? socketService;
  final MainVideoCallWidget
      mainVideoCallWidget; // 통화 대기화면 올 때마다, not null인 MainVideoCallWidget 받음
  const CallWaiting(this.socketService, this.mainVideoCallWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MixinBuilder<CardWaitController>(builder: (controller) {
          String profileUrl = controller.cardProfile.value.profileImageUrls![0];
          String partnerNickname = controller.cardProfile.value.nickname;
          return Stack(children: [
            Image.network(
              profileUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        '$partnerNickname님과 ',
                        style: const TextStyle(
                          fontFamily: 'Cafe24',
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '매치됐습니다!',
                        style: TextStyle(
                          fontFamily: 'Cafe24',
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 10,
              left: MediaQuery.of(context).size.width / 6,
              child: HorizontalSlidableButton(
                initialPosition: SlidableButtonPosition.center,
                autoSlide: false,
                width: MediaQuery.of(context).size.width * (2 / 3),
                height: 60,
                buttonWidth: 60.0,
                color: Colors.white.withOpacity(0.3),
                buttonColor: MyColor.myColor4,
                dismissible: false,
                label: const Center(
                  child: Icon(Icons.call),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Call',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                onChanged: (position) async {
                  if (position == SlidableButtonPosition.start) {
                    socketService!.onCallPressed();
                  } else {
                    mainVideoCallWidget.closePeerConnection();
                    Get.offAll(const HomePage());
                  }
                },
              ),
            ),
          ]);
        }),
      ),
    );
  }
}
