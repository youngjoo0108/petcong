import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () async {
      // try {
      //   User? user = await FirebaseAuth.instance.authStateChanges().first;
      //   if (user != null) {
      //     Get.offAll(const HomePage());
      //   } else {
      //     Get.offAll(const SignInPage());
      //   }
      // } catch (error) {
      //   debugPrint(error.toString());
      // }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "It's PetCong not VietCong",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
