import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/models/card_profile_model.dart';
import 'package:petcong/services/matching_service.dart';

class HistoryController extends GetxController {
  static HistoryController get to => Get.find();

  RxList<CardProfileModel> matchedUsers = <CardProfileModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    getMatchedUsers();
  }

  void getMatchedUsers() async {
    debugPrint("getMatchedUsers function called");
    getMatchList().then((profileList) {
      matchedUsers.clear();
      matchedUsers.addAll(profileList);
    });
  }
}
