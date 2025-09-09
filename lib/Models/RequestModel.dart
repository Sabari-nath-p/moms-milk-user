class RequestModel {
  int? id;
  String? requestType;
  String? status;
  String? title;
  String? description;
  int? quantity;
  String? urgency;
  String? requesterZipcode;
  String? donorZipcode;
  int? distance;
  String? neededBy;
  String? acceptedAt;
  String? completedAt;
  String? notes;
  String? createdAt;
  String? updatedAt;
  Requester? requester;
  Requester? donor;

  RequestModel({
    this.id,
    this.requestType,
    this.status,
    this.title,
    this.description,
    this.quantity,
    this.urgency,
    this.requesterZipcode,
    this.donorZipcode,
    this.distance,
    this.neededBy,
    this.acceptedAt,
    this.completedAt,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.requester,
    this.donor,
  });

  RequestModel.fromJson(Map<String, dynamic> json) {
  id = (json['id'] is int) ? json['id'] : (json['id'] as num?)?.toInt();
  requestType = json['requestType'];
  status = json['status'];
  title = json['title'];
  description = json['description'];
  quantity = (json['quantity'] is int) ? json['quantity'] : (json['quantity'] as num?)?.toInt();
  urgency = json['urgency'];
  requesterZipcode = json['requesterZipcode'];
  donorZipcode = json['donorZipcode'];
  distance = (json['distance'] is int) ? json['distance'] : (json['distance'] as num?)?.toInt();
  neededBy = json['neededBy'];
  acceptedAt = json['acceptedAt'];
  completedAt = json['completedAt'];
  notes = json['notes'];
  createdAt = json['createdAt'];
  updatedAt = json['updatedAt'];
  requester = json['requester'] != null
      ? Requester.fromJson(json['requester'])
      : null;
  donor = json['donor'] != null
      ? Requester.fromJson(json['donor'])
      : null;
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requestType'] = this.requestType;
    data['status'] = this.status;
    data['title'] = this.title;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['urgency'] = this.urgency;
    data['requesterZipcode'] = this.requesterZipcode;
    data['donorZipcode'] = this.donorZipcode;
    data['distance'] = this.distance;
    data['neededBy'] = this.neededBy;
    data['acceptedAt'] = this.acceptedAt;
    data['completedAt'] = this.completedAt;
    data['notes'] = this.notes;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.requester != null) {
      data['requester'] = this.requester!.toJson();
    }
    if (this.donor != null) {
      data['donor'] = this.donor!.toJson();
    }
    return data;
  }
}

class Requester {
  int? id;
  String? name;
  String? email;
  String? userType;

  Requester({this.id, this.name, this.email, this.userType});

  Requester.fromJson(Map<String, dynamic> json) {
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
