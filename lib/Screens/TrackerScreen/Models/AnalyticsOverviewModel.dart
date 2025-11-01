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
    totalDays = json['totalDays'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    babyId = json['babyId'];
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
    totalSleeps = json['totalSleeps'];
    totalSleepDuration =
        double.parse(json['totalSleepDuration'].toString()).toDouble();
    averageSleepDurationPerDay =
        double.parse(json['averageSleepDurationPerDay'].toString()).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalSleeps'] = this.totalSleeps;
    data['totalSleepDuration'] = this.totalSleepDuration;
    data['averageSleepDurationPerDay'] = this.averageSleepDurationPerDay;
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
    totalFeeds = json['totalFeeds'];
    averageFeedingTimePerDay =
        double.parse(json['averageFeedingTimePerDay'].toString()).toDouble();
    feedTypeBreakdown =
        json['feedTypeBreakdown'] != null
            ? new FeedTypeBreakdown.fromJson(json['feedTypeBreakdown'])
            : null;
    feedPositionBreakdown =
        json['feedPositionBreakdown'] != null
            ? new FeedPositionBreakdown.fromJson(json['feedPositionBreakdown'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalFeeds'] = this.totalFeeds;
    data['averageFeedingTimePerDay'] = this.averageFeedingTimePerDay;
    if (this.feedTypeBreakdown != null) {
      data['feedTypeBreakdown'] = this.feedTypeBreakdown!.toJson();
    }
    if (this.feedPositionBreakdown != null) {
      data['feedPositionBreakdown'] = this.feedPositionBreakdown!.toJson();
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
    bREAST = json['BREAST'];
    bOTTLE = json['BOTTLE'];
    oTHER = json['OTHER'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BREAST'] = this.bREAST;
    data['BOTTLE'] = this.bOTTLE;
    data['OTHER'] = this.oTHER;
    return data;
  }
}

class FeedPositionBreakdown {
  int? lEFT;
  int? rIGHT;
  int? bOTH;

  FeedPositionBreakdown({this.lEFT, this.rIGHT, this.bOTH});

  FeedPositionBreakdown.fromJson(Map<String, dynamic> json) {
    lEFT = json['LEFT'];
    rIGHT = json['RIGHT'];
    bOTH = json['BOTH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LEFT'] = this.lEFT;
    data['RIGHT'] = this.rIGHT;
    data['BOTH'] = this.bOTH;
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
    totalDiaperChanges = json['totalDiaperChanges'];
    averageDiaperChangesPerDay =
        double.parse(json['averageDiaperChangesPerDay'].toString()).toDouble();
    diaperTypeBreakdown =
        json['diaperTypeBreakdown'] != null
            ? new DiaperTypeBreakdown.fromJson(json['diaperTypeBreakdown'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalDiaperChanges'] = this.totalDiaperChanges;
    data['averageDiaperChangesPerDay'] = this.averageDiaperChangesPerDay;
    if (this.diaperTypeBreakdown != null) {
      data['diaperTypeBreakdown'] = this.diaperTypeBreakdown!.toJson();
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
    sOLID = json['SOLID'];
    lIQUID = json['LIQUID'];
    bOTH = json['BOTH'];
    eMPTY = json['EMPTY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SOLID'] = this.sOLID;
    data['LIQUID'] = this.lIQUID;
    data['BOTH'] = this.bOTH;
    data['EMPTY'] = this.eMPTY;
    return data;
  }
}
