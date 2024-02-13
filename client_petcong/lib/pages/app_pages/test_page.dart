import 'package:flutter/material.dart';
import 'package:petcong/services/user_service.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Button')),
        body: Center(
          child: ElevatedButton(
            child: const Text("press"),
            onPressed: () {
              // ignore: avoid_print
              print("button pressed");
              print(getIdToken());
            },
          ),
        ));
  }
}
