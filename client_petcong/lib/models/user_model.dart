class UserModel {
  int? userId;
  int? age;
  bool? callable;
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

  UserModel(
      {this.userId,
      this.age,
      this.callable,
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

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    age = json['age'];
    callable = json['callable'];
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
    data['userId'] = userId;
    data['age'] = age;
    data['callable'] = callable;
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
