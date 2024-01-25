import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petcong/controller/user_controller.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [
              Color.fromARGB(255, 240, 107, 100), // 우측 상단 색상
              Color.fromARGB(255, 255, 87, 143), // 좌측 상단 색상
            ],
          ),
        ),
        child: Center(
          child: GestureDetector(
            onTap: _handleGoogleSignIn,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // 그림자의 색상 및 투명도
                    spreadRadius: 2, // 그림자의 퍼짐 정도
                    blurRadius: 4, // 그림자의 흐림 정도
                    offset: const Offset(0, 2), // 그림자의 위치 (가로, 세로)
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/src/google_logo.png',
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Sign in with Google",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    User? user = await FirebaseAuth.instance.authStateChanges().first;
    try {
      if (user == null) {
        if (kIsWeb) {
          GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
          await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);
        } else {
          await UserController.loginWithGoogle();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
