import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ChoiceRes extends Equatable {
  String? targetLink;
  String? profileImgUrl;
  List<String>? questions;

  ChoiceRes({this.targetLink, this.profileImgUrl, this.questions});

  ChoiceRes.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    targetLink = map['targetLink'];
    profileImgUrl = map['profileImgUrl'];
    if (map['questions'] != null) {
      questions = <String>[];
      map['questions'].forEach((value) {
        questions!.add(value);
      });
    }
  }
  toJson() {
    return {
      'targetLink': targetLink,
      'profileImgUrl': profileImgUrl,
      'questions': questions,
    };
  }

  @override
  List<Object?> get props => [
        targetLink,
        profileImgUrl,
        questions,
      ];
}
