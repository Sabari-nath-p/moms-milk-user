import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/BabyModel.dart';
import 'package:mommilk_user/Models/BabyAnalyticsModel.dart';
import 'package:mommilk_user/Models/DiaperLogModel.dart';
import 'package:mommilk_user/Models/SleepLogModel.dart';
import 'package:mommilk_user/Models/FeedingLogModel.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/DiaperChangeBottomSheet.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/SleepLogBottomSheet.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/FeedingLogBottomSheet.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class Homecontroller extends GetxController {
  bool isLoading = false;
  bool isAnalyticsLoading = false;
  List<BabyModel> myBabies = [];
  BabyModel? selectedBady;
  BabyAnalyticsLog? babyAnalytics;

  fetchBabies({isNew = false}) async {
    await ApiService.request(
      endpoint: "/babies",
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
        }
        update();
      },
    );
  }

  bool isSubmitLoading = false;

  LogDiaper(DiaperLogModel model) async {
    isLoading = true;
    update();
    await ApiService.request(
      endpoint: "/diaper-logs",
      body: model.toJson(),
      onSuccess: (data) {
        Get.back();
        Get.snackbar('Success', 'Diaper log logged successfully!');
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
      },
    );
    isLoading = false;
    update();
  }

  void inituser() {
    fetchBabies();
  }

  // Fetch baby analytics data
  Future<void> fetchBabyAnalytics({
    required int babyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isAnalyticsLoading = true;
    update();

    // Default to last 3 days if no dates provided
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 2));
    final end = endDate ?? DateTime.now();

    // Format dates to ISO string with proper URL encoding
    final startDateString = start.toIso8601String();
    final endDateString = end.toIso8601String();

    final encodedStartDate = Uri.encodeComponent(startDateString);
    final encodedEndDate = Uri.encodeComponent(endDateString);

    final endpoint =
        '/analytics/baby/$babyId/combined?startDate=$encodedStartDate&endDate=$encodedEndDate';

    try {
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

  // Refresh analytics for current selected baby
  Future<void> refreshAnalytics() async {
    if (selectedBady?.id != null) {
      await fetchBabyAnalytics(babyId: selectedBady!.id!);
    }
  }

  // Get analytics for date range
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
        // You can add it to a list, send to API, etc.
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
        // You can add it to a list, send to API, etc.
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
        // You can add it to a list, send to API, etc.
        print('Feeding log saved: ${result.toJson()}');
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    inituser();
  }
}
