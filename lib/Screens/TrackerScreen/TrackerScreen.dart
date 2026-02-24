import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/TimeLineScreen/View/ActivityTimeLineScreen.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Service/TrackerController.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Views/ActivityChartScreen.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Views/OverviewScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class Trackerscreen extends StatelessWidget {
  Trackerscreen({super.key});

  /// ---------- MENU BUTTONS UI ---------- ///
  Map<int, Widget> buildMenus(int selectedIndex, BuildContext context) {
    return {
      0: Container(
        width: 200,
        height: 46,
        decoration: BoxDecoration(
          color:
              selectedIndex == 0 ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            "Baby Activity".tr,
            style: TextStyle(
              color:
                  selectedIndex == 0
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      1: Container(
        width: 200,
        height: 46,
        decoration: BoxDecoration(
          color:
              selectedIndex == 1 ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            "Overview".tr,
            style: TextStyle(
              color:
                  selectedIndex == 1
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    TrackerController tctrl = Get.put(TrackerController());
    tctrl.fetchAnalytics();
    tctrl.timelineController.fetchTimeLogs(
      tctrl.timelineController.selectedDate.value,
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        /// ---------------- APPBAR ---------------- ///
        appBar:AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  scrolledUnderElevation: 0,
  centerTitle: true,
  
  title:  Text(
    "Activity Report".tr,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontFamily: "Inter",
    ),
  ),
),


        body: GetBuilder<TrackerController>(
          builder: (__) {
            return Column(
              children: [
                SizedBox(height: 10),

                /// ---------- SEGMENT CONTROL ---------- ///
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      primaryColor: Colors.transparent,
                      scaffoldBackgroundColor: Colors.transparent,
                      barBackgroundColor: Colors.transparent,
                    ),
                    child: CupertinoSlidingSegmentedControl(
                      backgroundColor: Colors.black.withOpacity(.05),
                      thumbColor: Colors.transparent,
                      groupValue: tctrl.selectedTrackerMenu,
                      onValueChanged: (int? value) {
                        tctrl.selectedTrackerMenu = value ?? 0;

                        if (value == 0)
                          tctrl.timelineController.fetchTimeLogs(
                            tctrl.timelineController.selectedDate.value,
                          );
                        tctrl.update();
                      },
                      children: buildMenus(tctrl.selectedTrackerMenu, context),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                if (tctrl.selectedbaby == 0)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(24),
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
                          SizedBox(height: 24),
                          Text(
                            'No Babies Added Yet'.tr,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add your first baby profile to start tracking'.tr,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else if (tctrl.selectedTrackerMenu == 0)
                  Expanded(child: ActivityTimeLineBody())
                else
                  Expanded(child: ActivityChartScreen()),
              ],
            );
          },
        ),
      ),
    );
  }
}
