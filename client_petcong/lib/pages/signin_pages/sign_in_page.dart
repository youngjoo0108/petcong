import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/pages/homepage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google SignIn"),
      ),
      body: Center(
        child: SizedBox(
          height: 50,
          child: GestureDetector(
            onTap: _handleGoogleSignIn,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Sign up with Google",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    if (true) {
      try {
        User? user = await FirebaseAuth.instance.authStateChanges().first;
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          if (Platform.isAndroid) {
            await UserController.loginWithGoogle();
          } else {
            GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
            await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } catch (error) {
        print(error);
      }
    }
  }
}
