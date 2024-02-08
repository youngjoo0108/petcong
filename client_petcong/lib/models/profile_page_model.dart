// To parse this JSON data, do
//
//     final profilePageModel = profilePageModelFromJson(jsonString);

import 'dart:convert';

ProfilePageModel profilePageModelFromJson(String str) =>
    ProfilePageModel.fromJson(json.decode(str));

String profilePageModelToJson(ProfilePageModel data) =>
    json.encode(data.toJson());

class ProfilePageModel {
  MemberProfile? memberProfile;
  PetProfile? petProfile;

  ProfilePageModel({
    this.memberProfile,
    this.petProfile,
  });

  factory ProfilePageModel.fromJson(Map<String, dynamic> json) =>
      ProfilePageModel(
        memberProfile: json["memberProfile"] == null
            ? null
            : MemberProfile.fromJson(json["memberProfile"]),
        petProfile: json["petProfile"] == null
            ? null
            : PetProfile.fromJson(json["petProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "memberProfile": memberProfile?.toJson(),
        "petProfile": petProfile?.toJson(),
      };
}

class MemberProfile {
  MemberInfo? memberInfo;
  List<dynamic>? memberImgInfosList;

  MemberProfile({
    this.memberInfo,
    this.memberImgInfosList,
  });

  factory MemberProfile.fromJson(Map<String, dynamic> json) => MemberProfile(
        memberInfo: json["memberInfo"] == null
            ? null
            : MemberInfo.fromJson(json["memberInfo"]),
        memberImgInfosList: json["memberImgInfosList"] == null
            ? []
            : List<dynamic>.from(json["memberImgInfosList"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "memberInfo": memberInfo?.toJson(),
        "memberImgInfosList": memberImgInfosList == null
            ? []
            : List<dynamic>.from(memberImgInfosList!.map((x) => x)),
      };
}

class MemberInfo {
  int? age;
  String? nickname;
  String? email;
  String? address;
  String? uid;
  String? instagramId;
  String? kakaoId;
  List<int>? birthday;
  String? gender;
  String? status;
  String? preference;

  MemberInfo({
    this.age,
    this.nickname,
    this.email,
    this.address,
    this.uid,
    this.instagramId,
    this.kakaoId,
    this.birthday,
    this.gender,
    this.status,
    this.preference,
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) => MemberInfo(
        age: json["age"],
        nickname: json["nickname"],
        email: json["email"],
        address: json["address"],
        uid: json["uid"],
        instagramId: json["instagramId"],
        kakaoId: json["kakaoId"],
        birthday: json["birthday"] == null
            ? []
            : List<int>.from(json["birthday"]!.map((x) => x)),
        gender: json["gender"],
        status: json["status"],
        preference: json["preference"],
      );

  Map<String, dynamic> toJson() => {
        "age": age,
        "nickname": nickname,
        "email": email,
        "address": address,
        "uid": uid,
        "instagramId": instagramId,
        "kakaoId": kakaoId,
        "birthday":
            birthday == null ? [] : List<dynamic>.from(birthday!.map((x) => x)),
        "gender": gender,
        "status": status,
        "preference": preference,
      };
}

class PetProfile {
  PetInfo? petInfo;
  List<dynamic>? skillMultimediaInfoList;

  PetProfile({
    this.petInfo,
    this.skillMultimediaInfoList,
  });

  factory PetProfile.fromJson(Map<String, dynamic> json) => PetProfile(
        petInfo:
            json["petInfo"] == null ? null : PetInfo.fromJson(json["petInfo"]),
        skillMultimediaInfoList: json["skillMultimediaInfoList"] == null
            ? []
            : List<dynamic>.from(
                json["skillMultimediaInfoList"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "petInfo": petInfo?.toJson(),
        "skillMultimediaInfoList": skillMultimediaInfoList == null
            ? []
            : List<dynamic>.from(skillMultimediaInfoList!.map((x) => x)),
      };
}

class PetInfo {
  String? name;
  String? breed;
  int? age;
  String? gender;
  bool? neutered;
  String? size;
  int? weight;
  String? description;
  String? dbti;
  String? hobby;
  String? snack;
  String? toy;

  PetInfo({
    this.name,
    this.breed,
    this.age,
    this.gender,
    this.neutered,
    this.size,
    this.weight,
    this.description,
    this.dbti,
    this.hobby,
    this.snack,
    this.toy,
  });

  factory PetInfo.fromJson(Map<String, dynamic> json) => PetInfo(
        name: json["name"],
        breed: json["breed"],
        age: json["age"],
        gender: json["gender"],
        neutered: json["neutered"],
        size: json["size"],
        weight: json["weight"],
        description: json["description"],
        dbti: json["dbti"],
        hobby: json["hobby"],
        snack: json["snack"],
        toy: json["toy"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "breed": breed,
        "age": age,
        "gender": gender,
        "neutered": neutered,
        "size": size,
        "weight": weight,
        "description": description,
        "dbti": dbti,
        "hobby": hobby,
        "snack": snack,
        "toy": toy,
      };
}
