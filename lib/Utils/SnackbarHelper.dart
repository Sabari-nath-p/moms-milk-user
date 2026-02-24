import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static void success(String message, {String title = "Success"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.black,

      margin: EdgeInsets.all(12),
      borderRadius: 10,
      duration: Duration(seconds: 2),
    );
  }

  static void error(String message, {String title = "Error"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.black,

      margin: EdgeInsets.all(12),
      borderRadius: 10,
      duration: Duration(seconds: 3),
    );
  }

  static void warning(String message, {String title = "Warning"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.9),
      colorText: Colors.black,

      margin: EdgeInsets.all(12),
      borderRadius: 10,
      duration: Duration(seconds: 3),
    );
  }

  static void info(String message, {String title = "Info"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.9),
      colorText: Colors.black,

      margin: EdgeInsets.all(12),
      borderRadius: 10,
      duration: Duration(seconds: 2),
    );
  }
}
