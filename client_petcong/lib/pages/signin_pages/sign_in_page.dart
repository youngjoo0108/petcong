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
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [_googleSignInButton()],
          ),
        ),
      ),
    );
  }

  Widget _googleSignInButton() {
    return Center(
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
    );
  }

  void _handleGoogleSignIn() async {
    if (!Platform.isAndroid) {
      try {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        FirebaseAuth.instance.signInWithProvider(googleAuthProvider);
      } catch (error) {
        print(error);
      }
    } else {
      try {
        final user = await UserController.loginWithGoogle();
        print(user);
        if (user != null && mounted) {
          print(mounted);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      } on FirebaseAuthException catch (error) {
        print(error.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message ?? "Something went wrong",
            ),
          ),
        );
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
          ),
        );
      }
    }
  }
}
