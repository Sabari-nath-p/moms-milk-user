import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Service/TrackerController.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Views/ActivityChartScreen.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Views/OverviewScreen.dart';
import 'package:mommilk_user/Utils/TimeGantChart.dart';
import 'package:mommilk_user/theme/app_theme.dart';

Map<int, Widget> menus = <int, Widget>{
  0: SizedBox(
    width: 178,
    height: 46,
    child: Center(child: Text("Baby Activity")),
  ),
  1: SizedBox(width: 178, height: 46, child: Center(child: Text("Overview"))),
};

class Trackerscreen extends StatelessWidget {
  Trackerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    TrackerController tctrl = Get.put(TrackerController());
    tctrl.fetchAnalytics();
    return GetBuilder<TrackerController>(
      builder: (__) {
        return Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: CupertinoSlidingSegmentedControl(
                groupValue: tctrl.selectedTrackerMenu,
                onValueChanged: (int? value) {
                  tctrl.selectedTrackerMenu = value ?? 0;
                  tctrl.update();
                },
                children: menus,
              ),
            ),

            SizedBox(height: 20),
            if (tctrl.selectedbaby == 0)
              Container(
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.child_care,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Babies Added Yet',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first baby profile to start tracking',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else if (tctrl.selectedTrackerMenu == 0)
              ActivityChartScreen()
            else
              Expanded(child: Overviewscreen()),
            if (false)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 600,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: TimeGanttChart(
                    showZoomControls: true,
                    style: GanttChartStyle(
                      // Background colors - Deep purple/plum theme
                      backgroundColor: Colors.transparent,
                      chartBackgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(.05),
                      headerBackgroundColor: Color(0xFF4A3F52),
                      timeAxisBackgroundColor: Color(0xFF4A3F52),

                      // Grid and borders - Subtle darker purple
                      gridColor: Colors.white.withOpacity(.1),
                      gridLineWidth: 0.8,

                      // Text colors - Light gray/white text
                      headerTextColor: Color(0xFFE5D9E8),
                      timeAxisTextColor: Color(0xFFD1C4D9),
                      dateTextColor: Color(0xFFE5D9E8),

                      // Dimensions
                      cellHeight: 38.0,
                      headerHeight: 68.0,
                      timeAxisWidth: 58.0,
                      columnWidth: 78.0,

                      // Activity bar styling - Rounded corners
                      activityPadding: EdgeInsets.symmetric(
                        horizontal: 3.0,
                        vertical: 4.0,
                      ),
                      activityBorderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      activityBorderWidth: 0.0,
                      activityBorderColor: Colors.transparent,

                      // Current time indicator - Coral/salmon color
                      currentTimeIndicatorColor: Color(0xFFFF8A80),
                      showCurrentTimeIndicator: true,

                      // Text styles
                      headerTextStyle: TextStyle(
                        color: Color(0xFFE5D9E8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),

                      timeAxisTextStyle: TextStyle(
                        color: Color(0xFFD1C4D9),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),

                      dateTextStyle: TextStyle(
                        color: Color(0xFFE5D9E8),
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    activities: [
                      GanttActivity(
                        id: '1',
                        startTime: DateTime(2020, 11, 28, 8, 0),
                        endTime: DateTime(2020, 11, 28, 10, 30),
                        type: 'Sleep',
                        color: const Color(0xFF67E8F9),
                      ),
                      GanttActivity(
                        id: '2',
                        startTime: DateTime(2020, 11, 28, 12, 0),
                        endTime: DateTime(2020, 11, 28, 13, 30),
                        type: 'Meeting',
                        color: const Color(0xFF8B5CF6),
                      ),
                      GanttActivity(
                        id: '3',
                        startTime: DateTime(2020, 11, 28, 14, 0),
                        endTime: DateTime(2020, 11, 28, 16, 0),
                        type: 'Work',
                        color: const Color(0xFFF97316),
                      ),
                      GanttActivity(
                        id: '4',
                        startTime: DateTime(2020, 11, 29, 9, 0),
                        endTime: DateTime(2020, 11, 29, 10, 0),
                        type: 'Exercise',
                        color: const Color(0xFFEC4899),
                      ),
                      GanttActivity(
                        id: '5',
                        startTime: DateTime(2020, 11, 30, 8, 0),
                        endTime: DateTime(2020, 11, 30, 12, 0),
                        type: 'Sleep',
                        color: const Color(0xFF67E8F9),
                      ),
                    ],
                    startDate: DateTime(2020, 11, 28),
                    endDate: DateTime(2020, 12, 4),
                    onReachStart: () => debugPrint('Reached start'),
                    onReachEnd: () => debugPrint('Reached end'),
                    onActivityTap:
                        (activity) => debugPrint('Tapped: ${activity.type}'),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
