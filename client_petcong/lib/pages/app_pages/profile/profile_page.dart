import 'package:flutter/material.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/pages/app_pages/profile/nickname_page.dart';
import 'package:petcong/pages/signin_pages/sign_in_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:petcong/widgets/create_button.dart';
import 'package:petcong/widgets/delete_button.dart';

class MainProfilePage extends StatelessWidget {
  const MainProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile Page"),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NicknamePage(
                            progress: 0.0)), // progress를 0으로 설정합니다.
                  );
                },
                child: const Text('Go to write profile')),
            ElevatedButton(
                onPressed: () {
                  UserController.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                      (route) => false);
                },
                child: const Text('log out')),
            const SizedBox(
              height: 30,
            ),
            const ContinueButton(
                isFilled: false, buttonText: "Continue"), // buttonText 추가
            const SizedBox(
              height: 30,
            ),
            const ContinueButton(
                isFilled: true, buttonText: "Continue"), // buttonText 추가
            const RoundGradientXButton(),
            const RoundGradientPlusButton(),
          ],
        ),
      ),
    );
  }
}
