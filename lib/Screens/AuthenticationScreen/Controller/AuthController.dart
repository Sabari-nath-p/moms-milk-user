import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mommilk_user/Models/UserModel.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/OnboardingScreen.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

late UserModel user;

class AuthenticationController extends GetxController {
  TextEditingController emailController = TextEditingController(
    text: "sabarinath5604@gmail.com",
  );
  TextEditingController otpController = TextEditingController(text: "759409");

  bool isOtpSent = false;
  bool isLoading = false;

  verifyOtp() async {
    isLoading = true;
    update();
    await ApiService.request(
      endpoint: "/auth/verify-otp",
      body: {"email": emailController.text, "otp": otpController.text},
      requiresAuth: false,
      onSuccess: (data) async {
        if (data.statusCode == 201 || data.statusCode == 200) {
          print(data.data);
          if (data.data["isNew"] ?? false) {
            Get.to(
              () => OnboardingScreen(emailID: emailController.text),
              transition: Transition.cupertino,
            );
          } else {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString("AUTHKEY", data.data["authData"]["accessToken"]);
            pref.setString(
              "USERKEY",
              jsonEncode(data.data["authData"]["user"]),
            );
            user = UserModel.fromJson(data.data["authData"]["user"]);
            Get.offAll(() => MainDashboard(), transition: Transition.cupertino);
          }
        } else {
          Get.snackbar(
            "Request Failed",
            data.data["message"] ?? "Server erro Please try after some time",
          );
        }
      },

      onUnauthenticated: () {
        Get.snackbar(
          "Request Failed",
          "Invalid Otp,Please retry with valid otp ",
        );
      },
    );
    isLoading = false;
    update();
  }

  sendOtp() async {
    isLoading = true;
    update();
    await ApiService.request(
      endpoint: "/auth/send-otp",
      body: {"email": emailController.text},
      onSuccess: (data) {
        if (data.statusCode == 201) {
          isOtpSent = true;
          update();
        } else {
          Get.snackbar(
            "Request Failed",
            data.data["message"]?.toString() ??
                "Server error. Please try after some time",
          );
        }
      },
    );
    isLoading = false;
    update();
  }
}
