class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? zipcode;
  String? userType;
  bool? isNew;
  bool? isActive;
  String? fcmToken;
  String? lastLoginAt;
  String? description;
  String? bloodGroup;
  String? babyDeliveryDate;
  String? healthStyle;
  bool? ableToShareMedicalRecord;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.zipcode,
    this.userType,
    this.isNew,
    this.isActive,
    this.fcmToken,
    this.lastLoginAt,
    this.description,
    this.bloodGroup,
    this.babyDeliveryDate,
    this.healthStyle,
    this.ableToShareMedicalRecord,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    zipcode = json['zipcode'];
    userType = json['userType'];
    isNew = json['isNew'];
    isActive = json['isActive'];
    fcmToken = json['fcmToken'];
    lastLoginAt = json['lastLoginAt'];
    description = json['description'];
    bloodGroup = json['bloodGroup'];
    babyDeliveryDate = json['babyDeliveryDate'];
    healthStyle = json['healthStyle'];
    ableToShareMedicalRecord = json['ableToShareMedicalRecord'];
    isAvailable = json['isAvailable'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['zipcode'] = this.zipcode;
    data['userType'] = this.userType;
    data['isNew'] = this.isNew;
    data['isActive'] = this.isActive;
    data['fcmToken'] = this.fcmToken;
    data['lastLoginAt'] = this.lastLoginAt;
    data['description'] = this.description;
    data['bloodGroup'] = this.bloodGroup;
    data['babyDeliveryDate'] = this.babyDeliveryDate;
    data['healthStyle'] = this.healthStyle;
    data['ableToShareMedicalRecord'] = this.ableToShareMedicalRecord;
    data['isAvailable'] = this.isAvailable;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
