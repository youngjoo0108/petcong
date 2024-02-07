class UserInfoModel {
  int? age;
  String? nickname;
  String? email;
  String? address;
  String? uid;
  String? instagramId;
  String? kakaoId;
  String? birthday;
  String? gender;
  String? status;
  String? preference;

  UserInfoModel(
      {this.age,
      this.nickname,
      this.email,
      this.address,
      this.uid,
      this.instagramId,
      this.kakaoId,
      this.birthday,
      this.gender,
      this.status,
      this.preference});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    nickname = json['nickname'];
    email = json['email'];
    address = json['address'];
    uid = json['uid'];
    instagramId = json['instagramId'];
    kakaoId = json['kakaoId'];
    birthday = json['birthday'];
    gender = json['gender'];
    status = json['status'];
    preference = json['preference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['age'] = age;
    data['nickname'] = nickname;
    data['email'] = email;
    data['address'] = address;
    data['uid'] = uid;
    data['instagramId'] = instagramId;
    data['kakaoId'] = kakaoId;
    data['birthday'] = birthday;
    data['gender'] = gender;
    data['status'] = status;
    data['preference'] = preference;
    return data;
  }
}
