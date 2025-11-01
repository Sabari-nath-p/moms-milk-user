import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Service/TrackerController.dart';
import 'package:mommilk_user/Utils/TimeGantChart.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class ActivityChartScreen extends StatelessWidget {
  const ActivityChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackerController>(
      builder: (__) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 8, backgroundColor: Colors.amber),
                  SizedBox(width: 10),
                  Text("Feeding"),
                  SizedBox(width: 20),

                  CircleAvatar(radius: 8, backgroundColor: Colors.green),
                  SizedBox(width: 10),
                  Text("Diaper"),
                  SizedBox(width: 20),

                  CircleAvatar(radius: 8, backgroundColor: Colors.indigo),
                  SizedBox(width: 10),
                  Text("Sleep"),
                ],
              ),

              Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsetsDirectional.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TimeGanttChart(
                    activities: __.activityList,
                    controller: __.ganttChartController,
                    style: GanttChartStyle(
                      chartBackgroundColor: AppTheme.primaryColor.withOpacity(
                        .1,
                      ),
                      timeAxisBackgroundColor: AppTheme.primaryColor
                          .withOpacity(.1),
                      headerBackgroundColor: AppTheme.primaryColor.withOpacity(
                        .1,
                      ),
                      gridColor: Colors.white10,
                    ),
                    onReachEnd: () {
                      __.getLogs(isForward: true);
                    },
                    onReachStart: () {
                      __.getLogs(isForward: false);
                    },

                    yAxisTimeIncrement: Duration(minutes: 30),
                    startDate: __.activityStartDate,
                    endDate: __.activityEndDate,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
