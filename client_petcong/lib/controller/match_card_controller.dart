import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:petcong/models/card_profile_model.dart';
import 'package:petcong/models/profile_page_model.dart';
import 'package:petcong/services/matching_service.dart';
import 'package:petcong/services/user_service.dart';

class MatchCardController extends GetxController {
  static MatchCardController get to => Get.find();

  final Rx<DoubleLinkedQueue> _cardQueue =
      DoubleLinkedQueue.of(<CardProfileModel>[]).obs;

  final Rx<ProfilePageModel> _callWaitUser = ProfilePageModel().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fillQueue();
  }

  Future<void> getCardProfile() async {
    try {
      _cardQueue.value.add(await getProfile());
    } catch (e) {
      if (kDebugMode) {
        print("Error in getCardProfile: $e");
      }
    }
  }

  void removeCardProfile() {
    fillQueue();
    _cardQueue.value.removeFirst();
  }

  void nextCardProfile() {
    fillQueue();
    _cardQueue.value.add(_cardQueue.value.first);
    _cardQueue.value.removeFirst();
  }

  void getCallUser(int memberId) async {
    _callWaitUser.value = await getCallUserInfo(memberId);
  }

  Future<void> fillQueue() async {
    while (_cardQueue.value.length < 10) {
      await getCardProfile();
    }
  }

  Rx<DoubleLinkedQueue> getMatchingQue() {
    return _cardQueue;
  }

  Rx<ProfilePageModel> getCallWaitUser() {
    return _callWaitUser;
  }
}
