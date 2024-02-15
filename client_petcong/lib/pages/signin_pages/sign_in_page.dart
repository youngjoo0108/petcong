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
            colors: [Color(0xFFFFBD98), Color(0xFFF9715F)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/src/petcong_c.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    // const SizedBox(height: 10),
                    // Image.asset(
                    //   'assets/src/가로형-사이즈맞춤.png',
                    //   width: 200,
                    //   fit: BoxFit.contain,
                    // )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: _handleGoogleSignIn,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
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
          ],
        ),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);
      } else {
        await UserController.loginWithGoogle();
      }
      debugPrint("User:  ${FirebaseAuth.instance.currentUser?.getIdToken()}");
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
