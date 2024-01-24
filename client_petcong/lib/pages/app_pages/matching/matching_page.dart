import 'package:flutter/material.dart';
import 'package:petcong/pages/app_pages/webRTC/webrtc.dart';

class MainMatchingPage extends StatelessWidget {
  const MainMatchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Matching Page"),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainVideoCall(),
                ),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    ));
  }
}
