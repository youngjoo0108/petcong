import 'package:get/get.dart';
import 'package:petcong/models/profile_model.dart';
import 'package:petcong/services/matching_service.dart';

class HistoryController extends GetxController {
  static HistoryController get to => Get.find();

  var matched_users = <ProfileModel>[].obs;

  void getMatchedUsers() async {
    getMatchList().then((profileList) {
      matched_users.clear();
      matched_users.addAll(profileList);
    });
  }
}
