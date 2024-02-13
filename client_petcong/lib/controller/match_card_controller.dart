import 'dart:collection';

import 'package:get/get.dart';
import 'package:petcong/models/card_profile_model.dart';
import 'package:petcong/services/matching_service.dart';

class MatchCardController extends GetxController {
  static MatchCardController get to => Get.find();

  final Rx<DoubleLinkedQueue> _cardQueue =
      DoubleLinkedQueue.of(<CardProfileModel>[]).obs;

  @override
  void onInit() {
    super.onInit();
    fillQueue();
  }

  Future<void> getCardProfile() async {
    try {
      _cardQueue.value.add(await getProfile());
    } catch (e) {
      print("Error in getCardProfile: $e");
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

  Future<void> fillQueue() async {
    while (_cardQueue.value.length < 3) {
      await getCardProfile();
    }
  }
}
