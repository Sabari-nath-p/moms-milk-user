class SearchBuyerModel {
  Buyer? buyer;
  double? distance;
  String? distanceText;
  bool? hasAcceptedRequest;
  bool? hasPendingRequest;
  String? buyerPhoneNumber;
  Location? location;

  SearchBuyerModel({
    this.buyer,
    this.distance,
    this.distanceText,
    this.hasAcceptedRequest,
    this.hasPendingRequest,
    this.location,
  });

  SearchBuyerModel.fromJson(Map<String, dynamic> json) {
    buyer = json['buyer'] != null ? Buyer.fromJson(json['buyer']) : null;
    distance = double.parse((json['distance'] ?? 0).toString());
    distanceText = json['distanceText'];
    hasAcceptedRequest = json['hasAcceptedRequest'];
    hasPendingRequest = json['hasPendingRequest'];
    buyerPhoneNumber = json['buyerPhoneNumber'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (buyer != null) data['buyer'] = buyer!.toJson();
    data['distance'] = distance;
    data['distanceText'] = distanceText;
    data['hasAcceptedRequest'] = hasAcceptedRequest;
    data['hasPendingRequest'] = hasPendingRequest;
    if (location != null) data['location'] = location!.toJson();
    return data;
  }
}

class Buyer {
  int? id;
  String? name;
  String? email;
  String? zipcode;
  String? userType;
  String? description;
  bool? isAvailable; // ✅ matches the actual API field, same as Donor
  String? createdAt;

  Buyer({
    this.id,
    this.name,
    this.email,
    this.zipcode,
    this.userType,
    this.description,
    this.isAvailable,
    this.createdAt,
  });

  Buyer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    zipcode = json['zipcode'];
    userType = json['userType'];
    description = json['description'];
    isAvailable = json['isAvailable']; // ✅ same field as Donor
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'zipcode': zipcode,
      'userType': userType,
      'description': description,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
    };
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
    return {
      'zipcode': zipcode,
      'placeName': placeName,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'fullAddress': fullAddress,
    };
  }
}
