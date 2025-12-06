import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Service/TrackerController.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Views/ActivityChartScreen.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Views/OverviewScreen.dart';

class Trackerscreen extends StatelessWidget {
  Trackerscreen({super.key});

  /// ---------- MENU BUTTONS UI ---------- ///
  Map<int, Widget> buildMenus(int selectedIndex, BuildContext context) {
    return {
      0: Container(
        width: 200,
        height: 46,
        decoration: BoxDecoration(
          color: selectedIndex == 0
              ?  Color(0xffFB7185)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            "Baby Activity",
            style: TextStyle(
              color: selectedIndex == 0
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
          color: selectedIndex == 1
              ?   Color(0xffFB7185)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            "Overview",
            style: TextStyle(
              color: selectedIndex == 1
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        /// ---------------- APPBAR ---------------- ///
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            "Report",
            style: TextStyle(
              fontSize: 24,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      primaryColor: Colors.transparent,
                      scaffoldBackgroundColor: Colors.transparent,
                      barBackgroundColor: Colors.transparent,
                    ),
                    child: CupertinoSlidingSegmentedControl(
                      thumbColor: Colors.transparent,
                      groupValue: tctrl.selectedTrackerMenu,
                      onValueChanged: (int? value) {
                        tctrl.selectedTrackerMenu = value ?? 0;
                        tctrl.update();
                      },
                      children: buildMenus(tctrl.selectedTrackerMenu, context),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// ---------- MAIN CONTENT ---------- ///
                if (tctrl.selectedbaby == 0)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
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
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first baby profile to start tracking',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.7),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else if (tctrl.selectedTrackerMenu == 0)
                  Expanded(child: ActivityChartScreen())
                else
                  Expanded(child: Overviewscreen()),
              ],
            );
          },
        ),
      ),
    );
  }
}
