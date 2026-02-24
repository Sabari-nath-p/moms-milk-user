import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class CreateBabyController extends GetxController {
  final babyNameController = TextEditingController();
  Gender? babyGender;
  DateTime? babyDeliveryDate = DateTime.now();
  final babbyWeightController = TextEditingController();
  final babyHeightController = TextEditingController();
  bool isLoading = false;

  Future<void> createNewBaby({bool skip = true}) async {
    if (!validateBabyDetails()) return;

    isLoading = true;
    update();

    ApiService.request(
      endpoint: "/babies",
      body: {
        "name": babyNameController.text.trim(),
        "gender": babyGender!.name.toUpperCase(),
        "deliveryDate": babyDeliveryDate!.toUtc().toString(),
        "weight": double.tryParse(babbyWeightController.text) ?? 0,
        "height": double.tryParse(babyHeightController.text) ?? 0,
        "userId": user.id,
      },
      onSuccess: (data) {
        if (data.statusCode == 201 || data.statusCode == 200) {
          if (skip) {
            Get.offAll(MainDashboard());
          } else {
            Homecontroller controller = Get.put(Homecontroller());
            controller.fetchBabies();
            controller.update();

            Get.back();

            Get.snackbar(
              "Success",
              "Baby profile created successfully!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.black,
              duration: Duration(seconds: 2),
            );
          }
          isLoading = false;
          update();
        } else {
          Get.snackbar(
            "Error",
            "Failed to create baby profile. Please try again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.black,
          );
        }

        update();
      },
      onError: (error) {
        isLoading = false;
        Get.snackbar(
          "Network Error",
          "Unable to create baby profile. Please check your internet connection.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.black,
        );
        print("Error creating baby: $error");

        update();
      },
    );
  }

  /// Delete a baby profile
  Future<void> deleteBaby(int babyId) async {
    isLoading = true;
    update();
    await ApiService.request(
      endpoint: "/babies/$babyId",
      method: Api.DELETE,
      onSuccess: (data) {
        isLoading = false;
        update();
        if (data.statusCode == 200) {
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
        isLoading = false;
        update();
        Get.snackbar("Error", "Failed to delete baby: $error");
      },
    );
  }

  /// Validate user input
  bool validateBabyDetails() {
    // Baby name
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

    // Gender
    if (babyGender == null) {
      Get.snackbar('Validation Error', 'Please select baby\'s gender');
      return false;
    }

    // Delivery date
    if (babyDeliveryDate == null) {
      Get.snackbar('Validation Error', 'Please select delivery date');
      return false;
    }

    // Weight (MANDATORY)
    if (babbyWeightController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter baby\'s weight');
      return false;
    }

    final weight = double.tryParse(babbyWeightController.text.trim());
    if (weight == null || weight <= 0 || weight > 10) {
      Get.snackbar('Validation Error', 'Weight must be between 0.1 and 10 kg');
      return false;
    }

    // Height (MANDATORY)
    if (babyHeightController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter baby\'s height');
      return false;
    }

    final height = double.tryParse(babyHeightController.text.trim());
    if (height == null || height <= 0 || height > 100) {
      Get.snackbar('Validation Error', 'Height must be between 1 and 100 cm');
      return false;
    }

    return true;
  }
}
