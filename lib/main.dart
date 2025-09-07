import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mommilk_user/Models/UserModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Services/FCMService.dart';
import 'package:mommilk_user/firebase_options.dart';
import 'package:mommilk_user/theme/app_theme.dart';
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

  if (userKey != null) {
    print(userKey);
    user = UserModel.fromJson(jsonDecode(userKey));
    runApp(MomsMilkApp(isLogIn: true));
  } else {
    runApp(MomsMilkApp(isLogIn: false));
  }
}

class MomsMilkApp extends StatelessWidget {
  final bool isLogIn;
  const MomsMilkApp({super.key, required this.isLogIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Force dark them,

      home: (isLogIn) ? MainDashboard() : Authenticationscreen(),
    );
  }
}
