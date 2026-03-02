import 'package:fluttertoast/fluttertoast.dart';

class CustomSnackBar {
  static void success(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static void error(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static void warning(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static void info(String message) {
    Fluttertoast.showToast(msg: message);
  }
}
