import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcong/pages/signin_pages/sign_in_page.dart';

class MainProfilePage extends StatefulWidget {
  const MainProfilePage({Key? key}) : super(key: key);

  @override
  State<MainProfilePage> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  void _handleSignOut(BuildContext context) async {
    BuildContext scaffoldContext = context; // Save the context outside async

    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) {
        Navigator.of(scaffoldContext).pushReplacement(
            MaterialPageRoute(builder: (context) => const SignInPage()));
      }
    } catch (error) {
      print("로그아웃 중 오류 발생: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("프로필 페이지"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _handleSignOut(context),
              child: const Text("로그아웃"),
            ),
          ],
        ),
      ),
    );
  }
}
