class DiaperLogModel {
  int? id;
  String? diaperType; // Stored as string, can map to enum if needed
  String? note;
  int? babyId;
  String? date;      // API returns ISO string
  String? time;      // API returns ISO string
  String? createdAt; // Optional timestamp
  String? updatedAt;

  DiaperLogModel({
    this.id,
    this.diaperType,
    this.note,
    this.babyId,
    this.date,
    this.time,
    this.createdAt,
    this.updatedAt,
  });

  factory DiaperLogModel.fromJson(Map<String, dynamic> json) {
    return DiaperLogModel(
      id: json['id'],
      diaperType: json['diaperType'],
      note: json['note'],
      babyId: json['babyId'],
      date: json['date'],
      time: json['time'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "diaperType": diaperType,
      "note": note,
      "babyId": babyId,
      "date": date,
      "time": time,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
