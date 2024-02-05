import 'package:petcong/models/pet_info_model.dart';
import 'package:petcong/models/user_info_model.dart';

class UserSignupModel {
  UserInfoModel userInfoModel;
  PetInfoModel petInfoModel;

  UserSignupModel({required this.userInfoModel, required this.petInfoModel});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userInfoModel'] = userInfoModel.toJson();
    data['petInfoModel'] = petInfoModel.toJson();
    return data;
  }
}
