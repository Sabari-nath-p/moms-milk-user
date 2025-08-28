class DiaperLogModel {
  int? id;
  DateTime date;
  DateTime time;
  DiaperType diaperType;
  String? note;
  int? babyId;
  String? createdAt;
  String? updatedAt;

  DiaperLogModel({
    this.id,
    required this.date,
    required this.time,
    required this.diaperType,
    this.note,
    this.babyId,
    this.createdAt,
    this.updatedAt,
  });

  DiaperLogModel.fromJson(Map<String, dynamic> json)
    : date = DateTime.parse(json['date']),
      time = DateTime.parse(json['time']),
      diaperType = DiaperType.values.firstWhere(
        (e) =>
            e.name.toUpperCase() == json['diaperType'].toString().toUpperCase(),
        orElse: () => DiaperType.SOLID,
      ) {
    id = json['id'];
    note = json['note'];
    babyId = json['babyId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD format
      'time': time.toIso8601String(),
      'diaperType': diaperType.name.toUpperCase(),
      'note': note,
      'babyId': babyId,
    };
  }
}

enum DiaperType { SOLID, LIQUID, BOTH }

extension DiaperTypeExtension on DiaperType {
  String get displayName {
    switch (this) {
      case DiaperType.SOLID:
        return 'Solid';
      case DiaperType.LIQUID:
        return 'Liquid';
      case DiaperType.BOTH:
        return 'Both';
    }
  }
}
