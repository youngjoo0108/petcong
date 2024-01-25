import 'package:flutter/material.dart';

class MainChatPage extends StatelessWidget {
  const MainChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Chat Page",
          style: TextStyle(fontSize: 36.0),
        ),
      ),
    );
  }
}
