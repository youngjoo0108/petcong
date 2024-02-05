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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['nickname'] = this.nickname;
    data['email'] = this.email;
    data['address'] = this.address;
    data['uid'] = this.uid;
    data['instagramId'] = this.instagramId;
    data['kakaoId'] = this.kakaoId;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['preference'] = this.preference;
    return data;
  }
}
