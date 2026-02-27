import 'package:get/get.dart';

class BabyActivityOverviewModel {
  SleepAnalytics? sleepAnalytics;
  FeedAnalytics? feedAnalytics;
  DiaperAnalytics? diaperAnalytics;
  int? totalDays;
  String? startDate;
  String? endDate;
  int? babyId;

  BabyActivityOverviewModel({
    this.sleepAnalytics,
    this.feedAnalytics,
    this.diaperAnalytics,
    this.totalDays,
    this.startDate,
    this.endDate,
    this.babyId,
  });

  BabyActivityOverviewModel.fromJson(Map<String, dynamic> json) {
    sleepAnalytics =
        json['sleepAnalytics'] != null
            ? new SleepAnalytics.fromJson(json['sleepAnalytics'])
            : null;
    feedAnalytics =
        json['feedAnalytics'] != null
            ? new FeedAnalytics.fromJson(json['feedAnalytics'])
            : null;
    diaperAnalytics =
        json['diaperAnalytics'] != null
            ? new DiaperAnalytics.fromJson(json['diaperAnalytics'])
            : null;
    totalDays = json['totalDays'.tr];
    startDate = json['startDate'.tr];
    endDate = json['endDate'.tr];
    babyId = json['babyId'.tr];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sleepAnalytics != null) {
      data['sleepAnalytics'] = this.sleepAnalytics!.toJson();
    }
    if (this.feedAnalytics != null) {
      data['feedAnalytics'] = this.feedAnalytics!.toJson();
    }
    if (this.diaperAnalytics != null) {
      data['diaperAnalytics'] = this.diaperAnalytics!.toJson();
    }
    data['totalDays'] = this.totalDays;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['babyId'] = this.babyId;
    return data;
  }
}

class SleepAnalytics {
  int? totalSleeps;
  double? totalSleepDuration;
  double? averageSleepDurationPerDay;

  SleepAnalytics({
    this.totalSleeps,
    this.totalSleepDuration,
    this.averageSleepDurationPerDay,
  });

  SleepAnalytics.fromJson(Map<String, dynamic> json) {
    totalSleeps = json['totalSleeps'.tr];
    totalSleepDuration =
        double.parse(json['totalSleepDuration'.tr].toString()).toDouble();
    averageSleepDurationPerDay =
        double.parse(json['averageSleepDurationPerDay'.tr].toString()).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalSleeps'.tr] = this.totalSleeps;
    data['totalSleepDuration'.tr] = this.totalSleepDuration;
    data['averageSleepDurationPerDay'.tr] = this.averageSleepDurationPerDay;
    return data;
  }
}

class FeedAnalytics {
  int? totalFeeds;
  double? averageFeedingTimePerDay;
  FeedTypeBreakdown? feedTypeBreakdown;
  FeedPositionBreakdown? feedPositionBreakdown;

  FeedAnalytics({
    this.totalFeeds,
    this.averageFeedingTimePerDay,
    this.feedTypeBreakdown,
    this.feedPositionBreakdown,
  });

  FeedAnalytics.fromJson(Map<String, dynamic> json) {
    totalFeeds = json['totalFeeds'.tr];
    averageFeedingTimePerDay =
        double.parse(json['averageFeedingTimePerDay'.tr].toString()).toDouble();
    feedTypeBreakdown =
        json['feedTypeBreakdown'.tr] != null
            ? new FeedTypeBreakdown.fromJson(json['feedTypeBreakdown'.tr])
            : null;
    feedPositionBreakdown =
        json['feedPositionBreakdown'.tr] != null
            ? new FeedPositionBreakdown.fromJson(json['feedPositionBreakdown'.tr])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalFeeds'.tr] = this.totalFeeds;
    data['averageFeedingTimePerDay'.tr] = this.averageFeedingTimePerDay;
    if (this.feedTypeBreakdown != null) {
      data['feedTypeBreakdown'.tr] = this.feedTypeBreakdown!.toJson();
    }
    if (this.feedPositionBreakdown != null) {
      data['feedPositionBreakdown'.tr] = this.feedPositionBreakdown!.toJson();
    }
    return data;
  }
}

class FeedTypeBreakdown {
  int? bREAST;
  int? bOTTLE;
  int? oTHER;

  FeedTypeBreakdown({this.bREAST, this.bOTTLE, this.oTHER});

  FeedTypeBreakdown.fromJson(Map<String, dynamic> json) {
    bREAST = json['BREAST'.tr];
    bOTTLE = json['BOTTLE'.tr];
    oTHER = json['OTHER'.tr];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BREAST'.tr] = this.bREAST;
    data['BOTTLE'.tr] = this.bOTTLE;
    data['OTHER'.tr] = this.oTHER;
    return data;
  }
}

class FeedPositionBreakdown {
  int? lEFT;
  int? rIGHT;
  int? bOTH;

  FeedPositionBreakdown({this.lEFT, this.rIGHT, this.bOTH});

  FeedPositionBreakdown.fromJson(Map<String, dynamic> json) {
    lEFT = json['LEFT'.tr];
    rIGHT = json['RIGHT'.tr];
    bOTH = json['BOTH'.tr];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LEFT'.tr] = this.lEFT;
    data['RIGHT'.tr] = this.rIGHT;
    data['BOTH'.tr] = this.bOTH;
    return data;
  }
}

class DiaperAnalytics {
  int? totalDiaperChanges;
  double? averageDiaperChangesPerDay;
  DiaperTypeBreakdown? diaperTypeBreakdown;

  DiaperAnalytics({
    this.totalDiaperChanges,
    this.averageDiaperChangesPerDay,
    this.diaperTypeBreakdown,
  });

  DiaperAnalytics.fromJson(Map<String, dynamic> json) {
    totalDiaperChanges = json['totalDiaperChanges'.tr];
    averageDiaperChangesPerDay =
        double.parse(json['averageDiaperChangesPerDay'.tr].toString()).toDouble();
    diaperTypeBreakdown =
        json['diaperTypeBreakdown'.tr] != null
            ? new DiaperTypeBreakdown.fromJson(json['diaperTypeBreakdown'.tr])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalDiaperChanges'.tr] = this.totalDiaperChanges;
    data['averageDiaperChangesPerDay'.tr] = this.averageDiaperChangesPerDay;
    if (this.diaperTypeBreakdown != null) {
      data['diaperTypeBreakdown'.tr] = this.diaperTypeBreakdown!.toJson();
    }
    return data;
  }
}

class DiaperTypeBreakdown {
  int? sOLID;
  int? lIQUID;
  int? bOTH;
  int? eMPTY;

  DiaperTypeBreakdown({this.sOLID, this.lIQUID, this.bOTH, this.eMPTY});

  DiaperTypeBreakdown.fromJson(Map<String, dynamic> json) {
    sOLID = json['SOLID'.tr];
    lIQUID = json['LIQUID'.tr];
    bOTH = json['BOTH'.tr];
    eMPTY = json['EMPTY'.tr];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SOLID'.tr] = this.sOLID;
    data['LIQUID'.tr] = this.lIQUID;
    data['BOTH'.tr] = this.bOTH;
    data['EMPTY'.tr] = this.eMPTY;
    return data;
  }
}
