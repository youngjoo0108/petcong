// import 'dart:html';

// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petcong/controller/history_controller.dart';
import 'package:petcong/controller/match_card_controller.dart';
import 'package:petcong/controller/profile_controller.dart';
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
  List<String> selectedImages = [
    'assets/src/test_4.jpg',
    'assets/src/test_5.jpg',
    'assets/src/test_1.jpg',
    'assets/src/test_3.png',
    'assets/src/test_2.png',
    'Add Picture', // 마지막 요소를 'Add Picture' 텍스트로 설정
  ];

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(authentication.currentUser);
    _user.bindStream(authentication.userChanges());
    ever(_user, _moveToPage);
  }

  _moveToPage(User? user) {
    // TODO: Registered user goes to match page.
    if (user == null) {
      Get.offAll(() => const SignInPage());
    } else {
      HistoryController.to.onInit();
      MatchCardController.to.onInit();
      ProfileController.to.onInit();
      Get.offAll(() => const HomePage());
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

  void updateSelectedImage(int index, String newImage) {
    if (index >= 0 && index < 5) {
      // index가 5보다 작은 경우에만 업데이트
      selectedImages[index] = newImage;
      update();
    }
  }
}
