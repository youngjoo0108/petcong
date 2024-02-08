import 'package:flutter/material.dart';
import 'package:petcong/services/socket_service.dart';

class CallWaiting extends StatelessWidget {
  const CallWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            SocketService().startCamera();
          },
          child: const Text('call'),
        ),
      ),
    );
  }
}
