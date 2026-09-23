import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';

class HRequestCard extends StatelessWidget {
  final Homecontroller controller;
  HRequestCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Color(0xFFE11D48);
    final Color unselectedColor = Colors.black87;
    final Color bg = Color(0xFFFFE4E6);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          // -----------------------------------
          // MY CONNECTIONS TAB BUTTON
          // -----------------------------------
          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.connectionTabIndex = 0;
                controller.update();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: controller.connectionTabIndex == 0 ? bg : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: selectedColor.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "My Connections".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: controller.connectionTabIndex == 0
                        ? selectedColor
                        : unselectedColor,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // -----------------------------------
          // FIND DONORS TAB BUTTON
          // -----------------------------------
          if (user.userType != "DONOR".tr)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.connectionTabIndex = 1;
                  controller.update();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: controller.connectionTabIndex == 1 ? bg : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: selectedColor.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Find Donors".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: controller.connectionTabIndex == 1
                          ? selectedColor
                          : unselectedColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
