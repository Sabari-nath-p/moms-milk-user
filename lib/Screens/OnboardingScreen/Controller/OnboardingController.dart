import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/UserModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/Controller/BabyCreateController.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/CreateBabyScreen.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserType { donor, buyer }

enum Gender { BOY, GIRL, OTHER }

enum BloodGroup {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  oPositive,
  oNegative,
  abPositive,
  abNegative,
}

enum DonorQuality {
  organic,
  vegetarian,
  medicationFree,
  smokeFree,
  alcoholFree,
}

class Onboardingcontroller extends GetxController {
  Onboardingcontroller(String email) {
    emailController.text = email;
    update();
  }
  int currentStep = 0;
  int totalStep = 4;
  bool isLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final zipCodeController = TextEditingController();
  DateTime? babyDeliveryDate = null;
  String selectedCountryCode = "";
  UserType userType = UserType.buyer;

  BloodGroup? seletecBloodGroup;
  List<DonorQuality> selectedQualities = [];
  bool isWillingToShareMedicalReport = false;

  void previousStep() {
    if (currentStep > 0) {
      currentStep = currentStep - 1;
      update();
    }
  }

  void nextStep() {
    if (currentStep < 3) {
      if (currentStep == 0) {
        if (validateUserDetails()) {
          currentStep = currentStep + 1;
          update();
        }
      } else if (currentStep == 1) {
        if (userType == UserType.donor) {
          currentStep = currentStep + 1;
        } else {
          createUser();
        }
        update();
      } else if (currentStep == 2) {
        if (validateDonorDetails()) {
          createUser();
        }
      }
    }
  }

  addBaby() {}

  void toggleDonorQuality(DonorQuality quality) {
    if (selectedQualities.contains(quality)) {
      selectedQualities.remove(quality);
    } else {
      selectedQualities.add(quality);
    }
  }

  final List<Map<String, String>> countryCodes = [
    {'code': '+1', 'country': 'US'},
    {'code': '+11', 'country': 'CA'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+86', 'country': 'CN'},
    {'code': '+81', 'country': 'JP'},
    {'code': '+49', 'country': 'DE'},
    {'code': '+33', 'country': 'FR'},
    {'code': '+39', 'country': 'IT'},
    {'code': '+34', 'country': 'ES'},
    {'code': '+91', 'country': 'IN'},
  ];

  void createUser() async {
    isLoading = true;
    update();
    await ApiService.request(
      endpoint: "/auth/complete-profile",
      requiresAuth: false,
      body: {
        'name': nameController.text,
        'email': emailController.text,
        'phone': selectedCountryCode + phoneController.text,
        'zipcode': zipCodeController.text,
        'userType': userType.name.toUpperCase(),
        'description': '',
        'bloodGroup': getBloodGroupText(seletecBloodGroup!!),
        if (userType == UserType.donor)
          'babyDeliveryDate': babyDeliveryDate!.toUtc().toString(),
        if (userType == UserType.donor)
          'ableToShareMedicalRecord': isWillingToShareMedicalReport,
        if (userType == UserType.donor)
          "healthStyle": selectedQualities
              .map((e) => getDonorQualityText(e))
              .toList()
              .join(","),
      },
      onSuccess: (body) async {
        if (body.statusCode == 201) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("AUTHKEY", body.data["accessToken"]);
          pref.setString("USERKEY", jsonEncode(body.data["user"]));
          user = UserModel.fromJson(body.data["user"]);
          setFcm();

          Get.offAll(
            () => CreateBabyScreen(),
            transition: Transition.rightToLeft,
          );
        }
      },
      onError: (error) {
        Get.snackbar("Invalid Operation", error.toString());
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
          body: {"fcmToken": token},
        );
      }
    } catch (e) {}
  }

  bool validateUserDetails() {
    // Validate name
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter your full name');
      return false;
    }

    if (nameController.text.trim().length < 2) {
      Get.snackbar(
        'Validation Error',
        'Name must be at least 2 characters long',
      );
      return false;
    }

    // Validate phone number
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter your phone number');
      return false;
    }

    // Check if phone number contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(phoneController.text.trim())) {
      Get.snackbar(
        'Validation Error',
        'Phone number should contain only digits',
      );
      return false;
    }

    // Check phone number length (assuming 10 digits for most countries)
    if (phoneController.text.trim().length < 10) {
      Get.snackbar(
        'Validation Error',
        'Phone number must be at least 10 digits long',
      );
      return false;
    }

    // Validate zip code
    if (zipCodeController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter your zip code');
      return false;
    }

    // Check if zip code is valid (allowing alphanumeric for international support)
    if (!RegExp(r'^[0-9A-Za-z\s-]+$').hasMatch(zipCodeController.text.trim())) {
      Get.snackbar('Validation Error', 'Please enter a valid zip code');
      return false;
    }

    if (zipCodeController.text.trim().length < 3) {
      Get.snackbar(
        'Validation Error',
        'Zip code must be at least 3 characters long',
      );
      return false;
    }

    // Validate country code selection
    if (selectedCountryCode.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a country code');
      return false;
    }
    return true;
  }

  bool validateDonorDetails() {
    // Validate blood group selection
    if (seletecBloodGroup == null) {
      Get.snackbar('Validation Error', 'Please select your blood group');
      return false;
    }

    // Validate donor qualities (at least one should be selected)
    if (selectedQualities.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select at least one donor quality',
      );
      return false;
    }

    // All donor validations passed
    return true;
  }
}

String getBloodGroupText(BloodGroup bloodGroup) {
  switch (bloodGroup) {
    case BloodGroup.aPositive:
      return 'A+';
    case BloodGroup.aNegative:
      return 'A-';
    case BloodGroup.bPositive:
      return 'B+';
    case BloodGroup.bNegative:
      return 'B-';
    case BloodGroup.oPositive:
      return 'O+';
    case BloodGroup.oNegative:
      return 'O-';
    case BloodGroup.abPositive:
      return 'AB+';
    case BloodGroup.abNegative:
      return 'AB-';
  }
}

String getDonorQualityText(DonorQuality quality) {
  switch (quality) {
    case DonorQuality.organic:
      return 'Organic Diet';
    case DonorQuality.vegetarian:
      return 'Vegetarian';
    case DonorQuality.medicationFree:
      return 'Medication Free';
    case DonorQuality.smokeFree:
      return 'Smoke Free';
    case DonorQuality.alcoholFree:
      return 'Alcohol Free';
  }
}
