import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserModel extends Equatable {
  String? key;
  String? email;
  String? userId;
  String? displayName;
  String? userName;
  String? petName;
  String? profilePic;
  String? kakaoId;
  String? instagramId;
  List<String>? followersList;
  List<String>? followingList;

  UserModel(
      {this.key,
      this.email,
      this.userId,
      this.displayName,
      this.profilePic,
      this.kakaoId,
      this.instagramId,
      this.userName,
      this.followersList,
      this.followingList});

  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    followersList ??= [];
    email = map['email'];
    userId = map['userId'];
    displayName = map['displayName'];
    profilePic = map['profilePic'];
    key = map['key'];
    instagramId = map['instagramId'];
    kakaoId = map['kakaoId'];
    userName = map['userName'];
    if (map['followerList'] != null) {
      followersList = <String>[];
      map['followerList'].forEach((value) {
        followersList!.add(value);
      });
    }
    if (map['followingList'] != null) {
      followingList = <String>[];
      map['followingList'].forEach((value) {
        followingList!.add(value);
      });
    }
  }
  toJson() {
    return {
      'key': key,
      "userId": userId,
      "email": email,
      'displayName': displayName,
      'profilePic': profilePic,
      'kakaoId': kakaoId,
      'instagramId': instagramId,
      'userName': userName,
      'followerList': followersList,
      'followingList': followingList
    };
  }

  UserModel copyWith({
    String? email,
    String? userId,
    String? displayName,
    String? profilePic,
    String? key,
    String? kakaoId,
    String? instagramId,
    String? userName,
    List<String>? followingList,
    List<String>? followersList,
  }) {
    return UserModel(
      email: email ?? this.email,
      instagramId: instagramId ?? this.instagramId,
      kakaoId: kakaoId ?? this.kakaoId,
      displayName: displayName ?? this.displayName,
      key: key ?? this.key,
      profilePic: profilePic ?? this.profilePic,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      followersList: followersList ?? this.followersList,
      followingList: followingList ?? this.followingList,
    );
  }

  @override
  List<Object?> get props => [
        key,
        email,
        userId,
        displayName,
        userName,
        profilePic,
        kakaoId,
        instagramId,
        followersList,
        followingList
      ];
}
