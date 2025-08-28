class SleepLogModel {
  int? id;
  DateTime date;
  DateTime startTime;
  DateTime endTime;
  SleepQuality sleepQuality;
  SleepLocation location;
  String? note;
  int? babyId;
  String? createdAt;
  String? updatedAt;

  SleepLogModel({
    this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.sleepQuality,
    required this.location,
    this.note,
    this.babyId,
    this.createdAt,
    this.updatedAt,
  });

  SleepLogModel.fromJson(Map<String, dynamic> json)
    : date = DateTime.parse(json['date']),
      startTime = DateTime.parse(json['startTime']),
      endTime = DateTime.parse(json['endTime']),
      sleepQuality = SleepQuality.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            json['sleepQuality'].toString().toLowerCase(),
        orElse: () => SleepQuality.good,
      ),
      location = SleepLocation.values.firstWhere(
        (e) =>
            e.name.toUpperCase() == json['location'].toString().toUpperCase(),
        orElse: () => SleepLocation.CRIB,
      ) {
    id = json['id'];
    note = json['note'];
    babyId = json['babyId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'sleepQuality': sleepQuality.displayName,
      'location': location.name.toUpperCase(),
      'note': note,
      'babyId': babyId,
    };
  }

  Duration get duration => endTime.difference(startTime);
}

enum SleepQuality { good, better, best }

enum SleepLocation { BED, CRIB, HAND }

extension SleepQualityExtension on SleepQuality {
  String get displayName {
    switch (this) {
      case SleepQuality.good:
        return 'Good';
      case SleepQuality.better:
        return 'Better';
      case SleepQuality.best:
        return 'Best';
    }
  }
}

extension SleepLocationExtension on SleepLocation {
  String get displayName {
    switch (this) {
      case SleepLocation.BED:
        return 'Bed';
      case SleepLocation.CRIB:
        return 'Crib';
      case SleepLocation.HAND:
        return 'Hand';
    }
  }

  String get icon {
    switch (this) {
      case SleepLocation.BED:
        return '🛏️';
      case SleepLocation.CRIB:
        return '🛏️';
      case SleepLocation.HAND:
        return '🤱';
    }
  }
}
