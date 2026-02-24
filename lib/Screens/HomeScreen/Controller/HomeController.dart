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
  int connectionTabIndex = 0; // 0 = My Connections, 1 = Find Donors

  // 🔧 NEW: Individual loading states for logs

  // 🔧 EXISTING: Baby data
  List<BabyModel> myBabies = [];
  BabyModel? selectedBady;
  BabyAnalyticsLog? babyAnalytics;

  int pendingRequest = 0;

  // 🔧 NEW: Individual log lists

  fetchBabies({isNew = false}) async {
    await ApiService.request(
      endpoint: "/babies/user/${user.id}",
      method: Api.GET,
      onSuccess: (body) {
        myBabies.clear();
        print(body.data);
        for (var data in body.data) {
          myBabies.add(BabyModel.fromJson(data));
        }
        if (myBabies.isNotEmpty) {
          selectedBady = myBabies.last;
        } else {
          selectedBady = null;
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
        Get.to(
          () => Activitytimelinescreen(),
          transition: Transition.rightToLeft,
        );
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
        // 🔧 NEW: Refresh sleep logs after adding
        Get.to(
          () => Activitytimelinescreen(),
          transition: Transition.rightToLeft,
        );
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
        Get.back();
        Get.to(
          () => Activitytimelinescreen(),
          transition: Transition.rightToLeft,
        );
        Get.snackbar('Success', 'Feeding Log logged successfully!');
      },
    );
    isLoading = false;
    update();
  }

  void inituser() {
    fetchBabies();
    fetchIncommingRequest();
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

  void fetchIncommingRequest() async {
    ApiService.request(
      endpoint: "/requests/incoming?status=PENDING&page=1&limit=10",
      method: Api.GET,
      onSuccess: (data) {
        print(data.data);
        if (data.statusCode == 200 || data.statusCode == 201)
          pendingRequest = data.data["data"].length;
        update();
      },
    );
  }

  void showDiaperChangeBottomSheet() {
    Get.bottomSheet(
      DiaperChangeBottomSheet(),
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
      SleepLogBottomSheet(),
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
      FeedingLogBottomSheet(),
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
