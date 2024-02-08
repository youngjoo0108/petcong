import 'package:get/get.dart';
import 'package:petcong/models/profile_page_model.dart';
import 'package:petcong/services/user_service.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  Rx<ProfilePageModel> profile = ProfilePageModel().obs;

  void getProfile() async {
    getUserInfo().then((userInfo) {
      profile.value = userInfo;
    });
  }
}
