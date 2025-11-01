import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/BabyModel.dart';
import 'package:mommilk_user/Models/BabyAnalyticsModel.dart';
import 'package:mommilk_user/Models/DiaperLogModel.dart';
import 'package:mommilk_user/Models/SleepLogModel.dart';
import 'package:mommilk_user/Models/FeedingLogModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/DiaperChangeBottomSheet.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/SleepLogBottomSheet.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/FeedingLogBottomSheet.dart';
import 'package:mommilk_user/Screens/TimeLineScreen/ActivityTimeLineScreen.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class Homecontroller extends GetxController {
  // 🔧 EXISTING: Basic loading states
  bool isLoading = false;
  bool isAnalyticsLoading = false;
  bool isSubmitLoading = false;

  // 🔧 NEW: Individual loading states for logs
  bool isFeedingLogsLoading = false;
  bool isDiaperLogsLoading = false;
  bool isSleepLogsLoading = false;

  // 🔧 EXISTING: Baby data
  List<BabyModel> myBabies = [];
  BabyModel? selectedBady;
  BabyAnalyticsLog? babyAnalytics;

  // 🔧 NEW: Individual log lists
  List<FeedingLogModel> feedingLogs = [];
  List<DiaperLogModel> diaperLogs = [];
  List<SleepLogModel> sleepLogs = [];

  fetchBabies({isNew = false}) async {
    await ApiService.request(
      endpoint: "/babies/user/${user.id}",
      method: Api.GET,
      onSuccess: (body) {
        myBabies.clear();
        for (var data in body.data) {
          myBabies.add(BabyModel.fromJson(data));
        }

        if (myBabies.isNotEmpty) {
          selectedBady = myBabies.last;
          // Fetch analytics for the selected baby
          fetchBabyAnalytics(babyId: selectedBady!.id!);
          // 🔧 NEW: Also fetch all logs
          fetchAllLogsForBaby(selectedBady!.id!);
        }
        update();
      },
    );
  }

  LogDiaper(DiaperLogModel model) async {
    isLoading = true;
    update();
    await ApiService.request(
      endpoint: "/diaper-logs",
      body: model.toJson(),
      onSuccess: (data) {
        Get.back();
        Get.snackbar('Success', 'Diaper log logged successfully!');
        // 🔧 NEW: Refresh diaper logs after adding
        Get.to(
          () => Activitytimelinescreen(),
          transition: Transition.rightToLeft,
        );
      },
    );
    isLoading = false;
    update();
  }

  LogSleep(SleepLogModel model) async {
    isLoading = true;
    update();
    await ApiService.request(
      endpoint: "/sleep-logs",
      body: model.toJson(),
      onSuccess: (data) {
        print(data.data);
        Get.back();
        Get.snackbar('Success', 'Sleep Log logged successfully!');
        // 🔧 NEW: Refresh sleep logs after adding
        Get.to(
          () => Activitytimelinescreen(),
          transition: Transition.rightToLeft,
        );
      },
    );
    isLoading = false;
    update();
  }

  logFeeding(FeedingLogModel model) async {
    isLoading = true;
    update();
    await ApiService.request(
      endpoint: "/feed-logs",
      body: model.toJson(),
      onSuccess: (data) {
        print(data.data);
        Get.back();
        Get.snackbar('Success', 'Feeding Log logged successfully!');
        Get.to(
          () => Activitytimelinescreen(),
          transition: Transition.rightToLeft,
        );
      },
    );
    isLoading = false;
    update();
  }

  void inituser() {
    fetchBabies();
  }

  // 🔧 EXISTING: Fetch baby analytics data
  Future<void> fetchBabyAnalytics({
    required int babyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isAnalyticsLoading = true;
    update();

    try {
      String endpoint = '/analytics/baby/$babyId/combined';

      // Only add date params if both dates are provided
      if (startDate != null && endDate != null) {
        final encodedStart = Uri.encodeComponent(startDate.toIso8601String());
        final encodedEnd = Uri.encodeComponent(endDate.toIso8601String());
        endpoint += '?startDate=$encodedStart&endDate=$encodedEnd';
      }

      await ApiService.request(
        endpoint: endpoint,
        method: Api.GET,
        onSuccess: (data) {
          print('Analytics API success: ${data.data}');
          if (data.data != null) {
            babyAnalytics = BabyAnalyticsLog.fromJson(data.data);
            print('Analytics loaded successfully for baby $babyId');
          }
        },
        onError: (error) {
          print('Analytics API error: $error');
          Get.snackbar(
            'Error',
            'Failed to load baby analytics: $error',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      );
    } catch (e) {
      print('Exception in fetchBabyAnalytics: $e');
      Get.snackbar(
        'Error',
        'Failed to load baby analytics: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isAnalyticsLoading = false;
      update();
    }
  }

  // 🔧 CORRECTED: Fetch feeding logs by baby ID and date range
  Future<void> fetchFeedingLogsByDateRange({
    required int babyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isFeedingLogsLoading = true;
    update();

    // Default to last 7 days if no dates provided
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final end = endDate ?? DateTime.now();

    // Format dates to ISO string with proper URL encoding
    final startDateString = start.toIso8601String();
    final endDateString = end.toIso8601String();

    final encodedStartDate = Uri.encodeComponent(startDateString);
    final encodedEndDate = Uri.encodeComponent(endDateString);

    final endpoint =
        '/feed-logs/baby/$babyId/date-range?startDate=$encodedStartDate&endDate=$encodedEndDate';

    try {
      await ApiService.request(
        endpoint: endpoint,
        method: Api.GET,
        onSuccess: (data) {
          print(
            '🍼 Feeding logs API success: ${data.data?.length ?? 0} logs found',
          );

          feedingLogs.clear();
          if (data.data != null && data.data is List) {
            for (var logData in data.data) {
              try {
                feedingLogs.add(FeedingLogModel.fromJson(logData));
              } catch (e) {
                print('Error parsing feeding log: $e');
              }
            }
          }

          print(
            '📊 Loaded ${feedingLogs.length} feeding logs for baby $babyId',
          );
          // 🔧 CORRECTED: Sort logs by startTime (most recent first)
          feedingLogs.sort(
            (a, b) => (b.startTime ?? DateTime.now()).compareTo(
              a.startTime ?? DateTime.now(),
            ),
          );
        },
        onError: (error) {
          print('❌ Feeding logs API error: $error');
          Get.snackbar(
            'Error',
            'Failed to load feeding logs: $error',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      );
    } catch (e) {
      print('💥 Exception in fetchFeedingLogsByDateRange: $e');
      Get.snackbar(
        'Error',
        'Failed to load feeding logs: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isFeedingLogsLoading = false;
      update();
    }
  }

  // 🔧 CORRECTED: Fetch diaper logs by baby ID and date range
  Future<void> fetchDiaperLogsByDateRange({
    required int babyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isDiaperLogsLoading = true;
    update();

    // Default to last 7 days if no dates provided
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final end = endDate ?? DateTime.now();

    // Format dates to ISO string with proper URL encoding
    final startDateString = start.toIso8601String();
    final endDateString = end.toIso8601String();

    final encodedStartDate = Uri.encodeComponent(startDateString);
    final encodedEndDate = Uri.encodeComponent(endDateString);

    final endpoint =
        '/diaper-logs/baby/$babyId/date-range?startDate=$encodedStartDate&endDate=$encodedEndDate';

    try {
      await ApiService.request(
        endpoint: endpoint,
        method: Api.GET,
        onSuccess: (data) {
          print(
            '💩 Diaper logs API success: ${data.data?.length ?? 0} logs found',
          );

          diaperLogs.clear();
          if (data.data != null && data.data is List) {
            for (var logData in data.data) {
              try {
                diaperLogs.add(DiaperLogModel.fromJson(logData));
              } catch (e) {
                print('Error parsing diaper log: $e');
              }
            }
          }

          print('📊 Loaded ${diaperLogs.length} diaper logs for baby $babyId');
          // 🔧 CORRECTED: Sort logs by startTime (most recent first)
          diaperLogs.sort(
            (a, b) =>
                (b.time ?? DateTime.now()).compareTo(a.time ?? DateTime.now()),
          );
        },
        onError: (error) {
          print('❌ Diaper logs API error: $error');
          Get.snackbar(
            'Error',
            'Failed to load diaper logs: $error',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      );
    } catch (e) {
      print('💥 Exception in fetchDiaperLogsByDateRange: $e');
      Get.snackbar(
        'Error',
        'Failed to load diaper logs: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDiaperLogsLoading = false;
      update();
    }
  }

  // 🔧 EXISTING: Fetch sleep logs by baby ID and date range (already correct)
  Future<void> fetchSleepLogsByDateRange({
    required int babyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isSleepLogsLoading = true;
    update();

    // Default to last 7 days if no dates provided
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final end = endDate ?? DateTime.now();

    // Format dates to ISO string with proper URL encoding
    final startDateString = start.toIso8601String();
    final endDateString = end.toIso8601String();

    final encodedStartDate = Uri.encodeComponent(startDateString);
    final encodedEndDate = Uri.encodeComponent(endDateString);

    final endpoint =
        '/sleep-logs/baby/$babyId/date-range?startDate=$encodedStartDate&endDate=$encodedEndDate';

    try {
      await ApiService.request(
        endpoint: endpoint,
        method: Api.GET,
        onSuccess: (data) {
          print(
            '😴 Sleep logs API success: ${data.data?.length ?? 0} logs found',
          );

          sleepLogs.clear();
          if (data.data != null && data.data is List) {
            for (var logData in data.data) {
              try {
                sleepLogs.add(SleepLogModel.fromJson(logData));
              } catch (e) {
                print('Error parsing sleep log: $e');
              }
            }
          }

          print('📊 Loaded ${sleepLogs.length} sleep logs for baby $babyId');
          // Sort logs by date (most recent first)
          sleepLogs.sort(
            (a, b) => (b.startTime ?? DateTime.now()).compareTo(
              a.startTime ?? DateTime.now(),
            ),
          );
        },
        onError: (error) {
          print('❌ Sleep logs API error: $error');
          Get.snackbar(
            'Error',
            'Failed to load sleep logs: $error',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      );
    } catch (e) {
      print('💥 Exception in fetchSleepLogsByDateRange: $e');
      Get.snackbar(
        'Error',
        'Failed to load sleep logs: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSleepLogsLoading = false;
      update();
    }
  }

  // 🔧 NEW: Fetch all logs for a baby (convenience method)
  Future<void> fetchAllLogsForBaby(
    int babyId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    print('🚀 Fetching all logs for baby $babyId');

    // Fetch all logs concurrently
    await Future.wait([
      fetchFeedingLogsByDateRange(
        babyId: babyId,
        startDate: startDate,
        endDate: endDate,
      ),
      fetchDiaperLogsByDateRange(
        babyId: babyId,
        startDate: startDate,
        endDate: endDate,
      ),
      fetchSleepLogsByDateRange(
        babyId: babyId,
        startDate: startDate,
        endDate: endDate,
      ),
    ]);

    print('✅ All logs fetched for baby $babyId');
    print('   - Feeding logs: ${feedingLogs.length}');
    print('   - Diaper logs: ${diaperLogs.length}');
    print('   - Sleep logs: ${sleepLogs.length}');
  }

  // 🔧 NEW: Get logs for specific date range (public method for UI)
  Future<void> getLogsForDateRange({
    required int babyId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await fetchAllLogsForBaby(babyId, startDate: startDate, endDate: endDate);
  }

  // 🔧 NEW: Refresh all data for current selected baby
  Future<void> refreshAllData() async {
    if (selectedBady?.id != null) {
      print('🔄 Refreshing all data for baby ${selectedBady!.id}');
      await Future.wait([
        fetchBabyAnalytics(babyId: selectedBady!.id!),
        fetchAllLogsForBaby(selectedBady!.id!),
      ]);
      print('✅ All data refreshed');
    }
  }

  // 🔧 EXISTING: Refresh analytics for current selected baby
  Future<void> refreshAnalytics() async {
    if (selectedBady?.id != null) {
      await fetchBabyAnalytics(babyId: selectedBady!.id!);
    }
  }

  // 🔧 EXISTING: Get analytics for date range
  Future<void> getAnalyticsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (selectedBady?.id != null) {
      await fetchBabyAnalytics(
        babyId: selectedBady!.id!,
        startDate: startDate,
        endDate: endDate,
      );
    }
  }

  // 🔧 NEW: Helper methods to get recent logs
  List<FeedingLogModel> get recentFeedingLogs {
    return feedingLogs.take(10).toList(); // Get last 10 feeding logs
  }

  List<DiaperLogModel> get recentDiaperLogs {
    return diaperLogs.take(10).toList(); // Get last 10 diaper logs
  }

  List<SleepLogModel> get recentSleepLogs {
    return sleepLogs.take(10).toList(); // Get last 10 sleep logs
  }

  // 🔧 CORRECTED: Get logs by date using startTime for all models
  List<FeedingLogModel> getFeedingLogsByDate(DateTime date) {
    return feedingLogs.where((log) {
      if (log.startTime == null) return false;
      return _isSameDate(log.startTime!, date);
    }).toList();
  }

  List<DiaperLogModel> getDiaperLogsByDate(DateTime date) {
    return diaperLogs.where((log) {
      if (log.time == null) return false;
      return _isSameDate(log.time!, date);
    }).toList();
  }

  List<SleepLogModel> getSleepLogsByDate(DateTime date) {
    return sleepLogs.where((log) {
      if (log.startTime == null) return false;
      return _isSameDate(log.startTime!, date);
    }).toList();
  }

  // 🔧 NEW: Duration calculation methods (endTime - startTime)
  Duration getFeedingDuration(FeedingLogModel log) {
    if (log.startTime == null || log.endTime == null) {
      return Duration.zero;
    }
    return log.endTime!.difference(log.startTime!);
  }

  Duration getSleepDuration(SleepLogModel log) {
    if (log.startTime == null || log.endTime == null) {
      return Duration.zero;
    }
    return log.endTime!.difference(log.startTime!);
  }

  // 🔧 NEW: Format duration as readable string
  String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  // 🔧 NEW: Get formatted duration strings
  String getFeedingDurationString(FeedingLogModel log) {
    final duration = getFeedingDuration(log);
    if (duration == Duration.zero) {
      return 'No duration';
    }
    return formatDuration(duration);
  }

  String getSleepDurationString(SleepLogModel log) {
    final duration = getSleepDuration(log);
    if (duration == Duration.zero) {
      return 'No duration';
    }
    return formatDuration(duration);
  }

  // 🔧 NEW: Calculate total times for a day
  Duration getTotalFeedingTimeForDate(DateTime date) {
    final dayLogs = getFeedingLogsByDate(date);
    Duration total = Duration.zero;

    for (var log in dayLogs) {
      total += getFeedingDuration(log);
    }

    return total;
  }

  Duration getTotalSleepTimeForDate(DateTime date) {
    final dayLogs = getSleepLogsByDate(date);
    Duration total = Duration.zero;

    for (var log in dayLogs) {
      total += getSleepDuration(log);
    }

    return total;
  }

  // 🔧 NEW: Calculate average durations
  Duration getAverageFeedingDuration() {
    if (feedingLogs.isEmpty) return Duration.zero;

    Duration total = Duration.zero;
    int validLogs = 0;

    for (var log in feedingLogs) {
      final duration = getFeedingDuration(log);
      if (duration > Duration.zero) {
        total += duration;
        validLogs++;
      }
    }

    if (validLogs == 0) return Duration.zero;
    return Duration(milliseconds: total.inMilliseconds ~/ validLogs);
  }

  Duration getAverageSleepDuration() {
    if (sleepLogs.isEmpty) return Duration.zero;

    Duration total = Duration.zero;
    int validLogs = 0;

    for (var log in sleepLogs) {
      final duration = getSleepDuration(log);
      if (duration > Duration.zero) {
        total += duration;
        validLogs++;
      }
    }

    if (validLogs == 0) return Duration.zero;
    return Duration(milliseconds: total.inMilliseconds ~/ validLogs);
  }

  // 🔧 NEW: Get comprehensive statistics
  Map<String, String> getFeedingStats() {
    final totalTime = feedingLogs.fold<Duration>(
      Duration.zero,
      (total, log) => total + getFeedingDuration(log),
    );

    final avgDuration = getAverageFeedingDuration();

    return {
      'totalFeedings': '${feedingLogs.length}',
      'totalTime': formatDuration(totalTime),
      'averageTime': formatDuration(avgDuration),
      'longestFeeding': formatDuration(_getLongestFeedingDuration()),
      'shortestFeeding': formatDuration(_getShortestFeedingDuration()),
    };
  }

  Map<String, String> getSleepStats() {
    final totalTime = sleepLogs.fold<Duration>(
      Duration.zero,
      (total, log) => total + getSleepDuration(log),
    );

    final avgDuration = getAverageSleepDuration();

    return {
      'totalSessions': '${sleepLogs.length}',
      'totalTime': formatDuration(totalTime),
      'averageTime': formatDuration(avgDuration),
      'longestSleep': formatDuration(_getLongestSleepDuration()),
      'shortestSleep': formatDuration(_getShortestSleepDuration()),
    };
  }

  // 🔧 NEW: Private helper methods for min/max durations
  Duration _getLongestFeedingDuration() {
    if (feedingLogs.isEmpty) return Duration.zero;

    Duration longest = Duration.zero;
    for (var log in feedingLogs) {
      final duration = getFeedingDuration(log);
      if (duration > longest) {
        longest = duration;
      }
    }
    return longest;
  }

  Duration _getShortestFeedingDuration() {
    if (feedingLogs.isEmpty) return Duration.zero;

    Duration shortest = Duration(days: 1); // Start with a very large duration
    for (var log in feedingLogs) {
      final duration = getFeedingDuration(log);
      if (duration > Duration.zero && duration < shortest) {
        shortest = duration;
      }
    }
    return shortest == Duration(days: 1) ? Duration.zero : shortest;
  }

  Duration _getLongestSleepDuration() {
    if (sleepLogs.isEmpty) return Duration.zero;

    Duration longest = Duration.zero;
    for (var log in sleepLogs) {
      final duration = getSleepDuration(log);
      if (duration > longest) {
        longest = duration;
      }
    }
    return longest;
  }

  Duration _getShortestSleepDuration() {
    if (sleepLogs.isEmpty) return Duration.zero;

    Duration shortest = Duration(days: 1); // Start with a very large duration
    for (var log in sleepLogs) {
      final duration = getSleepDuration(log);
      if (duration > Duration.zero && duration < shortest) {
        shortest = duration;
      }
    }
    return shortest == Duration(days: 1) ? Duration.zero : shortest;
  }

  // 🔧 NEW: Get logs with their durations for UI display
  List<Map<String, dynamic>> getFeedingLogsWithDuration() {
    return feedingLogs.map((log) {
      return {
        'log': log,
        'duration': getFeedingDuration(log),
        'durationString': getFeedingDurationString(log),
        'startTime': log.startTime,
        'endTime': log.endTime,
      };
    }).toList();
  }

  List<Map<String, dynamic>> getSleepLogsWithDuration() {
    return sleepLogs.map((log) {
      return {
        'log': log,
        'duration': getSleepDuration(log),
        'durationString': getSleepDurationString(log),
        'startTime': log.startTime,
        'endTime': log.endTime,
      };
    }).toList();
  }

  // 🔧 NEW: Get comprehensive daily summary with durations
  Map<String, dynamic> getDailySummary(DateTime date) {
    final feedingLogs = getFeedingLogsByDate(date);
    final diaperLogs = getDiaperLogsByDate(date);
    final sleepLogs = getSleepLogsByDate(date);

    final totalFeedingTime = getTotalFeedingTimeForDate(date);

    final totalSleepTime = getTotalSleepTimeForDate(date);

    return {
      'date': date,
      'feedingCount': feedingLogs.length,
      'diaperCount': diaperLogs.length,
      'sleepCount': sleepLogs.length,
      'totalFeedingTime': totalFeedingTime,
      // 'totalDiaperTime': totalDiaperTime,
      'totalSleepTime': totalSleepTime,
      'totalFeedingTimeString': formatDuration(totalFeedingTime),
      //'totalDiaperTimeString': formatDuration(totalDiaperTime),
      'totalSleepTimeString': formatDuration(totalSleepTime),
      'feedingLogs': feedingLogs,
      'diaperLogs': diaperLogs,
      'sleepLogs': sleepLogs,
    };
  }

  // 🔧 NEW: Helper method to check if two dates are the same day
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // 🔧 NEW: Get total counts
  int get totalFeedingLogs => feedingLogs.length;
  int get totalDiaperLogs => diaperLogs.length;
  int get totalSleepLogs => sleepLogs.length;

  // 🔧 NEW: Get loading states
  bool get isAnyLoading =>
      isLoading ||
      isAnalyticsLoading ||
      isFeedingLogsLoading ||
      isDiaperLogsLoading ||
      isSleepLogsLoading;
  bool get isAnyLogLoading =>
      isFeedingLogsLoading || isDiaperLogsLoading || isSleepLogsLoading;

  // 🔧 NEW: Check if we have any logs
  bool get hasAnyLogs =>
      feedingLogs.isNotEmpty || diaperLogs.isNotEmpty || sleepLogs.isNotEmpty;
  bool get hasFeedingLogs => feedingLogs.isNotEmpty;
  bool get hasDiaperLogs => diaperLogs.isNotEmpty;
  bool get hasSleepLogs => sleepLogs.isNotEmpty;

  String calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);

    // Calculate various time units
    final days = difference.inDays;
    final weeks = (days / 7).floor();
    final months =
        ((now.year - birthDate.year) * 12 + now.month - birthDate.month);
    final years = now.year - birthDate.year;

    // Adjust months if the day hasn't occurred yet this month
    final adjustedMonths = months - (now.day < birthDate.day ? 1 : 0);

    // Adjust years if birthday hasn't occurred yet this year
    final adjustedYears =
        years -
        ((now.month < birthDate.month ||
                (now.month == birthDate.month && now.day < birthDate.day))
            ? 1
            : 0);

    // Return appropriate format based on age
    if (adjustedYears >= 2) {
      return '$adjustedYears years old';
    } else if (adjustedYears == 1) {
      return '1 year old';
    } else if (adjustedMonths >= 2) {
      return '$adjustedMonths months old';
    } else if (adjustedMonths == 1) {
      return '1 month old';
    } else if (weeks >= 2) {
      return '$weeks weeks old';
    } else if (weeks == 1) {
      return '1 week old';
    } else if (days >= 2) {
      return '$days days old';
    } else if (days == 1) {
      return '1 day old';
    } else {
      return 'Born today';
    }
  }

  void showDiaperChangeBottomSheet() {
    Get.bottomSheet(
      const DiaperChangeBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((result) {
      if (result != null && result is DiaperLogModel) {
        // Handle the saved diaper log here
        LogDiaper(result);
        print('Diaper log saved: ${result.toJson()}');
      }
    });
  }

  void showSleepLogBottomSheet() {
    Get.bottomSheet(
      const SleepLogBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((result) {
      if (result != null && result is SleepLogModel) {
        // Handle the saved sleep log here
        LogSleep(result);
        print('Sleep log saved: ${result.toJson()}');
      }
    });
  }

  void showFeedingLogBottomSheet() {
    Get.bottomSheet(
      const FeedingLogBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((result) {
      if (result != null && result is FeedingLogModel) {
        // Handle the saved feeding log here
        logFeeding(result);
        print('Feeding log saved: ${result.toJson()}');
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    inituser();
  }
}
