import 'package:get/get.dart';
import 'package:petcong/models/profile_page_model.dart';
import 'package:petcong/services/user_service.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  Rx<ProfilePageModel> profile = ProfilePageModel().obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  void getProfile() async {
    getUserInfo().then((userInfo) {
      print("getProfile successful");
      print(userInfo);
      profile.value = userInfo;
    });
  }
}
