class Member {
  int memberId;
  int age;
  bool callable;
  String nickname;
  String email;
  String? address;
  String? instagramId;
  String? kakaoId;
  String uid;
  List<int> birthday;
  String gender;
  String status;
  String? preference;
  List<Image>? memberImgList;
  List<SkillMultimedia>? skillMultimediaList;
  Pet pet;

  Member({required this.memberId, required this.age, required this.callable, required this.nickname, required this.email, required this.address, this.instagramId, this.kakaoId, required this.uid, required this.birthday, required this.gender, required this.status, this.preference, this.memberImgList, this.skillMultimediaList, required this.pet});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['memberId'],
      age: json['age'],
      callable: json['callable'],
      nickname: json['nickname'],
      email: json['email'],
      address: json['address'],
      instagramId: json['instagramId'],
      kakaoId: json['kakaoId'],
      uid: json['uid'],
      birthday: List<int>.from(json['birthday']),
      gender: json['gender'],
      status: json['status'],
      preference: json['preference'],
      memberImgList: (json['memberImgList'] as List).map((i) => Image.fromJson(i)).toList(),
      skillMultimediaList: (json['skillMultimediaList'] as List).map((i) => SkillMultimedia.fromJson(i)).toList(),
      pet: Pet.fromJson(json['pet']),
    );
  }
}

class Image {
  int imgId;
  int? ordinal;
  int? length;
  String bucketKey;
  String? contentType;

  Image({required this.imgId, this.ordinal, this.length, required this.bucketKey, this.contentType});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      imgId: json['imgId'],
      ordinal: json['ordinal'],
      length: json['length'],
      bucketKey: json['bucketKey'],
      contentType: json['contentType'],
    );
  }
}

class SkillMultimedia {
  // 필요한 필드를 입력해주세요.
}

class Pet {
  int petId;
  String name;
  String? breed;
  int age;
  String gender;
  bool neutered;
  String? size;
  int? weight;
  String? description;
  String? dbti;
  String? hobby;
  String? snack;
  String? toy;

  Pet({required this.petId, required this.name, this.breed, required this.age, required this.gender, required this.neutered, required this.size, required this.weight, this.description, this.dbti, this.hobby, this.snack, this.toy});

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petId: json['petId'],
      name: json['name'],
      breed: json['breed'],
      age: json['age'],
      gender: json['gender'],
      neutered: json['neutered'],
      size: json['size'],
      weight: json['weight'],
      description: json['description'],
      dbti: json['dbti'],
      hobby: json['hobby'],
      snack: json['snack'],
      toy: json['toy'],
    );
  }
}

class CardProfileModel {
  int id;
  Member fromMember;
  Member toMember;
  String callStatus;

  CardProfileModel({required this.id, required this.fromMember, required this.toMember, required this.callStatus});

  factory CardProfileModel.fromJson(Map<String, dynamic> json) {
    return CardProfileModel(
      id: json['id'],
      fromMember: Member.fromJson(json['fromMember']),
      toMember: Member.fromJson(json['toMember']),
      callStatus: json['callStatus'],
    );
  }
}
