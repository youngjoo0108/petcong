import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcong/main.dart';
import 'package:petcong/pages/signin_pages/sign_in_page.dart';

class MainProfilePage extends StatefulWidget {
  const MainProfilePage({Key? key}) : super(key: key);

  @override
  State<MainProfilePage> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  Future<void> signOut(BuildContext context) async {
    try {
      print(mounted);
      await FirebaseAuth.instance.signOut();
      print("sign out");
      print(mounted);
      if (mounted) {
        print("sign out mounted");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
          (route) => false,
        );
      }
    } catch (error) {
      debugPrint('sign out failed $error');
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
              onPressed: () => {signOut(context)},
              // {
              //   // Navigator.push(
              //   //   context,
              //   //   MaterialPageRoute(builder: (context) => const MyAppContent()),
              //   // );
              // },
              child: const Text("로그아웃"),
            ),
          ],
        ),
      ),
    );
  }
}
