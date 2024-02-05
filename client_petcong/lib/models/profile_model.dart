class ProfileModel {
  late int userId;
  late int age;
  late String nickname;
  late String gender;
  late String petName;
  late String petGender;
  late int petAge;
  String? description;
  List<String>? pictureUrls;

  ProfileModel(
      {required this.userId,
      required this.age,
      required this.nickname,
      required this.gender,
      required this.petName,
      required this.petGender,
      required this.petAge,
      this.description,
      this.pictureUrls});

  ProfileModel.fromJson(Map<String, dynamic> map) {
    userId = map['userId'];
    age = map['age'];
    nickname = map['nickname'];
    gender = map['gender'];
    petName = map['petName'];
    petGender = map['petGender'];
    petAge = map['petAge'];
    description = description != null ? map['description'] : '';
    pictureUrls = pictureUrls != null ? map['pictureUrls'] : [];
  }

  List<Object?> get props => [
        userId,
        age,
        nickname,
        gender,
        petName,
        petGender,
        petAge,
        description,
        pictureUrls
      ];
}
