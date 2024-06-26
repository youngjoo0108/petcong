import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/models/pet_info_model.dart';
import 'package:petcong/models/user_info_model.dart';
import 'package:petcong/models/user_signup_model.dart';
import 'package:petcong/services/matching_service.dart';
import 'package:petcong/services/user_service.dart';

class SignupController extends GetxController {
  static SignupController get to => Get.find();

  FirebaseAuth authentication = FirebaseAuth.instance;

// =============      breederinfo      =============
  String? nickname;
  String? birthday;
  int? age;
  String? gender;
  String? preference;
  String? email;
  String? address;
  String? instagramId;
  String? kakaoId;

// =============      petinfo      =============

  String? petName;
  String? breed;
  String? petGender;
  String? size;
  String? description;
  String? dbti;
  String? hobby;
  String? snack;
  String? toy;
  bool neutered = false;
  int? weight;
  int? petAge;

  addNickName(String nickName) {
    nickname = nickName;
    update();
  }

  addBirthdayAndAge(String userBirthday) {
    birthday = userBirthday;
    final birthDate = _convertToDate(userBirthday);
    final today = DateTime.now();
    int userAge = today.year - birthDate!.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      userAge--;
    }
    age = userAge;
    update();
  }

  addGender(String userGender) {
    gender = userGender;
    update();
  }

  addInstagram(String nickName) {
    nickname = nickName;
    update();
  }

  addBirthday(String userBirthday) {
    birthday = userBirthday;
    update();
  }

  addPetAge(int petage) {
    petAge = petage;
    update();
  }

  addPreference(String userPreference) {
    preference = userPreference;
    update();
  }

  // addAddress(String userAddress) {
  //   address = userAddress;
  //   update();
  // }

  addKakaoId(String userKakaoId) {
    kakaoId = userKakaoId;
    update();
  }

  addInstagramId(String userInstagramId) {
    instagramId = userInstagramId;
    update();
  }

  // addStatus(String userStatus) {
  //   status = userStatus;
  //   update();
  // }

  // addHobby(String petHobby) {
  //   hobby = petHobby;
  //   update();
  // }

  // addSnack(String petSnack) {
  //   snack = petSnack;
  //   update();
  // }

  // addToy(String petToy) {
  //   toy = petToy;
  //   update();
  // }

  // addWeight(int userWeight) {
  //   weight = userWeight;
  //   update();
  // }

  addDescription(String userDescription) {
    description = userDescription;
    update();
  }

  // addDbti(String petDbti) {
  //   dbti = petDbti;
  //   update();
  // }

  addPetName(String userPetName) {
    petName = userPetName;
    update();
  }

  // addBreed(String petBreed) {
  //   breed = petBreed;
  //   update();
  // }

  addPetGender(String userPetGender) {
    petGender = userPetGender;
    update();
  }

  addSize(String petSize) {
    size = petSize;
    update();
  }

  addNeutered(bool userNeutered) {
    neutered = userNeutered;
    update();
  }

  printUser() {
    debugPrint(nickname);
    debugPrint(birthday);
    debugPrint(age.toString());
    debugPrint(gender);
    debugPrint(preference);
    debugPrint(currentUser!.email);
    debugPrint(address);
    debugPrint(instagramId);
    debugPrint(kakaoId);
    debugPrint(petName);
    debugPrint(breed);
    debugPrint(petGender);
    debugPrint(size);
    debugPrint(description);
    debugPrint(dbti);
    debugPrint(hobby);
    debugPrint(snack);
    debugPrint(toy);
    debugPrint(neutered.toString());
    debugPrint(weight.toString());
    debugPrint(petAge.toString());
  }

  signUpUser(BuildContext context) async {
    UserInfoModel userModel = UserInfoModel(
      nickname: nickname,
      birthday: birthday,
      age: age,
      gender: gender,
      preference: preference,
      email: UserController.currentUser?.email,
      address: address,
      instagramId: instagramId,
      kakaoId: kakaoId,

      //TODO: needs to be removed
    );

    PetInfoModel petModel = PetInfoModel(
      name: petName,
      breed: breed,
      gender: petGender,
      size: size,
      description: description,
      dbti: dbti,
      hobby: hobby,
      snack: snack,
      toy: toy,
      neutered: neutered,
      weight: weight,
      age: petAge,
    );

    UserSignupModel model =
        UserSignupModel(userInfoModel: userModel, petInfoModel: petModel);
    if (kDebugMode) {
      print(model.toString());
    }

    postSignup(model);
  }

  DateTime? _convertToDate(String input) {
    try {
      List<String> dateParts = input.split('-');
      return DateTime.parse('${dateParts[0]}-${dateParts[1]}-${dateParts[2]}');
    } catch (e) {
      return null;
    }
  }
}
