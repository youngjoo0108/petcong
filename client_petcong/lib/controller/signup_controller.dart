import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcong/models/user_info_model.dart';
import 'package:petcong/models/user_signup_model.dart';
import 'package:petcong/pages/signin_pages/sign_in_page.dart';
import 'package:uuid/uuid.dart';

class SignupController extends GetxController {
  static SignupController get to => Get.find();

// =============      breederinfo      =============

  int? _age;
  String? _nickname;
  String? _email;
  String? _address;
  String? _uid;
  String? _instagramId;
  String? _kakaoId;
  String? _birthday;
  String? _gender;
  String? _status;
  String? _preference;

// =============      petinfo      =============

  String? _petName;
  String? _breed;
  String? _petGender;
  String? _size;
  String? _description;
  String? _dbti;
  String? _hobby;
  String? _snack;
  String? _toy;
  bool? _neutered;
  int? _weight;
  int? _petAge;



  addNickName(String nickname) {
    _nickname = nickname;
    update();
  }

  addBirthday(String birthday) {
    _birthday = birthday;
    update();
  }

  addAge(int age) {
    _age = age;
    update();
  }

  addGender(String gender) {
    _gender = gender;
    update();
  }




  signUPUser(BuildContext context) async {
    var uuid = const Uuid();
    String userId = uuid.v4();
  }
}
