import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petcong/pages/homepage.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

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

  // void _handleGoogleSignIn() {
  //   try {
  //     GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
  //     FirebaseAuth.instance.signInWithProvider(googleAuthProvider);
  //   } catch (error) {
  //     print(error);
  //   }
  // }
  void _handleGoogleSignIn() async {
    try {
      final user = await UserController.loginWithGoogle();
      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } on FirebaseAuthException catch (error) {
      print(error.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        error.message ?? "Something went wrong",
      )));
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        error.toString(),
      )));
    }
  }
}
