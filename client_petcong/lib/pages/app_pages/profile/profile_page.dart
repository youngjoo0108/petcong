import 'package:flutter/material.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/pages/app_pages/profile/pet_name_page.dart';
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
                        builder: (context) => const PetNamePage()),
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
            const ContinueButton(isFilled: false),
            const SizedBox(
              height: 30,
            ),
            const ContinueButton(isFilled: true),
            const RoundGradientXButton(),
            const RoundGradientPlusButton(),
          ],
        ),
      ),
    );
  }
}
