import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mommilk_user/Screens/TimeLineScreen/Service/TimelineController.dart';
import 'package:mommilk_user/Screens/TimeLineScreen/View/ActivityTimeLineScreen.dart';
import 'package:mommilk_user/Utils/Constants.dart';
import 'package:mommilk_user/theme/app_theme.dart';
import 'package:timelines_plus/timelines_plus.dart';

class Activitytimelinescreen extends StatelessWidget {
  Activitytimelinescreen({super.key});

  final Timelinecontroller tcltr = Get.put(Timelinecontroller());

  @override
  Widget build(BuildContext context) {
    tcltr.fetchTimeLogs(tcltr.selectedDate.value);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Image.asset(fullIcon),
        actions: [SizedBox(width: 10)],
      ),
      body: ActivityTimeLineBody(),
    );
  }
}
