import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mommilk_user/Models/UserModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _login = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  bool isLogIn = false;
  MomsMilkApp({super.key, required this.isLogIn});

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
