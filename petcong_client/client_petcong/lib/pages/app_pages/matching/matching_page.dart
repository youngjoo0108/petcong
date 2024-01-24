import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

class MainMatchingPage extends StatelessWidget {
  const MainMatchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("Matching Page"),
            ElevatedButton(
                onPressed: () {
                  Get.to(WebRTC());
                },
                child: const Text('Call'))
          ],
        ),
      ),
    );
  }
}
