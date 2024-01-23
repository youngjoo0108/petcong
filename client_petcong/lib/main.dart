import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petcong/pages/signin_pages/sign_in_page.dart';
import 'package:petcong/pages/signin_pages/splash_screen_page.dart';
import 'package:petcong/utils/firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  debugPrint("before WidgetFlutterBinding");
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("before initialization");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("after initializing");

  setPathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(
        child: SignInPage(),
      ),
    );
  }
}
