import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/pages/signin_pages/splash_screen_page.dart';
import 'package:petcong/utils/firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(UserController()));

  setPathUrlStrategy(); // 리딩 해쉬 없이 웹 url을 생성

  // debugPrint(
  //     'Run with either `dart example/main.dart` or `dart --enable-asserts example/main.dart`.');
  // demo();
  runApp(const MyApp());
}

// var logger = Logger(
//   printer: PrettyPrinter(),
// );

// var loggerNoStack = Logger(
//   printer: PrettyPrinter(methodCount: 0),
// );

// void demo() {
//   logger.d('Log message with 2 methods');

//   loggerNoStack.i('Info message');

//   loggerNoStack.w('Just a warning!');

//   logger.e('Error! Something bad happened');

//   loggerNoStack.v({'key': 5, 'value': 'something'});

//   Logger(printer: SimplePrinter(colors: true)).v('boom');
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
