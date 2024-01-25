import 'package:flutter/material.dart';
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
                  Get.to(const MainMatchingPage());
                },
                child: const Text('Call'))
          ],
        ),
      ),
    );
  }
}
