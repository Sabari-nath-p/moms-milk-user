import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';
import 'package:mommilk_user/Screens/SearchBuyerScreen/SearchBuyerScreen.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/SearchDonarScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class ConnectScreen extends StatelessWidget {
  ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<Homecontroller>(
        builder: (controller) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Connections".tr,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              // ✅ FIX ISSUE 2: DONOR gets compact search icon + text chip
              if (user.userType == "DONOR")
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => SearchBuyerScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Find Buyers'.tr,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // BUYER gets compact search icon + text chip (mirrors DONOR)
              if (user.userType == "BUYER")
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => Searchdonarscreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Find Donors'.tr,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          body: _buildBody(context, controller),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Homecontroller controller) {
    // Both BUYER and DONOR → My Connections; use the search chip in the
    // appbar to find buyers/donors instead.
    return RequestScreen();
  }
}
