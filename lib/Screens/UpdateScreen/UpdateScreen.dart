import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Screens/SplashScreen/SplashScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  bool isLogin;
  int versionNumber;
  bool isForce;
  UpdateScreen({
    super.key,
    required this.isLogin,
    required this.isForce,
    required this.versionNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Image.asset("assets/updateApp.png"),
          ),
          Positioned(
            top: 300,
            left: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                "assets/AppIcon.png",
                fit: BoxFit.cover,

                height: 70,
              ),
            ),
          ),
          Positioned(
            top: 390,
            left: 25,
            right: 22,
            child: Text(
              "Update your application to the\nlatest version".tr,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          if (!isForce)
            Positioned(
              top: 40,
              right: 20,
              child: InkWell(
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();

                  pref.setInt("LAST-CHECK", versionNumber);
                  if (isLogin)
                    Get.offAll(() => MainDashboard());
                  else
                    Get.offAll(() => SplashScreen());
                },
                child: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(.8),
                  child: Icon(Icons.close),
                ),
              ),
            ),
          Positioned(
            top: 450,
            left: 25,
            right: 10,
            child: Text(
              "We added some new features and fix some bug to make your experience as smooth as possible".tr,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 22,
            right: 22,
            child: Container(
              width: 200,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                gradient: AppTheme.roundButtonGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    launchUrl(
                      Uri.parse(
                        "https://play.google.com/store/apps/details?id=com.app.momsmilk&hl=en_IN",
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    launchUrl(
                      Uri.parse(
                        "https://apps.apple.com/in/app/moms-milk-breast-milk-sharing/id6751459414",
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.transparent, // remove default background
                  shadowColor: Colors.transparent, // remove shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Update Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
