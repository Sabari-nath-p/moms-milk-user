import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class TimeLineData {
  int id;
  String activity;
  String descirpiton;
  DateTime dateTime;
  String activityType; // 'feeding', 'diaper', 'sleep'
  dynamic icon;
  Color color;

  TimeLineData({
    required this.id,
    required this.activity,
    required this.dateTime,
    required this.descirpiton,
    required this.activityType,
    required this.icon,
    required this.color,
  });
}

class Timelinecontroller extends GetxController {
  List<TimeLineData> timedatalist = [];
  RxBool isLoading = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  DateTime startDate = DateTime.now();
  Homecontroller hctrl = Get.find();
  int selectedbaby = 0;
  DatePickerController dateController = DatePickerController();

  // Filter options
  RxBool showFeeding = true.obs;
  RxBool showDiaper = true.obs;
  RxBool showSleep = true.obs;

  // Statistics
  RxInt totalFeedings = 0.obs;
  RxInt totalDiaperChanges = 0.obs;
  RxInt totalSleepSessions = 0.obs;
  RxString totalSleepDuration = "0h 0m".obs;

  List<TimeLineData> get filteredTimeDataList {
    return timedatalist.where((item) {
      if (item.activityType == 'feeding' && !showFeeding.value) return false;
      if (item.activityType == 'diaper' && !showDiaper.value) return false;
      if (item.activityType == 'sleep' && !showSleep.value) return false;
      return true;
    }).toList();
  }

  fetchTimeLogs(DateTime date) async {
    if (hctrl.selectedBady == null) {
      return;
    }
    selectedbaby = hctrl.selectedBady!.id ?? 0;
    selectedDate.value = date;
    timedatalist.clear();
    isLoading.value = true;

    startDate = date.add(Duration(hours: 24));
    await Future.wait([
      fetchFeedingLogs(startDate: date, endDate: startDate),
      fetchDiaperLogs(startDate: date, endDate: startDate),
      fetchSleepLog(startDate: date, endDate: startDate),
    ]);
    dateController.animateToSelection();

    timedatalist.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    calculateStatistics();
    isLoading.value = false;
    update();
  }

  void calculateStatistics() {
    totalFeedings.value = 0;
    totalDiaperChanges.value = 0;
    // totalSleepSessions.value = 0;

    Map<int, DateTime> sleepStarts = {};
    //int totalSleepMinutes = 0;

    for (var item in timedatalist) {
      if (item.activityType == 'feeding') {
        totalFeedings.value++;
      } else if (item.activityType == 'diaper') {
        totalDiaperChanges.value++;
      } else if (item.activityType == 'sleep') {
        // if (item.activity == 'Sleep Started') {
        //   sleepStarts[item.id] = item.dateTime;
        // } else if (item.activity == 'Sleep Ended' &&
        //     sleepStarts.containsKey(item.id)) {
        //   totalSleepSessions.value++;
        //   var duration = item.dateTime.difference(sleepStarts[item.id]!);
        //   totalSleepMinutes += duration.inMinutes;
        // }
      }
    }

    int hours = totalSleepSessions.value ~/ 60;
    int minutes = totalSleepSessions.value % 60;
    totalSleepDuration.value = "${hours}h ${minutes}m";
  }

  String formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds} seconds'.tr;
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minutes'.tr;
    } else {
      return '${duration.inHours} hour'.tr;
    }
  }

  Future<void> fetchFeedingLogs({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await ApiService.request(
      endpoint:
          "/feed-logs/baby/${selectedbaby}/date-range?startDate=${DateFormat("yyyy-MM-dd").format(startDate)}&endDate=${DateFormat("yyyy-MM-dd").format(startDate)} 23:59:59.000",
      method: Api.GET,
      onSuccess: (body) {
        if (body.statusCode == 200) {
          for (var data in body.data) {
            String content = "";
            String title = "";

            if (data["feedType"] == "BREAST") {
              title =
                  title +
                  "${data["feedType"].toString().capitalize} -  ${data["position"].toString().capitalize} Side";
            } else {
              title = title + "${data["feedType"].toString().capitalize}";
            }
            var difference = DateTime.parse(
              data["endTime"],
            ).difference(DateTime.parse(data["startTime"]));
            content = "${formatDuration(difference)} • $title";
            timedatalist.add(
              TimeLineData(
                id: data["id"],
                dateTime: DateTime.parse(data["startTime"]),
                activity: "Baby Feeded".tr,
                descirpiton: content,
                activityType: 'feeding',
                icon: FontAwesomeIcons.personBreastfeeding,
                color: Colors.orange.shade400,
              ),
            );
          }
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
          "/diaper-logs/baby/${selectedbaby}/date-range?startDate=${DateFormat("yyyy-MM-dd").format(startDate)}&endDate=${DateFormat("yyyy-MM-dd").format(endDate)}",
      method: Api.GET,
      onSuccess: (body) {
        if (body.statusCode == 200) {
          for (var data in body.data) {
            DateTime dt = DateTime.parse(data["time"]);
            timedatalist.add(
              TimeLineData(
                id: data["id"],
                dateTime: dt,
                activity: "Diaper Change".tr,
                descirpiton:
                    "${'Baby diaper change with'.tr} ${data["diaperType"]}"
                        .capitalizeFirst!,
                activityType: 'diaper',
                icon: Icons.baby_changing_station,
                color: Colors.blue.shade400,
              ),
            );
          }
        }
      },
    );
  }

  Future<void> fetchSleepLog({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    totalSleepSessions.value = 0;
    await ApiService.request(
      endpoint:
          "/sleep-logs/baby/${selectedbaby}/date-range?startDate=${DateFormat("yyyy-MM-dd").format(startDate)}&endDate=${DateFormat("yyyy-MM-dd").format(endDate)}",
      method: Api.GET,
      onSuccess: (body) {
        if (body.statusCode == 200) {
          for (var data in body.data) {
            var duration = formatDuration(
              DateTime.parse(
                data["endTime"],
              ).difference(DateTime.parse(data["startTime"])),
            );
            timedatalist.add(
              TimeLineData(
                id: data["id"],
                dateTime: DateTime.parse(data["endTime"]),
                activity: "${"Sleep".tr} ($duration)",
                descirpiton:
                    "${'baby_sleeps_in'.tr} ${data["location"]}"
                        .capitalizeFirst!,
                activityType: 'sleep',
                icon: Icons.alarm,
                color: Colors.indigo.shade400,
              ),
            );

            totalSleepSessions.value =
                totalSleepSessions.value +
                DateTime.parse(
                  data["endTime"],
                ).difference(DateTime.parse(data["startTime"])).inMinutes;
            update();
          }
        }
      },
    );
  }

  void toggleFilter(String type) {
    if (type == 'feeding') {
      showFeeding.value = !showFeeding.value;
    } else if (type == 'diaper') {
      showDiaper.value = !showDiaper.value;
    } else if (type == 'sleep') {
      showSleep.value = !showSleep.value;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();

    fetchTimeLogs(DateTime.now());
  }
}
