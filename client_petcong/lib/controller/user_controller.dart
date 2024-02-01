import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petcong/pages/homepage.dart';
import 'package:petcong/pages/signin_pages/sign_in_page.dart';
import 'package:petcong/services/socket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  late Rx<User?> _user;
  FirebaseAuth authentication = FirebaseAuth.instance;
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

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // await SocketService.init();
    await SocketService().disposeSocket();
  }
}
