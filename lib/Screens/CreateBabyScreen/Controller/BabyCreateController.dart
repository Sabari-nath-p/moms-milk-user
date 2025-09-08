import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class CreateBabyController extends GetxController {
  final babyNameController = TextEditingController();
  Gender? babyGender = null;
  DateTime? babyDeliveryDate = DateTime.now();
  final babbyWeightController = TextEditingController();
  final babyHeightController = TextEditingController();
  bool isLoading = false;

  CreateNewBaby({bool skip = true}) async {
    if (validateBabyDetails()) {
      isLoading = true;
      update();
      print(babyGender!.name.toUpperCase());
      ApiService.request(
        endpoint: "/babies",
        body: {
          "name": "${babyNameController.text}",
          "gender": babyGender!.name.toUpperCase(),
          "deliveryDate": babyDeliveryDate!.toUtc().toString(),
          //"bloodGroup":  getBloodGroupText(),
          "weight": double.parse(babbyWeightController.text),
          "height": double.parse(babyHeightController.text),
          "userId": user.id,
        },
        onSuccess: (data) {
          print(data.data);
          if (data.statusCode == 201) {
            if (skip)
              Get.off(() => Homescreen());
            else {
              Homecontroller controller = Get.find();
              controller.fetchBabies();
              controller.update();
              Get.back();
            }
          }
        },
      );
      isLoading = false;
      update();
    }
  }
Future<void> deleteBaby(int babyId) async {
    isLoading = true;
    update();

    await ApiService.request(
      endpoint: "/babies/$babyId",
      method: Api.DELETE,
      onSuccess: (data) {
        if (data.statusCode == 200 ) {
          Get.snackbar("Success", "Baby deleted successfully");
          try {
            Homecontroller controller = Get.find();
            controller.fetchBabies();
            controller.update();
          } catch (e) {
            print("HomeController not found: $e");
          }
          Get.back(); // Close dialog/screen after delete
        }
      },
      onError: (error) {
        Get.snackbar("Error", "Failed to delete baby: $error");
      },
    );

    isLoading = false;
    update();
  }
  bool validateBabyDetails() {
    // Validate baby name (required)
    if (babyNameController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter baby\'s name');
      return false;
    }

    if (babyNameController.text.trim().length < 2) {
      Get.snackbar(
        'Validation Error',
        'Baby\'s name must be at least 2 characters long',
      );
      return false;
    }

    // Validate gender (required)
    if (babyGender == null) {
      Get.snackbar('Validation Error', 'Please select baby\'s gender');
      return false;
    }

    // Validate delivery date (required)
    if (babyDeliveryDate == null) {
      Get.snackbar('Validation Error', 'Please select delivery date');
      return false;
    }

    // Validate weight (optional, but if provided must be valid)
    if (babbyWeightController.text.trim().isNotEmpty) {
      final weight = double.tryParse(babbyWeightController.text.trim());
      if (weight == null) {
        Get.snackbar('Validation Error', 'Please enter a valid weight');
        return false;
      }
      if (weight <= 0 || weight > 10) {
        Get.snackbar(
          'Validation Error',
          'Weight must be between 0.1 and 10 kg',
        );
        return false;
      }
    }

    // Validate height (optional, but if provided must be valid)
    if (babyHeightController.text.trim().isNotEmpty) {
      final height = double.tryParse(babyHeightController.text.trim());
      if (height == null) {
        Get.snackbar('Validation Error', 'Please enter a valid height');
        return false;
      }
      if (height <= 0 || height > 100) {
        Get.snackbar('Validation Error', 'Height must be between 1 and 100 cm');
        return false;
      }
    }
    return true;
  }
}
