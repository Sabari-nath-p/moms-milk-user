import 'dart:convert';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/TimeLineScreen/Service/TimelineController.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Models/AnalyticsOverviewModel.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:mommilk_user/Utils/TimeGantChart.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class TrackerController extends GetxController {
  int selectedTrackerMenu = 0;
  int selectedDateOption = 0;
  TimeGanttChartController ganttChartController = TimeGanttChartController();
  final Timelinecontroller timelineController = Get.put(Timelinecontroller());

  List<GanttActivity> activityList = [];

  DateTime activityStartDate = DateTime.now();
  DateTime activityEndDate = DateTime.now().add(Duration(days: 4));
  DateTime overviewEndDate = DateTime.now();
  DateTime overviewStartDate = DateTime.now();

  Homecontroller hctrl = Get.find();
  int selectedbaby = 0;
  late BabyActivityOverviewModel overviewModel;
  bool isLoading = false;
  bool isOverviewLoading = true;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    // selectedbaby = hctrl.selectedBady!.id!;
    // fetchFeedingLogs(startDate: activityStartDate, endDate: activityEndDate);
    // fetchDiaperLogs(startDate: activityStartDate, endDate: activityEndDate);
    // fetchSleepLog(startDate: activityStartDate, endDate: activityEndDate);
    // ganttChartController.scrollToDate(DateTime.now());
    // ganttChartController.scrollToCurrentTime();
    // fetchBabyOverview();
  }

  void fetchAnalytics() {
    isLoading = false;
    isOverviewLoading = true;
    selectedTrackerMenu = 0;
    selectedDateOption = 0;
    ganttChartController = TimeGanttChartController();

    activityList = [];

    activityStartDate = DateTime.now().subtract(Duration(days: 2));
    activityEndDate = DateTime.now().add(Duration(days: 4));
    overviewEndDate = DateTime.now();
    overviewStartDate = DateTime.now();

    hctrl = Get.find();
    selectedbaby = 0;

    if (hctrl.selectedBady != null) {
      selectedbaby = hctrl.selectedBady!.id!;
      fetchFeedingLogs(startDate: activityStartDate, endDate: activityEndDate);
      fetchDiaperLogs(startDate: activityStartDate, endDate: activityEndDate);
      fetchSleepLog(startDate: activityStartDate, endDate: activityEndDate);
      ganttChartController.scrollToDate(DateTime.now());
      ganttChartController.scrollToCurrentTime();
      fetchBabyOverview();
    }
  }

  Future<void> fetchBabyOverview() async {
    await ApiService.request(
      endpoint: "/babies/analytics",
      body: {
        "babyId": selectedbaby,
        "startDate": DateFormat("yyyy-MM-dd").format(overviewStartDate),
        "endDate":
            "${DateFormat("yyyy-MM-dd").format(overviewEndDate)} 23:59:59",
      },

      onSuccess: (data) {
        if (data.statusCode == 201) {
          overviewModel = BabyActivityOverviewModel.fromJson(data.data);
          isOverviewLoading = false;
          update();
        }
      },
    );
  }

  void resetAll() {
    activityStartDate = DateTime.now().subtract(Duration(days: 5));
    activityEndDate = DateTime.now().add(Duration(days: 5));
    activityList = [];
  }

  void getLogs({bool isForward = false}) async {
    DateTime endDate = activityEndDate;
    DateTime startDate = activityEndDate;
    if (!isForward) {
      startDate = activityStartDate.subtract(Duration(days: 7));
      endDate = activityStartDate;
    } else {
      endDate = activityEndDate.add(Duration(days: 7));
      startDate = activityEndDate;
    }

    isLoading = true;
    Get.dialog(
      Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      ),
      barrierDismissible: false,
    );

    update();
    if (isForward) {
      activityEndDate = endDate;
    } else {
      activityStartDate = startDate;
    }

    await fetchFeedingLogs(startDate: startDate, endDate: endDate);
    await fetchDiaperLogs(startDate: startDate, endDate: endDate);
    await fetchSleepLog(startDate: startDate, endDate: endDate);
    Get.back();
    isLoading = false;

    update();
    ganttChartController.updateDateRange(
      startDate: activityStartDate,
      endDate: activityEndDate,
    );

    await Future.delayed(Duration(milliseconds: 800));
    if (isForward) {
      ganttChartController.scrollToDate(startDate.subtract(Duration(days: 4)));
    } else {
      ganttChartController.scrollToDate(startDate.add(Duration(days: 4)));
    }
  }

  Future<void> fetchFeedingLogs({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await ApiService.request(
      endpoint:
          "/feed-logs/baby/${selectedbaby}/date-range?startDate=${DateFormat("yyyy-MM-dd").format(startDate)}&endDate=${DateFormat("yyyy-MM-dd").format(endDate)} 23:59:59",
      method: Api.GET,
      onSuccess: (body) {
        if (body.statusCode == 200) {
          for (var data in body.data) {
            activityList.add(
              GanttActivity(
                id: data["id"].toString(),
                startTime: DateTime.parse(data["startTime"]),
                endTime: DateTime.parse(data["endTime"]),
                type: "Feed(${data["feedType"]})",
                color: Colors.amber,
              ),
            );
          }

          update();
        }
      },
    );
  }

  Future<void> fetchDiaperLogs({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await ApiService.request(
      endpoint:
          "/diaper-logs/baby/${selectedbaby}/date-range?startDate=${DateFormat("yyyy-MM-dd").format(startDate)}&endDate=${DateFormat("yyyy-MM-dd").format(endDate)} 23:59:59",
      method: Api.GET,
      onSuccess: (body) {
        if (body.statusCode == 200) {
          for (var data in body.data) {
            DateTime dt = DateTime.parse(data["time"]);
            activityList.add(
              GanttActivity(
                id: data["id"].toString(),
                startTime: dt,
                endTime: dt.add(Duration(minutes: 15)),
                type: "Diaper(${data["diaperType"]})",
                color: Colors.green,
              ),
            );
          }
          update();
        }
      },
    );
  }

  Future<void> fetchSleepLog({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await ApiService.request(
      endpoint:
          "/sleep-logs/baby/${selectedbaby}/date-range?startDate=${DateFormat("yyyy-MM-dd").format(startDate)} 00:00:00&endDate=${DateFormat("yyyy-MM-dd").format(endDate)} 23:59:59",

      method: Api.GET,
      onSuccess: (body) {
        if (body.statusCode == 200) {
          for (var data in body.data) {
            activityList.add(
              GanttActivity(
                id: data["id"].toString(),
                startTime: DateTime.parse(data["startTime"]),
                endTime: DateTime.parse(data["endTime"]),
                type: "${'sleep'.tr} (${data["location"]})",
                color: Colors.indigo,
              ),
            );
          }
          update();
        }
      },
    );
  }
}
