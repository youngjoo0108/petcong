// import 'dart:html';

// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petcong/controller/history_controller.dart';
import 'package:petcong/controller/match_card_controller.dart';
import 'package:petcong/controller/profile_controller.dart';
import 'package:petcong/pages/app_pages/matching/matching_page.dart';
import 'package:petcong/pages/app_pages/profile/nickname_page.dart';
import 'package:petcong/pages/homepage.dart';
import 'package:petcong/pages/signin_pages/sign_in_page.dart';
import 'package:petcong/services/socket_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petcong/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  late Rx<User?> _user;
  FirebaseAuth authentication = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance; // Firestore 인스턴스 추가
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ProfileController profileController = Get.put(ProfileController());
  final HistoryController historyController = Get.put(HistoryController());
  final MatchCardController matchCardController =
      Get.put(MatchCardController());

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(authentication.currentUser);
    _user.bindStream(authentication.userChanges());
    ever(_user, _moveToPage);
  }

  _moveToPage(User? user) async {
    if (user == null) {
      Get.offAll(() => const SignInPage());
    } else {
      bool isSignedUP = await postSignin();
      if (isSignedUP) {
        HistoryController.to.onInit();
        const MainMatchingPage();
        await MatchCardController.to.onInit();
        ProfileController.to.onInit();
        Get.offAll(() => const HomePage());
      } else {
        Get.offAll(() => const NicknamePage(progress: 0.1));
      }
    }
  }

  static User? user = FirebaseAuth.instance.currentUser;

  static Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();
    final googleAuth = await googleAccount?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', userCredential.user!.uid);
    String? idToken = await userCredential.user!.getIdToken();
    prefs.setString('idToken', idToken ?? '');
    return userCredential.user;
  }

  static Future<void> signOut(String uid) async {
    await SocketService().disposeSocket(uid);
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  static Future<void> withdraw(String uid) async {
    withdrawUser();
    await SocketService().disposeSocket(uid);
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  static User? get currentUser => user;
}
