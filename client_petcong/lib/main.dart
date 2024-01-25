import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/pages/signin_pages/sign_in_page.dart';
import 'package:petcong/pages/signin_pages/splash_screen_page.dart';
import 'package:petcong/utils/firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(UserController()));

  setPathUrlStrategy(); // 리딩 해쉬 없이 웹 url을 생성

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: SplashScreen(
        child: SignInPage(),
      ),
    );
  }
}
