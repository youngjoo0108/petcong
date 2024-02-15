import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/constants/style.dart';
import 'package:petcong/pages/app_pages/matching/matching_page.dart';
import 'package:petcong/pages/app_pages/webRTC/webrtc.dart';
import 'package:petcong/services/socket_service.dart';

class CallWaiting extends StatelessWidget {
  final SocketService? socketService;
  final MainVideoCallWidget
      mainVideoCallWidget; // 통화 대기화면 올 때마다, not null인 MainVideoCallWidget 받음
  const CallWaiting(this.socketService, this.mainVideoCallWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       SocketService().startCamera();
      //     },
      //     child: const Text('call'),
      //   ),
      // ),
      body: Center(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              'assets/src/fatdog-dog-unscreen.gif',
            )),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width / 4,
            child: FloatingActionButton(
              heroTag: 'call_button',
              onPressed: () async {
                // socketService!
                //     .onCallPressed('on'); // 통화대기화면 call버튼 -> rtc 연결 시작 ~ 화면 on
                socketService!.onCallPressed();
              },
              shape: const CircleBorder(eccentricity: 0),
              backgroundColor: MyColor.myColor1,
              child: const Icon(Icons.call),
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width / 5,
            child: FloatingActionButton(
              heroTag: 'call_reject_button',
              onPressed: () async {
                await mainVideoCallWidget.closePeerConnection();
                Get.to(const MainMatchingPage());
              },
              shape: const CircleBorder(eccentricity: 0),
              backgroundColor: MyColor.petCongColor4,
              child: const Icon(Icons.call_end),
            ),
          ),
        ],
      ),
    );
  }
}
