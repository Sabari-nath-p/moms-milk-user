import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController otpController = TextEditingController(text: "");

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
        if ((data.statusCode == 201 || data.statusCode == 200) &&
            data.data["success"] != false) {
          print(data.data);
          isOtpSent = false;
          update();
          if (data.data["isNew"] ?? false) {
            String email = emailController.text;
            Get.to(
              () => OnboardingScreen(emailID: email),
              transition: Transition.cupertino,
            );
            emailController.text = "";
            otpController.text = "";
          } else {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString("AUTHKEY", data.data["authData"]["accessToken"]);
            pref.setString(
              "USERKEY",
              jsonEncode(data.data["authData"]["user"]),
            );
            user = UserModel.fromJson(data.data["authData"]["user"]);
            Get.offAll(() => MainDashboard(), transition: Transition.cupertino);
            setFcm();
          }
        } else {
          Fluttertoast.showToast(
            msg:
                data.data["message"] ??
                "Server erro Please try after some time",
          );
        }
      },

      onUnauthenticated: () {
        Fluttertoast.showToast(msg: "Invalid Otp,Please retry with valid otp ");
      },
    );
    isLoading = false;
    update();
  }

  setFcm() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        ApiService.request(
          endpoint: "/auth/fcm-token",
          method: Api.PATCH,
          body: {"fcmToken": token},
        );
      } else {}
      print(token.toString() + " token value");
    } catch (e) {
      print(e);
    }
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
          Fluttertoast.showToast(
            msg:
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
