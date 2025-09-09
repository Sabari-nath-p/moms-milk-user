import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/UserModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/OnboardingScreen.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

late UserModel user;

class AuthenticationController extends GetxController {
  TextEditingController emailController =
      TextEditingController(text: "sabarinath5604@gmail.com");
  TextEditingController otpController = TextEditingController(text: "759409");

  bool isOtpSent = false;
  bool isLoading = false;

  /// Verify OTP
  verifyOtp() async {
    isLoading = true;
    update();

    await ApiService.request(
      endpoint: "/auth/verify-otp",
      body: {"email": emailController.text, "otp": otpController.text},
      requiresAuth: false,
      onSuccess: (data) async {
        if (data.statusCode == 200 || data.statusCode == 201) {
          if (data.data["isNew"] ?? false) {
            Get.to(() => OnboardingScreen(emailID: emailController.text),
                transition: Transition.cupertino);
          } else {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString("AUTHKEY", data.data["authData"]["accessToken"]);
            pref.setString(
                "USERKEY", jsonEncode(data.data["authData"]["user"]));

            // Set global user
            user = UserModel.fromJson(data.data["authData"]["user"]);

            // Navigate to MainDashboard (home tab)
            Get.offAll(() => MainDashboard(initialTabIndex: 0),
                transition: Transition.cupertino);

            setFcm();
          }
        } else {
          Get.snackbar(
            "Request Failed",
            data.data["message"] ?? "Server error. Please try again later.",
          );
        }
      },
      onUnauthenticated: () {
        Get.snackbar("Request Failed", "Invalid OTP. Please try again.");
      },
    );

    isLoading = false;
    update();
  }

  /// Send OTP
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
                "Server error. Please try again later.",
          );
        }
      },
    );
    isLoading = false;
    update();
  }

  /// Set FCM token
  setFcm() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        ApiService.request(
          endpoint: "/auth/fcm-token",
          body: {"fcmToken": token},
        );
      }
    } catch (e) {
      print("FCM error: $e");
    }
  }

  /// Logout function
  logout() async {
    try {
      // Clear all controllers and global user
      Get.deleteAll(force: true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('USERKEY');
      await prefs.remove('AUTHKEY');

      user = UserModel(); // Reset global user

      // Navigate to login screen
      Get.offAll(
        () => Authenticationscreen(),
        transition: Transition.fadeIn,
      );

      // Show success message
      Get.snackbar(
        'Success',
        'Logged out successfully',
       // backgroundColor: Colors.green,
        //colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
       // backgroundColor: Colors.red,
       // colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
