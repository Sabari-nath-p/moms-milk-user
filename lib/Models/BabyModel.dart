class BabyModel {
  int? id;
  String? name;
  String? gender;
  String? deliveryDate;
  String? bloodGroup;
  double? weight;
  double? height;
  int? userId;
  String? createdAt;
  String? updatedAt;
  User? user;

  BabyModel({
    this.id,
    this.name,
    this.gender,
    this.deliveryDate,
    this.bloodGroup,
    this.weight,
    this.height,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  BabyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    deliveryDate = json['deliveryDate'];
    bloodGroup = json['bloodGroup'];
    weight = double.parse((json['weight'] ?? 0).toString());
    height = double.parse((json['height'] ?? 0).toString());
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['deliveryDate'] = this.deliveryDate;
    data['bloodGroup'] = this.bloodGroup;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? userType;

  User({this.id, this.name, this.email, this.userType});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['userType'] = this.userType;
    return data;
  }
}
