import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Service/TrackerController.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Views/DiaperOverview.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Views/FeedingOverviewCard.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Views/SleepingActivityCard.dart';
import 'package:mommilk_user/theme/app_theme.dart';

Map<int, Widget> _menus = <int, Widget>{
  0: SizedBox(width: 178, height: 46, child: Center(child: Text("Last Day".tr))),
  1: SizedBox(width: 178, height: 46, child: Center(child: Text("Last Week".tr))),
  2: SizedBox(width: 178, height: 46, child: Center(child: Text("Last Month".tr))),
};

class Overviewscreen extends StatelessWidget {
  Overviewscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackerController>(
      builder: (__) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child:
              (__.isOverviewLoading)
                  ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  )
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: double.infinity),

                        CupertinoSlidingSegmentedControl(
                          groupValue: __.selectedDateOption,
                          backgroundColor: AppTheme.darkBackgroundColor,
                          thumbColor: Theme.of(context).primaryColor,
                          onValueChanged: (int? value) async {
                            __.selectedDateOption = value ?? 0;
                            if (value == 0) {
                              __.overviewStartDate = DateTime.now();
                            } else if (value == 1) {
                              __.overviewStartDate = DateTime.now().subtract(
                                Duration(days: 7),
                              );
                            } else {
                              __.overviewStartDate = DateTime.now().subtract(
                                Duration(days: 30),
                              );
                            }
                            Get.dialog(
                              Center(
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                              barrierDismissible: false,
                            );
                            await __.fetchBabyOverview();
                            Get.back();

                            __.update();
                          },
                          children: _menus,
                        ),
                        SizedBox(height: 20),

                        Text(
                          'Feeding Analytics'.tr,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),

                        Feedingoverviewcard(
                          model: __.overviewModel.feedAnalytics!,
                        ),
                        SizedBox(height: 20),
                        SleepingActivityCard(
                          model: __.overviewModel.sleepAnalytics!!,
                        ),
                        SizedBox(height: 10),
                        DiaperOverviewCard(
                          model: __.overviewModel.diaperAnalytics!!,
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
