import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:petcong/models/profile_page_model.dart';
import 'package:petcong/services/user_service.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  Rx<ProfilePageModel> profile = ProfilePageModel().obs;
  String introText = '';
  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  void getProfile() async {
    try {
      var userInfo = await getUserInfo();
      if (kDebugMode) {
        print("getProfile successful: $userInfo");
      }
      profile.value = userInfo;
    } catch (e) {
      if (kDebugMode) {
        print("Error in getProfile: $e");
      }
    }
  }

  void updateIntroText(String newIntroText) {
    introText = newIntroText;
    update(); // GetX 컨트롤러를 업데이트하여 UI를 다시 빌드합니다.
  }
}
