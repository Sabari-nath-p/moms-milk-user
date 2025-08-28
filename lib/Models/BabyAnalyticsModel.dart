class BabyAnalyticsLog {
  int? babyId;
  DateRange? dateRange;
  Feeding? feeding;
  Diaper? diaper;
  Sleep? sleep;
  String? generatedAt;

  BabyAnalyticsLog({
    this.babyId,
    this.dateRange,
    this.feeding,
    this.diaper,
    this.sleep,
    this.generatedAt,
  });

  BabyAnalyticsLog.fromJson(Map<String, dynamic> json) {
    babyId = json['babyId'];
    dateRange =
        json['dateRange'] != null
            ? new DateRange.fromJson(json['dateRange'])
            : null;
    feeding =
        json['feeding'] != null ? new Feeding.fromJson(json['feeding']) : null;
    diaper =
        json['diaper'] != null ? new Diaper.fromJson(json['diaper']) : null;
    sleep = json['sleep'] != null ? new Sleep.fromJson(json['sleep']) : null;
    generatedAt = json['generatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['babyId'] = this.babyId;
    if (this.dateRange != null) {
      data['dateRange'] = this.dateRange!.toJson();
    }
    if (this.feeding != null) {
      data['feeding'] = this.feeding!.toJson();
    }
    if (this.diaper != null) {
      data['diaper'] = this.diaper!.toJson();
    }
    if (this.sleep != null) {
      data['sleep'] = this.sleep!.toJson();
    }
    data['generatedAt'] = this.generatedAt;
    return data;
  }
}

class DateRange {
  String? startDate;
  String? endDate;

  DateRange({this.startDate, this.endDate});

  DateRange.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}

class Feeding {
  int? totalFeeds;
  double? totalFeedTimeMinutes;
  double? averageFeedTimeMinutes;
  double? totalAmountMl;
  double? averageAmountMl;
  FeedMethodCount? feedMethodCount;
  PositionBreakdown? positionBreakdown;
  List<FeedingPatterns>? feedingPatterns;

  Feeding({
    this.totalFeeds,
    this.totalFeedTimeMinutes,
    this.averageFeedTimeMinutes,
    this.totalAmountMl,
    this.averageAmountMl,
    this.feedMethodCount,
    this.positionBreakdown,
    this.feedingPatterns,
  });

  Feeding.fromJson(Map<String, dynamic> json) {
    totalFeeds = json['totalFeeds'];
    totalFeedTimeMinutes = double.parse(
      (json['totalFeedTimeMinutes'] ?? 0).toString(),
    );
    averageFeedTimeMinutes = double.parse(
      (json['averageFeedTimeMinutes'] ?? 0).toString(),
    );
    totalAmountMl = double.parse((json['totalAmountMl'] ?? 0).toString());
    averageAmountMl = double.parse((json['averageAmountMl'] ?? 0).toString());
    feedMethodCount =
        json['feedMethodCount'] != null
            ? new FeedMethodCount.fromJson(json['feedMethodCount'])
            : null;
    positionBreakdown =
        json['positionBreakdown'] != null
            ? new PositionBreakdown.fromJson(json['positionBreakdown'])
            : null;
    if (json['feedingPatterns'] != null) {
      feedingPatterns = <FeedingPatterns>[];
      json['feedingPatterns'].forEach((v) {
        feedingPatterns!.add(new FeedingPatterns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalFeeds'] = this.totalFeeds;
    data['totalFeedTimeMinutes'] = this.totalFeedTimeMinutes;
    data['averageFeedTimeMinutes'] = this.averageFeedTimeMinutes;
    data['totalAmountMl'] = this.totalAmountMl;
    data['averageAmountMl'] = this.averageAmountMl;
    if (this.feedMethodCount != null) {
      data['feedMethodCount'] = this.feedMethodCount!.toJson();
    }
    if (this.positionBreakdown != null) {
      data['positionBreakdown'] = this.positionBreakdown!.toJson();
    }
    if (this.feedingPatterns != null) {
      data['feedingPatterns'] =
          this.feedingPatterns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedMethodCount {
  int? bREAST;
  int? bOTTLE;
  int? oTHER;

  FeedMethodCount({this.bREAST, this.bOTTLE, this.oTHER});

  FeedMethodCount.fromJson(Map<String, dynamic> json) {
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

class PositionBreakdown {
  int? lEFT;
  int? rIGHT;
  int? bOTH;
  int? nOTSPECIFIED;

  PositionBreakdown({this.lEFT, this.rIGHT, this.bOTH, this.nOTSPECIFIED});

  PositionBreakdown.fromJson(Map<String, dynamic> json) {
    lEFT = json['LEFT'];
    rIGHT = json['RIGHT'];
    bOTH = json['BOTH'];
    nOTSPECIFIED = json['NOT_SPECIFIED'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LEFT'] = this.lEFT;
    data['RIGHT'] = this.rIGHT;
    data['BOTH'] = this.bOTH;
    data['NOT_SPECIFIED'] = this.nOTSPECIFIED;
    return data;
  }
}

class FeedingPatterns {
  String? date;
  int? feedCount;
  double? totalTimeMinutes;
  double? totalAmountMl;

  FeedingPatterns({
    this.date,
    this.feedCount,
    this.totalTimeMinutes,
    this.totalAmountMl,
  });

  FeedingPatterns.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    feedCount = json['feedCount'];
    totalTimeMinutes = double.parse((json['totalTimeMinutes'] ?? 0).toString());
    totalAmountMl = double.parse((json['totalAmountMl'] ?? 0).toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['feedCount'] = this.feedCount;
    data['totalTimeMinutes'] = this.totalTimeMinutes;
    data['totalAmountMl'] = this.totalAmountMl;
    return data;
  }
}

class Diaper {
  int? totalChanges;
  double? averageChangesPerDay;
  DiaperTypeBreakdown? diaperTypeBreakdown;
  List<DailyPatterns>? dailyPatterns;
  List<HourlyDistribution>? hourlyDistribution;

  Diaper({
    this.totalChanges,
    this.averageChangesPerDay,
    this.diaperTypeBreakdown,
    this.dailyPatterns,
    this.hourlyDistribution,
  });

  Diaper.fromJson(Map<String, dynamic> json) {
    totalChanges = json['totalChanges'];
    averageChangesPerDay = double.parse(
      (json['averageChangesPerDay'] ?? 0).toString(),
    );
    diaperTypeBreakdown =
        json['diaperTypeBreakdown'] != null
            ? new DiaperTypeBreakdown.fromJson(json['diaperTypeBreakdown'])
            : null;
    if (json['dailyPatterns'] != null) {
      dailyPatterns = <DailyPatterns>[];
      json['dailyPatterns'].forEach((v) {
        dailyPatterns!.add(new DailyPatterns.fromJson(v));
      });
    }
    if (json['hourlyDistribution'] != null) {
      hourlyDistribution = <HourlyDistribution>[];
      json['hourlyDistribution'].forEach((v) {
        hourlyDistribution!.add(new HourlyDistribution.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalChanges'] = this.totalChanges;
    data['averageChangesPerDay'] = this.averageChangesPerDay;
    if (this.diaperTypeBreakdown != null) {
      data['diaperTypeBreakdown'] = this.diaperTypeBreakdown!.toJson();
    }
    if (this.dailyPatterns != null) {
      data['dailyPatterns'] =
          this.dailyPatterns!.map((v) => v.toJson()).toList();
    }
    if (this.hourlyDistribution != null) {
      data['hourlyDistribution'] =
          this.hourlyDistribution!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DiaperTypeBreakdown {
  int? sOLID;
  int? lIQUID;
  int? bOTH;

  DiaperTypeBreakdown({this.sOLID, this.lIQUID, this.bOTH});

  DiaperTypeBreakdown.fromJson(Map<String, dynamic> json) {
    sOLID = json['SOLID'];
    lIQUID = json['LIQUID'];
    bOTH = json['BOTH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SOLID'] = this.sOLID;
    data['LIQUID'] = this.lIQUID;
    data['BOTH'] = this.bOTH;
    return data;
  }
}

class DailyPatterns {
  String? date;
  int? changeCount;
  int? solidCount;
  int? liquidCount;
  int? bothCount;

  DailyPatterns({
    this.date,
    this.changeCount,
    this.solidCount,
    this.liquidCount,
    this.bothCount,
  });

  DailyPatterns.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    changeCount = json['changeCount'];
    solidCount = json['solidCount'];
    liquidCount = json['liquidCount'];
    bothCount = json['bothCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['changeCount'] = this.changeCount;
    data['solidCount'] = this.solidCount;
    data['liquidCount'] = this.liquidCount;
    data['bothCount'] = this.bothCount;
    return data;
  }
}

class HourlyDistribution {
  int? hour;
  int? changeCount;

  HourlyDistribution({this.hour, this.changeCount});

  HourlyDistribution.fromJson(Map<String, dynamic> json) {
    hour = json['hour'];
    changeCount = json['changeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hour'] = this.hour;
    data['changeCount'] = this.changeCount;
    return data;
  }
}

class Sleep {
  int? totalSleepSessions;
  double? totalSleepHours;
  double? averageSleepHours;
  double? averageSessionDurationMinutes;
  double? longestSleepSessionMinutes;
  double? shortestSleepSessionMinutes;
  LocationBreakdown? locationBreakdown;
  List<SleepQualityTrends>? sleepQualityTrends;
  List<DailySleepPatterns>? dailyPatterns;

  Sleep({
    this.totalSleepSessions,
    this.totalSleepHours,
    this.averageSleepHours,
    this.averageSessionDurationMinutes,
    this.longestSleepSessionMinutes,
    this.shortestSleepSessionMinutes,
    this.locationBreakdown,
    this.sleepQualityTrends,
    this.dailyPatterns,
  });

  Sleep.fromJson(Map<String, dynamic> json) {
    totalSleepSessions = json['totalSleepSessions'];
    totalSleepHours = double.parse((json['totalSleepHours'] ?? 0).toString());
    averageSleepHours = double.parse(
      (json['averageSleepHours'] ?? 0).toString(),
    );
    averageSessionDurationMinutes = double.parse(
      (json['averageSessionDurationMinutes'] ?? 0).toString(),
    );
    longestSleepSessionMinutes = double.parse(
      (json['longestSleepSessionMinutes'] ?? 0).toString(),
    );
    shortestSleepSessionMinutes = double.parse(
      (json['shortestSleepSessionMinutes'] ?? 0).toString(),
    );
    locationBreakdown =
        json['locationBreakdown'] != null
            ? new LocationBreakdown.fromJson(json['locationBreakdown'])
            : null;
    if (json['sleepQualityTrends'] != null) {
      sleepQualityTrends = <SleepQualityTrends>[];
      json['sleepQualityTrends'].forEach((v) {
        sleepQualityTrends!.add(new SleepQualityTrends.fromJson(v));
      });
    }
    if (json['dailyPatterns'] != null) {
      dailyPatterns = <DailySleepPatterns>[];
      json['dailyPatterns'].forEach((v) {
        dailyPatterns!.add(new DailySleepPatterns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalSleepSessions'] = this.totalSleepSessions;
    data['totalSleepHours'] = this.totalSleepHours;
    data['averageSleepHours'] = this.averageSleepHours;
    data['averageSessionDurationMinutes'] = this.averageSessionDurationMinutes;
    data['longestSleepSessionMinutes'] = this.longestSleepSessionMinutes;
    data['shortestSleepSessionMinutes'] = this.shortestSleepSessionMinutes;
    if (this.locationBreakdown != null) {
      data['locationBreakdown'] = this.locationBreakdown!.toJson();
    }
    if (this.sleepQualityTrends != null) {
      data['sleepQualityTrends'] =
          this.sleepQualityTrends!.map((v) => v.toJson()).toList();
    }
    if (this.dailyPatterns != null) {
      data['dailyPatterns'] =
          this.dailyPatterns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocationBreakdown {
  int? cRIB;
  int? bED;
  int? sTROLLER;
  int? oTHER;

  LocationBreakdown({this.cRIB, this.bED, this.sTROLLER, this.oTHER});

  LocationBreakdown.fromJson(Map<String, dynamic> json) {
    cRIB = json['CRIB'];
    bED = json['BED'];
    sTROLLER = json['STROLLER'];
    oTHER = json['OTHER'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CRIB'] = this.cRIB;
    data['BED'] = this.bED;
    data['STROLLER'] = this.sTROLLER;
    data['OTHER'] = this.oTHER;
    return data;
  }
}

class SleepQualityTrends {
  String? date;
  int? sessionCount;
  double? totalHours;
  String? averageQuality;

  SleepQualityTrends({
    this.date,
    this.sessionCount,
    this.totalHours,
    this.averageQuality,
  });

  SleepQualityTrends.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    sessionCount = json['sessionCount'];
    totalHours = double.parse((json['totalHours'] ?? 0).toString());
    averageQuality = json['averageQuality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['sessionCount'] = this.sessionCount;
    data['totalHours'] = this.totalHours;
    data['averageQuality'] = this.averageQuality;
    return data;
  }
}

class DailySleepPatterns {
  String? date;
  int? sessionCount;
  double? totalHours;
  double? averageSessionMinutes;

  DailySleepPatterns({
    this.date,
    this.sessionCount,
    this.totalHours,
    this.averageSessionMinutes,
  });

  DailySleepPatterns.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    sessionCount = json['sessionCount'];
    totalHours = double.parse((json['totalHours'] ?? 0).toString());
    averageSessionMinutes = double.parse(
      (json['averageSessionMinutes'] ?? 0).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['sessionCount'] = this.sessionCount;
    data['totalHours'] = this.totalHours;
    data['averageSessionMinutes'] = this.averageSessionMinutes;
    return data;
  }
}
