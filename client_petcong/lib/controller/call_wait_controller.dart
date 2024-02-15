import 'package:get/get.dart';
import 'package:petcong/models/card_profile_model.dart';

class CardWaitController extends GetxController {
  static CardWaitController get to => Get.find();

  Rx<CardProfileModel> cardProfile = CardProfileModel(
          memberId: -1,
          age: -1,
          nickname: '',
          gender: '',
          petName: '',
          petGender: '',
          petAge: -1)
      .obs;

  void setCardProfile(CardProfileModel newCardProfile) {
    cardProfile.value = newCardProfile;
  }
}
