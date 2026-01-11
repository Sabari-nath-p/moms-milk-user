import 'dart:convert';
import 'dart:io';
import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mommilk_user/Models/AppConfigModel.dart';
import 'package:mommilk_user/Models/UserModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Screens/SplashScreen/LogSplash.dart';
import 'package:mommilk_user/Screens/SplashScreen/SplashScreen.dart';
import 'package:mommilk_user/Screens/UpdateScreen/UpdateScreen.dart';
import 'package:mommilk_user/Services/FCMService.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:mommilk_user/Utils/UpdateChecker.dart';
import 'package:mommilk_user/firebase_options.dart';
import 'package:mommilk_user/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize FCM Service
  await FCMService.initialize();

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? userKey = pref.getString("USERKEY");
  int lastBuildCheckVersion = pref.getInt("LAST-CHECK") ?? 0;

  final clarityConfig = ClarityConfig(
    projectId: "uznguw2qxf",
    logLevel:
        LogLevel
            .None, // Note: Use "LogLevel.Verbose" value while testing to debug initialization issues.
  );
  final info = await PackageInfo.fromPlatform();
  if (userKey != null) {
    print(userKey);
    user = UserModel.fromJson(jsonDecode(userKey));
  }

  ApiService.request(
    endpoint: "/getAppConfig",
    method: Api.GET,
    requiresAuth: false,
    onSuccess: (body) {
      AppConfig config = AppConfig.fromJson(body.data);
      int currentBuildNumber = int.parse(info.buildNumber);
      String status = getAppUpdateStatus(
        currentVersion: currentBuildNumber,
        config: config,
        lastCheckVersion: lastBuildCheckVersion,
      );

      if (status == "skip" || status == "updated") {
        runApp(
          ClarityWidget(
            app: MomsMilkApp(isLogIn: userKey != null),
            clarityConfig: clarityConfig,
          ),
        );
      } else {
        runApp(
          ClarityWidget(
            app: MomsMilkApp(
              isLogIn: userKey != null,
              showUpdate: true,
              isForce: status == "force",
              latestBuildVerison:
                  (Platform.isAndroid)
                      ? config.currentBuildNoAndroid ?? 0
                      : config.currentBuildNoIos ?? 0,
            ),
            clarityConfig: clarityConfig,
          ),
        );
      }
    },
  );
}

class MomsMilkApp extends StatelessWidget {
  final bool isLogIn;
  bool showUpdate;
  bool isForce;
  int latestBuildVerison;
  MomsMilkApp({
    super.key,
    required this.isLogIn,
    this.showUpdate = false,
    this.isForce = false,
    this.latestBuildVerison = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Figma / iPhone X size
      minTextAdapt: true,
      splitScreenMode: true,
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            theme: AppTheme.darkTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark, // Force dark them,
            debugShowCheckedModeBanner: false,
            home:
                (showUpdate)
                    ? UpdateScreen(
                      isLogin: isLogIn,
                      isForce: isForce,
                      versionNumber: latestBuildVerison,
                    )
                    : (isLogIn)
                    ? MainDashboard()
                    : SplashScreen(),
          );
        },
      ),
    );
  }
}
