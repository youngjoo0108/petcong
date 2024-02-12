// import 'dart:html';

// import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  List<String> selectedImages = [
    'assets/src/test_4.jpg',
    'assets/src/test_5.jpg',
    'assets/src/test_1.jpg',
    'assets/src/test_3.png',
    'assets/src/test_2.png',
    'Add Picture', // 마지막 요소를 'Add Picture' 텍스트로 설정
  ];

  // 사용자 정보를 저장할 변수들 추가
  String nickname = '';
  String birthday = '';
  String introText = 'Your Text Here';
  String photoUrl = ''; // Add this line
  int age = 0; // 만 나이를 저장할 변수 추가
  String petHobby = ''; // 반려견 취미 저장 변수
  String favoriteSnack = ''; // 최애 간식 저장 변수

  final ImagePicker _picker = ImagePicker();

  int calculateAge() {
    if (birthday.isEmpty) return 0;
    final birthDate = DateTime.parse(birthday);
    final currentDate = DateTime.now();

    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  void updateIntroText(String newIntroText) {
    introText = newIntroText;
    update(); // GetX 컨트롤러를 업데이트하여 UI를 다시 빌드합니다.
  }

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

  Future<void> pickImageFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      photoUrl = photo.path;
      update();
    }
  }

  Future<void> takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      photoUrl = photo.path;
      update();
    }
  }

  void updateNickname(String newNickname) {
    nickname = newNickname;
    firestore.collection('users').doc(_user.value?.uid).update({
      'nickname': nickname,
    });
  }

  void updateSelectedImage(int index, String newImage) {
    if (index >= 0 && index < 5) {
      // index가 5보다 작은 경우에만 업데이트
      selectedImages[index] = newImage;
      update();
    }
  }
}
