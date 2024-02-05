class PetInfoModel {
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

  PetInfoModel(
      {this.name,
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
      this.toy});

  PetInfoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    breed = json['breed'];
    age = json['age'];
    gender = json['gender'];
    neutered = json['neutered'];
    size = json['size'];
    weight = json['weight'];
    description = json['description'];
    dbti = json['dbti'];
    hobby = json['hobby'];
    snack = json['snack'];
    toy = json['toy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['breed'] = this.breed;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['neutered'] = this.neutered;
    data['size'] = this.size;
    data['weight'] = this.weight;
    data['description'] = this.description;
    data['dbti'] = this.dbti;
    data['hobby'] = this.hobby;
    data['snack'] = this.snack;
    data['toy'] = this.toy;
    return data;
  }
}
