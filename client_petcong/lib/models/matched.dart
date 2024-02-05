import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class MatchedUser extends Equatable {
  String? key;
  String? email;
  String? userId;
  String? displayName;
  String? userName;
  String? profilePic;
  String? kakaoId;
  String? instagramId;

  MatchedUser(
      {this.email,
      this.userId,
      this.displayName,
      this.profilePic,
      this.key,
      this.kakaoId,
      this.instagramId,
      this.userName,

});

  MatchedUser.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    email = map['email'];
    userId = map['userId'];
    displayName = map['displayName'];
    profilePic = map['profilePic'];
    key = map['key'];
    instagramId = map['instagramId'];
    kakaoId = map['kakaoId'];
    userName = map['userName'];
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
    };
  }

  MatchedUser copyWith({
    String? email,
    String? userId,
    String? displayName,
    String? profilePic,
    String? key,
    String? kakaoId,
    String? instagramId,
    String? userName,
  }) {
    return MatchedUser(
      email: email ?? this.email,
      instagramId: instagramId ?? this.instagramId,
      kakaoId: kakaoId ?? this.kakaoId,
      displayName: displayName ?? this.displayName,
      key: key ?? this.key,
      profilePic: profilePic ?? this.profilePic,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
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
      ];
}
