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
 var isLoading = false.obs;
  var babySaved = false.obs;

Future<void> createNewBaby({bool skip = true}) async {
  if (!validateBabyDetails()) return;

  isLoading.value = true;

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
      isLoading.value = false;

      if (data.statusCode == 201) {
        babySaved.value = true; // ← mark as saved

        Get.snackbar(
          "Success",
          "Baby profile created successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate after short delay to let snackbar show
        Future.delayed(const Duration(milliseconds: 500), () {
          if (skip) {
            Get.offAll(MainDashboard());
          } else {
            try {
              Homecontroller controller = Get.find();
              controller.fetchBabies();
              controller.update();
            } catch (e) {
              print("HomeController not found: $e");
            }
            Get.back();
          }
        });
      } else {
        Get.snackbar(
          "Error",
          "Failed to create baby profile. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    },
    onError: (error) {
      isLoading.value = false;
      Get.snackbar(
        "Network Error",
        "Unable to create baby profile. Please check your internet connection.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Error creating baby: $error");
    },
  );
}

  /// Delete a baby profile
  Future<void> deleteBaby(int babyId) async {
    isLoading.value = true;

    await ApiService.request(
      endpoint: "/babies/$babyId",
      method: Api.DELETE,
      onSuccess: (data) {
        isLoading.value = false;
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
        isLoading.value = false;
        Get.snackbar("Error", "Failed to delete baby: $error");
      },
    );
  }

  /// Validate user input
  bool validateBabyDetails() {
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

    if (babyGender == null) {
      Get.snackbar('Validation Error', 'Please select baby\'s gender');
      return false;
    }

    if (babyDeliveryDate == null) {
      Get.snackbar('Validation Error', 'Please select delivery date');
      return false;
    }

    if (babbyWeightController.text.trim().isNotEmpty) {
      final weight = double.tryParse(babbyWeightController.text.trim());
      if (weight == null || weight <= 0 || weight > 10) {
        Get.snackbar('Validation Error', 'Weight must be between 0.1 and 10 kg');
        return false;
      }
    }

    if (babyHeightController.text.trim().isNotEmpty) {
      final height = double.tryParse(babyHeightController.text.trim());
      if (height == null || height <= 0 || height > 100) {
        Get.snackbar('Validation Error', 'Height must be between 1 and 100 cm');
        return false;
      }
    }

    return true;
  }
}