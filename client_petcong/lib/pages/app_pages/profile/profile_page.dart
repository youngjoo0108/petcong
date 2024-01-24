import 'package:flutter/material.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/pages/app_pages/profile/nickname_page.dart';
import 'package:petcong/pages/signin_pages/sign_in_page.dart';
// import 'package:petcong/constants/style.dart';
import 'package:petcong/widgets/continue_button.dart';

class MainProfilePage extends StatelessWidget {
  const MainProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Profile Page",
              style: TextStyle(
                fontSize: 40, // 여기에서 글자 크기를 조절합니다.
              ),
            ),
            const SizedBox(height: 50),
            ContinueButton(
              isFilled: true,
              buttonText: 'Go to write profile',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NicknamePage(
                          progress: 0.0)), // progress를 0으로 설정합니다.
                );
              },
            ),
            const SizedBox(height: 30),
            ContinueButton(
              isFilled: true,
              buttonText: 'Log out',
              onPressed: () {
                UserController.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                    (route) => false);
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
