class FeedingLogModel {
  int? id;
  DateTime feedingDate;
  DateTime startTime;
  DateTime? endTime;
  FeedType feedType;
  FeedPosition? position; // Only for BREAST feeding
  int? amount; // Optional, in ml
  String? note;
  int? babyId;
  String? createdAt;
  String? updatedAt;

  FeedingLogModel({
    this.id,
    required this.feedingDate,
    required this.startTime,
    this.endTime,
    required this.feedType,
    this.position,
    this.amount,
    this.note,
    this.babyId,
    this.createdAt,
    this.updatedAt,
  });

  FeedingLogModel.fromJson(Map<String, dynamic> json)
    : feedingDate = DateTime.parse(json['feedingDate']),
      startTime = DateTime.parse(json['startTime']),
      endTime =
          json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      feedType = FeedType.values.firstWhere(
        (e) =>
            e.name.toUpperCase() == json['feedType'].toString().toUpperCase(),
        orElse: () => FeedType.BREAST,
      ),
      position =
          json['position'] != null
              ? FeedPosition.values.firstWhere(
                (e) =>
                    e.name.toUpperCase() ==
                    json['position'].toString().toUpperCase(),
                orElse: () => FeedPosition.LEFT,
              )
              : null {
    id = json['id'];
    amount = json['amount'];
    note = json['note'];
    babyId = json['babyId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'feedingDate': feedingDate.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'feedType': feedType.name.toUpperCase(),
      'position': position?.name.toUpperCase(),
      'amount': amount,
      'note': note,
      'babyId': babyId,
    };
  }

  Duration? get duration =>
      endTime != null ? endTime!.difference(startTime) : null;
}

enum FeedType { BREAST, BOTTLE, OTHER }

extension FeedTypeExtension on FeedType {
  String get displayName {
    switch (this) {
      case FeedType.BREAST:
        return 'Breast';
      case FeedType.BOTTLE:
        return 'Bottle';
      case FeedType.OTHER:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case FeedType.BREAST:
        return '🤱';
      case FeedType.BOTTLE:
        return '🍼';
      case FeedType.OTHER:
        return '🥛';
    }
  }
}

enum FeedPosition { LEFT, RIGHT, BOTH }

extension FeedPositionExtension on FeedPosition {
  String get displayName {
    switch (this) {
      case FeedPosition.LEFT:
        return 'Left';
      case FeedPosition.RIGHT:
        return 'Right';
      case FeedPosition.BOTH:
        return 'Both';
    }
  }
}
