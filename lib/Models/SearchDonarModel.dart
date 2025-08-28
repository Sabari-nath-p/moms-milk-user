class SearchDonarModel {
  Donor? donor;
  double? distance;
  String? distanceText;
  bool? hasAcceptedRequest;
  Location? location;

  SearchDonarModel({
    this.donor,
    this.distance,
    this.distanceText,
    this.hasAcceptedRequest,
    this.location,
  });

  SearchDonarModel.fromJson(Map<String, dynamic> json) {
    donor = json['donor'] != null ? new Donor.fromJson(json['donor']) : null;
    distance = double.parse((json['distance'] ?? 0).toString());
    distanceText = json['distanceText'];
    hasAcceptedRequest = json['hasAcceptedRequest'];
    location =
        json['location'] != null
            ? new Location.fromJson(json['location'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.donor != null) {
      data['donor'] = this.donor!.toJson();
    }
    data['distance'] = this.distance;
    data['distanceText'] = this.distanceText;
    data['hasAcceptedRequest'] = this.hasAcceptedRequest;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}

class Donor {
  int? id;
  String? name;
  String? email;
  String? zipcode;
  String? userType;
  String? description;
  String? bloodGroup;
  String? babyDeliveryDate;
  bool? ableToShareMedicalRecord;
  bool? isAvailable;
  String? createdAt;

  Donor({
    this.id,
    this.name,
    this.email,
    this.zipcode,
    this.userType,
    this.description,
    this.bloodGroup,
    this.babyDeliveryDate,
    this.ableToShareMedicalRecord,
    this.isAvailable,
    this.createdAt,
  });

  Donor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    zipcode = json['zipcode'];
    userType = json['userType'];
    description = json['description'];
    bloodGroup = json['bloodGroup'];
    babyDeliveryDate = json['babyDeliveryDate'];
    ableToShareMedicalRecord = json['ableToShareMedicalRecord'];
    isAvailable = json['isAvailable'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['zipcode'] = this.zipcode;
    data['userType'] = this.userType;
    data['description'] = this.description;
    data['bloodGroup'] = this.bloodGroup;
    data['babyDeliveryDate'] = this.babyDeliveryDate;
    data['ableToShareMedicalRecord'] = this.ableToShareMedicalRecord;
    data['isAvailable'] = this.isAvailable;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Location {
  String? zipcode;
  String? placeName;
  String? country;
  double? latitude;
  double? longitude;
  String? fullAddress;

  Location({
    this.zipcode,
    this.placeName,
    this.country,
    this.latitude,
    this.longitude,
    this.fullAddress,
  });

  Location.fromJson(Map<String, dynamic> json) {
    zipcode = json['zipcode'];
    placeName = json['placeName'];
    country = json['country'];
    latitude = double.parse((json['latitude'] ?? 0).toString());
    longitude = double.parse((json['longitude'] ?? 0).toString());
    fullAddress = json['fullAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zipcode'] = this.zipcode;
    data['placeName'] = this.placeName;
    data['country'] = this.country;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['fullAddress'] = this.fullAddress;
    return data;
  }
}
