import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      FirebaseAuth.instance.signInWithProvider(googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}
